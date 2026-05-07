`timescale 1ns / 1ps

module mux(
    input [31:0] a_true,
    input [31:0] b_false,
    input sel,
    output reg [31:0] y
);
    always @(*) begin
        if (sel == 1'b1)
            y = a_true;    // blocking assignment - correct for combinational
        else
            y = b_false;
    end
endmodule