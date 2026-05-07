`timescale 1ns / 1ps

module regfile(clk, rst, regwrite, rs, rt, rd, writedata, A_readdat1, B_readdat2);
    input clk, rst, regwrite;
    input [4:0] rs, rt, rd;
    input [31:0] writedata;
    output reg [31:0] A_readdat1, B_readdat2;

    reg [31:0] REG [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            REG[i] = 32'h00000000;
        A_readdat1 = 32'h00000000;
        B_readdat2 = 32'h00000000;
    end

    always @(posedge clk) begin
        if (rst) begin
            A_readdat1 <= 32'h00000000;
            B_readdat2 <= 32'h00000000;
        end else begin
            A_readdat1 <= REG[rs];
            B_readdat2 <= REG[rt];
            if (regwrite == 1 && rd != 5'b00000)
                REG[rd] <= writedata;
        end
    end
endmodule