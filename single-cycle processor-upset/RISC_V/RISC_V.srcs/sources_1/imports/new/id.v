/*
1. 根据指令内容，解析出当前具体是哪一条指令 (比如 add 指令)。
2. 根据具体的指令，确定当前指令涉及的寄存器。比如读寄存器是一个还是两个，是否需要写寄存器以及写哪一个寄存器。
3. 立即数的扩展
3. 访问通用寄存器，得到要读的寄存器的值。
*/

module id(//对指令进行分析
    //system signals
    input                       rst,
	//pc_reg
    input               [31:0]  inst_i,//指令内容
	output						beq,//jal,//bne,
	output						bge,
	output						bne,
	//regfile
    output		reg     [4:0]   rd1_addr_out,//rs1_addr
    output		reg     [4:0]   rd2_addr_out,//rs2_addr
	output		reg				wr_en,
	output		reg		[4:0]	wr_addr_out,
	//alu
	output				[6:0]	op,
	output		reg		[3:0]	alu_op,
	output		reg				alu_scr,
	//data_memory
	output		reg				memwrite,
	output		reg				memtoreg
);
	//fun3
	localparam 	SW_FUNC3	= 3'b010;

	//op_code
	localparam	type_1	= 7'b001_0011,//I_TYPE  OP_IMM	7'b001_0011;
				type_2	= 7'b011_0011,//R_TYPE  OP		7'b011_0011;
				type_3	= 7'b110_1111,//J_TYPE	JAL		7'b110_1111;
				type_4	= 7'b110_0011,//B_TYPE	BRANCH	7'b110_0011;
				type_5	= 7'b000_0011,//I_TYPE	STORE	7'b000_0011;
				type_6	= 7'b010_0011;//S_TYPE	STORE	7'b010_0011;
	//sign_inst 指令类型标志
	localparam	INST_ADDI	=	5'd1,
				INST_ORI	=	5'd2,
				INST_ANDI	=	5'd3,
				INST_ADD	=	5'd4,
				INST_SUB	=	5'd5,
				INST_SLL	=	5'd6,
				INST_SLTU	=	5'd7,
				INST_XOR	=	5'd8,
				INST_SRL	=	5'd9,
				INST_OR		=	5'd10,
				INST_AND	=	5'd11,
				INST_JAL	=	5'd12,
				INST_BEQ	=	5'd13,
				INST_LW		=	5'd14,
				INST_SW		=	5'd15,
				INST_SLT	=	5'd16,
				INST_XORI	=	5'd17,
				INST_SLTI	=	5'd18,
				INST_SRLI	=	5'd19,
				INST_BGE	=	5'd20,
				INST_BNE	=	5'd21;
	//sign_alu 指令运算类型
	localparam	ADD = 4'b0001,
				SUB = 4'b0011,
				AND = 4'b0100,
			  	OR  = 4'b0101,
			  	XOR = 4'b0110,
			  	SLL = 4'b1100,
			  	SLTU= 4'b1000,
			  	SRL = 4'b1101,
				COM = 4'b1111;

	reg [4:0]	inst_judge;//指令类型

	wire [2:0]	func3;
	wire [6:0]	func7;
//--------------------------------------------------------------------详细指令的确定--------------------------------
	assign op 		=	inst_i[6:0];
	assign func3	=	inst_i[14:12];
	assign func7	=	inst_i[30:25];

	always@(*)begin
		if(rst)begin
			inst_judge = 'd0;
		end
		else begin
			case(op)
				type_1:begin
					case(func3)
						3'b000:inst_judge = INST_ADDI;
						3'b110:inst_judge = INST_ORI;
						3'b111:inst_judge = INST_ANDI;
						3'b100:inst_judge = INST_XORI;
						3'b010:inst_judge = INST_SLTI;
						3'b101:inst_judge = INST_SRLI;
					endcase
				end
				type_2:begin
					case(func3)
						3'b000:begin
							case (func7)
								7'b000_0000: inst_judge = INST_ADD;
								7'b010_0000: inst_judge = INST_SUB;
							endcase
						end
						3'b001:inst_judge = INST_SLL;
						3'b011:inst_judge = INST_SLTU;
						3'b100:inst_judge = INST_XOR;
						3'b101:begin
							case(func7)
								7'b000_0000:inst_judge = INST_SRL;
							endcase
						end
						3'b110:inst_judge = INST_OR;
						3'b111:inst_judge = INST_AND;
						3'b010:inst_judge = INST_SLT;
					endcase
				end
				type_3:begin
					inst_judge = INST_JAL;
				end
				type_4:begin
					case(func3)
						3'b000:inst_judge = INST_BEQ;
						3'b101:inst_judge = INST_BGE;
						3'b001:inst_judge = INST_BNE;
					endcase
				end
				type_5:begin
					case(func3)
						3'b010:inst_judge = INST_LW;
					endcase
				end
				type_6:begin
					case(func3)
						3'b010:inst_judge = INST_SW;
					endcase
				end
				default:begin
					inst_judge = 'd0;
				end
			endcase
		end
	end
