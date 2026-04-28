`timescale 1ns / 1ps

module mips_pipeline_TB;

    reg clk;
    reg rst;

    mips_pipeline uut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #15 rst = 0;
        #500 $finish;
    end

endmodule