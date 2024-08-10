module sys_array_wrapper
#(  parameter DATA_WIDTH = 8,//Разрядность шины входных данных
	parameter ARRAY_A_W  = 1, //Количество строк в массиве данных
    parameter ARRAY_A_L  = 784, //Количество столбцов в массиве данных
    parameter ARRAY_W_W  = 784, //Количество строк в массиве весов
    parameter ARRAY_W_L  = 10) //Количество столбцов в массиве весов
(   input  clk,
    input  reset_n,
    input load_params,
    input  start_comp,
    input  [3:0] row,
    input  [3:0] col,
    output            ready,
    output [0:5][7:0] hex_connect
);

localparam NUM_HEX = DATA_WIDTH >> 1; // Количество необходимых семисегментных индикаторов

reg signed [DATA_WIDTH - 1:0] input_data [0:ARRAY_A_W-1] [0:ARRAY_A_L-1];
reg signed [DATA_WIDTH - 1:0] weights [0:ARRAY_W_W-1] [0:ARRAY_W_L-1];
wire signed [2*DATA_WIDTH-1:0] outputs_fetcher [0:ARRAY_A_W-1] [0:ARRAY_W_L-1];

genvar ii;

rom
#(.DATA_WIDTH(DATA_WIDTH), .ARRAY_W(ARRAY_A_W), .ARRAY_L(ARRAY_A_L), .FILE("../a_data.hex")) 
rom_instance_a
(   .clk(clk), 
    .data_rom(input_data)
);

rom
#(.DATA_WIDTH(DATA_WIDTH), .ARRAY_W(ARRAY_W_W), .ARRAY_L(ARRAY_W_L), .FILE("../b_data.hex")) 
rom_instance_b
(   .clk(clk), 
    .data_rom(weights)
);

// Модуль вычислителя
sys_array_fetcher #(.DATA_WIDTH(DATA_WIDTH),
                    .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
                    .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L)) 
fetching_unit
(
    .clk(clk),
    .reset_n(reset_n),
    .weights_load(~load_params),
    .start_comp(~start_comp),
    .input_data(input_data),
    .weights(weights),
    .ready(ready),
    .out_data(outputs_fetcher)
);

// Генерация модулей для семисегментных переключателей
generate
    for (ii=0; ii<NUM_HEX; ii=ii+1) begin : generate_hexes
        seg7_tohex hex_converter_i1
        (   .code(outputs_fetcher[row][col][4*ii +: 4]), 
            .hexadecimal(hex_connect[ii])
        );
    end
endgenerate

endmodule