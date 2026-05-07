`timescale 1ns / 1ps

module mips_pipeline(
    input wire clk, rst
);
    wire stall;
    wire [31:0] if_id_instr, if_id_pc;
    wire [1:0]  id_ex_wb;
    wire [2:0]  id_ex_mem;
    wire [3:0]  id_ex_execute;
    wire [31:0] id_ex_npc, id_ex_readdat1, id_ex_readdat2, id_ex_sign_ext;
    wire [4:0]  id_ex_instr_20_16, id_ex_instr_15_11;
    wire [4:0]  id_ex_rs, id_ex_rt;
    wire        regdst     = id_ex_execute[3];
    wire        alusrc     = id_ex_execute[2];
    wire [1:0]  alu_op     = id_ex_execute[1:0];
    wire [5:0]  instr_0500 = id_ex_sign_ext[5:0];
    wire [1:0]  ForwardA, ForwardB;
    wire [1:0]  wb_ctlout;
    wire        branch, memread, memwrite, zero;
    wire [31:0] EX_MEM_NPC, alu_result, rdata2out;
    wire [4:0]  five_bit_muxout, ex_mem_rs, ex_mem_rt;
    wire        MEM_PCSrc, MEM_WB_regwrite, MEM_WB_memtoreg;
    wire [31:0] read_data, mem_alu_result, mem_write_data;
    wire [4:0]  mem_write_reg;

    hazard_unit hazard(
        .id_ex_memread(memread),
        .id_ex_rt(id_ex_rt),
        .if_id_rs(if_id_instr[25:21]),
        .if_id_rt(if_id_instr[20:16]),
        .stall(stall)
    );

    forwarding_unit fwd(
        .id_ex_rs(id_ex_rs),
        .id_ex_rt(id_ex_rt),
        .ex_mem_rd(five_bit_muxout),
        .mem_wb_rd(mem_write_reg),
        .ex_mem_regwrite(wb_ctlout[1]),
        .mem_wb_regwrite(MEM_WB_regwrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    fetch instr_fetch_stage(
        .clk(clk), .rst(rst), .stall(stall),
        .PC_src(MEM_PCSrc), .PC_from_ExMem(EX_MEM_NPC),
        .if_id_instr(if_id_instr), .if_id_pc(if_id_pc)
    );

    decode decode_stage(
        .clk(clk), .rst(rst), .stall(stall),
        .wb_reg_write(MEM_WB_regwrite),
        .wb_write_reg_location(mem_write_reg),
        .mem_wb_write_data(mem_write_data),
        .if_id_instr(if_id_instr), .if_id_npc(if_id_pc),
        .id_ex_wb(id_ex_wb), .id_ex_mem(id_ex_mem), .id_ex_execute(id_ex_execute),
        .id_ex_npc(id_ex_npc), .id_ex_readdat1(id_ex_readdat1),
        .id_ex_readdat2(id_ex_readdat2), .id_ex_sign_ext(id_ex_sign_ext),
        .id_ex_instr_bits_20_16(id_ex_instr_20_16),
        .id_ex_instr_bits_15_11(id_ex_instr_15_11),
        .id_ex_rs(id_ex_rs), .id_ex_rt(id_ex_rt)
    );

    execute execute_stage(
        .clk(clk), .rst(rst),
        .wb_ctl(id_ex_wb), .m_ctl(id_ex_mem),
        .regdst(regdst), .alusrc(alusrc), .alu_op(alu_op),
        .npc(id_ex_npc), .rdata1(id_ex_readdat1), .rdata2(id_ex_readdat2),
        .s_extend(id_ex_sign_ext), .instr_0500(instr_0500),
        .instr_2016(id_ex_instr_20_16), .instr_1511(id_ex_instr_15_11),
        .id_ex_rs(id_ex_rs), .id_ex_rt(id_ex_rt),
        .ForwardA(ForwardA), .ForwardB(ForwardB),
        .ex_mem_alu_result(alu_result),
        .mem_wb_write_data(mem_write_data),
        .wb_ctlout(wb_ctlout), .branch(branch), .memread(memread), .memwrite(memwrite),
        .EX_MEM_NPC(EX_MEM_NPC), .zero(zero),
        .alu_result(alu_result), .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout),
        .ex_mem_rs(ex_mem_rs), .ex_mem_rt(ex_mem_rt)
    );

    memory memory_wb_stage(
        .clk(clk), .branch(branch), .zero(zero),
        .memwrite(memwrite), .memread(memread),
        .alu_result(alu_result), .rdata2out(rdata2out),
        .wb_ctlout(wb_ctlout), .five_bit_muxout(five_bit_muxout),
        .MEM_PCSrc(MEM_PCSrc), .MEM_WB_regwrite(MEM_WB_regwrite),
        .MEM_WB_memtoreg(MEM_WB_memtoreg),
        .read_data(read_data), .mem_alu_result(mem_alu_result),
        .mem_write_reg(mem_write_reg)
    );

    mux mem_mux(
        .a_true(read_data), .b_false(mem_alu_result),
        .sel(MEM_WB_memtoreg), .y(mem_write_data)
    );
endmodule
