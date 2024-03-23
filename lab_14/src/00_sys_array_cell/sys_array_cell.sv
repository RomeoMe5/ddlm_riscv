module sys_array_cell
#(parameter DATA_WIDTH = 8 // Разрядность шины входных данных
)
( input                            clk,
  input                            reset_n,
  input                            weight_load,
  input  signed [DATA_WIDTH - 1:0] input_data,
  input  signed [2*DATA_WIDTH-1:0] prop_data,
  input  signed [DATA_WIDTH-1:0]   weights,
   
  output reg signed [2*DATA_WIDTH-1:0] out_data,
  output reg signed [DATA_WIDTH-1:0]   prop_output
);

reg signed [DATA_WIDTH-1:0] weight;

always @(posedge clk)
begin
  if (~reset_n) begin // Синхронный сброс
    out_data <= {2 * DATA_WIDTH{1'b0}};
    weight <= {DATA_WIDTH{1'b0}};
  end
  else if (weight_load) begin // Загрузка параметров
    weight <= weights;
  end
  else begin // Вычисление
    out_data <= prop_data + input_data * weight;
    prop_output <= input_data;
  end
end
  
endmodule
