//给出指令地址pc
module pc_reg (
    //system signals
    input                       clk,
    input                       rst,
    input               [31:0]  pc_i,//跳转的指令地址
    output      reg     [31:0]  pc_o//目前的指令地址
);

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            pc_o <= 31'h0;
        end
        else begin
            pc_o <= pc_i;
        end
    end
endmodule
