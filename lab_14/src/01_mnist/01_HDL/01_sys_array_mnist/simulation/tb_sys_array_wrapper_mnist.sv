`timescale 1 ns / 100 ps

module tb_sys_array_wrapper_mnist
#(  parameter DATA_WIDTH = 16,//Разрядность шины входных данных
	parameter ARRAY_A_W  = 1, //Количество строк в массиве данных
    parameter ARRAY_A_L  = 784, //Количество столбцов в массиве данных
    parameter ARRAY_W_W  = 784, //Количество строк в массиве весов
    parameter ARRAY_W_L  = 10, //Количество столбцов в массиве весов
    parameter IMAGES = 10); //Количество изображений для тестирования
    
reg clk, reset_n, load_params, start_comp;
reg [3:0] image_num;
wire [7:0] out_data;
wire [9:0] classes;
wire ready;

sys_array_wrapper_mnist #(.DATA_WIDTH(DATA_WIDTH),
                    .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
                    .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L),
                    .IMAGES(IMAGES))
sys_array_wrapper_mnist0 (
    .clk(clk),
    .reset_n(reset_n),
    .load_params(load_params),
    .start_comp(start_comp),
    .image_num(image_num),
    .ready(ready),
    .hex_connect(out_data),
    .classes(classes)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

integer ii;

initial
begin
    reset_n=0; 
    load_params = 1;
    start_comp = 1;
    #80; reset_n=1;
    #20;

    for (ii = 0; ii < IMAGES; ii = ii + 1) begin
        image_num = ii;
        load_params = 1'b0;
        #20;
        load_params = 1'b1;
        #20;
        start_comp = 1'b0;
        #20;
        start_comp = 1'b1;
        while (~ready)
            #20;
        case (classes)
            10'b0000000001: $display("Image #%d is 0", ii);
            10'b0000000010: $display("Image #%d is 1", ii);
            10'b0000000100: $display("Image #%d is 2", ii);
            10'b0000001000: $display("Image #%d is 3", ii);
            10'b0000010000: $display("Image #%d is 4", ii);
            10'b0000100000: $display("Image #%d is 5", ii);
            10'b0001000000: $display("Image #%d is 6", ii);
            10'b0010000000: $display("Image #%d is 7", ii);
            10'b0100000000: $display("Image #%d is 8", ii);
            10'b1000000000: $display("Image #%d is 9", ii);
        endcase
        #100;
    end   

    $finish;

end
endmodule
