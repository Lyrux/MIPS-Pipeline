`timescale 1ns / 1ps

module regfile(clk, rst, regwrite, rs, rt, rd, writedata, A_readdat1, B_readdat2);
    input clk, rst, regwrite;
    input [4:0] rs, rt, rd;
    input [31:0] writedata;
    output wire [31:0] A_readdat1, B_readdat2;

    reg [31:0] REG [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            REG[i] = 32'h00000000;
    end

    // Write on posedge clk
    always @(posedge clk) begin
        if (!rst && regwrite == 1 && rd != 5'b00000)
            REG[rd] <= writedata;
    end

    // Read with write-first: if reading same reg being written, return new value
    assign A_readdat1 = (rst) ? 32'h0 :
                        (regwrite && rd == rs && rd != 5'b0) ? writedata : REG[rs];
    assign B_readdat2 = (rst) ? 32'h0 :
                        (regwrite && rd == rt && rd != 5'b0) ? writedata : REG[rt];

endmodule