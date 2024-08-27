`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/07 16:44:31
// Design Name: 
// Module Name: datapath
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


module datapath(
    input                   clk,
    input                   rst_n,

    output          [31:0]  pc,
    input           [6:0]   opcode,
    input           [2:0]   func3,
    input           [6:0]   func7,
    input           [4:0]   rs1,
    input           [4:0]   rs2,
    input           [4:0]   rd,
    input           [31:0]  imm,
    input                   regwrite,
    input                   aluscr,
    input           [3:0]   alu_crl,
    input                   jalr,
    input                   jal,
    input                   beq,
    input                   bne,
    input                   blt,
    input                   bge,
    input                   bltu,
    input                   bgeu,
    input                   memtoreg,
    input           [31:0]  mem_rd_data,
    output          [31:0]  mem_wr_data,
    output          [31:0]  mem_addr,
    input                   lui,
    input                   U_type

    );
    wire [31:0]     pc_next;
    wire [31:0]     pc_4;
    wire [31:0]     pc_imm;
    wire [31:0]     pc_jump;
    wire [31:0]     pc_jalr;
    wire            jump;

    wire [31:0]     rs1_data;
    wire [31:0]     rs2_data;
    wire [31:0]     reg_wr_data;


    wire [31:0]     alu_data1;
    wire [31:0]     alu_data2;
    wire [31:0]     alu_result;
    wire            zero;
    wire            j;

    wire [31:0] reg_data_1;
    wire [31:0] reg_data_2;
    wire [31:0] reg_data_1_2;


    pc  pc_u(
    .clk        (clk),
    .rst_n      (rst_n),
    .pc_next    (pc_next),
    .pc         (pc)
    );

    regfile regfile(
    .clk        (clk),
    .rst_n      (rst_n),
    .rs1        (rs1),
    .rs2        (rs2),
    .rd         (rd),
    .wr_data    (reg_wr_data),
    .wr_en      (regwrite),
    .rs1_data   (rs1_data),
    .rs2_data   (rs2_data)
    );
    assign mem_wr_data = rs2_data;

    alu alu(
    .alu_crl    (alu_crl),
    .data1      (alu_data1),
    .data2      (alu_data2),
    .result     (alu_result),
    .zero       (zero)
    );
    assign alu_data1 = rs1_data;
    assign alu_data2 = aluscr ? imm : rs2_data;
    assign mem_addr = alu_result;

//reg wr_data sel
    assign j = jal | jalr;
    MUX MUX_regdata_1(
    .data1      (reg_data_1),
    .data2      (reg_data_2),
    .sel        (U_type),
    .result     (reg_wr_data)
    );
    MUX MUX_regdata_2(
    .data1      (pc_imm),
    .data2      (imm),
    .sel        (lui),
    .result     (reg_data_2)
    );
    MUX MUX_regdata_3(
    .data1      (reg_data_1_2),
    .data2      (pc_4),
    .sel        (j),
    .result     (reg_data_1)
    );
    MUX MUX_regdata_4(
    .data1      (alu_result),
    .data2      (mem_rd_data),
    .sel        (memtoreg),
    .result     (reg_data_1_2)
    );


//pc_addr
    ADD ADD_pc_4(
        .data1      (pc),
        .data2      (32'd4),
        .result     (pc_4)
    );
    ADD ADD_pc_imm(
        .data1      (pc),
        .data2      (imm),
        .result     (pc_imm)
    );
    assign pc_jalr = {alu_result[31:1],1'b0};
//pc_sel
    MUX MUX_pc_1(
    .data1      (pc_jump),
    .data2      (pc_jalr),
    .sel        (jalr),
    .result     (pc_next)
    );
    MUX MUX_pc_2(
    .data1      (pc_4),
    .data2      (pc_imm),
    .sel        (jump),
    .result     (pc_jump)
    );
    assign jump = jal    ? 1'b1 :
                  (beq & zero) ? 1'b1 :
                  (bne & !zero) ? 1'b1 :
                  (blt & alu_result == 1'b1) ? 1'b1 :
                  (bge & alu_result == 1'b0) ? 1'b1 :
                  (bltu & alu_result == 1'b1) ? 1'b1 :
                  (bgeu & alu_result == 1'b0) ? 1'b1 :
                  1'b0;


endmodule




//数据选择器
module MUX(
    input       [31:0]  data1,
    input       [31:0]  data2,
    input               sel,
    output      [31:0]  result
);

    assign  result = !sel ? data1 : data2;
endmodule
/*
MUX MUX(
    .data1      (),
    .data2      (),
    .sel        (),
    .result     ()
    );
*/


//加法器
module ADD(
    input       [31:0]  data1,
    input       [31:0]  data2,
    
    output      [31:0]  result

);
    assign result = data1 + data2;

endmodule
/*
ADD ADD(
    .data1      (),
    .data2      (),
    .result     ()
);
*/