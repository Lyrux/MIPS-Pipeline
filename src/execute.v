`timescale 1ns / 1ps
/*
Execute Stage: This uses the outputs of Fetch and Decode Stages as well as combining the modules: adder, bottom_mux(5-bit), alu_control, alu, top_mux (32-bit),
and ex_mem.
*/
module execute(
    input wire [1:0] wb_ctl,  // 11 inputs, based off of outputs of ID/EX latch (Lab 2-2)
    input wire [2:0] m_ctl,
    input wire regdst, alusrc, clk, rst,
    input wire [1:0] alu_op, 
    input wire [31:0] npc, rdata1, rdata2, s_extend,
    input wire [5:0] instr_0500, // funct field for R-type instructions
    input wire [4:0] instr_2016, instr_1511,
    output wire [1:0] wb_ctlout, // 9 total outputs from EX/MEM latch
    output wire branch, memread, memwrite,
    output wire [31:0] EX_MEM_NPC, // add_result which is the NPC + 4*sign_extend
    output wire zero,
    output wire [31:0] alu_result, rdata2out,
    output wire [4:0] five_bit_muxout
    );
    
    // internal wires to connect internal EXECUTE components together
    wire [4:0] muxout;
    wire [31:0] adder_out, b, aluout; // b is the output of top_mux
    wire [2:0] control;
    wire aluzero;

        adder adder3(
            .add_in1(npc),
            .add_in2(s_extend),
            .add_out(adder_out)
        );

        bottom_mux bottom_mux3(
            .a(instr_1511), // a is MUX output 1
            .b(instr_2016), // b is MUX output 0
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
            .b(b), // b <= output of top_mux
            .control(control),
            .result(aluout),
            .zero(aluzero)
        );

        top_mux top_mux3(
            .y(b), // output of mux is 32 bit "b" wire
            .a(s_extend), 
            .b(rdata2), // input a = 1'b1, b = 1'b0
            .alusrc(alusrc)
        );

        ex_mem ex_mem3(
            .wb_ctl(wb_ctl), // inputs, which should stem from intermediate modules 
            .m_ctl(m_ctl),
            .adder_out(adder_out),
            .aluzero(aluzero),
            .aluout(aluout), 
            .readdat2(rdata2),
            .muxout(muxout), 
            .wb_ctlout(wb_ctlout), // outputs going to FETCH or MEM/WB
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

endmodule // IEXECUTE