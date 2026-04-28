`timescale 1ns / 1ps

module ifIdLatch(clk, rst, pc_in, instr_in, pc_out, instr_out);
    input clk, rst;
    input [31:0] pc_in, instr_in;
    output reg [31:0] pc_out, instr_out;

    initial begin
        pc_out    = 32'd0;
        instr_out = 32'd0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out    <= 32'd0;
            instr_out <= 32'd0;
        end else begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule