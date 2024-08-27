`timescale 1ns / 1ps

module top_risc_v(
    input   clk,
	input	rst
    );

    wire           	[31:0]  readdata;
    wire            [31:0]  inst_o;
	wire			    	memwrite;
	wire			[31:0]	dataadr;
	wire			[31:0]	writedata;//i_type and s_type，
    wire            [31:0]  pc_i;

top_cpu top_cpu(
    .clk                        (clk),
    .rst	                    (rst),
    .readdata                   (readdata ),
    .inst_o                     (inst_o   ),
	.memwrite                   (memwrite ),
	.dataadr                    (dataadr  ),
	.writedata                  (writedata),//i_type and s_type，
    .pc_i                       (pc_i     )
);



inst_memory inst_memory (
    .pc_i               (pc_i),//地址
    .inst_o             (inst_o)//数据
);


data_memory data_memory(
    .clk                (clk),
    .memwrite           (memwrite),//MemWr
    .dataadr            (dataadr),//Data In
    .writedata          (writedata),//Addr
    .readdata           (readdata)//读出的数据
);


endmodule
