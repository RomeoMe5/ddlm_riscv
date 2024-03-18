module top (SW, KEY, LEDR);

    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [9:0] LEDR;     // DE-series LEDs   

    cnt_load lab6 (KEY[0], KEY[1], KEY[2], SW, LEDR);
 
endmodule

