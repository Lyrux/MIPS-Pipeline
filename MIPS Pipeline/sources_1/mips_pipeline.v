`timescale 1ns / 1ps

module mips_pipeline(
    input wire clk, rst
);

    // ===========================================================
    // IF/ID latch outputs
    // ===========================================================
    wire [31:0] if_id_instr;
    wire [31:0] if_id_pc;           // NPC = PC+4 out of IF/ID latch

    // ===========================================================
    // ID/EX latch outputs (from decode stage)
    // ===========================================================
    wire [1:0]  id_ex_wb;           // {RegWrite, MemtoReg}
    wire [2:0]  id_ex_mem;          // {Branch, MemRead, MemWrite}
    wire [3:0]  id_ex_execute;      // {RegDst, ALUSrc, ALUOp[1:0]}
    wire [31:0] id_ex_npc;
    wire [31:0] id_ex_readdat1;
    wire [31:0] id_ex_readdat2;
    wire [31:0] id_ex_sign_ext;
    wire [4:0]  id_ex_instr_20_16;  // rt field
    wire [4:0]  id_ex_instr_15_11;  // rd field

    // Slice id_ex_execute into individual execute control signals
    wire        regdst     = id_ex_execute[3];
    wire        alusrc     = id_ex_execute[2];
    wire [1:0]  alu_op     = id_ex_execute[1:0];

    // funct field = low 6 bits of instruction = low 6 bits of sign_ext
    wire [5:0]  instr_0500 = id_ex_sign_ext[5:0];

    // ===========================================================
    // EX/MEM latch outputs (from execute stage)
    // ===========================================================
    wire [1:0]  wb_ctlout;
    wire        branch;
    wire        memread;
    wire        memwrite;
    wire [31:0] EX_MEM_NPC;
    wire        zero;
    wire [31:0] alu_result;
    wire [31:0] rdata2out;
    wire [4:0]  five_bit_muxout;

    // ===========================================================
    // MEM/WB latch outputs (from memory stage)
    // ===========================================================
    wire        MEM_PCSrc;
    wire        MEM_WB_regwrite;
    wire        MEM_WB_memtoreg;
    wire [31:0] read_data;
    wire [31:0] mem_alu_result;
    wire [4:0]  mem_write_reg;

    // WB mux output fed back to decode
    wire [31:0] mem_write_data;

    // ===========================================================
    // FETCH STAGE
    // ===========================================================
    fetch instr_fetch_stage(
        .clk           (clk),
        .rst           (rst),
        .PC_src        (MEM_PCSrc),
        .PC_from_ExMem (EX_MEM_NPC),
        .if_id_instr   (if_id_instr),
        .if_id_pc      (if_id_pc)
    );

    // ===========================================================
    // DECODE STAGE
    // ===========================================================
    decode decode_stage(
        .clk                    (clk),
        .rst                    (rst),
        // write-back feedback
        .wb_reg_write           (MEM_WB_regwrite),
        .wb_write_reg_location  (mem_write_reg),
        .mem_wb_write_data      (mem_write_data),
        // from IF/ID latch
        .if_id_instr            (if_id_instr),
        .if_id_npc              (if_id_pc),     // fetch port is if_id_pc
        // ID/EX latch outputs
        .id_ex_wb               (id_ex_wb),
        .id_ex_mem              (id_ex_mem),
        .id_ex_execute          (id_ex_execute),
        .id_ex_npc              (id_ex_npc),
        .id_ex_readdat1         (id_ex_readdat1),
        .id_ex_readdat2         (id_ex_readdat2),
        .id_ex_sign_ext         (id_ex_sign_ext),
        .id_ex_instr_bits_20_16 (id_ex_instr_20_16),
        .id_ex_instr_bits_15_11 (id_ex_instr_15_11)
    );

    // ===========================================================
    // EXECUTE STAGE
    // ===========================================================
    execute execute_stage(
        .clk        (clk),
        .rst        (rst),
        // control bundles passed through from ID/EX latch
        .wb_ctl     (id_ex_wb),
        .m_ctl      (id_ex_mem),
        // individual execute controls sliced from id_ex_execute
        .regdst     (regdst),
        .alusrc     (alusrc),
        .alu_op     (alu_op),
        // data from ID/EX latch
        .npc        (id_ex_npc),
        .rdata1     (id_ex_readdat1),
        .rdata2     (id_ex_readdat2),
        .s_extend   (id_ex_sign_ext),
        .instr_0500 (instr_0500),
        .instr_2016 (id_ex_instr_20_16),
        .instr_1511 (id_ex_instr_15_11),
        // EX/MEM latch outputs
        .wb_ctlout      (wb_ctlout),
        .branch         (branch),
        .memread        (memread),
        .memwrite       (memwrite),
        .EX_MEM_NPC     (EX_MEM_NPC),
        .zero           (zero),
        .alu_result     (alu_result),
        .rdata2out      (rdata2out),
        .five_bit_muxout(five_bit_muxout)
    );

    // ===========================================================
    // MEMORY STAGE
    // ===========================================================
    memory memory_wb_stage(
        .clk            (clk),
        .branch         (branch),
        .zero           (zero),
        .memwrite       (memwrite),
        .memread        (memread),
        .alu_result     (alu_result),
        .rdata2out      (rdata2out),
        .wb_ctlout      (wb_ctlout),
        .five_bit_muxout(five_bit_muxout),
        .MEM_PCSrc      (MEM_PCSrc),
        .MEM_WB_regwrite(MEM_WB_regwrite),
        .MEM_WB_memtoreg(MEM_WB_memtoreg),
        .read_data      (read_data),
        .mem_alu_result (mem_alu_result),
        .mem_write_reg  (mem_write_reg)
    );

    // ===========================================================
    // WRITE-BACK MUX (MemtoReg)
    //   sel=1 -> read_data  (load word result)
    //   sel=0 -> mem_alu_result  (ALU result)
    // ===========================================================
    mux mem_mux(
        .a_true  (read_data),
        .b_false (mem_alu_result),
        .sel     (MEM_WB_memtoreg),
        .y       (mem_write_data)
    );

endmodule