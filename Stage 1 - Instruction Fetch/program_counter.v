`timescale 1ns / 1ps
module program_counter(clock, mux_in, pc);
    input clock;
    input [31:0] mux_in; 
    output reg [31:0] pc;
    
    always @(posedge clock) begin
         pc <= mux_in;
    end
endmodule
