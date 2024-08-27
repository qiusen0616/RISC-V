`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/07 14:19:33
// Design Name: 
// Module Name: decoder
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

module decoder(
    input       [31:0]      inst,
    output      [6:0]       opcode,
    output      [6:0]       func7,
    output      [2:0]       func3,
    output      [4:0]       rs1,
    output      [4:0]       rs2,
    output      [4:0]       rd,
    output      [31:0]      imm
    );

    wire I_type;
//    wire R_type;
    wire U_type;
    wire J_type;
    wire B_type;
    wire S_type;

    wire [31:0] imm_I;
    wire [31:0] imm_U;
    wire [31:0] imm_J;
    wire [31:0] imm_B;
    wire [31:0] imm_S;

    assign opcode = inst[6:0];
    assign func7 = inst[31:25];
    assign func3 = inst[14:12];
    assign rs1 = inst[19:15];
    assign rs2 = inst[24:20];
    assign rd = inst[11:7];


    assign I_type = (inst[6:0] == `I_type) | (inst[6:0] == `jalr) | (inst[6:0] == `load);
//    assign R_type = (inst[6:0] == `R_type);
    assign U_type = (inst[6:0] == `lui) | (inst[6:0] == `auipc);
    assign J_type = (inst[6:0] == `jal);
    assign B_type = (inst[6:0] == `B_type);
    assign S_type = (inst[6:0] == `S_type);


    assign imm_I ={{20{inst[31]}},inst[31:20]}; 
	assign imm_U ={inst[31:12],{12{1'b0}}};
	assign imm_J ={{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};   
	assign imm_B ={{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
	assign imm_S ={{20{inst[31]}},inst[31:25],inst[11:7]}; 

    assign imm = I_type ? imm_I :
                 U_type ? imm_U :
                 J_type ? imm_J :
                 B_type ? imm_B :
                 S_type ? imm_S :
                 32'b0;
                 
endmodule
