`timescale 1ns / 1ps

module hazard_unit(
    input wire       id_ex_memread,
    input wire [4:0] id_ex_rt,
    input wire [4:0] if_id_rs, if_id_rt,
    output reg       stall
);
    always @(*) begin
        if (id_ex_memread && (id_ex_rt == if_id_rs || id_ex_rt == if_id_rt))
            stall = 1;
        else
            stall = 0;
    end
endmodule
