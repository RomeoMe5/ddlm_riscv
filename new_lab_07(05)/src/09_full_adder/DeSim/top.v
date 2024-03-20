module top (SW, LEDR);

    input wire [9:0] SW;        // DE-series switches
 
    output wire [9:0] LEDR;     // DE-series LEDs   

    external_full_adder dut (SW[9:0], LEDR[9:0]);

endmodule

