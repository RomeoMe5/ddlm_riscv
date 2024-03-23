module top (SW, KEY, LEDR);

	 input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons
   
	 output wire [9:0] LEDR;     // DE-series LEDs   

    isqrt isqrt (KEY[0], KEY[3], KEY[1], SW, LEDR[9], LEDR[8:0]);

endmodule

