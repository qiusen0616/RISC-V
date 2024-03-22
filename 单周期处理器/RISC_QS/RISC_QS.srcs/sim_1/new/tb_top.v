`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/01 21:46:08
// Design Name: 
// Module Name: tb_top
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


module tb_top(
    );
    reg clk;
    reg rst;
    top_cpu top_cpu(
    .clk(clk),
	.rst(rst)
);
always #10 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    #100
    rst = 0;
end

endmodule
