`timescale 1ns / 1ps

module execute(
    input wire [1:0] wb_ctl,
    input wire [2:0] m_ctl,
    input wire regdst, alusrc, clk, rst,
    input wire [1:0] alu_op,
    input wire [31:0] npc, rdata1, rdata2, s_extend,
    input wire [5:0] instr_0500,
    input wire [4:0] instr_2016, instr_1511,
    output wire [1:0] wb_ctlout,
    output wire branch, memread, memwrite,
    output wire [31:0] EX_MEM_NPC,
    output wire zero,
    output wire [31:0] alu_result, rdata2out,
    output wire [4:0] five_bit_muxout
);

    wire [4:0]  muxout;
    wire [31:0] adder_out, b, aluout;
    wire [2:0]  control;
    wire aluzero;

    // renamed to ex_adder to avoid collision with fetch stage's pc_adder
    ex_adder adder3(
        .add_in1(npc),
        .add_in2(s_extend),
        .add_out(adder_out)
    );

    bottom_mux bottom_mux3(
        .a(instr_1511),
        .b(instr_2016),
        .sel(regdst),
        .y(muxout)
    );

    alu_control alu_control3(
        .funct(instr_0500),
        .alu_op(alu_op),
        .select(control)
    );

    alu alu3(
        .a(rdata1),
        .b(b),
        .control(control),
        .result(aluout),
        .zero(aluzero)
    );

    top_mux top_mux3(
        .y(b),
        .a(s_extend),
        .b(rdata2),
        .alusrc(alusrc)
    );

    ex_mem ex_mem3(
        .wb_ctl(wb_ctl),
        .m_ctl(m_ctl),
        .adder_out(adder_out),
        .aluzero(aluzero),
        .aluout(aluout),
        .readdat2(rdata2),
        .muxout(muxout),
        .wb_ctlout(wb_ctlout),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .add_result(EX_MEM_NPC),
        .zero(zero),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout),
        .clk(clk),
        .rst(rst)
    );

endmodule