`timescale 1ns / 1ps

module forwarding_unit(
    input wire [4:0] id_ex_rs, id_ex_rt,
    input wire [4:0] ex_mem_rd, mem_wb_rd,
    input wire       ex_mem_regwrite, mem_wb_regwrite,
    output reg [1:0] ForwardA, ForwardB
);
    always @(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        if (ex_mem_regwrite && ex_mem_rd != 5'b0 && ex_mem_rd == id_ex_rs)
            ForwardA = 2'b10;
        if (ex_mem_regwrite && ex_mem_rd != 5'b0 && ex_mem_rd == id_ex_rt)
            ForwardB = 2'b10;

        if (mem_wb_regwrite && mem_wb_rd != 5'b0 &&
            !(ex_mem_regwrite && ex_mem_rd != 5'b0 && ex_mem_rd == id_ex_rs) &&
            mem_wb_rd == id_ex_rs)
            ForwardA = 2'b01;

        if (mem_wb_regwrite && mem_wb_rd != 5'b0 &&
            !(ex_mem_regwrite && ex_mem_rd != 5'b0 && ex_mem_rd == id_ex_rt) &&
            mem_wb_rd == id_ex_rt)
            ForwardB = 2'b01;
    end
endmodule
