`default_nettype none
module Top (
    CLOCK_50,
    KEY,
    SW,
    HEX0,
    HEX1,
    LEDR
);
    input logic CLOCK_50;
    input logic [3:0] KEY;
    input logic [9:0] SW;
    output logic [6:0] HEX0;
    output logic [6:0] HEX1;
    output logic [9:0] LEDR;
    
    wire ready;
    assign HEX1 = {6'b111111, ~ready};

    sys_array_wrapper_mnist_split #(
        .DATA_WIDTH (16),
        .ARRAY_W (10),
        .ARRAY_L (13),
        .ARRAY_A_W (1),
        .ARRAY_A_L (784),
        .ARRAY_W_W (784),
        .ARRAY_W_L (10),
        .ARRAY_MAX_A_W(1),
        .OUT_SIZE (128),
        .IMAGES (10)
    ) sawms1 (
        .clk(CLOCK_50),
        .reset_n(KEY[3]),
        .start_comp(KEY[2]),
        .image_num(SW[3:0]),
        .ready(ready),
        .hex_connect(HEX0),
        .classes(LEDR)
    );
endmodule