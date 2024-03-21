module top (SW, KEY, LEDR);

    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [9:0] LEDR;     // DE-series LEDs   

    hcsr04 lab6 (KEY[0], SW[0], KEY[2], LEDR[9], LEDR[7:0]);
 
endmodule

