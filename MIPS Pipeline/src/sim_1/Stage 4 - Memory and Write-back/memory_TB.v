`timescale 1ns / 1ps

module memoryTB;

    reg branch, zero, clk, memwrite, memread;
    reg [31:0] alu_result, rdata2out;
    reg [1:0] wb_ctlout;
    reg [4:0] five_bit_muxout;
    wire MEM_PCSrc, MEM_WB_regwrite, MEM_WB_memtoreg;
    wire [31:0] read_data, mem_alu_result;
    wire [4:0] mem_write_reg;

    memory UUT (
        .branch(branch),
        .zero(zero),
        .clk(clk),
        .memwrite(memwrite),
        .memread(memread),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .wb_ctlout(wb_ctlout),
        .five_bit_muxout(five_bit_muxout),
        .MEM_PCSrc(MEM_PCSrc),
        .MEM_WB_regwrite(MEM_WB_regwrite),
        .MEM_WB_memtoreg(MEM_WB_memtoreg),
        .read_data(read_data),
        .mem_alu_result(mem_alu_result),
        .mem_write_reg(mem_write_reg)
    );

    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;
    end

    initial begin
        // Mem Read
        alu_result = 32'h4; //the index in data.txt
        rdata2out = 32'h12345678;
        five_bit_muxout = 5'h02;
        wb_ctlout = 2'b01;
        memwrite = 0;
        memread = 1;
        branch = 0;
        zero = 0;

        #2

        // Mem Write
        memwrite = 1;
        memread = 0;

        #2 // Allow write to occur
        
        memwrite = 0;
        memread = 1;

        #2 // Verify write by reading back

        // Branch
        branch = 1;
        zero = 1;
        
        #2 // Check PCSrc

        branch = 0;
        zero = 0;
        rdata2out = 32'h1;

        #2 

        // Mem Write
        memwrite = 1;
        memread = 0;

        #2
        
        memwrite = 0;
        memread = 1;

        #2 

        $finish;
    end
endmodule