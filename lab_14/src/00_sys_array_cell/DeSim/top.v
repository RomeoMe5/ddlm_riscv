module top (
    input                    CLOCK_50,
    input                    reset_n,
    input                    weight_load,
    input  signed [7:0]      input_data,
    input  signed [15:0]     prop_data,
    input  signed [7:0]      weights,

    output reg signed [15:0] out_data,
    output reg signed [7:0]  prop_output
);

sys_array_cell#(.DATA_WIDTH(8)) dut ( 
    .clk(CLOCK_50),
    .reset_n(),
    .weight_load(),
    .input_data(),
    .prop_data(),
    .weights(),

    .out_data(),
    .prop_output()
);

endmodule

