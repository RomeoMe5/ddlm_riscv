module top (SW, KEY, LEDR);

    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [9:0] LEDR;     // DE-series LEDs   

    moore_reg_next_out Moore_FSM_reg_next_output (KEY[0], KEY[2], KEY[3], SW[0], LEDR[0]);

endmodule

