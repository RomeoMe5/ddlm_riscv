`timescale 1 ns / 100 ps

module testbench;

    reg  clk, rst_n, d;
    wire q;

    dff_sync_rst_n dff_sync_rst_n (clk, rst_n, d, q);
    
    initial $dumpvars;

    initial
    begin
        rst_n = 0;
        
        $monitor ("%0d clk %b d %b q %b", $time, clk, d, q);

        # 20;   clk = 0; d = 0; 
        # 20;   clk = 1; d = 0; 
        # 20;   clk = 0; d = 1;
        # 20;   clk = 1; d = 1;
        # 20;   clk = 0; d = 1; rst_n = 1;
        # 20;   clk = 1; d = 1;
        # 20;   clk = 0; d = 0;
        # 20;   clk = 1; d = 0; 
        # 10;   clk = 1; d = 0; 
        # 10;   clk = 0; d = 0;
        # 10;   clk = 0; d = 1; 
        # 10;   clk = 1; d = 1; 
        # 10;   clk = 1; d = 1; rst_n = 0;
        # 10;   clk = 0; d = 1;
        # 10;   clk = 0; d = 1;
        # 10;   clk = 1; d = 1;
        # 10;   clk = 1; d = 0;
        # 20;

        $finish;
    end

endmodule
