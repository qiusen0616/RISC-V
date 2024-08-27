`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/07 15:29:16
// Design Name: 
// Module Name: pc
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


module pc(
    input                   clk,
    input                   rst_n,
    input       [31:0]      pc_next,
    output  reg [31:0]      pc
    );

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            pc <= 32'b0;
        else
            pc <= pc_next;
    end

endmodule
