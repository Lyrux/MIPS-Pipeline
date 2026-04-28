`timescale 1ns / 1ps

module ex_mem(
    input wire [1:0] wb_ctl,
    input wire [2:0] m_ctl,
    input wire [31:0] adder_out,
    input wire aluzero, clk, rst,
    input wire [31:0] aluout, readdat2,
    input wire [4:0] muxout,
    output reg [1:0] wb_ctlout,
    output reg branch, memread, memwrite,
    output reg [31:0] add_result,
    output reg zero,
    output reg [31:0] alu_result, rdata2out,
    output reg [4:0] five_bit_muxout
);

    initial begin
        wb_ctlout      = 2'b0;
        branch         = 1'b0;
        memread        = 1'b0;
        memwrite       = 1'b0;
        add_result     = 32'b0;
        zero           = 1'b0;
        alu_result     = 32'b0;
        rdata2out      = 32'b0;
        five_bit_muxout = 5'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wb_ctlout      <= 2'b0;
            branch         <= 1'b0;
            memread        <= 1'b0;
            memwrite       <= 1'b0;
            add_result     <= 32'b0;
            zero           <= 1'b0;
            alu_result     <= 32'b0;
            rdata2out      <= 32'b0;
            five_bit_muxout <= 5'b0;
        end else begin
            wb_ctlout      <= wb_ctl;
            branch         <= m_ctl[2];
            memread        <= m_ctl[1];
            memwrite       <= m_ctl[0];
            add_result     <= adder_out;
            zero           <= aluzero;
            alu_result     <= aluout;
            rdata2out      <= readdat2;
            five_bit_muxout <= muxout;
        end
    end
endmodule