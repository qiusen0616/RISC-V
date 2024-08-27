`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/04 15:44:52
// Design Name: 
// Module Name: tb_inst_mem
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


module tb_inst_mem(

    );
    reg     [7:0]       addr;
    wire    [31:0]      inst;
    inst_mem inst_mem_t(
    .addr   (addr),
    .inst   (inst)
    );
    always#10addr=addr+1;
    initial begin
        addr = 0;
    end
endmodule
