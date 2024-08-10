`timescale 1 ns / 100 ps

module tb_shift_reg
#(
	parameter DATA_WIDTH=8,
	parameter LENGTH=4);

reg clk, reset_n;
reg [1:0] ctrl_code;
reg signed [DATA_WIDTH-1:0] data_in [0: LENGTH-1];
reg signed [DATA_WIDTH-1:0] data_write;

wire signed [DATA_WIDTH-1:0] data_read;
wire signed [DATA_WIDTH-1:0] data_out [0: LENGTH-1];

shift_reg #(.DATA_WIDTH(DATA_WIDTH), .LENGTH(LENGTH)) shift_reg1
(
.clk(clk),
.reset_n(reset_n),
.ctrl_code(ctrl_code),
.data_in(data_in),
.data_write(data_write),

.data_read(data_read),
.data_out(data_out)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

integer ii;

initial
    begin
        reset_n = 0; 
		ctrl_code = 2'b00;
		#80; reset_n=1;
        #20;

		ctrl_code = 2'b01;		  
		for (ii = 0; ii < LENGTH; ii = ii + 1) begin
			data_in[ii] = ii + 1;
		end

		#20;
		ctrl_code = 2'b11;
		#80;
		ctrl_code = 2'b10;
		for (ii = 0; ii < 3; ii = ii + 1) begin
			data_write = ii + 5;
			#20;
		end

		ctrl_code = 2'b00;
		#20;
		ctrl_code = 2'b11;
		for (ii = 0; ii < LENGTH; ii = ii + 1) begin
			#20;
        end

		#100;
		$finish;



    end
endmodule