`timescale 1ns/1ns

module SHL2_tb;

    // 测试信号
    reg [7:0] input_data;
    wire [9:0] output_data;
    
    // 实例化被测模块
    SHL2 #(.DATA_WIDTH(8)) uut (
        .input_data(input_data),
        .output_data(output_data)
    );
    
    // 测试流程
    initial begin
        $display("========================");
        $display("SHL2 Module Testbench");
        $display("========================");
        
        // 测试1：基本测试
        $display("\n[Test 1] Basic Tests");
        input_data = 8'b00000001;  // 1
        #10;
        $display("Input: 0h%b (%0d)", input_data, input_data);
        $display("Output: 0h%b (%0d)", output_data, output_data);
        $display("Expected: 0h04 (4)");
        
        input_data = 8'b00000101;  // 5
        #10;
        $display("\nInput: 0h%b (%0d)", input_data, input_data);
        $display("Output: 0h%b (%0d)", output_data, output_data);
        $display("Expected: 0h14 (20)");
        
        // 测试2：边界测试
        $display("\n[Test 2] Boundary Tests");
        input_data = 8'b00000000;  // 0
        #10;
        $display("Input: 0h%b (%0d)", input_data, input_data);
        $display("Output: 0h%b (%0d)", output_data, output_data);
        $display("Expected: 0h00 (0)");
        
        input_data = 8'b11111111;  // 255
        #10;
        $display("\nInput: 0h%b (%0d)", input_data, input_data);
        $display("Output: 0h%b (%0d)", output_data, output_data);
        $display("Expected: 0h3FC (1020)");
        
        // 测试3：随机测试
        $display("\n[Test 3] Random Tests");
        for (int i = 0; i < 5; i++) begin
            input_data = $random;
            #10;
            $display("Test %0d: Input=0h%b (%0d), Output=0h%b (%0d)", 
                    i+1, input_data, input_data, output_data, output_data);
            
            // 验证结果
            if (output_data !== (input_data * 4)) begin
                $display("ERROR: Mismatch detected!");
                $display("  Expected: %0d", input_data * 4);
                $finish;
            end
        end
        
        // 测试完成
        $display("\n========================");
        $display("All tests completed successfully!");
        $display("========================");
        $finish;
    end
    
    // 可选：波形输出
    initial begin
        $dumpfile("wave/SHL2_tb.vcd");
        $dumpvars(0, SHL2_tb);
    end
    
endmodule