module full_adder
(
    input wire  x, y, carry_in,
	output wire z, carry_out
);
    assign {carry_out, z} = x + y + carry_in;
endmodule