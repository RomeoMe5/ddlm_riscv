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

    sys_array_wrapper_mnist #(.DATA_WIDTH(16), 
                    .ARRAY_W_W(784), .ARRAY_W_L(10),
                    .ARRAY_A_W(1), .ARRAY_A_L(784)) 
    sys_array_wrapper0 (
        .clk(MAX10_CLK1_50),
        .reset_n(KEY[0]),
        .load_params(SW[0]),
        .start_comp(SW[1]),
        .image_num(SW[5:2]),
        .ready(HEX1[0]),
        .hex_connect(HEX0),
        .classes(LEDR)
    );

endmodule
