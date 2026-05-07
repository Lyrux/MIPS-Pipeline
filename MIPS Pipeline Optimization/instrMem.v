`timescale 1ns / 1ps

module instrMem(clk, rst, addr, instr_out);
    input clk, rst;
    input  [31:0] addr;
    output wire [31:0] instr_out;

    reg [31:0] mem [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'h00000000;

        mem[0]  = 32'h8c010001; // LW r1, 1(r0)    -> r1 = 1
        mem[1]  = 32'h00000000; // NOP
        mem[2]  = 32'h00000000; // NOP
        mem[3]  = 32'h00000000; // NOP
        mem[4]  = 32'h00000000; // NOP
        mem[5]  = 32'h8c020002; // LW r2, 2(r0)    -> r2 = 2
        mem[6]  = 32'h00000000; // NOP
        mem[7]  = 32'h00000000; // NOP
        mem[8]  = 32'h00000000; // NOP
        mem[9]  = 32'h00000000; // NOP
        // r1 and r2 fully in regfile - back to back ADDs test EX forwarding
        mem[10] = 32'h00221820; // ADD r3, r1, r2  -> r3 = 3
        mem[11] = 32'h00612020; // ADD r4, r3, r1  -> r4 = 4  (EX forward r3)
        mem[12] = 32'h00832820; // ADD r5, r4, r3  -> r5 = 7  (EX forward r4)
        mem[13] = 32'h00a43020; // ADD r6, r5, r4  -> r6 = 11 (EX forward r5)
        mem[14] = 32'h00000000; // NOP
        mem[15] = 32'h00000000; // NOP
        mem[16] = 32'h00000000; // NOP
        mem[17] = 32'h00000000; // NOP
    end

    wire [5:0] word_addr = addr[7:2];
    assign instr_out = (rst) ? 32'h00000000 : mem[word_addr];
endmodule