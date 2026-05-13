module data_memory(
    input wire [31:0] addr,
    input wire [31:0] write_data,
    input wire memread, memwrite, clk,
    output wire [31:0] read_data      // <-- wire, not reg
);
    reg [31:0] DMEM [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            DMEM[i] = 32'h00000000;
        $readmemb("data.mem", DMEM);
    end

    assign read_data = memread ? DMEM[addr] : 32'h00000000;

    always @(posedge clk) begin
        if (memwrite)
            DMEM[addr] <= write_data;
    end

endmodule
