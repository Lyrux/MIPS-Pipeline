`timescale 1ns / 1ps

module regfile(clk, rst, regwrite, rs, rt, rd, writedata, A_readdat1, B_readdat2);
    input clk, rst, regwrite;
    input [4:0] rs, rt, rd;
    input [31:0] writedata;
    output reg [31:0] A_readdat1, B_readdat2;
    
    //create an internal regfile called REG that is 32-bit wide regs with 32 address
    reg [31:0] REG [0:31];
    
    initial begin
        REG[0] = 'h002300AA;
        REG[1] = 'h10654321;
        REG[2] = 'h00100022;
        REG[3] = 'h8C123456;
        REG[4] = 'h8F123456;
        REG[5] = 'hAD654321;
        REG[6] = 'h60000066;
        REG[7] = 'h13012345;
        REG[8] = 'hAC654321;
        REG[9] = 'h12012345;
        REG[10] = 'h00000000;
        REG[11] = 'h00000000;
        REG[12] = 'h00000000;
        REG[13] = 'h00000000;
        REG[14] = 'h00000000;
        REG[15] = 'h00000000;
        REG[16] = 'h00000000;
        REG[17] = 'h00000000;
        REG[18] = 'h00000000;
        REG[19] = 'h00000000;
        REG[20] = 'h00000000;
        REG[21] = 'h00000000;
        REG[22] = 'h00000000;
        REG[23] = 'h00000000;
        REG[24] = 'h00000000;
        REG[25] = 'h00000000;
        REG[26] = 'h00000000;
        REG[27] = 'h00000000;
        REG[28] = 'h00000000;
        REG[29] = 'h00000000;
        REG[30] = 'h00000000;
        REG[31] = 'h00000000;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            A_readdat1 <= 32'h00000000;
            B_readdat2 <= 32'h00000000;
        end
        else begin
            if (regwrite) begin
                if (rd != 'b00000) begin
                    REG[rd] <= writedata;
                end
            end
            else begin 
                A_readdat1 <= REG[rs];
                B_readdat2 <= REG[rt];
            end
        end
    end
endmodule
