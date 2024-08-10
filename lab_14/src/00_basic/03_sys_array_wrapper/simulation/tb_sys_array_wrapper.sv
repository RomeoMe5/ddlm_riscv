`timescale 1 ns / 100 ps

module tb_sys_array_wrapper
#(  parameter DATA_WIDTH = 8,//Разрядность шины входных данных
  	parameter ARRAY_A_W  = 4, //Количество строк в массиве данных
    parameter ARRAY_A_L  = 3, //Количество столбцов в массиве данных
    parameter ARRAY_W_W  = 3, //Количество строк в массиве весов
    parameter ARRAY_W_L  = 4);//Количество столбцов в массиве весов
    
reg clk, reset_n, load_params, start_comp;
reg [3:0] row, col;
wire [0:5][7:0] out_data;
wire ready;

sys_array_wrapper #(.DATA_WIDTH(DATA_WIDTH),
                    .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
                    .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L)) 
sys_array_wrapper0 (
    .clk(clk),
    .reset_n(reset_n),
    .load_params(load_params),
    .start_comp(start_comp),
    .row(row),
    .col(col),
    .ready(ready),
    .hex_connect(out_data)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

integer ii, jj;

initial
begin
    row = 0;
    col = 0;
    reset_n=0; 
    load_params = 1;
    start_comp = 1;
    #80; reset_n=1;
    #20;
    load_params = 1'b0;
    #20;
    load_params = 1'b1;
    #10;
    start_comp = 1'b0;
    #20;
    start_comp = 1'b1;
    while (~ready)
        #20;

    for (ii = 0; ii < ARRAY_A_W; ii = ii + 1) begin
        for (jj = 0; jj < ARRAY_W_L; jj = jj + 1) begin
            row = ii;
            col = jj;
            #20;
        end
    end
    $finish;

end
endmodule
