`timescale 1ns/1ps

module inst_mem(
    input   [31:0]   addr,

    output  [31:0]  inst
    );

    reg [31:0]  rom [255:0];

    initial begin
        $readmemb("../../../../single-cycle processor.srcs/sim_1/new/rom_inst_bin.txt",rom);//读取二进制数据文件
    end

    assign inst=rom[addr[31:2]];
endmodule