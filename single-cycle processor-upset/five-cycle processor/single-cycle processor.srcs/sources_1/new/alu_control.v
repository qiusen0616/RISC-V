`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/07 15:50:18
// Design Name: 
// Module Name: alu_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"

module alu_control(
    input           [2:0]   func3,
    input           [6:0]   func7,
    input           [1:0]   aluop,

    output          [3:0]   alu_crl
    );

    reg     [3:0]   alu_crl_r;
/*
     aluop
R    10
I    01
B    11
add  00
*/
    wire [3:0]   alu_crl_B;
    reg [3:0]   alu_crl_RI;

    assign alu_crl_B = (func3[2:1] == 2'b00) ? `SUB ://beq and bne
                       (func3[2:1] == 2'b10) ? `SLT ://blt and bge
                       `SLTU;                       //
    /*
- 对于 `BEQ` 和 `BNE` 指令，ALU执行减法运算 (`data1 - data2`) 并判断结果是否为零。
- 对于 `BLT` 和 `BGE` 指令，ALU也是执行减法运算 (`data1 - data2`)，然后判断结果的符号以决定跳转。
- 对于 `BLTU` 和 `BGEU` 指令，ALU直接进行无符号比较。
    */
    always @(*) begin//R and I type
        case (func3)
            3'b000: if(func7[5] & aluop[1])//
					    alu_crl_RI=`SUB;
					else   
					    alu_crl_RI=`ADD;
			3'b001: alu_crl_RI=`SLL;
			3'b010: alu_crl_RI=`SLT;
			3'b011: alu_crl_RI=`SLTU;
			3'b100: alu_crl_RI=`XOR;
			3'b101: if(func7[5])
					    alu_crl_RI=`SRA;
					else
					alu_crl_RI=`SRL;
			3'b110: alu_crl_RI=`OR;
			3'b111: alu_crl_RI=`AND;
			default:alu_crl_RI=`ADD;
        endcase
    end

    assign alu_crl = (aluop[1] ^ aluop[0]) ? alu_crl_RI :
                     (aluop[1] & aluop[0]) ? alu_crl_B :
                     `ADD;

endmodule
