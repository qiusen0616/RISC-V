`timescale 1ns/1ps
`include "define.v"
module main_control (
    input           [6:0]   opcode,
    input           [2:0]   func3,

    output                  regwrite,
    output                  aluscr,
    output                  jalr,
    output                  jal,
    output                  beq,
    output                  bne,
    output                  blt,
    output                  bge,
    output                  bltu,
    output                  bgeu,

    output                  memtoreg,
    output                  memwrite,
    output                  memread,
    output                  lui,
    output                  U_type,
    output          [2:0]   rw_type,
    output          [1:0]   aluop

);
    wire            B_type;
    wire            R_type;
    wire            I_type;
    wire            S_type;
    wire            load;
    wire            auipc;

        
    assign B_type = (opcode == `B_type);
    assign R_type = (opcode == `R_type);
    assign I_type = (opcode == `I_type);
    assign S_type = (opcode == `S_type);
    assign U_type = lui | auipc;

    assign load =  (opcode == `load);
    assign jal = (opcode == `jal);
    assign jalr = (opcode == `jalr);
    assign lui = (opcode == `lui);
    assign auipc = (opcode == `auipc);

    assign beq= B_type & (func3==3'b000);
	assign bne= B_type & (func3==3'b001);
	assign blt= B_type & (func3==3'b100);
	assign bge= B_type & (func3==3'b101);
	assign bltu= B_type & (func3==3'b110);
	assign bgeu= B_type & (func3==3'b111);
	assign rw_type = func3;

    assign memtoreg = load;
    assign memread = load;
    assign memwrite = S_type;

    assign aluscr = I_type | load | auipc | jalr | S_type;
    assign regwrite = jal| jalr | load | I_type |R_type | U_type;
    
    assign aluop[1] = R_type | B_type;
    assign aluop[0] = I_type | B_type;


/*
R 10
I 01
B 11
add 00
*/
endmodule