module Top (
    CLOCK_50,
    KEY,
    SW,
    LEDR,
    HEX
);

    input logic CLOCK_50;  // DE-series 50 MHz clock signal
    input logic [3:0] KEY;  // DE-series pushbuttons
    input logic [9:0] SW;  // DE-series switches
    output logic [47: 0] HEX;
    output logic [9:0] LEDR;

    sys_array_wrapper #(.DATA_WIDTH(8), 
                    .ARRAY_W_W(3), .ARRAY_W_L(4),
                    .ARRAY_A_W(4), .ARRAY_A_L(3)) 
    sys_array_wrapper0 (
        .clk(CLOCK_50),
        .reset_n(reset_n),
        .load_params(SW[0]),
        .start_comp(SW[1]),
        .row(SW[9:6]),
        .col(SW[5:2]),
        .ready(LEDR[0]),
        .hex_connect(HEX)
    );

endmodule

