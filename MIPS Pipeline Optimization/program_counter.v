`timescale 1ns / 1ps

module program_counter(clock, rst, stall, mux_in, pc);
    input clock, rst, stall;
    input [31:0] mux_in;
    output reg [31:0] pc;

    initial pc = 32'h00000000;

    always @(posedge clock) begin
        if (rst)
            pc <= 32'h00000000;
        else if (!stall)
            pc <= mux_in;
    end
endmodule