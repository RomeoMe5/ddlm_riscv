module shift_reg #(
    parameter DATA_WIDTH = 8,
    parameter LENGTH = 4
) (
    input clk,
    input reset_n,
    input [1:0] ctrl_code,
    input signed [DATA_WIDTH-1:0] data_in[0:LENGTH-1],
    input signed [DATA_WIDTH-1:0] data_write,

    output reg signed [DATA_WIDTH-1:0] data_read,
    output reg signed [DATA_WIDTH-1:0] data_out [0:LENGTH-1]
);

  localparam REG_UPLOAD = 0,
    REG_LOAD = 1,
    REG_WRITE = 2,
    REG_READ = 3; //Gray coding of states

  reg signed [DATA_WIDTH-1:0] contents[0:LENGTH-1];

  integer i;
  always @(posedge clk) begin
    if (~reset_n) begin
      for (i = 0; i < LENGTH; i = i + 1) begin : for_reset_n
        contents[i] <= {DATA_WIDTH{1'b0}};
      end
    end else begin
      case (ctrl_code)
        REG_UPLOAD: data_out <= contents;
        REG_LOAD:   contents <= data_in;
        REG_READ: begin
          data_read <= contents[0];
          for (i = 0; i < LENGTH - 1; i = i + 1) begin : for_REG_READ
            contents[i] <= contents[i+1];
          end
          contents[LENGTH-1] <= contents[0];
        end
        REG_WRITE: begin
          for (i = 0; i < LENGTH - 1; i = i + 1) begin : for_REG_WRITE
            contents[i] <= contents[i+1];
          end
          contents[LENGTH-1] <= data_write;
        end
      endcase
    end
  end

endmodule
