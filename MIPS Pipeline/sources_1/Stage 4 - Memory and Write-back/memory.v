`timescale 1ns / 1ps

// Memory Stage: combines AND, data_memory, and mem_wb.
module memory(
    input wire branch, zero, clk, memwrite, memread,
    input wire [31:0] alu_result, rdata2out,
    input wire [1:0]  wb_ctlout,
    input wire [4:0]  five_bit_muxout,
    output wire        MEM_PCSrc, MEM_WB_regwrite, MEM_WB_memtoreg,
    output wire [31:0] read_data, mem_alu_result,
    output wire [4:0]  mem_write_reg
);

    wire [31:0] read_data_wire;  // data_memory -> mem_wb

    AND AND_4(
        .membranch(branch),
        .zero(zero),
        .PCSrc(MEM_PCSrc)
    );

    data_memory data_memory4(
        .clk(clk),
        .addr(alu_result),
        .write_data(rdata2out),
        .memwrite(memwrite),
        .memread(memread),
        .read_data(read_data_wire)   // feeds into mem_wb, not directly out
    );

    mem_wb mem_wb4(
        .clk(clk),
        .control_wb_in(wb_ctlout),
        .read_data_in(read_data_wire),   // FIXED: was undriven wire
        .alu_result_in(alu_result),
        .write_reg_in(five_bit_muxout),
        .regwrite(MEM_WB_regwrite),
        .memtoreg(MEM_WB_memtoreg),
        .read_data(read_data),
        .mem_alu_result(mem_alu_result),
        .mem_write_reg(mem_write_reg)
    );

endmodule