module top_mux(
    input [31:0] a, b,
    input alusrc,
    output [31:0] y
);
    assign y = (alusrc) ? a : b;
endmodule
