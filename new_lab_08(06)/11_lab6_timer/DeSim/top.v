module top (SW, KEY, LEDR);

    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [9:0] LEDR;     // DE-series LEDs   

    timer lab6 (KEY[0], SW[0], LEDR[7:0], LEDR[9:8]);
 
endmodule

