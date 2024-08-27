//回写模块
module data_memory(
	input						clk,
	input				    	memwrite,//写使能
	input				[31:0]	dataadr,//数据的地址
	input				[31:0]	writedata,//写入的数据
    output        	    [31:0]  readdata//读取的数据
);
    reg [31:0]  regs [31:0];

initial begin
	
end
	always @(posedge clk ) begin
		if(memwrite)
			regs[dataadr] <= writedata;
	end
assign readdata = regs[dataadr];
endmodule