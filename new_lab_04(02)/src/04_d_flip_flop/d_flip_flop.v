module d_flip_flop
(
    input   clk,
    input   d,
    output  reg q
);

    always @ (posedge clk)
        q <= d;
 
endmodule
