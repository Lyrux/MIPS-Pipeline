`timescale 1ns/1ps
module fetch_sim;
    reg clk, rst, PC_src;
    reg [31:0] PC_from_ExMem;
    wire [31:0] if_id_instr, if_id_pc;

    fetch UUT(.clk(clk), .rst(rst), .PC_src(PC_src), .PC_from_ExMem(PC_from_ExMem),
              .if_id_instr(if_id_instr), .if_id_pc(if_id_pc));

    initial begin
        clk = 0;
        forever #1 clk = ~clk;   
    end

    initial begin
     
        rst = 1;
        PC_from_ExMem = 32'h0;
        PC_src = 1;
        


        #5
        rst = 0;
        PC_src = 0;

        #2

        #20
        PC_from_ExMem = 32'h8;
        PC_src = 1;
        #5
        PC_src = 0;
        
        #30
        
        
        $finish;
    end
endmodule