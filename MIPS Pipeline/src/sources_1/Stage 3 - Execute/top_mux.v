module top_mux(
    input [31:0] a, b, // SignExtend, ReadData2
    input alusrc, // control signal from ID/EX latch
    output [31:0] y // 32-bit output to ALU
);
    assign y = (alusrc) ? a : b;
endmodule