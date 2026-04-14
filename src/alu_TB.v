`timescale 1ns / 1ps

module alu_TB;
    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] control;
    // Outputs
    wire [31:0] result;
    wire zero;
    
    alu uut (
    .a(a), 
    .b(b), 
    .control(control), 
    .result(result), 
    .zero(zero)
    );
    
    initial begin
        a <= 'b1010; // 10
        b <= 'b0111; // 7

        control <= 'b011;
        #1 
        control <= 'b100;
        #1 
        control <= 'b010;
        #1 
        control <= 'b111; // result = 0 check slt
        #1 
        control <= 'b011;
        #1 
        control <= 'b110;
        #1 
        control <= 'b001; // result = 'b1111, check or
        #1 
        control <= 'b000; // result = 'b10, check and
        #1
        $finish;
    end
endmodule
