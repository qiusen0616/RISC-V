`timescale 1ns / 1ps

module risc_v(
    input                   clk,
    input                   rst_n,

    input           [31:0]  inst,
    output          [31:0]  pc,

    input           [31:0]  mem_rd_data,
    input           [31:0]  mem_wr_data,
    output                  memwrite,
    output                  memread,
    output          [31:0]  mem_addr,
    wire            [2:0]   rw_type

    );

    wire                  regwrite;
    wire                  aluscr;
    wire          [3:0]   alu_crl;
    wire                  jalr;
    wire                  jal;
    wire                  memtoreg;
    wire          [6:0]   opcode;
    wire          [2:0]   func3;
    wire          [6:0]   func7;
    wire          [4:0]   rs1;
    wire          [4:0]   rs2;
    wire          [4:0]   rd;
    wire          [31:0]  imm;


    wire                  lui;
    wire                  U_type;
    wire                  beq;
    wire                  bne;
    wire                  blt;
    wire                  bge;
    wire                  bltu;
    wire                  bgeu;


    decoder decoder_u(//译码模块
    .inst       (inst  ),
    .opcode     (opcode),
    .func7      (func7  ),
    .func3      (func3  ),
    .rs1        (rs1   ),
    .rs2        (rs2   ),
    .rd         (rd    ),
    .imm        (imm   )
    );

    control control_u(//控制模块
    .opcode         (opcode  ),
    .func3          (func3   ),
    .func7          (func7   ),
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
    .alu_crl        (alu_crl )
    );

    datapath datapath_u(//数据通路
    .clk             (clk        ),
    .rst_n           (rst_n      ),
    .pc              (pc         ),
    .opcode          (opcode     ),
    .func3           (func3      ),
    .func7           (func7      ),
    .rs1             (rs1        ),
    .rs2             (rs2        ),
    .rd              (rd         ),
    .imm             (imm        ),
    .regwrite        (regwrite   ),
    .aluscr          (aluscr     ),
    .alu_crl         (alu_crl    ),
    .jalr            (jalr       ),
    .jal             (jal        ),
    .beq             (beq        ),
    .bne             (bne        ),
    .blt             (blt        ),
    .bge             (bge        ),
    .bltu            (bltu       ),
    .bgeu            (bgeu       ),
    .memtoreg        (memtoreg   ),
    .mem_rd_data     (mem_rd_data),
    .mem_wr_data     (mem_wr_data),
    .mem_addr        (mem_addr   ),
    .lui             (lui        ),
    .U_type          (U_type     )
    );


endmodule