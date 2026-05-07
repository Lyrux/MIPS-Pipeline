`timescale 1ns / 1ps

module alu_mux_b(
    input wire [1:0]  ForwardB,
    input wire [31:0] rdata2,
    input wire [31:0] ex_mem_alu_result,
    input wire [31:0] mem_wb_write_data,
    output reg [31:0] y
);
    always @(*) begin
        case (ForwardB)
            2'b00: y = rdata2;
            2'b10: y = ex_mem_alu_result;
            2'b01: y = mem_wb_write_data;
            default: y = rdata2;
        endcase
    end
endmodule
