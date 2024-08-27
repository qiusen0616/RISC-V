`timescale 1ns / 1ps

module regfile(
    input                   clk,
    input                   rst_n,
    input       [4:0]       rs1,
    input       [4:0]       rs2,
    input       [4:0]       rd,

    input       [31:0]      wr_data,
    input                   wr_en,

    output      [31:0]      rs1_data,
    output      [31:0]      rs2_data

    );

    reg     [31:0]  regs    [31:0];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for (i = 0; i<256; i=i+1) begin
                regs[i] = 32'b0;
            end
        end
        else if(wr_en && (rd != 0))//register 0 is constant 0
            regs[rd] <= wr_data;
    end

    assign rs1_data = (rs1 != 5'b0) ? regs[rs1] : 32'b0;
    assign rs2_data = (rs2 != 5'b0) ? regs[rs2] : 32'b0;

endmodule
