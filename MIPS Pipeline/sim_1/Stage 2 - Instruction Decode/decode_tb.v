`timescale 1ns / 1ps

module tb_decode;
    reg         clk, rst;
    reg         wb_reg_write;
    reg  [4:0]  wb_write_reg_location;
    reg  [31:0] mem_wb_write_data, if_id_instr, if_id_npc;

    wire [1:0]  id_ex_wb;
    wire [2:0]  id_ex_mem;
    wire [3:0]  id_ex_execute;
    wire [31:0] id_ex_npc, id_ex_readdat1, id_ex_readdat2, id_ex_sign_ext;
    wire [4:0]  id_ex_instr_bits_20_16, id_ex_instr_bits_15_11;

    decode dut(
        .clk(clk), .rst(rst),
        .wb_reg_write(wb_reg_write),
        .wb_write_reg_location(wb_write_reg_location),
        .mem_wb_write_data(mem_wb_write_data),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc),
        .id_ex_wb(id_ex_wb),
        .id_ex_mem(id_ex_mem),
        .id_ex_execute(id_ex_execute),
        .id_ex_npc(id_ex_npc),
        .id_ex_readdat1(id_ex_readdat1),
        .id_ex_readdat2(id_ex_readdat2),
        .id_ex_sign_ext(id_ex_sign_ext),
        .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16),
        .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        wb_reg_write = 0;
        wb_write_reg_location = 0;
        mem_wb_write_data = 0;
        if_id_instr = 0;
        if_id_npc = 0;
        #10 rst = 0;

        // Test R-type: add $t2,$t0,$t1
        if_id_instr = {6'b000000, 5'd8, 5'd9, 5'd10, 5'b00000, 6'b100000};
        if_id_npc = 32'h00000004;
        #10;

        // Test LW: lw $s0, 16($t0)
        if_id_instr = {6'b100011, 5'd8, 5'd16, 16'd16};
        if_id_npc = 32'h00000008;
        #10;

        // Test SW: sw $s0, 4($t0)
        if_id_instr = {6'b101011, 5'd8, 5'd16, 16'd4};
        if_id_npc = 32'h0000000C;
        #10;

        // Test BEQ: beq $t0, $t1, 8
        if_id_instr = {6'b000100, 5'd8, 5'd9, 16'd8};
        if_id_npc = 32'h00000010;
        #10;

        $finish;
    end
endmodule
