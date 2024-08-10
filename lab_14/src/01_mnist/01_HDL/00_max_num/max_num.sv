module max_num
#(  parameter DATA_WIDTH = 8) //Разрядность шины входных данных
(   input                         clk,
    input                         reset_n,
    input                         start,
    input signed [DATA_WIDTH-1:0] matrix [0:9],

    output reg [9:0] classes,
    output reg       ready
);

reg [2:0] counter;
reg [4:0] half_max_reg;
reg [2:0] three_max_reg;
reg [1:0] i_var;

reg signed [DATA_WIDTH-1:0] half_max [0:4];
reg signed [DATA_WIDTH-1:0] three_max [0:2];
reg signed [DATA_WIDTH-1:0] maximum;

integer i;

always @(posedge clk)
begin
    if (~reset_n)
    begin
        counter <= 'b0;
        classes <= 10'd0;
        ready <= 1'b0;
    end
    else
        if (start)
        begin
            counter <= 'd1;
            classes <= 10'd0;
            ready <= 1'b0;
        end
        else
        begin
            case(counter)                
                'd1: begin
                    counter <= counter + 1;
                    for (i = 0; i < 5; i=i+1)
                    begin
                        if (matrix[2*i] > matrix[2*i+1])
                        begin
                            half_max[i] <= matrix[2*i];
                            half_max_reg[i] <= 1'b0;
                        end
                        else
                        begin
                            half_max[i] <= matrix[2*i+1];
                            half_max_reg[i] <= 1'b1;
                        end
                    end
                end
                'd2: begin
                    counter <= counter + 1;
                    for (i = 0; i < 2; i=i+1)
                    begin
                        if (half_max[2*i] > half_max[2*i+1])
                        begin
                            three_max[i] <= half_max[2*i];
                            three_max_reg[i] <= 1'b0;
                        end
                        else
                        begin
                            three_max[i] <= half_max[2*i+1];
                            three_max_reg[i] <= 1'b1;
                        end
                    end
                    three_max[2] <= half_max[4];
                    three_max_reg[2] <= 1'b0;
                end
                'd3: begin
                    counter <= counter + 1;
                    if ((three_max[0] >= three_max[1]) && (three_max[0] >= three_max[2]))
                    begin
                        maximum <= three_max[0];
                        i_var <= 'd0;
                    end
                    else if ((three_max[1] >= three_max[0]) && (three_max[1] >= three_max[2]))
                    begin
                        maximum <= three_max[1];
                        i_var <= 'd1;
                    end
                    else if ((three_max[2] >= three_max[1]) && (three_max[2] >= three_max[0]))
                    begin
                        maximum <= three_max[2];
                        i_var <= 'd2;
                    end
                end
                'd4: begin
                    classes[4*i_var + 2*three_max_reg[i_var] + half_max_reg[2*i_var+three_max_reg[i_var]]] = 1'b1;
                    ready <= 1'b1;
                end
                default:
                    counter <= 'd0;
            endcase
        end
end

endmodule