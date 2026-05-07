`timescale 1ns / 1ps

module alu_mux_a(
    input wire [1:0]  ForwardA,
    input wire [31:0] rdata1,
    input wire [31:0] ex_mem_alu_result,
    input wire [31:0] mem_wb_write_data,
    output reg [31:0] y
);
    always @(*) begin
        case (ForwardA)
            2'b00: y = rdata1;
            2'b10: y = ex_mem_alu_result;
            2'b01: y = mem_wb_write_data;
            default: y = rdata1;
        endcase
    end
endmodule
