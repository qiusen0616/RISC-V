`timescale 1ns/1ps
`include "define.v"
module control(
    input           [6:0]   opcode,
    input           [2:0]   func3,
    input           [6:0]   func7,
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
    output          [3:0]   rw_type,
    output          [3:0]   alu_crl

);
wire [1:0]  aluop;


main_control main_control_u(
.opcode         (opcode  ),
.func3          (func3   ),
.regwrite       (regwrite),
.aluscr         (aluscr  ),
.jalr           (jalr    ),
.jal            (jal     ),
.beq            (beq     ),
.bne            (bne     ),
.blt            (blt     ),
.bge            (bge     ),
.bltu           (bltu    ),
.bgeu           (bgeu    ),
.memtoreg       (memtoreg),
.memwrite       (memwrite),
.memread        (memread ),
.lui            (lui     ),
.U_type         (U_type  ),
.rw_type        (rw_type ),
.aluop          (aluop   )
);

alu_control alu_control_u(
.func3          (func3),
.func7          (func7),
.aluop          (aluop),
.alu_crl        (alu_crl)
);
endmodule