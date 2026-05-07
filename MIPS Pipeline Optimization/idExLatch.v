`timescale 1ns / 1ps

module idExLatch(
    input  wire        clk, rst, stall,
    input  wire [1:0]  ctl_wb,
    input  wire [2:0]  ctl_mem,
    input  wire [3:0]  ctl_ex,
    input  wire [31:0] npc, readdat1, readdat2, sign_ext,
    input  wire [4:0]  instr_bits_20_16, instr_bits_15_11,
    input  wire [4:0]  rs_in, rt_in,
    output reg  [1:0]  wb_out,
    output reg  [2:0]  mem_out,
    output reg  [3:0]  ctl_out,
    output reg  [31:0] npc_out, readdat1_out, readdat2_out, sign_ext_out,
    output reg  [4:0]  instr_bits_20_16_out, instr_bits_15_11_out,
    output reg  [4:0]  rs_out, rt_out
);
    initial begin
        wb_out = 0; mem_out = 0; ctl_out = 0;
        npc_out = 0; readdat1_out = 0; readdat2_out = 0; sign_ext_out = 0;
        instr_bits_20_16_out = 0; instr_bits_15_11_out = 0;
        rs_out = 0; rt_out = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst || stall) begin
            wb_out <= 0; mem_out <= 0; ctl_out <= 0;
            npc_out <= 0; readdat1_out <= 0; readdat2_out <= 0; sign_ext_out <= 0;
            instr_bits_20_16_out <= 0; instr_bits_15_11_out <= 0;
            rs_out <= 0; rt_out <= 0;
        end else begin
            wb_out               <= ctl_wb;
            mem_out              <= ctl_mem;
            ctl_out              <= ctl_ex;
            npc_out              <= npc;
            readdat1_out         <= readdat1;
            readdat2_out         <= readdat2;
            sign_ext_out         <= sign_ext;
            instr_bits_20_16_out <= instr_bits_20_16;
            instr_bits_15_11_out <= instr_bits_15_11;
            rs_out               <= rs_in;
            rt_out               <= rt_in;
        end
    end
endmodule
