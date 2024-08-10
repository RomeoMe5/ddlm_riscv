module de10_lite
(
    input               ADC_CLK_10,
    input               MAX10_CLK1_50,
    input               MAX10_CLK2_50,

    output  [  7:0 ]    HEX0,
    output  [  7:0 ]    HEX1,
    output  [  7:0 ]    HEX2,
    output  [  7:0 ]    HEX3,
    output  [  7:0 ]    HEX4,
    output  [  7:0 ]    HEX5,

    input   [  1:0 ]    KEY,
    output  [  9:0 ]    LEDR,
    input   [  9:0 ]    SW,
    inout   [ 35:0 ]    GPIO
);

    sys_array_wrapper #(.DATA_WIDTH(8), 
                    .ARRAY_W_W(3), .ARRAY_W_L(4),
                    .ARRAY_A_W(4), .ARRAY_A_L(3)) 
    sys_array_wrapper0 (
        .clk(MAX10_CLK1_50),
        .reset_n(KEY[0]),
        .load_params(SW[0]),
        .start_comp(SW[1]),
        .row(SW[9:6]),
        .col(SW[5:2]),
        .ready(LEDR[0]),
        .hex_connect({HEX5, HEX4, HEX3, HEX2, HEX1, HEX0})
    );

endmodule
