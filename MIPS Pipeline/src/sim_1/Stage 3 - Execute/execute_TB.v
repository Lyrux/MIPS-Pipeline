//executeTB.v

module execute_TB;
    reg [1:0] wb_ctl;
    reg [2:0] m_ctl;
    reg alusrc, regdst, clk, rst;
    reg [1:0] alu_op;
    reg [31:0] npc, rdata1, rdata2, s_extend;
    reg [5:0] instr_0500;
    reg [4:0] instr_2016, instr_1511;
    wire [1:0] wb_ctlout;
    wire branch, memread, memwrite, zero;
    wire [31:0] add_result, alu_result, rdata2out; //add_result -> EX_MEM_NPC
    wire [4:0] five_bit_muxout;

    execute UUT (
        .clk(clk),
        .rst(rst),
        .wb_ctl(wb_ctl),
        .m_ctl(m_ctl),
        .npc(npc),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .s_extend(s_extend),
        .instr_2016(instr_2016),
        .instr_1511(instr_1511),
        .alu_op(alu_op),
        .instr_0500(instr_0500),
        .alusrc(alusrc),
        .regdst(regdst),
        .wb_ctlout(wb_ctlout),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .EX_MEM_NPC(add_result),
        .zero(zero),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout)
    );
    
    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;
    end

    initial begin
        // Initialize inputs
        rst = 1;
        wb_ctl = 2'b10; m_ctl = 3'b001;
        npc = 32'd100; rdata1 = 32'd10; rdata2 = 32'd20; s_extend = 32'd4;
        instr_2016 = 5'd5; instr_1511 = 5'd10;
        alu_op = 2'b10; instr_0500 = 6'b100000;
        alusrc = 1; regdst = 1;

        #2
        // Modify inputs to test different scenarios
        rst = 0;
        alusrc = 0; regdst = 0;
        s_extend = 32'd8;
        alu_op = 2'b01; instr_0500 = 6'b100010;

        #2
        $finish;
    end
endmodule