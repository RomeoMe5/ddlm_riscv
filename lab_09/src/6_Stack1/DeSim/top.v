module top (SW, KEY, LEDR);

    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [9:0] LEDR;     // DE-series LEDs   

    stack_1 dut (KEY[0], KEY[1], KEY[2], KEY[3], SW[7:0], LEDR[7:0]);
 
endmodule

