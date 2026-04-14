`timescale 1ns / 1ps

module bottom_mux_TB;

    wire [4:0] y;
    reg [4:0] a, b;
    reg sel;

    bottom_mux UUT (y, a, b, sel);

    initial begin
        a = 5'b01010;
        b = 5'b10101;
        sel = 1'b1;

        #2
        a = 5'b00000;
        #2
        sel = 1'b1;
        #2
        b = 5'b11111;
        #2
        a = 5'b00101;
        sel = 1'b0;
        b = 5'b11101;
        #2
        $finish;
    end
endmodule