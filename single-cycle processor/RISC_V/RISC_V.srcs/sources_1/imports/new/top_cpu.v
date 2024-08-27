module top_cpu(
    input   clk,
	input	rst,
    input        	[31:0]  readdata,
    input           [31:0]  inst_o,
	output			    	memwrite,
	output			[31:0]	dataadr,
	output			[31:0]	writedata,//i_type and s_type闁挎冻鎷�?
    output          [31:0]  pc_i
);

wire				[31:0]	pc_wr;//閻犲搫鐤囧ù鍡涙儍閸曨偅鍕鹃柨鐕傛�??
wire				[31:0]	pc_rd;//閻庡湱鍋ゅ顖炲嫉婢跺娅忛柣銊ュ濠€鎾晸閿燂拷?
wire                        beq;
wire                        bge;
wire                        bne;
wire				[31:0]	inst_data;

wire                [31:0]  rd1_data            ;//閻犲洩顕цぐ鍥儍閸曨剚娈堕柨鐕傛�??
wire                [31:0]  rd2_data            ;
wire                [4:0]   rd1_addr            ;//閻熸洑娴囬浼村矗閺嶃劍娈堕柟璇″枤濞堟垿宕烽弶鎸庣�?
wire                [4:0]   rd2_addr            ;

wire				[6:0]	op                  ;
wire				[3:0]	alu_op              ;
wire				[31:0]	alu_data2           ;
wire				       	alu_scr             ;       
wire                [31:0]  alu_result          ;
wire                        overflow            ;
wire                        carryout            ;
wire                        PF                  ;
wire                        SF                  ;
wire						wr_en               ;
wire				[4:0]	wr_addr             ;

wire			[31:0]	    wr_data             ;                

wire                        zero                ;

wire            [31:0]      imm_exp             ;


assign pc_i = pc_rd;
assign inst_data = inst_o;
assign dataadr = alu_result;
assign writedata = rd2_data;


pc_reg pc_reg (
    //system signals
    .clk				(clk)	,
    .rst				(rst)	,
    .pc_i				(pc_wr)	,
    .pc_o				(pc_rd)
);
pc_next pc_next(
.rst                (rst),
.imm_exp            (imm_exp),
.pc                 (pc_rd),
.zero               (zero),
.beq                (beq),//nPC_sel
.bge                (bge),
.bne                (bne),
.sign               (alu_result[31]),
//.jal                (jal),
.pc_n               (pc_wr)
    );



//-----------------------------------------------------------------------------------------------
id id(//閻庝絻顫夌€垫碍绂掗妶鍫㈢閻炴稑鑻崹搴ㄦ晸閿燂拷?
    //system signals
.rst                 (rst       ),
.beq                 (beq       ),    
.bge                 (bge       ),
.bne                 (bne       ),
//.jal                 (jal),
.inst_i              (inst_data ),//闁圭ǹ娲ｉ幎銈夊礃閸涱収鍟�?
.rd1_addr_out        (rd1_addr  ),//rs1_addr
.rd2_addr_out        (rd2_addr  ),//rs2_addr

.op                  (op       ),
.alu_op              (alu_op   ),
.alu_scr             (alu_scr  ),

.wr_en               (wr_en      ),
.wr_addr_out         (wr_addr    ),

.memwrite            (memwrite),
.memtoreg            (memtoreg)
);

//缂佹柨顑呭畵鍡涘极閻�?牆鈷栭悘鐑囨�?
imm_extender imm_extender(
.op                 (op),//ExtOp,闁圭ǹ娲ｉ幎銈囩尵鐠囪尙鈧拷
.inst_i             (inst_data),
.imm_exp            (imm_exp)//
    );

//-----------------------------------------------------------------------------------------------
Regfile Regfile (
    //system signal
.clk					(clk),
    //write signal 
.wr_addr				(wr_addr),//RW
.wr_data				(wr_data),//busW
.wr_en					(wr_en),//RegWr
    //read signal
.rd1_addr				(rd1_addr),//RA
.rd1_data				(rd1_data),//busA

.rd2_addr				(rd2_addr),//R
.rd2_data				(rd2_data)//busB
);
assign  wr_data = memtoreg ? readdata : alu_result;
//assign  RW = rd ? 
//濠碘€冲€归悘濉瞐l闂侇叏绲肩粻锟�  wr_data = pcrd + 'd4;濠碘€冲€归悘澶屾啺娴ｅ壊鏉婚柛鏃傚瀺al闁圭ǹ娲ｉ幎銈夋儍閸曨喚妯�?
//-----------------------------------------------------------------------------------------------
alu alu(
.data_1              (rd1_data),//busA
.data_2              (alu_data2),
.alu_op              (alu_op),//ALUctr

.zero                (zero),
.alu_result          (alu_result),
.overflow            (overflow ),//婵犙佸灩閸ゎ參寮介崶褏绠�?
.carryout            (carryout ),//閺夆晜绋愮紞鍛村�?閸パ呯
.PF                  (PF       ),//濠靛倸娲ゆ导鎾诲�?閸パ呯
.SF                  (SF       )   //缂佹绠戣ぐ鍧楀�?閸パ呯
    );
//-----------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------

//alu闁轰胶澧�?畵渚€鏌呮径瀣�?
assign alu_data2 = alu_scr ? rd2_data : imm_exp;
endmodule