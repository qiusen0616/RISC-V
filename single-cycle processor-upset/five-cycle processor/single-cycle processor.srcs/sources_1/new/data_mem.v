`timescale 1ns/1ps

module data_mem(
    input                       clk,
    input                       rst_n,
    input                       wr_en,
    input                       rd_en,
    input           [31:0]      addr,
    input           [2:0]       rw_type,
    input           [31:0]      wr_data,
    output          [31:0]      rd_data
);


    reg     [31:0]      ram         [255:0] ;

    reg     [7:0]       rd_data_b;//byte_read
    wire    [15:0]      rd_data_h;//halfword_read
    wire    [31:0]      rd_data_w;//word_read

    wire    [31:0]      rd_data_b_exp;
    wire    [31:0]      rd_data_h_exp;

    reg     [31:0]      rd_data_t;
    
    reg     [31:0]      wr_data_b;
    wire    [31:0]      wr_data_h;
    wire    [31:0]      wr_data_w;

    reg     [31:0]      wr_data_t;

//data_read
    assign rd_data_w = ram[addr[9:2]];//防止溢出
    always @(*) begin
        case (addr[1:0])
            2'b00: rd_data_b = rd_data_w[7:0];
            2'b01: rd_data_b = rd_data_w[15:8];
            2'b10: rd_data_b = rd_data_w[23:16];
            2'b11: rd_data_b = rd_data_w[31:24];
        endcase
    end

    assign rd_data_h = addr[1] ? rd_data_w[31:16] : rd_data_w[15:0];

    assign rd_data_b_exp = rw_type[2] ? {24'b0,rd_data_b[7:0]} : {{24{rd_data_b[7]}},rd_data_b[7:0]};
    assign rd_data_h_exp = rw_type[2] ? {16'b0,rd_data_h[15:0]} : {{16{rd_data_h[15]}},rd_data_h[15:0]};

    always @(*) begin
        case (rw_type[1:0])
            2'b00: rd_data_t = rd_data_b_exp;
            2'b01: rd_data_t = rd_data_h_exp;
            2'b10: rd_data_t = rd_data_w;
            default: rd_data_t = rd_data_w;//发生意外情况，赋原值.
        endcase
    end

    assign rd_data = rd_data_t;
//data_write
    always @(*) begin
        case (addr[1:0])
            2'b00: wr_data_b = {rd_data_w[31:8],wr_data[7:0]};
            2'b01: wr_data_b = {rd_data_w[31:16],wr_data[7:0],rd_data_w[7:0]};
            2'b10: wr_data_b = {rd_data_w[31:24],wr_data[7:0],rd_data_w[15:0]};
            2'b11: wr_data_b = {wr_data[7:0],rd_data_w[23:0]};
        endcase
    end

    assign wr_data_h = addr[1] ? {wr_data[15:0],rd_data_w[15:0]} : {rd_data_w[31:16],wr_data[15:0]};
    assign wr_data_w = wr_data;

    always @(*) begin
        case (rw_type[1:0])
            2'b00: wr_data_t = wr_data_b;
            2'b01: wr_data_t = wr_data_h;
            2'b10: wr_data_t = wr_data_w;
            default: wr_data_t = rd_data_w;//发生意外情况，赋原值.
        endcase
    end
    
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            for (i = 0; i<256 ; i=i+1) begin
                ram[i] = 32'b0;
            end
        end
        else if(wr_en)begin
            ram[addr[31:2]] = wr_data_t;
        end
    end


endmodule
