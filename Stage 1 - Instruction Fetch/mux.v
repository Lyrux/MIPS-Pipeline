`timescale 1ns / 1ps

module mux(
    input [31:0] a_true,
    input [31:0] b_false,
    input sel,
    output reg [31:0] y
);

always @(*) begin

    if (sel == 1'b1) 
        begin
            y <= a_true;
        end
    
    else 
        begin
            y <= b_false;
        end
end

endmodule