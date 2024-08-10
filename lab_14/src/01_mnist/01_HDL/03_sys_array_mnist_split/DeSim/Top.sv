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

    sys_array_wrapper_mnist_split
    #(.DATA_WIDTH(16),
      .ARRAY_W(10),
      .ARRAY_L(13),
      .ARRAY_A_W(1),
      .ARRAY_A_L(784),
      .ARRAY_W_W(784),
      .ARRAY_W_L(10),
      .ARRAY_MAX_A_W(1),
      .OUT_SIZE(128),
      .IMAGES(10)
      )
    sys_array_wrapper0 (
        .clk(MAX10_CLK1_50),
        .reset_n(KEY[0]),
        .start_comp(SW[0]),
        .image_num(SW[5:2]),
        .ready(HEX[8]),
        .hex_connect(HEX[7:0]),
        .classes(LEDR)
    );

endmodule

