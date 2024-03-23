module prefix_adder
# (
    parameter LEVELS = 3,
    parameter WIDTH = 2 ** LEVELS
)
(
    input                      carry_in,
    input    [ WIDTH - 1 : 0 ] x,
    input    [ WIDTH - 1 : 0 ] y,
    output   [ WIDTH - 1 : 0 ] z,
    output                     carry_out
);
    wire [ WIDTH - 1 : 0 ] carry;
    
    wire [ WIDTH - 1 : 0 ] generate_wire, propagate_wire; 
    
    prefix_carry_generator
    # ( .LEVELS(LEVELS), .WIDTH(WIDTH) )
    i_PCG
    (
        .carry_in    ( carry_in       ),
        .generate_in ( generate_wire  ),
        .propagate_in( propagate_wire ),
        .carry       ( carry          ),
        .carry_out   ( carry_out      )
    );
    
    generate
        
        genvar i;
        
        for (i = 0; i <= WIDTH - 1; i = i + 1)
        begin : stage
            //Create generate and propagate signals
            assign generate_wire [ i ] = x[ i ] & y[ i ];
            assign propagate_wire[ i ] = x[ i ] ^ y[ i ];
            //Calculate sum (z bus)
            assign z[ i ] = carry[ i ] ^ propagate_wire[ i ];
        end
    endgenerate
    
endmodule
