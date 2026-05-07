`timescale 1ns / 1ps

module alu_control(
    input wire [5:0] funct,
    input wire [1:0] alu_op,
    output reg [2:0] select
);

    parameter FUNCTadd = 6'b100000,
              FUNCTsub = 6'b100010,
              FUNCTand = 6'b100100,
              FUNCTor  = 6'b100101,
              FUNCTslt = 6'b101010;

    initial select = 3'b010; // default ADD

    always @(*) begin
        if (^alu_op === 1'bx || ^funct === 1'bx) begin
            select = 3'b010;
        end else begin
            case(alu_op)
                2'b10: begin // R-type
                    case(funct)
                        FUNCTadd: select = 3'b010;
                        FUNCTsub: select = 3'b110;
                        FUNCTand: select = 3'b000;
                        FUNCTor:  select = 3'b001;
                        FUNCTslt: select = 3'b111;
                        default:  select = 3'b010;
                    endcase
                end
                2'b00: select = 3'b010; // LW/SW - ADD
                2'b01: select = 3'b110; // BEQ - SUB
                default: select = 3'b010;
            endcase
        end
    end

endmodule