`timescale 1ns / 1ps
module adder(pc_in, adder_out);
    input [31:0] pc_in;
    output [31:0] adder_out;
    localparam [31:0] FOUR = 32'd4;
    
    assign adder_out = pc_in + FOUR;
    
endmodule