`timescale 1ns / 1ps

module instrMem(clk, rst, addr, instr_out);
    input clk, rst;
    input  [31:0] addr;
    output wire [31:0] instr_out;

    reg [31:0] mem [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'h00000000;
        $readmemb("instr.mem", mem);
    end

    // mask addr to stay within bounds, always return 0 for out-of-range
    wire [5:0] word_addr = addr[7:2];
    assign instr_out = (rst) ? 32'h00000000 : mem[word_addr];

endmodule