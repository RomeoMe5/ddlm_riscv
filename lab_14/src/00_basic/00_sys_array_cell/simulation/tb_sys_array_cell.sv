`timescale 1 ns / 100 ps

module tb_sys_array_cell
#(parameter DATA_WIDTH=8);
	
reg  signed [DATA_WIDTH - 1:0] input_data;
reg  signed [2*DATA_WIDTH-1:0] prop_data;
reg  signed [DATA_WIDTH-1:0] weights;

wire signed [2*DATA_WIDTH-1:0] out_data;
wire signed [DATA_WIDTH-1:0] prop_output;

reg clk, reset_n, weight_load;

sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) systolic_array_cell(
	.clk(clk),
	.reset_n(reset_n),
    .weight_load(weight_load),
	.input_data(input_data),
	.prop_data(prop_data),
	.weights(weights),
	.out_data(out_data),
    .prop_output(prop_output)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

initial
    begin
        reset_n=0; weight_load = 0;        
        prop_data = 'd2;
        #80; reset_n=1;
        #20;
        weights = 'd5;
        #10;
        weight_load = 1;
        #20; weight_load = 0; 
        #20; input_data = 8'd1;
        #5; $display("time = ", $time, " out_data = ", out_data, " prop_output = ", prop_output);
        #15; input_data = 8'd5;
        #5; $display("time = ", $time, " out_data = ", out_data, " prop_output = ", prop_output);
        $finish;
    end
endmodule
