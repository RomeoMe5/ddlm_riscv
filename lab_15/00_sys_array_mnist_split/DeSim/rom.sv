module rom
#(parameter DATA_WIDTH=8, 
parameter ARRAY_W=4, 
parameter ARRAY_L=4,
parameter FILE="rom.hex")
(	input clk,
    output [DATA_WIDTH - 1:0] data_rom [0:ARRAY_W-1] [0:ARRAY_L-1]
);

genvar i, j;
reg [DATA_WIDTH-1:0] rom [ARRAY_W*ARRAY_L-1:0];
initial begin
    $readmemh(FILE, rom);
end

generate
    for (i=0;i<ARRAY_W;i=i+1) begin: generate_roma_W
        for (j=0;j<ARRAY_L;j=j+1) begin: generate_roma_L
	        assign data_rom[i][j] = rom[ARRAY_L*i + j];
	    end
    end
endgenerate

endmodule