module top_cpu(
    input   clk,
	input	rst
);

wire				[31:0]	pc_wr;//跳转的地�?
wire				[31:0]	pc_rd;//实际有效的地�?
wire                        beq;
wire                        bge;
wire                        bne;
wire				[31:0]	inst_data;

wire                [31:0]  rd1_data            ;//读取的数�?
wire                [31:0]  rd2_data            ;
wire                [4:0]   rd1_addr            ;//要读取数据的地址
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

wire            [31:0]      readdata            ;

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
inst_memory inst_memory (
    .pc_i				(pc_rd),
    .inst_o				(inst_data)
);


//-----------------------------------------------------------------------------------------------
id id(//对指令进行分�?
    //system signals
.rst                 (rst       ),
.beq                 (beq       ),    
.bge                 (bge       ),
.bne                 (bne       ),
//.jal                 (jal),
.inst_i              (inst_data ),//指令内容
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

//立即数扩展
imm_extender imm_extender(
.op                 (op),//ExtOp,指令类型
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
//如果jal那么  wr_data = pcrd + 'd4;如果要增加jal指令的话
//-----------------------------------------------------------------------------------------------
alu alu(
.data_1              (rd1_data),//busA
.data_2              (alu_data2),
.alu_op              (alu_op),//ALUctr

.zero                (zero),
.alu_result          (alu_result),
.overflow            (overflow ),//溢出标志
.carryout            (carryout ),//进位标志
.PF                  (PF       ),//奇偶标志
.SF                  (SF       )   //符号标志
    );
//-----------------------------------------------------------------------------------------------

data_memory data_memory(
.clk                (clk),
.memwrite           (memwrite),//MemWr
.dataadr            (alu_result),//Data In
.writedata          (rd2_data),//Addr
.readdata           (readdata)//读出的数据
);

//-----------------------------------------------------------------------------------------------

//alu数据选择
assign alu_data2 = alu_scr ? rd2_data : imm_exp;
endmodule