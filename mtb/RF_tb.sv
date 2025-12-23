module RegFile_tb;

    // 定义时钟周期
    parameter CLK_PERIOD = 10;

    // 测试信号
    reg clk;
    reg we;
    reg [4:0] waddr;
    reg [31:0] wdata;
    reg [4:0] raddr1;
    reg [4:0] raddr2;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // 实例化被测模块
    RegFile uut (
        .clk(clk),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr1(raddr1),
        .rdata1(rdata1),
        .raddr2(raddr2),
        .rdata2(rdata2)
    );

    // 生成时钟
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // 测试流程
    initial begin
        // 初始化信号
        we = 0;
        waddr = 0;
        wdata = 0;
        raddr1 = 0;
        raddr2 = 0;
        #(CLK_PERIOD * 2); // 等待一段时间

        // 测试1：向寄存器 $1 写入数据
        $display("[Test 1] Write to register $1");
        we = 1;
        waddr = 5'd1;
        wdata = 32'h12345678;
        #CLK_PERIOD;
        we = 0;
        #CLK_PERIOD;

        // 读取寄存器 $1
        raddr1 = 5'd1;
        #1; // 等待组合逻辑稳定
        if (rdata1 === 32'h12345678)
            $display("[Pass] rdata1 = 0x%h", rdata1);
        else
            $display("[Fail] rdata1 = 0x%h, expected 0x12345678", rdata1);

        // 测试2：两个读端口同时读 $1 寄存器
        $display("\n[Test 2] Read from two registers");
        raddr2 = 5'd1;
        #1;
        if (rdata2 === 32'h12345678)
            $display("[Pass] rdata2 = 0x%h", rdata2);
        else
            $display("[Fail] rdata2 = 0x%h, expected 0x12345678", rdata2);

        // 测试3：向寄存器 $2 写入另一数据
        $display("\n[Test 3] Write to register $2");
        we = 1;
        waddr = 5'd2;
        wdata = 32'h87654321;
        #CLK_PERIOD;
        we = 0;
        #CLK_PERIOD;

        raddr1 = 5'd2;
        raddr2 = 5'd1;
        #1;
        if (rdata1 === 32'h87654321 && rdata2 === 32'h12345678)
            $display("[Pass] rdata1 = 0x%h, rdata2 = 0x%h", rdata1, rdata2);
        else
            $display("[Fail] rdata1 = 0x%h, rdata2 = 0x%h", rdata1, rdata2);

        // 测试4：尝试写入 $0 寄存器（应该失败）
        $display("\n[Test 4] Write to register $0 (should be protected)");
        we = 1;
        waddr = 5'd0;
        wdata = 32'hDEADBEEF;
        #CLK_PERIOD;
        we = 0;
        raddr1 = 5'd0;
        #1;
        if (rdata1 === 32'h0)
            $display("[Pass] $0 is still zero (0x%h)", rdata1);
        else
            $display("[Fail] $0 is not zero (0x%h)", rdata1);

        // 测试5：读取未初始化的寄存器
        $display("\n[Test 5] Read from uninitialized register $3");
        raddr1 = 5'd3;
        #1;
        if (rdata1 === 32'h0)
            $display("[Pass] Uninitialized register reads as zero");
        else
            $display("[Fail] Uninitialized register reads as 0x%h", rdata1);

        // 测试结束
        $display("\nAll tests completed.");
        $finish;
    end

    // 可选：波形输出
    initial begin
        $dumpfile("wave/RegFile_tb.vcd");
        $dumpvars(0, RegFile_tb);
    end

endmodule