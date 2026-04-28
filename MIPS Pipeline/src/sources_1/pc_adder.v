`timescale 1ns / 1ps

module pc_adder(
    input  [31:0] pc_in,
    output [31:0] adder_out
);
    assign adder_out = pc_in + 32'd4;
endmodule