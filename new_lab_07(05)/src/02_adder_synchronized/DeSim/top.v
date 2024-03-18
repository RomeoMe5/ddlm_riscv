module top (CLOCK_50, KEY, SW, LEDR);

    input CLOCK_50;             // DE-series 50 MHz clock signal
	 input wire [9:0] SW;        // DE-series switches
	 input wire [3:0] KEY;       // DE-series pushbuttons
	 
    output wire [9:0] LEDR;     // DE-series LEDs   

    lab5 adder (CLOCK_50, KEY[1:0], SW[9:0], LEDR[9:0]);

endmodule
