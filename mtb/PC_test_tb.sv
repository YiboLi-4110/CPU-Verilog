module PC_test;
    logic clk = 0;           // 时钟信号，初始0
    logic [31:0] pc_in = 0;  // PC输入
    logic [31:0] pc_out;     // PC输出
    
    // 2. 实例化待测试的PC模块
    PC dut (
        .CLK(clk),
        .pc_in_addr(pc_in),
        .pc_out_addr(pc_out)
    );
    
    // 3. 生成时钟（50MHz，周期20ns）
    always #10 clk = ~clk;  // 每10ns翻转一次
    
    // 4. 主测试逻辑
    initial begin
        // 等待一个时钟周期，让初始化稳定
        #5;
        
        $display("=== PC寄存器测试开始 ===");
        $display("时间\t\tclk\tpc_in\t\tpc_out\t\t备注");
        $display("----------------------------------------------------------------");
        
        // 初始状态检查
        $display("%0t\t%b\t%h\t%h\t初始状态", $time, clk, pc_in, pc_out);
        
        // 测试1：第一个时钟上升沿
        @(posedge clk);  // 等待时钟上升沿
        #1;  // 等待1ns稳定
        $display("%0t\t%b\t%h\t%h\t第一个时钟后", $time, clk, pc_in, pc_out);
        
        // 测试2：改变输入，观察下一个时钟
        pc_in = 32'h0000_1000;  // 新地址
        @(posedge clk);
        #1;
        $display("%0t\t%b\t%h\t%h\t输入0x1000", $time, clk, pc_in, pc_out);
        
        // 测试3：再改变输入
        pc_in = 32'h0000_1004;
        @(posedge clk);
        #1;
        $display("%0t\t%b\t%h\t%h\t输入0x1004", $time, clk, pc_in, pc_out);
        
        $display("=== 测试完成 ===");
        $finish;  // 结束仿真
    end
endmodule