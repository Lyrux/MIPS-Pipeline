`timescale 1ns / 1ps

module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [2:0] control,
    output reg [31:0] result,
    output wire zero
);

    parameter ALUadd = 3'b010,
              ALUsub = 3'b110,
              ALUand = 3'b000,
              ALUor  = 3'b001,
              ALUslt = 3'b111;

    wire sign_mismatch = a[31] ^ b[31];

    initial result = 32'h00000000;

    always @(*) begin
        if (^a === 1'bx || ^b === 1'bx || ^control === 1'bx)
            result = 32'h00000000;
        else
            case(control)
                ALUadd: result = a + b;
                ALUsub: result = a - b;
                ALUand: result = a & b;
                ALUor:  result = a | b;
                ALUslt: result = (a < b) ? (1 - sign_mismatch) : (0 + sign_mismatch);
                default: result = 32'h00000000;
            endcase
    end

    assign zero = (result == 0) ? 1 : 0;

endmodule