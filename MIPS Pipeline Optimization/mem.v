`timescale 1ns / 1ps

module data_memory(
    input wire [31:0] addr, write_data,
    input wire memread, memwrite, clk,
    output wire [31:0] read_data  // combinational read
);
    reg [31:0] DMEM [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            DMEM[i] = 32'h00000000;
        $readmemb("data.mem", DMEM);
    end

    // combinational read - data available same cycle as address
    assign read_data = (memread) ? DMEM[addr] : 32'h00000000;

    // registered write
    always @(posedge clk) begin
        if (memwrite)
            DMEM[addr] <= write_data;
    end

endmodule