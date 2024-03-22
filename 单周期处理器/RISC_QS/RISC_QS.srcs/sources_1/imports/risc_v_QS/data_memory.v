//回写模块
module data_memory(
	input						clk,
	input				    	memwrite,
	input				[31:0]	dataadr,
	input				[31:0]	writedata,//i_type and s_type，
    output        	    [31:0]  readdata
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