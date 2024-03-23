module top (SW, KEY, LEDR);

    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [9:0] LEDR;     // DE-series LEDs   

    onePort_RAM dut (SW[3:0], SW[9:4], KEY[3], KEY[0], LEDR[3:0], LEDR[9:4]);
 
endmodule

