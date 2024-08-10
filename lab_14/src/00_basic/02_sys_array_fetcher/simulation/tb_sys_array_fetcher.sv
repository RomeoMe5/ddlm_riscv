`timescale 1 ns / 1 ns

module tb_sys_array_fetcher
#(
	parameter DATA_WIDTH = 8,  // Размерность данных
    parameter ARRAY_W = 10,   // Количество строк в систолическом массиве
    parameter ARRAY_L = 10,   // Количество столбцов в систолическом массиве
    parameter ARRAY_A_W = 4,  // Строк в массиве данных
    parameter ARRAY_A_L = 3,  // Столбцов в массиве данных
    parameter ARRAY_W_W = 3,  // Строк в массиве весов
    parameter ARRAY_W_L = 4   // Столбцов в массиве весов
);
reg clk, reset_n,start_comp, weights_load;

reg signed [DATA_WIDTH-1:0] input_data  [0:ARRAY_A_W-1] [0:ARRAY_A_L-1];
reg signed [DATA_WIDTH-1:0] weights_data  [0:ARRAY_W_W-1] [0:ARRAY_W_L-1];
reg signed [2*DATA_WIDTH-1:0] result_data  [0:ARRAY_A_W-1] [0:ARRAY_W_L-1];

wire ready;
wire signed [2*DATA_WIDTH-1:0] out_data [0:ARRAY_A_W-1] [0:ARRAY_W_L-1];
wire [15:0] cnt;
wire div_clk;

sys_array_fetcher 
#(.DATA_WIDTH(DATA_WIDTH),
.ARRAY_W(ARRAY_W),
.ARRAY_L(ARRAY_L),
.ARRAY_A_W       (ARRAY_A_W    ),
.ARRAY_A_L       (ARRAY_A_L    ),
.ARRAY_W_W       (ARRAY_W_W    ),
.ARRAY_W_L       (ARRAY_W_L    ))
sys_array_fetcher0 (
    .clk(clk),
	.reset_n(reset_n),
    .weights_load(weights_load),
    .start_comp(start_comp),
    .input_data(input_data),
    .weights(weights_data),  
    .ready(ready),
    .out_data(out_data)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

initial begin
    $readmemh("../a_data.hex", input_data);
    $readmemh("../b_data.hex", weights_data);
    $readmemh("../c_data.hex", result_data);
end


integer ii, jj;

initial
    begin
        reset_n=0; weights_load = 1'b0;
        start_comp = 1'b0;
        #20; reset_n=1;
        #20;
        weights_load = 1'b1;
        #20;
        weights_load = 1'b0;
        start_comp = 1'b1;
        #20;
        start_comp = 1'b0;
        #20;
        while (~ready)
            #20;
        for (ii = 0; ii < ARRAY_A_W; ii = ii + 1) begin
            for (jj = 0; jj < ARRAY_W_L; jj = jj + 1) begin
                if (result_data[ii][jj] != out_data[ii][jj])
                begin
                    $display("FAIL!");
                    $finish; 
                end
            end
        end
        #40;
        $display("PASSED");
        $finish;            
    end
endmodule