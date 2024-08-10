// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

// This testbench is designed to hide the details of using the VPI code

module tb();

    reg             CLOCK_50 = 0; // DE-series 50 MHz clock
    reg     [ 3: 0] KEY = 0;      // DE-series pushbutton keys
    reg     [ 9: 0] SW = 0;       // DE-series SW switches
    wire    [47: 0] HEX;          // HEX displays (six ports)
    wire    [ 9: 0] LEDR;         // DE-series LEDs

    reg             key_action = 0;
    reg     [ 7: 0] scan_code = 0;
    wire    [ 2: 0] ps2_lock_control;
    wire            ps2_clk;
    wire            ps2_dat;

    wire    [ 7: 0] VGA_X;        // "VGA" column
    wire    [ 6: 0] VGA_Y;        // "VGA" row
    wire    [ 2: 0] VGA_COLOR;    // "VGA pixel" colour (0-7)
    wire            plot;         // "Pixel" is drawn when this is pulsed
    wire    [31: 0] GPIO;         // DE-series 40-pin header

    initial $sim_fpga(CLOCK_50, SW, KEY, LEDR, HEX, key_action, scan_code, 
                      ps2_lock_control, VGA_X, VGA_Y, VGA_COLOR, plot, GPIO);


    // create the 50 MHz clock signal
    always #10
        CLOCK_50 <= ~CLOCK_50;

    // the key action should only be active for one cycle.
	// In is set by the VPI, and is unset here.
    always @(posedge CLOCK_50) begin
        if(key_action == 1'b1) begin
            key_action <= 1'b0;
        end
    end

    Top DUT (CLOCK_50, KEY, SW, LEDR, HEX);

    keyboard_interface KeyBoard(CLOCK_50, ~KEY[0], 
        key_action, scan_code, ps2_clk, ps2_dat, ps2_lock_control
    );

endmodule
