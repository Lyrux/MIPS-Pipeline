`timescale 1ns / 1ps

module fetch(

    input wire clk,
    input wire rst,
    input wire PC_src,
    
    
    input wire [31:0] PC_from_ExMem,
    
    output wire [31:0] if_id_instr,
    output wire [31:0] if_id_pc
);

// internal wires
wire [31:0] pc_out;
wire [31:0] pc_mux;
wire [31:0] next_pc;
wire [31:0] instr_data;

// MUX
mux m0(
    .a_true(PC_from_ExMem),
    .b_false(next_pc),
    .sel(PC_src),
    .y(pc_mux)
);

// PROGRAM COUNTER
program_counter pc0(
    .clock(clk), .mux_in(pc_mux),
    .pc(pc_out)
);

// ADDER
adder in0(
    .pc_in(pc_out),
    .adder_out(next_pc)
);


// INSTRUCTION MEMORY
instrMem inMem0(
    .clk(clk),
    .rst(rst),
    .addr(pc_out),
    .instr_out(instr_data)
);

// IF/ID LATCH
ifIdLatch ifIdLatch0(
    .clk(clk),
    .rst(rst),
    .pc_in(next_pc),
    .instr_in(instr_data),
    .pc_out(if_id_pc),
    .instr_out(if_id_instr)
);



endmodule