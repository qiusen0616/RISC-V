`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 13:40:08
// Design Name: 
// Module Name: pc_next
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


module pc_next(
    input                   rst,
    input           [31:0]  imm_exp,
    input           [31:0]  pc,
    input                   zero,
    input                   beq,
    input                   bge,
    input                   bne,
    input                   sign,
//    input                   jal,

    output          [31:0]  pc_n
    );
    wire                    pc_jump;
    wire            [31:0]  pc_4;
    wire            [31:0]  imm_pc;
    assign pc_n = pc_jump ? imm_pc : pc_4;
    assign imm_pc = pc + imm_exp ;
    assign pc_jump = (zero & beq)||(bge & ~sign)||(!zero & bne);//|jal;// | (!zero & bne);
    assign pc_4 =  rst ? 'd0 : (pc + 'd4);
endmodule
