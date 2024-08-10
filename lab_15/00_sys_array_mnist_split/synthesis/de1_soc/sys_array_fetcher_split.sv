`ifndef types
`define types 0;
typedef struct packed {
  logic [9:0] A_W_0, A_L_0, A_W_1, A_L_1;
  logic [9:0] B_W_0, B_L_0, B_W_1, B_L_1;
  logic [9:0] O_W_0, O_L_0, O_W_1, O_L_1;
  logic [7:0] to_n1;
  logic [7:0] to_n2;
  logic signed [8:0] parent;
} split_type;
`endif

module sys_array_fetcher_split #(
    parameter DATA_WIDTH = 8,
    parameter ARRAY_A_W = 5,  //Строк в массиве данных
    parameter ARRAY_A_L = 2,  //Столбцов в массиве данных
    parameter ARRAY_W_W = 2,  //Строк в массиве весов
    parameter ARRAY_W_L = 5,  //Столбцов в массиве весов    
    parameter ARRAY_W = 10, //Максимальное число строк в систолическом массиве
    parameter ARRAY_L = 10, //Максимальное число столбцов в систолическом массиве
    parameter ARRAY_MAX_A_W = 10,
    parameter OUT_SIZE = 100
) (
    input clk,
    input reset_n,
    input start_comp,
    input signed [DATA_WIDTH-1:0] input_data [0:ARRAY_A_W-1] [0:ARRAY_A_L-1],
    input signed [DATA_WIDTH-1:0] weights[0:ARRAY_W_W-1][0:ARRAY_W_L-1],

    output reg ready,
    output reg signed [2*DATA_WIDTH-1:0] out_data [0:ARRAY_A_W-1] [0:ARRAY_W_L-1]
);

  // Контрольные сигналы регистра чтения
  reg [1:0] control_sr_read[ARRAY_L-1:0];
  // Контрольные сигналы регистра записи
  reg [1:0] control_sr_write[ARRAY_W-1:0];

  reg signed [DATA_WIDTH-1:0] weights_max[0:ARRAY_L-1][0:ARRAY_W-1];
  reg signed [DATA_WIDTH-1:0] input_data_max  [0:ARRAY_MAX_A_W-1][0:ARRAY_L-1];

  reg weights_load;

  wire signed [DATA_WIDTH-1:0] input_sys_array[0:ARRAY_L-1];
  wire signed [2*DATA_WIDTH-1:0] output_sys_array[0:ARRAY_W-1];
  wire signed [2*DATA_WIDTH-1:0] output_wire [0:ARRAY_W-1] [0:ARRAY_MAX_A_W-1];
  wire split_ready;

  split_type split_out_data[OUT_SIZE];

  wire [7:0] first_none;
  wire [7:0] last;

  sys_array_split #(
      .ARRAY_W      (ARRAY_W),
      .ARRAY_L      (ARRAY_L),
      .ARRAY_MAX_A_W(ARRAY_MAX_A_W),
      .OUT_SIZE     (OUT_SIZE)
  ) u_sys_array_split1 (
      .clk       (clk),
      .reset_n   (reset_n),
      .ARRAY_W_W (ARRAY_W_W),
      .ARRAY_W_L (ARRAY_W_L),
      .ARRAY_A_W (ARRAY_A_W),
      .ARRAY_A_L (ARRAY_A_L),
      .start     (start_comp),
      .ready     (split_ready),
      .out_data  (split_out_data),
      .first_none(first_none),
      .last      (last)
  );

  genvar i, j;
  wire [DATA_WIDTH-1:0] transposed_a[0:ARRAY_L-1][0:ARRAY_MAX_A_W-1];
  // Транспонирование матрицы A
  generate
    for (i = 0; i < ARRAY_MAX_A_W; i = i + 1) begin : transpose_i
      for (j = 0; j < ARRAY_L; j = j + 1) begin : transpose_j
        assign transposed_a[j][i] = input_data_max[i][j];
      end
    end
  endgenerate

  generate
    for (i = 0; i < ARRAY_L; i = i + 1) begin : generate_reads_shift_reg
      shift_reg #(
          .DATA_WIDTH(DATA_WIDTH),
          .LENGTH(ARRAY_MAX_A_W)
      ) reads (
          .clk(clk),
          .reset_n(reset_n),
          .ctrl_code(control_sr_read[i]),
          .data_in(transposed_a[i]),
          .data_read(input_sys_array[i])
      );
    end
  endgenerate

  generate
    for (i = 0; i < ARRAY_W; i = i + 1) begin : generate_writes_shift_reg
      shift_reg #(
          .DATA_WIDTH(2 * DATA_WIDTH),
          .LENGTH(ARRAY_MAX_A_W)
      ) writes (
          .clk(clk),
          .reset_n(reset_n),
          .ctrl_code(control_sr_write[i]),
          .data_write(output_sys_array[i]),
          .data_out(output_wire[i])
      );
    end
  endgenerate

  reg [15:0] len_w_l;
  reg [15:0] len_w_w;
  reg [15:0] len_a_l;
  reg [15:0] len_a_w;
  reg reset_n_basic;

  sys_array_basic_split #(
      .DATA_WIDTH(DATA_WIDTH),
      .ARRAY_W(ARRAY_W),
      .ARRAY_L(ARRAY_L)
  ) systolic_array (
      .clk(clk),
      .reset_n(reset_n),
      .weights_load(weights_load),
      .array_a_l(len_a_l),
      .weight_data(weights_max),
      .input_data(input_sys_array),
      .output_data(output_sys_array)
  );

  reg prev_split_ready;
  reg start_comp_split;

  initial begin
    prev_split_ready = 1'b0;
  end

  always @(posedge clk) begin
    if ((prev_split_ready == 1'b0) && (split_ready == 1'b1))
      start_comp_split <= 1'b1;
    else start_comp_split <= 1'b0;
    prev_split_ready <= split_ready;
  end

  reg [15:0] fetch_len;  // Счетчик

  reg signed [16:0] cur;  // Счетчик
  reg [15:0] cnt;  // Счетчик
  reg [15:0] cnt_input_data_max_w;  // Счетчик
  reg [15:0] cnt_input_data_max_l;  // Счетчик

  reg [15:0] cnt_weights_max_w;  // Счетчик
  reg [15:0] cnt_weights_max_l;  // Счетчик

  reg [15:0] cnt_output_data_max_w;  // Счетчик
  reg [15:0] cnt_output_data_max_l;  // Счетчик


  always @(posedge clk) begin
    if (~reset_n) begin  // reset
      cur <= -'d1;
      cnt <= 15'd0;
      control_sr_read <= '{default: 2'b00};
      control_sr_write <= '{default: 2'b00};
      ready <= 1'b0;
      input_data_max <= '{default: 'b00};
      weights_max <= '{default: 'b00};
      cnt_input_data_max_w <= 16'd0;
      cnt_input_data_max_l <= 16'd0;
      cnt_weights_max_w <= 16'd0;
      cnt_weights_max_l <= 16'd0;
      cnt_output_data_max_w <= 16'd0;
      cnt_output_data_max_l <= 16'd0;
      out_data <= '{default: 'b00};

      weights_load <= 1'b0;

      fetch_len <= 'b0;
      reset_n_basic <= 1'b1;
    end
    else if(start_comp_split) begin // Получено разбиение матриц на подматрицы
      cur <= first_none;
      cnt <= 15'd0;
      len_w_l <= 'b0;
      len_w_w <= 'b0;
      len_a_l <= 'b0;
      len_a_w <= 'b0;
      ready <= 1'b0;
      input_data_max <= '{default: 'b00};
      weights_max <= '{default: 'b00};
      cnt_input_data_max_w <= 16'd0;
      cnt_input_data_max_l <= 16'd0;
      cnt_weights_max_w <= 16'd0;
      cnt_weights_max_l <= 16'd0;
      cnt_output_data_max_w <= 16'd0;
      cnt_output_data_max_l <= 16'd0;
      out_data <= '{default: 'b00};
      weights_load <= 1'b0;
      fetch_len <= 'b0;
      reset_n_basic <= 1'b1;
    end
    else if (cur >= 0 && cur < last) begin // Начат процесс вычисления подматриц
      if (cnt == 0) begin // Установка сигналов на нулевом такте вычислений
        len_w_l <= (split_out_data[cur].B_L_1 - split_out_data[cur].B_L_0 + 1);
        len_w_w <= (split_out_data[cur].B_W_1 - split_out_data[cur].B_W_0 + 1);
        len_a_l <= (split_out_data[cur].A_L_1 - split_out_data[cur].A_L_0 + 1);
        len_a_w <= (split_out_data[cur].A_W_1 - split_out_data[cur].A_W_0 + 1);
        reset_n_basic <= 1'b0;
        if ((cnt_input_data_max_w > (split_out_data[cur].A_W_1 - split_out_data[cur].A_W_0)) &&
                (cnt_weights_max_w > (split_out_data[cur].B_W_1 - split_out_data[cur].B_W_0))) begin
          cnt <= cnt + 'd1;
          weights_load <= 1'b1;
          control_sr_read <= '{default: 2'b01};
        end else begin
          if (cnt_input_data_max_w <= (split_out_data[cur].A_W_1 - split_out_data[cur].A_W_0)) begin
            cnt_input_data_max_l <= ((cnt_input_data_max_l + 1) > (split_out_data[cur].A_L_1 - split_out_data[cur].A_L_0)) ?
                                                0 : (cnt_input_data_max_l + 1);
            cnt_input_data_max_w <= ((cnt_input_data_max_l + 1) > (split_out_data[cur].A_L_1 - split_out_data[cur].A_L_0)) ?
                                                (cnt_input_data_max_w + 1) : cnt_input_data_max_w;
            input_data_max[cnt_input_data_max_w][cnt_input_data_max_l] <= input_data[split_out_data[cur].A_W_0 + cnt_input_data_max_w][split_out_data[cur].A_L_0 + cnt_input_data_max_l];
          end

          if (cnt_weights_max_w <= (split_out_data[cur].B_W_1 - split_out_data[cur].B_W_0)) begin
            cnt_weights_max_l <= ((cnt_weights_max_l + 1) > (split_out_data[cur].B_L_1 - split_out_data[cur].B_L_0)) ?
                                                0 : (cnt_weights_max_l + 1);
            cnt_weights_max_w <= ((cnt_weights_max_l + 1) > (split_out_data[cur].B_L_1 - split_out_data[cur].B_L_0)) ?
                                                (cnt_weights_max_w + 1) : cnt_weights_max_w;
            weights_max[cnt_weights_max_w][cnt_weights_max_l] <= weights[split_out_data[cur].B_W_0 + cnt_weights_max_w][split_out_data[cur].B_L_0 + cnt_weights_max_l];
          end
        end
      end
        else if (cnt == 1) begin 
        // Установка сигналов на первом такте вычислений
        control_sr_read[0] <= 2'b11;
        cnt <= cnt + 1'b1;
        fetch_len <= len_w_l + len_a_w + len_w_w + 1;
        reset_n_basic <= 1'b1;
        weights_load <= 1'b0;
      end else begin
        if (cnt < len_a_l + 1) // Включение регистров чтения
          control_sr_read[cnt-1] = 2'b11;
        // Старт отключения регистров чтения
        if ((cnt > len_a_w) && (cnt < len_a_l + len_a_w + 1))
          control_sr_read[cnt-len_a_w-1] = 2'b00;
        // Включение регистров записи
        if ((cnt > len_w_w + 2) && (cnt < len_w_w + len_w_l + 3))
          control_sr_write[cnt-len_w_w-3] = 2'b10;
        // Старт отключения регистров записи
        if ((cnt > len_a_w + len_w_w + 2) && (cnt <= fetch_len + 1))
          control_sr_write[cnt-(len_a_w+len_w_w)-3] = 2'b00;

        if (cnt <= fetch_len + 2) cnt = cnt + 1'b1;
        else begin
          if (cnt == fetch_len + 3) begin
            if (cnt_output_data_max_w > (split_out_data[cur].O_W_1 - split_out_data[cur].O_W_0))
              cnt <= cnt + 'd1;
            else begin
              cnt_output_data_max_l <= ((cnt_output_data_max_l + 1) > (split_out_data[cur].O_L_1 - split_out_data[cur].O_L_0)) ?
                                                    0 : (cnt_output_data_max_l + 1);
              cnt_output_data_max_w <= ((cnt_output_data_max_l + 1) > (split_out_data[cur].O_L_1 - split_out_data[cur].O_L_0)) ?
                                                    (cnt_output_data_max_w + 1) : cnt_output_data_max_w;
              out_data[cnt_output_data_max_w + split_out_data[cur].O_W_0][cnt_output_data_max_l + split_out_data[cur].O_L_0] <= 
                        out_data[cnt_output_data_max_w + split_out_data[cur].O_W_0][cnt_output_data_max_l + split_out_data[cur].O_L_0] + 
                        output_wire[cnt_output_data_max_l][cnt_output_data_max_w + ARRAY_MAX_A_W - len_a_w];
            end
          end else begin
            cur <= cur + 1;
            cnt <= 16'd0;
            control_sr_read <= '{default: 2'b00};
            control_sr_write <= '{default: 2'b00};
            input_data_max <= '{default: 'b00};
            weights_max <= '{default: 'b00};
            cnt_input_data_max_w <= 16'd0;
            cnt_input_data_max_l <= 16'd0;
            cnt_weights_max_w <= 16'd0;
            cnt_weights_max_l <= 16'd0;
            cnt_output_data_max_w <= 16'd0;
            cnt_output_data_max_l <= 16'd0;
          end
        end
      end
    end else if (cur >= $signed(last)) begin
      ready <= 1'b1;
      cur   <= 0;
    end
  end
endmodule
