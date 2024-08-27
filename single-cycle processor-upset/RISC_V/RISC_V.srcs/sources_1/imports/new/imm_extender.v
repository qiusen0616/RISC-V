`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 13:11:30
// Design Name: 
// Module Name: imm_exp
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


module imm_extender(
    input           [6:0]   op,
    input           [31:0]  inst_i,
    output  reg     [31:0]  imm_exp
    );

	localparam	type_1	= 7'b001_0011,//I_TYPE  OP_IMM	7'b001_0011;
				type_2	= 7'b011_0011,//R_TYPE  OP		7'b011_0011;
				type_3	= 7'b110_1111,//J_TYPE	JAL		7'b110_1111;
				type_4	= 7'b110_0011,//B_TYPE	BRANCH	7'b110_0011;
				type_5	= 7'b000_0011,//I_TYPE	STORE	7'b000_0011;
				type_6	= 7'b010_0011;//S_TYPE	STORE	7'b010_0011;

    always@(*)begin
        case(op)
            type_1:begin
                imm_exp  = {{20{inst_i[31]}},inst_i[31:20]};
            end
            type_3:begin
                imm_exp  = {{12{inst_i[31]}},inst_i[19:12],inst_i[20],inst_i[30:21],1'b0};
            end
            type_4:begin
                imm_exp  = {{20{inst_i[31]}},inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
            end
            type_5:begin
                imm_exp  = {{20{inst_i[31]}},inst_i[31:20]};
            end
            type_6:begin
                imm_exp  = {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]};
            end
            default:begin
                imm_exp = 'd0;
            end
        endcase
	end
endmodule
