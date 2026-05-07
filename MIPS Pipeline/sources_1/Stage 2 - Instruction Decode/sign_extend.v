`timescale 1ns / 1ps

//pre-pend immediate w/ 16 bits of the MSB

// {} -> concatenate {111, 100} -> 111000
// replicate {4{1}} -> 1111
module sign_extend(
    input wire [15:0] immediate,
    output wire [31:0] extended
    );
    
    
    assign extended = {{16{immediate[15]}}, immediate};
endmodule
