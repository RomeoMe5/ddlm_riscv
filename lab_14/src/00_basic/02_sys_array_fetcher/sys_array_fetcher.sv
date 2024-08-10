module sys_array_fetcher #(
    parameter DATA_WIDTH = 8,  // Размерность данных
    parameter ARRAY_A_W = 4,  // Строк в массиве данных
    parameter ARRAY_A_L = 4,  // Столбцов в массиве данных
    parameter ARRAY_W_W = 4,  // Строк в массиве весов
    parameter ARRAY_W_L = 4  // Столбцов в массиве весов
) (
    input clk,
    input reset_n,
    input weights_load,
    input start_comp,
    input signed [DATA_WIDTH-1:0] input_data [0:ARRAY_A_W-1][0:ARRAY_A_L-1],
    input signed [DATA_WIDTH-1:0] weights [0:ARRAY_W_W-1][0:ARRAY_W_L-1],

    output reg ready,
    output reg signed [2*DATA_WIDTH-1:0] out_data [0:ARRAY_A_W-1][0:ARRAY_W_L-1]
);

  // Необходимое количество циклов clk для выполнения выборки и возврата результатов
  localparam FETCH_LENGTH = ARRAY_A_W + ARRAY_W_W + ARRAY_W_L + 1;


  reg signed [15:0] cnt;  // Счетчик
  // Контрольные сигналы регистра чтения
  reg [1:0] control_sr_read [ARRAY_A_L-1:0];
  // Контрольные сигналы регистра записи
  reg [1:0] control_sr_write [ARRAY_W_L-1:0];

  // Массив входных данных
  reg signed [DATA_WIDTH-1:0] input_sys_array[0:ARRAY_A_L-1];
  // Выход систолического массива
  wire signed [2*DATA_WIDTH-1:0] output_sys_array[0:ARRAY_W_L-1];
  // Промежуточная выходная матрица
  wire signed [2*DATA_WIDTH-1:0] output_wire [0:ARRAY_W_L-1] [0:ARRAY_A_W-1] ;


  sys_array_basic #(
      .DATA_WIDTH(DATA_WIDTH),
      .ARRAY_W_W(ARRAY_W_W),
      .ARRAY_W_L(ARRAY_W_L),
      .ARRAY_A_W(ARRAY_A_W),
      .ARRAY_A_L(ARRAY_A_L)
  ) systolic_array (
      .clk(clk),
      .reset_n(reset_n),
      .weights_load(weights_load),
      .weight_data(weights),
      .input_data(input_sys_array),
      .output_data(output_sys_array)
  );

  genvar i, j;
  wire [DATA_WIDTH-1:0] transposed_a[0:ARRAY_A_L-1][0:ARRAY_A_W-1];
  // Транспонирование матрицы A
  generate
    for (i = 0; i < ARRAY_A_W; i = i + 1) begin : transpose_i
      for (j = 0; j < ARRAY_A_L; j = j + 1) begin : transpose_j
        assign transposed_a[j][i] = input_data[i][j];
      end
    end
  endgenerate

  generate
    for (i = 0; i < ARRAY_A_L; i = i + 1) begin : generate_reads_shift_reg
      shift_reg #(
          .DATA_WIDTH(DATA_WIDTH),
          .LENGTH(ARRAY_A_W)
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
    for (i = 0; i < ARRAY_W_L; i = i + 1) begin : generate_writes_shift_reg
      shift_reg #(
          .DATA_WIDTH(2 * DATA_WIDTH),
          .LENGTH(ARRAY_A_W)
      ) writes (
          .clk(clk),
          .reset_n(reset_n),
          .ctrl_code(control_sr_write[i]),
          .data_write(output_sys_array[i]),
          .data_out(output_wire[i])
      );
    end
  endgenerate

  always @(posedge clk) begin
    if (~reset_n) begin  // reset
      cnt <= -16'd1;
      control_sr_read <= '{default: 2'b00};
      control_sr_write <= '{default: 2'b00};
      ready <= 1'b0;
    end else if (start_comp) begin  // Начало вычислений
      cnt   <= 16'd0;
      ready <= 1'b0;
    end else if (cnt == 0) begin
      //Инициализация регистров загрузки входных данных 
      control_sr_read <= '{default: 2'b01};
      cnt <= 16'd1;
    end else if (cnt > 0) begin  // Основные вычисления
      if (cnt == 1) begin
        // Задание сигналова на первом такте вычислений
        control_sr_read[0] <= 2'b11;
        cnt <= cnt + 1'b1;
      end else begin  // Задание логических сигналов
        // Включение регистров чтения
        if (cnt < ARRAY_A_L + 1) control_sr_read[cnt-1] = 2'b11;
        // Старт отключения регистров чтения
        if ((cnt > ARRAY_A_W) && (cnt < ARRAY_A_L + ARRAY_A_W + 1))
          control_sr_read[cnt-ARRAY_A_W-1] = 2'b00;
        // Включение регистров записи
        if ((cnt > ARRAY_W_W + 1) && (cnt < ARRAY_W_W + ARRAY_W_L + 2))
          control_sr_write[cnt-ARRAY_W_W-2] = 2'b10;
        // Старт отключения регистров записи
        if ((cnt > ARRAY_A_W + ARRAY_W_W + 1) && (cnt <= FETCH_LENGTH))
          control_sr_write[cnt-(ARRAY_A_W+ARRAY_W_W)-2] = 2'b00;
        // Увеличение счетчика каждый такт вычислений
        if (cnt <= FETCH_LENGTH) cnt = cnt + 1'b1;
        else begin  // Выдача итогового результата
          cnt   <= 15'd0;
          ready <= 1'b1;
        end
      end
    end
  end

  // Транспонирование выходной матрицы
  generate
    for (i = 0; i < ARRAY_A_W; i = i + 1) begin : transpose_out_i
      for (j = 0; j < ARRAY_W_L; j = j + 1) begin : transpose_out_j
        assign out_data[i][j] = output_wire[j][i] & {DATA_WIDTH * 2{ready}};
      end
    end
  endgenerate

endmodule
