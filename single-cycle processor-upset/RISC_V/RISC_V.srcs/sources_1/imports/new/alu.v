module alu(
	input               [31:0]  data_1,
	input               [31:0]  data_2,
	input               [3:0]   alu_op,

	output                      zero,//0标志
	output      reg     [31:0]  alu_result,
	output		reg				overflow,//溢出标志
	output		reg				carryout,//进位标志
	output						PF,//奇偶标志
	output						SF//符号标志


    );
	
	parameter   ADD = 4'b0001,
			    SUB = 4'b0011,
			    AND = 4'b0100,
			    OR  = 4'b0101,
			    XOR = 4'b0110,
			    SLL = 4'b1100,
			    SLTU= 4'b1000,
                SRL = 4'b1101,
				COM = 4'b1111;
	always@(*)begin
		case(alu_op)
			AND : alu_result = data_1 & data_2;
			OR  : alu_result = data_1 | data_2;
			ADD : alu_result = data_1 + data_2;
			SUB : alu_result = data_1 - data_2;
			XOR : alu_result = data_1 ^ data_2;
			SLL : alu_result = data_1 << data_2;
			SRL : alu_result = data_1 >> data_2;
			COM : alu_result = data_1 < data_2 ? 1 : 0;
			default:alu_result = 32'd0;
		endcase
	end

	assign zero = (alu_result == 32'b0);

	always@(*)begin
		case (alu_op)
			ADD: overflow <= (data_1[31] & data_2[31] & ~alu_result[31])|
							 (~data_1[31] & ~data_2[31] & alu_result[31]);
			SUB: overflow <= (~data_1[31] & data_2[31] & alu_result[31])|
							 (data_1[31] & ~data_2[31] & ~alu_result[31]);
			default: overflow <= 1'B0;
		endcase
	end

		always@(*)begin
		case (alu_op)
			ADD: carryout <= (data_1[31] & data_2[31] & ~alu_result[31])|
							 (~data_1[31] & ~data_2[31] & alu_result[31]);
			default: carryout <= 1'B0;
		endcase
	end

	assign PF = alu_result[0];
	assign SF = alu_result[31];
	
endmodule
