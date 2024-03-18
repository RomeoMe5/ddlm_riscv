module b3_enc_case(
   input [15:0] encoder_in,
   output reg [3:0] binary_out,
   input enable
  );


  always @ (*)
   begin
    binary_out = 0;
    if (enable) begin
		 case (encoder_in)
			16'h1   : binary_out = 0;
			16'h2   : binary_out = 1;
			16'h4   : binary_out = 2;
			16'h8   : binary_out = 3;
			16'h10  : binary_out = 4;
			16'h20  : binary_out = 5;
			16'h40  : binary_out = 6;
			16'h80  : binary_out = 7;
			16'h100 : binary_out = 8;
			16'h200 : binary_out = 9;
                        16'h400  : binary_out = 10;
			16'h800  : binary_out = 11;
			16'h1000  : binary_out = 12;
			16'h2000 : binary_out = 13;
			16'h4000 : binary_out = 14;
                        16'h8000 : binary_out = 15;
		 endcase
    end
  end

 endmodule
module timeQuest_wrapper(clock,SW,LED,enable);
	input clock,enable;
	input [9:0] SW;
	output [3:0] LED;
 
	reg [9:0] SW_reg;
	reg [3:0] LED_reg; // registers for 'catching' time
 
	wire [3:0] LED_wire;
	wire [9:0] SW_wire;
	assign SW_wire = SW_reg;
	
	// creating our test instance
	b3_enc_case (SW_reg,LED_wire,enable);
  
   // clock needed to determine at which step register was filled with data
	always @(posedge clock)
		begin
			SW_reg <= SW; // avoiding race and latch by setting '<=' instead of '='
			LED_reg<=LED_wire;
		end
	assign LED = LED_reg;
endmodule


module lab3
(
    input   [ 1:0]  KEY,
    input   [ 9:0]  SW,
    output  [ 9:0]  LEDR
);

	b3_enc_case (SW,LEDR,KEY[0]);
	// Please comment the line above and uncomment line below to use timeQUest_wrapper
	//timeQuest_wrapper(KEY[1],SW,LEDR,KEY[0]);
	
endmodule