//--------------------------------------------------------------------详细指令的确定--------------------------------
assign beq = (inst_judge == INST_BEQ);//分支跳转
assign bge=  (inst_judge == INST_BGE);
assign bne=  (inst_judge == INST_BNE);
//assign jal = (inst_judge == INST_JAL);
//--------------------------------------------------------------------运算数据的获得--------------------------------
//rs1，rs2，rd地址的确定，立即数扩展
//当aluscr为1时数据为寄存器的值，0为立即数
//rs1，rs2，rd地址的确定，立即数扩展
	always@(*)begin
		if(rst)begin
			rd1_addr_out = 'b0;
			rd2_addr_out = 'b0;
			wr_en		 = 'b0;
			wr_addr_out	 = 'b0;
		end
		else begin
			case(op)
				type_1:begin
					rd1_addr_out = inst_i[19:15];
					wr_addr_out  = inst_i[11:7];
					wr_en		 = 'b1;
					memwrite	 = 'b0;
					memtoreg	 = 'b0;
					alu_scr 	 = 'b0;
				end
				type_2:begin
					rd1_addr_out = inst_i[19:15];
					rd2_addr_out = inst_i[24:20];
					wr_addr_out  = inst_i[11:7];
					wr_en		 = 'b1;
					memwrite	 = 'b0;
					memtoreg	 = 'b0;
					alu_scr 	 = 'b1;
				end
				type_3:begin
					wr_addr_out  = inst_i[11:7];
					wr_en		 = 'b1;
					memwrite	 = 'b0;
					memtoreg	 = 'b0;
					alu_scr 	 = 'b0;
				end
				type_4:begin
					rd1_addr_out = inst_i[19:15];
					rd2_addr_out = inst_i[24:20];
					wr_en		 = 'b0;
					memwrite	 = 'b0;
					memtoreg	 = 'b0;
					alu_scr 	 = 'b1;
				end
				type_5:begin
					rd1_addr_out = inst_i[19:15];// + imm_exp;
					wr_addr_out  = inst_i[11:7];
					wr_en		 = 'b1;
					memwrite	 = 'b0;
					memtoreg	 = 'b1;
					alu_scr 	 = 'b0;
				end
				type_6:begin
					rd1_addr_out = inst_i[19:15];
					rd2_addr_out = inst_i[24:20];
					wr_en		 = 'b0;
					memwrite	 = 'b1;
					memtoreg	 = 'b0;
					alu_scr 	 = 'b0;
				end
				default:begin
					rd1_addr_out = 0;
					rd2_addr_out = 0;
					wr_addr_out  = 0;
					wr_en		 = 0;
					memwrite	 = 'b0;
					memtoreg	 = 'b0;
					alu_scr 	 = 'b0;
				end
			endcase
		end
	end
//--------------------------------------------------------------------运算数据的获得--------------------------------

//--------------------------------------------------------------------alu功能的选择---------------------------------
	always @(*) begin
		if(rst)begin
			alu_op = 'b0;
		end
		else begin
			case(inst_judge)
				INST_ADDI	:	alu_op = ADD	;
				INST_ORI	:	alu_op = OR		;
				INST_ANDI	:	alu_op = AND	;
				INST_ADD	:	alu_op = ADD	;
				INST_SUB	:	alu_op = SUB	;
				INST_SLL	:	alu_op = SLL	;
				INST_SLTU	:	alu_op = SLTU	;
				INST_XOR	:	alu_op = XOR	;
				INST_SRL	:	alu_op = SRL	;
				INST_OR		:	alu_op = OR		;
				INST_AND	:	alu_op = AND	;
				INST_LW		:	alu_op = ADD	;
				INST_SW		:	alu_op = ADD	;
				INST_SLT	:	alu_op = COM	;
				INST_XORI	:	alu_op = XOR	;
				INST_SLTI	:	alu_op = COM	;
				INST_SRLI	:	alu_op = SRL	;
				INST_BEQ	:	alu_op = SUB	;
				INST_BGE	:	alu_op = SUB	;
				INST_BNE	:	alu_op = SUB	;
			endcase
		end
	end
//--------------------------------------------------------------------alu功能的选择---------------------------------

endmodule