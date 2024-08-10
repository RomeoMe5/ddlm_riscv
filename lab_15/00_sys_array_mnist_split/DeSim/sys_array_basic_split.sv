module sys_array_basic_split #(
    parameter DATA_WIDTH = 8,  // Размерность данных
    parameter ARRAY_W = 10,   // Количество строк в систолическом массиве
    parameter ARRAY_L = 30   // Количество столбцов в систолическом массиве
)  
(
    input                  clk,
    input                  reset_n,
    input                  weights_load,
    input	[15:0]           array_a_l,
    input signed [DATA_WIDTH-1:0] input_data  [0:ARRAY_L-1],
    input signed [DATA_WIDTH-1:0] weight_data [0:ARRAY_L-1][0:ARRAY_W-1],

    output reg signed [2*DATA_WIDTH-1:0] output_data [0:ARRAY_W-1]
);

  wire signed [2*DATA_WIDTH-1:0] temp_output_data [0:ARRAY_W-1][0:ARRAY_L-1];
  wire signed [  DATA_WIDTH-1:0] propagate_module [0:ARRAY_W-1][0:ARRAY_L-1];

  genvar i;
  genvar j;
  genvar t;
  // Генерация массива вычислительных ячеек
  generate
    for (i = 0; i < ARRAY_W; i = i + 1) begin : generate_array_proc
      for (j = 0; j < ARRAY_L; j = j + 1) begin : generate_array_proc2
        if ((i == 0) && (j == 0)) begin : array_first_cell // i - строка, j - столбец
          sys_array_cell #(
              .DATA_WIDTH(DATA_WIDTH)
          ) cell_inst (
              .clk(clk),
              .reset_n(reset_n),
              .weight_load(weights_load),
              .input_data(input_data[0]),
              .prop_data({2 * DATA_WIDTH{1'b0}}),
              .weights(weight_data[0][0]),
              .out_data(temp_output_data[0][0]),
              .prop_output(propagate_module[0][0])
          );
        end
		 else if (i == 0) //первая строка
		 begin : array_first_row
          sys_array_cell #(
              .DATA_WIDTH(DATA_WIDTH)
          ) cell_inst (
              .clk(clk),
              .reset_n(reset_n),
              .weight_load(weights_load),
              .input_data(input_data[j]),
              .prop_data(temp_output_data[0][j-1]),
              .weights(weight_data[j][0]),
              .out_data(temp_output_data[0][j]),
              .prop_output(propagate_module[0][j])
          );
        end
		 else if (j == 0) //первый столбец
		 begin : array_first_column
          sys_array_cell #(
              .DATA_WIDTH(DATA_WIDTH)
          ) cell_inst (
              .clk(clk),
              .reset_n(reset_n),
              .weight_load(weights_load),
              .input_data(propagate_module[i-1][0]),
              .prop_data({2 * DATA_WIDTH{1'b0}}),
              .weights(weight_data[0][i]),
              .out_data(temp_output_data[i][0]),
              .prop_output(propagate_module[i][0])
          );
        end else begin : array_all_cells // Остальные элементы
          sys_array_cell #(
              .DATA_WIDTH(DATA_WIDTH)
          ) cell_inst (
              .clk(clk),
              .reset_n(reset_n),
              .weight_load(weights_load),
              .input_data(propagate_module[i-1][j]),
              .prop_data(temp_output_data[i][j-1]),
              .weights(weight_data[j][i]),
              .out_data(temp_output_data[i][j]),
              .prop_output(propagate_module[i][j])
          );
        end
      end
    end
  endgenerate

  // Генерация связей для выходных данных
  generate
    for (t = 0; t < ARRAY_W; t = t + 1) begin : output_prop
      always @(posedge clk) begin
        output_data[t] = temp_output_data[t][array_a_l-1];
      end
    end
  endgenerate

endmodule
