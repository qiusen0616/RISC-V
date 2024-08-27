`timescale 1ns/1ps

module top_cpu(
    input                   clk,
    input                   rst_n
);

wire [31:0] pc;
wire [31:0] inst;
wire [2:0] rw_type;
wire [31:0] mem_rd_data;
wire [31:0] mem_wr_data;
wire memwrite;
wire memread;
wire [31:0] mem_addr;

risc_v risc_v_u(
    .clk                    (clk        ),
    .rst_n                  (rst_n      ),
    .inst                   (inst       ),
    .pc                     (pc         ),
    .mem_rd_data            (mem_rd_data),
    .mem_wr_data            (mem_wr_data),
    .memwrite               (memwrite   ),
    .memread                (memread    ),
    .mem_addr               (mem_addr   ),
    .rw_type                (rw_type    )
);

data_mem data_mem_u(
    .clk                    (clk        ),
    .rst_n                  (rst_n      ),
    .wr_en                  (memwrite   ),
    .rd_en                  (memread    ),
    .addr                   (mem_addr   ),
    .rw_type                (rw_type    ),
    .wr_data                (mem_wr_data),
    .rd_data                (mem_rd_data)
);

inst_mem inst_mem(
    .addr                   (pc),
    .inst                   (inst)
);

endmodule