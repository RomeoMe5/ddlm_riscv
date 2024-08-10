module sys_array_basic #(
    parameter DATA_WIDTH = 8,// Размерность данных`
    parameter ARRAY_W_W  = 4, // Строк в массиве весов
    parameter ARRAY_W_L  = 4, // Столбцов в массиве весов
    parameter ARRAY_A_W  = 4, // Строк в массиве данных
    parameter ARRAY_A_L  = 4  // Столбцов в массиве данных
) (
    input                         clk,
    input                         reset_n,
    input                         weights_load,
    input signed [DATA_WIDTH-1:0] input_data  [0:ARRAY_A_L-1],
    input signed [DATA_WIDTH-1:0] weight_data [0:ARRAY_W_W-1][0:ARRAY_W_L-1],

    output signed [2*DATA_WIDTH-1:0] output_data[0:ARRAY_W_L-1]
);

  wire [2*DATA_WIDTH-1:0] temp_output_data [0:ARRAY_W_L-1][0:ARRAY_W_W-1];
  wire [  DATA_WIDTH-1:0] propagate_module [0:ARRAY_W_L-1][0:ARRAY_W_W-1];

  genvar i, j, t;
  // Генерация ячеек систолического массива
  // i - строка, j - столбец
  generate
    for (i = 0; i < ARRAY_W_L; i = i + 1) begin : generate_array_proc
      for (j = 0; j < ARRAY_W_W; j = j + 1) begin : generate_array_proc2
        // Нулевая ячейка массива
        if ((i == 0) && (j == 0)) begin : array_first_cell
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
		 else if (i == 0) // Первая строка массива
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
		 else if (j == 0) // Первый столбец массива
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
    for (t = 0; t < ARRAY_W_L; t = t + 1) begin : output_prop
      assign output_data[t] = temp_output_data[t][ARRAY_A_L-1];
    end
  endgenerate

endmodule
