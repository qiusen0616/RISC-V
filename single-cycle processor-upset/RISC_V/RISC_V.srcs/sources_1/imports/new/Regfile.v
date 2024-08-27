module Regfile (
    //system signal
    input					    clk,
    //write signal
    input			[4:0]		wr_addr,
    input			[31:0]	    wr_data,
    input					    wr_en,
    //read signal
    input			[4:0]		rd1_addr,
    output          [31:0]      rd1_data,

    input			[4:0]		rd2_addr,
    output          [31:0]      rd2_data
);

    reg  [31:0]     regs [31:0];
    wire            regs_en;

    assign regs_en = (wr_en && (wr_addr != 'd0) );
    always@(posedge clk)begin
        regs[0] <= 32'b0;
        if(regs_en)begin
            regs[wr_addr] <= wr_data;
        end
    end

    assign rd1_data = regs[rd1_addr];
    assign rd2_data = regs[rd2_addr];

endmodule