`timescale 1ns / 1ps

`include "define.v"

module alu(
    input       [3:0]       alu_crl,
    input       [31:0]      data1,
    input       [31:0]      data2,

    output  reg [31:0]      result,
    output                  zero

    );

    always @(*) begin
        case (alu_crl)
            `ADD : result = data1 + data2;
            `SUB : result = data1 - data2;
            `OR  : result = data1 | data2;
            `AND : result = data1 & data2;
            `XOR : result = data1 ^ data2;

            `SLT : result = (!data1[31] && !data2[31]) ? data1 < data2 ://data1为正，data2为正
                            (!data1[31] && data2[31]) ? 32'd0 ://data1为正，data2为负
                            (data1[31] && !data2[31]) ? 32'd1 ://data1为负，data2为正
                            data1 < data2;//等效(data1[31] && data2[31]) ? data1 < data2 :
            

            `SLTU: result = data1 < data2;//无符号小于
            `SLL : result = data1 << data2[4:0];//逻辑左移
            `SRL : result = data1 >> data2[4:0];//逻辑右移

            `SRA : result = ({32{data2[31]}} << 6'd32 - data2[4:0]) | (data1 >> data2[4:0]);//算数右移

            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 0);

endmodule
