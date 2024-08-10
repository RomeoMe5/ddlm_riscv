`timescale 1 ns / 100 ps

module tb_sys_array_basic #(
    parameter DATA_WIDTH = 16,  // Размерность данных
    parameter ARRAY_A_W = 4,  // Строк в массиве данных
    parameter ARRAY_A_L = 3,  // Столбцов в массиве данных
    parameter ARRAY_W_W = 3,  // Строк в массиве весов
    parameter ARRAY_W_L = 4  // Столбцов в массиве весов
);

  reg signed  [  DATA_WIDTH-1:0] weight_test [0:ARRAY_W_W-1] [0:ARRAY_W_L-1];
  reg signed  [  DATA_WIDTH-1:0] inputs_test [0:ARRAY_A_L-1];
  wire signed [2*DATA_WIDTH-1:0] outputs_test[0:ARRAY_W_L-1];
  reg clk, reset_n, weights_load;
  reg signed [DATA_WIDTH-1:0] input_data[0:ARRAY_A_W-1][0:ARRAY_A_L-1];

  initial begin
    input_data[0] = '{'h01, 'h02, 'h03};
    input_data[1] = '{'h04, 'h05, 'h06};
    input_data[2] = '{'h07, 'h08, 'h09};
    input_data[3] = '{'h0A, 'h0B, 'h0C};
    input_data[4] = '{'h0D, 'h0E, 'h0F};
  end

  sys_array_basic #(
      .DATA_WIDTH(DATA_WIDTH),
      .ARRAY_W_W (ARRAY_W_W),
      .ARRAY_W_L (ARRAY_W_L),
      .ARRAY_A_W (ARRAY_A_W),
      .ARRAY_A_L (ARRAY_A_L)
  ) systolic_array (
      .clk(clk),
      .reset_n(reset_n),
      .weights_load(weights_load),
      .weight_data(weight_test),
      .input_data(inputs_test),
      .output_data(outputs_test)
  );

  initial $dumpfile("test.vcd");
  initial $dumpvars;
  initial begin
    clk = 0;
    forever #10 clk = !clk;
  end

  integer ii, jj;

  initial begin
    reset_n = 0;
    weights_load = 0;
    #80;
    reset_n = 1;
    #20;

    for (ii = 0; ii < ARRAY_W_W; ii = ii + 1) begin
      for (jj = 0; jj < ARRAY_W_L; jj = jj + 1) begin
        weight_test[ii][jj] = ARRAY_W_L * ii + jj + 1;
      end
    end
    weights_load = 1;

    #20;
    weights_load = 0;
    #20;
    inputs_test[0] = input_data[0][0];
    #20;
    inputs_test[0] = input_data[1][0];
    inputs_test[1] = input_data[0][1];
    #20;
    inputs_test[0] = input_data[2][0];
    inputs_test[1] = input_data[1][1];
    inputs_test[2] = input_data[0][2];
    #20;
    inputs_test[0] = input_data[3][0];
    inputs_test[1] = input_data[2][1];
    inputs_test[2] = input_data[1][2];
    #20;
    inputs_test[1] = input_data[3][1];
    inputs_test[2] = input_data[2][2];
    #20;
    inputs_test[2] = input_data[3][2];
    #500;
    $finish;
  end
endmodule
