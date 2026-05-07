`timescale 1ns / 1ps

module execute(
    input wire [1:0]  wb_ctl,
    input wire [2:0]  m_ctl,
    input wire        regdst, alusrc, clk, rst,
    input wire [1:0]  alu_op,
    input wire [31:0] npc, rdata1, rdata2, s_extend,
    input wire [5:0]  instr_0500,
    input wire [4:0]  instr_2016, instr_1511,
    input wire [4:0]  id_ex_rs, id_ex_rt,
    input wire [1:0]  ForwardA, ForwardB,
    input wire [31:0] ex_mem_alu_result,
    input wire [31:0] mem_wb_write_data,
    output wire [1:0] wb_ctlout,
    output wire        branch, memread, memwrite,
    output wire [31:0] EX_MEM_NPC,
    output wire        zero,
    output wire [31:0] alu_result, rdata2out,
    output wire [4:0]  five_bit_muxout,
    output wire [4:0]  ex_mem_rs, ex_mem_rt
);
    wire [4:0]  muxout;
    wire [31:0] adder_out, alu_b_mux, aluout;
    wire [31:0] forward_a_out, forward_b_out;
    wire [2:0]  control;

    ex_adder adder3(.add_in1(npc), .add_in2(s_extend), .add_out(adder_out));

    bottom_mux bottom_mux3(.a(instr_1511), .b(instr_2016), .sel(regdst), .y(muxout));

    alu_control alu_control3(.funct(instr_0500), .alu_op(alu_op), .select(control));

    alu_mux_a fwd_mux_a(
        .ForwardA(ForwardA), .rdata1(rdata1),
        .ex_mem_alu_result(ex_mem_alu_result),
        .mem_wb_write_data(mem_wb_write_data),
        .y(forward_a_out)
    );

    alu_mux_b fwd_mux_b(
        .ForwardB(ForwardB), .rdata2(rdata2),
        .ex_mem_alu_result(ex_mem_alu_result),
        .mem_wb_write_data(mem_wb_write_data),
        .y(forward_b_out)
    );

    top_mux top_mux3(.y(alu_b_mux), .a(s_extend), .b(forward_b_out), .alusrc(alusrc));

    alu alu3(.a(forward_a_out), .b(alu_b_mux), .control(control), .result(aluout), .zero());

    ex_mem ex_mem3(
        .wb_ctl(wb_ctl), .m_ctl(m_ctl), .adder_out(adder_out),
        .aluzero(aluout == 32'b0), .clk(clk), .rst(rst),
        .aluout(aluout), .readdat2(forward_b_out), .muxout(muxout),
        .wb_ctlout(wb_ctlout), .branch(branch), .memread(memread), .memwrite(memwrite),
        .add_result(EX_MEM_NPC), .zero(zero),
        .alu_result(alu_result), .rdata2out(rdata2out), .five_bit_muxout(five_bit_muxout)
    );

    assign ex_mem_rs = id_ex_rs;
    assign ex_mem_rt = id_ex_rt;
endmodule
