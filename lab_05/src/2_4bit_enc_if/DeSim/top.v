module top (SW, KEY, LEDR);

    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [9:0] LEDR;     // DE-series LEDs   

    b2_enc_if dut (SW[9:0], LEDR[3:0], KEY[0]);
 
endmodule

