`timescale 1ns / 1ps

module DMem_tb;

    reg         we;
    reg         re;
    reg [31:0]  addr;
    reg [31:0]  wdata;
    wire [31:0] rdata;

    // 实例化被测模块
    DMem uut (
        .we(we),
        .re(re),
        .data_addr(addr),
        .data_write(wdata),
        .data_read(rdata)
    );

    initial begin
        $dumpfile("wave/dmem_wave.vcd");
        $dumpvars(0, DMem_tb);

        // 初始化信号
        we = 0; re = 0;
        addr = 0; wdata = 0;
        #10;

        // 测试1: 写入地址 8（对应word地址2）
        $display("测试1: 写入地址8，数据AABBCCDD");
        addr  = 32'd8;
        wdata = 32'hAABBCCDD;
        we    = 1;
        re    = 0;
        #10;
        we    = 0;
        #10;

        // 测试1: 读回地址8
        $display("测试1: 读取地址8");
        re    = 1;
        #10;
        $display("读出的数据 = %h (应为 AABBCCDD)", rdata);
        re = 0;
        #10;

        // 测试2: 写入地址 12（word addr 3）
        $display("测试2: 写入地址12，数据12345678");
        addr  = 32'd12;
        wdata = 32'h12345678;
        we    = 1;
        #10;
        we = 0;
        #10;

        // 测试2: 读回地址12
        $display("测试2: 读取地址12");
        re = 1;
        #10;
        $display("读出的数据 = %h (应为 12345678)", rdata);
        re = 0;
        #10;

        // 测试3: 验证地址8的数据是否仍然存在
        $display("测试3: 再次读取地址8，验证数据是否仍然存在");
        addr = 32'd8;
        re = 1;
        #10;
        $display("读出的数据 = %h (应为 AABBCCDD)", rdata);
        re = 0;
        #10;

        // 测试4: 测试未使能时的读取
        $display("测试4: 测试未使能时的读取");
        re = 0;
        #10;
        $display("未使能时读出的数据 = %h (应为高阻态)", rdata);
        #10;

        // 测试5: 测试边界地址
        $display("测试5: 测试边界地址");
        addr = 32'd4092;  // 最后一个有效地址 (1023*4)
        wdata = 32'hFFFFFFFF;
        we = 1;
        #10;
        we = 0;
        #10;
        re = 1;
        #10;
        $display("边界地址读出的数据 = %h (应为 FFFFFFFF)", rdata);
        re = 0;
        #10;

        // 测试6: 测试超出范围的地址
        $display("测试6: 测试超出范围的地址");
        addr = 32'd5000;  // 超出范围的地址
        re = 1;
        #10;
        $display("超出范围地址读出的数据 = %h (应为高阻态)", rdata);
        re = 0;
        #10;

        // 测试7: 测试同时读写
        $display("测试7: 测试同时读写");
        addr = 32'd16;
        wdata = 32'h55555555;
        we = 1;
        re = 1;  // 同时读写
        #10;
        $display("同时读写时读出的数据 = %h", rdata);
        we = 0;
        re = 0;
        #10;

        #20;
        $display("所有测试完成");
        $finish;
    end

endmodule
