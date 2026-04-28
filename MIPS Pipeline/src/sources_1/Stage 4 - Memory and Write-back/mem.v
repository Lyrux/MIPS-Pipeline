`timescale 1ns / 1ps

module data_memory(
    input wire [31:0] addr,
    input wire [31:0] write_data,
    input wire memread, memwrite, clk,
    output reg [31:0] read_data
);

    reg [31:0] DMEM [0:255];
    integer i;

    initial begin
        read_data = 0;
        for (i = 0; i < 256; i = i + 1)
            DMEM[i] = 32'h00000000;
        $readmemb("data.mem", DMEM);
    end

    always @(posedge clk) begin
        if (memread)
            read_data <= DMEM[addr];
        if (memwrite)
            DMEM[addr] <= write_data;
    end

endmodule