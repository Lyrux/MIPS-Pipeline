`timescale 1ns / 1ps

module bottom_mux(
//#(parameter BITS = 32)(
output wire [4:0] y, //[BITS-1:0] y, Output of Multiplexer
input wire [4:0] a, //[BITS-1:0] a, Input 1 of Multiplexer (bit 15-11)
input wire [4:0] b, // [BITS-1:0] b, // Input 0 of Multiplexer (bits 20-16)
input wire sel // Select Input
);
   
   assign y = sel ? a : b;
endmodule // mux
