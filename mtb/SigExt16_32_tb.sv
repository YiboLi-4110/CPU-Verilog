`timescale 1ns/1ps

module SigExt16_32_tb;
    // 测试信号
    reg [15:0] input_data;
    wire [31:0] output_data;
    
    // 实例化被测模块
    SigExt16_32 uut (
        .input_data(input_data),
        .output_data(output_data)
    );
    
    // 测试用例
    initial begin
        // 初始化
        input_data = 16'h0000;
        
        // 测试1: 正数（最高位为0）
        $display("\n=== 测试1: 正数扩展 ===");
        input_data = 16'h7FFF;  // 最大正数 32767
        #10;
        $display("输入: 16'h%b (%d), 输出: 32'h%b (%d)", 
                 input_data, $signed(input_data), 
                 output_data, $signed(output_data));
        
        // 测试2: 负数（最高位为1）
        $display("\n=== 测试2: 负数扩展 ===");
        input_data = 16'h8000;  // 最小负数 -32768
        #10;
        $display("输入: 16'h%b (%d), 输出: 32'h%b (%d)", 
                 input_data, $signed(input_data), 
                 output_data, $signed(output_data));
        
        // 测试3: 负数的典型值
        $display("\n=== 测试3: 典型负数扩展 ===");
        input_data = 16'hFFFE;  // -2
        #10;
        $display("输入: 16'h%b (%d), 输出: 32'h%b (%d)", 
                 input_data, $signed(input_data), 
                 output_data, $signed(output_data));
        
        // 测试4: 边界值测试
        $display("\n=== 测试4: 边界值测试 ===");
        input_data = 16'h0001;  // 1
        #10;
        $display("输入: 16'h%b (%d), 输出: 32'h%b (%d)", 
                 input_data, $signed(input_data), 
                 output_data, $signed(output_data));
        
        input_data = 16'hFFFF;  // -1
        #10;
        $display("输入: 16'h%b (%d), 输出: 32'h%b (%d)", 
                 input_data, $signed(input_data), 
                 output_data, $signed(output_data));
        
        // 测试5: 随机测试
        $display("\n=== 测试5: 随机测试 ===");
        repeat (5) begin
            input_data = $random;
            #10;
            $display("输入: 16'h%b (%d), 输出: 32'h%b (%d)", 
                     input_data, $signed(input_data), 
                     output_data, $signed(output_data));
        end
        
        // 结束测试
        $display("\n=== 测试完成 ===");
        $finish;
    end
    
    // 监视器（可选）
    initial begin
        $monitor("时间: %0t ns | 输入: %b | 输出: %b", 
                 $time, input_data, output_data);
    end

    // 波形
    initial begin
        $dumpfile("wave/SigExt16_32_tb.vcd");
        $dumpvars(0, uut);
    end
endmodule