`timescale 1ns / 1ps

module DMem_tb;

    reg         clk;
    reg         we;
    reg         re;
    reg [31:0]  addr;
    reg [31:0]  wdata;
    wire [31:0] rdata;

    // 实例化被测模块
    DMem uut (
        .clk(clk),
        .we(we),
        .re(re),
        .data_addr(addr),
        .data_write(wdata),
        .data_read(rdata)
    );

    // 生成时钟：10ns周期
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("wave/dmem_wave.vcd");
        $dumpvars(0, DMem_tb);

        // 初始化信号
        we = 0; re = 0;
        addr = 0; wdata = 0;
        #20;

        // 写入地址 8（对应word地址2）
        addr  = 32'd8;
        wdata = 32'hAABBCCDD;
        we    = 1;
        re    = 0;
        #10;          // 上升沿写入
        we    = 0;

        // 读地址 8
        addr  = 32'd8;
        re    = 1;
        #10;

        $display("读出的数据 = %h (应为 AABBCCDD)", rdata);

        re = 0;

        // 写入地址 12（word addr 3）
        addr  = 32'd12;
        wdata = 32'h12345678;
        we    = 1;
        #10;
        we = 0;

        // 读回
        re = 1;
        #10;

        $display("读出的数据 = %h (应为 12345678)", rdata);

        #20;
        $finish;
    end

endmodule
