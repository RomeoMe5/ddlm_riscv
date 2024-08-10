`ifndef types
`define types 0;
typedef struct packed {
  logic [9:0] A_W_0, A_L_0, A_W_1, A_L_1;
  logic [9:0] B_W_0, B_L_0, B_W_1, B_L_1;
  logic [9:0] O_W_0, O_L_0, O_W_1, O_L_1;
  logic [7:0] to_n1;
  logic [7:0] to_n2;
  logic signed [8:0] parent;
} split_type;
`endif

module sys_array_split #(
    parameter ARRAY_W = 10, //Максимальное число строк в систолическом массиве
    parameter ARRAY_L = 30, //Максимальное число столбцов в систолическом массиве 
    parameter ARRAY_MAX_A_W = 10,
    parameter OUT_SIZE = 64
) (
    input clk,
    input reset_n, 
    input start,
    input  [9:0]   ARRAY_W_W,
    input  [9:0]   ARRAY_W_L,
    input  [9:0]   ARRAY_A_W,
    input  [9:0]   ARRAY_A_L,

    output reg ready,
    
    output split_type out_data[OUT_SIZE],
    output reg [7:0] first_none,
    output reg [7:0] last
);

  reg [9:0] cnt, cur;

  always @(posedge clk) begin
    if (~reset_n) begin
      cnt <= 16'd0;
      cur <= 16'd0;
      ready <= 1'b0;
      last <= 16'd0;
      first_none <= 16'd0;
      out_data <= '{default:'0};
    end else if (start)  begin
      cnt <= 16'd0;
      cur <= 16'd0;
      ready <= 1'b0;
      first_none <= 16'd0;
      last <= 16'd0;
      out_data <= '{default:'0};
    end
    else
    begin
      if (cnt == 0) begin
        out_data[cnt].A_W_0 <= 'b0;
        out_data[cnt].A_L_0 <= 'b0;
        out_data[cnt].A_W_1 <= ARRAY_A_W - 1;
        out_data[cnt].A_L_1 <= ARRAY_A_L - 1;

        out_data[cnt].B_W_0 <= 'b0;
        out_data[cnt].B_L_0 <= 'b0;
        out_data[cnt].B_W_1 <= ARRAY_W_W - 1;
        out_data[cnt].B_L_1 <= ARRAY_W_L - 1;

        out_data[cnt].O_W_0 <= 'b0;
        out_data[cnt].O_L_0 <= 'b0;
        out_data[cnt].O_W_1 <= ARRAY_A_W - 1;
        out_data[cnt].O_L_1 <= ARRAY_W_L - 1;

        cur <= cnt;
        out_data[cnt].parent = -1;

        cnt <= cnt + 1;
      end else begin
        if (cur < cnt) begin
          //LEN_A_W <= (out_data[cur].A_W_1 - out_data[cur].A_W_0);
          //LEN_A_L <= (out_data[cur].A_L_1 - out_data[cur].A_L_0);
          //LEN_B_W <= (out_data[cur].B_W_1 - out_data[cur].B_W_0);
          //LEN_B_L <= (out_data[cur].B_L_1 - out_data[cur].B_L_0);
          if (!((((out_data[cur].A_L_1 - out_data[cur].A_L_0)) < ARRAY_L) && (((out_data[cur].A_W_1 - out_data[cur].A_W_0)) < ARRAY_MAX_A_W) && ((out_data[cur].B_L_1 - out_data[cur].B_L_0) < ARRAY_W)))
                begin
            if ((((out_data[cur].A_W_1 - out_data[cur].A_W_0)) >= ((out_data[cur].A_L_1 - out_data[cur].A_L_0))) && (((out_data[cur].A_W_1 - out_data[cur].A_W_0)) >= (out_data[cur].B_L_1 - out_data[cur].B_L_0))) begin

              out_data[cnt].A_W_0 <= out_data[cur].A_W_0;
              out_data[cnt].A_L_0 <= out_data[cur].A_L_0;
              out_data[cnt].A_W_1 <= out_data[cur].A_W_0 + (((out_data[cur].A_W_1 - out_data[cur].A_W_0) + 1) >> 1) - 1;
              out_data[cnt].A_L_1 <= out_data[cur].A_L_1;

              out_data[cnt].B_W_0 <= out_data[cur].B_W_0;
              out_data[cnt].B_L_0 <= out_data[cur].B_L_0;
              out_data[cnt].B_W_1 <= out_data[cur].B_W_1;
              out_data[cnt].B_L_1 <= out_data[cur].B_L_1;

              out_data[cnt].O_W_0 <= out_data[cur].O_W_0;
              out_data[cnt].O_L_0 <= out_data[cur].O_L_0;
              out_data[cnt].O_W_1 <= out_data[cur].O_W_0 + (((out_data[cur].A_W_1 - out_data[cur].A_W_0) + 1) >> 1) - 1;
              out_data[cnt].O_L_1 <= out_data[cur].O_L_1;

              out_data[cur].to_n1 <= cnt;

              out_data[cnt+1].A_W_0 <= out_data[cur].A_W_0 + (((out_data[cur].A_W_1 - out_data[cur].A_W_0) + 1) >> 1);
              out_data[cnt+1].A_L_0 <= out_data[cur].A_L_0;
              out_data[cnt+1].A_W_1 <= out_data[cur].A_W_1;
              out_data[cnt+1].A_L_1 <= out_data[cur].A_L_1;

              out_data[cnt+1].B_W_0 <= out_data[cur].B_W_0;
              out_data[cnt+1].B_L_0 <= out_data[cur].B_L_0;
              out_data[cnt+1].B_W_1 <= out_data[cur].B_W_1;
              out_data[cnt+1].B_L_1 <= out_data[cur].B_L_1;

              out_data[cnt+1].O_W_0 <= out_data[cur].O_W_0 + (((out_data[cur].A_W_1 - out_data[cur].A_W_0) + 1) >> 1);
              out_data[cnt+1].O_L_0 <= out_data[cur].O_L_0;
              out_data[cnt+1].O_W_1 <= out_data[cur].O_W_1;
              out_data[cnt+1].O_L_1 <= out_data[cur].O_L_1;

              out_data[cur].to_n2 <= cnt + 1;
              cnt <= cnt + 2;
            end else begin
              if (((out_data[cur].B_L_1 - out_data[cur].B_L_0) >= ((out_data[cur].A_L_1 - out_data[cur].A_L_0))) && ((out_data[cur].B_L_1 - out_data[cur].B_L_0) >= ((out_data[cur].A_W_1 - out_data[cur].A_W_0))))
                        begin

                out_data[cnt].A_W_0 <= out_data[cur].A_W_0;
                out_data[cnt].A_L_0 <= out_data[cur].A_L_0;
                out_data[cnt].A_W_1 <= out_data[cur].A_W_1;
                out_data[cnt].A_L_1 <= out_data[cur].A_L_1;

                out_data[cnt].B_W_0 <= out_data[cur].B_W_0;
                out_data[cnt].B_L_0 <= out_data[cur].B_L_0;
                out_data[cnt].B_W_1 <= out_data[cur].B_W_1;
                out_data[cnt].B_L_1 <= out_data[cur].B_L_0 + ((out_data[cur].B_L_1 - out_data[cur].B_L_0 + 1) >> 1) - 1;
                out_data[cur].to_n1 <= cnt;

                out_data[cnt].O_W_0 <= out_data[cur].O_W_0;
                out_data[cnt].O_L_0 <= out_data[cur].O_L_0;
                out_data[cnt].O_W_1 <= out_data[cur].O_W_1;
                out_data[cnt].O_L_1 <= out_data[cur].O_L_0 + ((out_data[cur].B_L_1 - out_data[cur].B_L_0 + 1) >> 1) - 1;



                out_data[cnt+1].A_W_0 <= out_data[cur].A_W_0;
                out_data[cnt+1].A_L_0 <= out_data[cur].A_L_0;
                out_data[cnt+1].A_W_1 <= out_data[cur].A_W_1;
                out_data[cnt+1].A_L_1 <= out_data[cur].A_L_1;

                out_data[cnt+1].B_W_0 <= out_data[cur].B_W_0;
                out_data[cnt+1].B_L_0 <= out_data[cur].B_L_0 + ((out_data[cur].B_L_1 - out_data[cur].B_L_0 + 1) >> 1);
                out_data[cnt+1].B_W_1 <= out_data[cur].B_W_1;
                out_data[cnt+1].B_L_1 <= out_data[cur].B_L_1;

                out_data[cnt+1].O_W_0 <= out_data[cur].O_W_0;
                out_data[cnt+1].O_L_0 <= out_data[cur].O_L_0 + ((out_data[cur].B_L_1 - out_data[cur].B_L_0 + 1) >> 1);
                out_data[cnt+1].O_W_1 <= out_data[cur].O_W_1;
                out_data[cnt+1].O_L_1 <= out_data[cur].O_L_1;

                out_data[cur].to_n2 <= cnt + 1;
                cnt <= cnt + 2;
              end else begin
                if ((((out_data[cur].A_L_1 - out_data[cur].A_L_0)) >= (out_data[cur].B_L_1 - out_data[cur].B_L_0)) && (((out_data[cur].A_L_1 - out_data[cur].A_L_0)) >= ((out_data[cur].A_W_1 - out_data[cur].A_W_0))))
                            begin

                  out_data[cnt].A_W_0 <= out_data[cur].A_W_0;
                  out_data[cnt].A_L_0 <= out_data[cur].A_L_0;
                  out_data[cnt].A_W_1 <= out_data[cur].A_W_1;
                  out_data[cnt].A_L_1 <= out_data[cur].A_L_0 + (((out_data[cur].A_L_1 - out_data[cur].A_L_0) + 1) >> 1) - 1;

                  out_data[cnt].B_W_0 <= out_data[cur].B_W_0;
                  out_data[cnt].B_L_0 <= out_data[cur].B_L_0;
                  out_data[cnt].B_W_1 <= out_data[cur].B_W_0 + ((out_data[cur].B_W_1 - out_data[cur].B_W_0 + 1) >> 1) - 1;
                  out_data[cnt].B_L_1 <= out_data[cur].B_L_1;
                  out_data[cur].to_n1 <= cnt;
                  out_data[cnt].O_W_0 <= out_data[cur].O_W_0;
                  out_data[cnt].O_L_0 <= out_data[cur].O_L_0;
                  out_data[cnt].O_W_1 <= out_data[cur].O_W_1;
                  out_data[cnt].O_L_1 <= out_data[cur].O_L_1;


                  out_data[cnt+1].A_W_0 <= out_data[cur].A_W_0;
                  out_data[cnt+1].A_L_0 <= out_data[cur].A_L_0 + (((out_data[cur].A_L_1 - out_data[cur].A_L_0) + 1) >> 1);
                  out_data[cnt+1].A_W_1 <= out_data[cur].A_W_1;
                  out_data[cnt+1].A_L_1 <= out_data[cur].A_L_1;

                  out_data[cnt+1].B_W_0 <= out_data[cur].B_W_0 + (((out_data[cur].B_W_1 - out_data[cur].B_W_0) + 1) >> 1);
                  out_data[cnt+1].B_L_0 <= out_data[cur].B_L_0;
                  out_data[cnt+1].B_W_1 <= out_data[cur].B_W_1;
                  out_data[cnt+1].B_L_1 <= out_data[cur].B_L_1;

                  out_data[cnt+1].O_W_0 <= out_data[cur].O_W_0;
                  out_data[cnt+1].O_L_0 <= out_data[cur].O_L_0;
                  out_data[cnt+1].O_W_1 <= out_data[cur].O_W_1;
                  out_data[cnt+1].O_L_1 <= out_data[cur].O_L_1;

                  out_data[cur].to_n2 <= cnt + 1;
                  cnt <= cnt + 2;
                end
              end
            end
            out_data[cnt].parent   <= cur;
            out_data[cnt+1].parent <= cur;
          end else begin
            if (first_none == 0) first_none <= cur;
          end
          cur <= cur + 1;

        end else begin
          ready <= 1'b1;
          last  <= cur;
        end
      end
    end
  end

endmodule
