`timescale 1ns/1ps

module ALU_test;

    // 包含头文件
    `include "../src/includes/ALU_Mod.svh"
    `include "../src/includes/Flags.svh"
    
    // 测试信号
    reg [31:0] A;
    reg [31:0] B;
    reg [`ALUCTRL_WIRENUM:0] Mod;
    wire [31:0] C;
    wire FLAGS_t flags;
    
    // 实例化ALU
    ALU uut (
        .A(A),
        .B(B),
        .Mod(Mod),
        .C(C),
        .flags(flags)
    );
    
    // 测试记录
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;
    
    // 辅助任务：显示结果
    task display_result;
        input [31:0] expected_C;
        input FLAGS_t expected_flags;
        input string test_name;
        begin
            test_count = test_count + 1;
            
            // 修正：直接比较FLAGS_t的各个字段
            if (C === expected_C && 
                flags.CF === expected_flags.CF &&
                flags.OF === expected_flags.OF &&
                flags.ZF === expected_flags.ZF &&
                flags.SF === expected_flags.SF) begin
                $display("[PASS] Test %0d: %s", test_count, test_name);
                $display("  A=%h, B=%h, Mod=%h", A, B, Mod);
                $display("  C=%h (expected %h)", C, expected_C);
                $display("  Flags: CF=%b, OF=%b, ZF=%b, SF=%b", 
                        flags.CF, flags.OF, flags.ZF, flags.SF);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Test %0d: %s", test_count, test_name);
                $display("  A=%h, B=%h, Mod=%h", A, B, Mod);
                $display("  C=%h (expected %h)", C, expected_C);
                $display("  Flags: CF=%b, OF=%b, ZF=%b, SF=%b", 
                        flags.CF, flags.OF, flags.ZF, flags.SF);
                $display("  Expected Flags: CF=%b, OF=%b, ZF=%b, SF=%b",
                        expected_flags.CF, expected_flags.OF, 
                        expected_flags.ZF, expected_flags.SF);
                fail_count = fail_count + 1;
            end
            $display("");
        end
    endtask
    
    // 辅助任务：创建FLAGS_t值
    function FLAGS_t create_flags;
        input logic cf, of, zf, sf;
        begin
            create_flags.CF = cf;
            create_flags.OF = of;
            create_flags.ZF = zf;
            create_flags.SF = sf;
            create_flags.unused = 4'b0;  // 设置未使用位为0
        end
    endfunction
    
    // 主测试过程
    initial begin
        $display("========================================");
        $display("Starting ALU Testbench");
        $display("========================================\n");
        
        // 测试1: NOP操作
        $display("Test 1: NOP Operation");
        Mod = `OP_NOP;
        A = 32'h12345678;
        B = 32'h87654321;
        #10;
        display_result(32'h0, create_flags(0, 0, 0, 0), "NOP");
        
        // 测试2: ADD - 正常加法
        $display("Test 2: ADD Operation");
        Mod = `OP_ADD;
        A = 32'h00000001;
        B = 32'h00000002;
        #10;
        display_result(32'h00000003, create_flags(0, 0, 0, 0), "ADD 1+2");
        
        // 测试3: ADD - 有符号溢出
        Mod = `OP_ADD;
        A = 32'h7fffffff;  // 最大正数
        B = 32'h00000001;
        #10;
        display_result(32'h80000000, create_flags(0, 1, 0, 1), "ADD overflow");
        
        // 测试4: ADDU - 无符号加法
        Mod = `OP_ADDU;
        A = 32'hffffffff;
        B = 32'h00000001;
        #10;
        display_result(32'h00000000, create_flags(1, 0, 1, 0), "ADDU with carry");
        
        // 测试5: SUB - 正常减法
        Mod = `OP_SUB;
        A = 32'h00000005;
        B = 32'h00000003;
        #10;
        display_result(32'h00000002, create_flags(0, 0, 0, 0), "SUB 5-3");
        
        // 测试6: SUB - 有符号负数
        Mod = `OP_SUB;
        A = 32'h00000003;
        B = 32'h00000005;
        #10;
        display_result(32'hfffffffe, create_flags(1, 0, 0, 1), "SUB 3-5 (negative)");
        
        // 测试7: SUBU - 无符号减法
        Mod = `OP_SUBU;
        A = 32'h00000001;
        B = 32'h00000002;
        #10;
        display_result(32'hffffffff, create_flags(1, 0, 0, 0), "SUBU 1-2 (borrow)");
        
        // 测试8: SLT - 小于设置
        Mod = `OP_SLT;
        A = 32'h00000001;
        B = 32'h00000002;
        #10;
        display_result(32'h00000001, create_flags(0, 0, 0, 0), "SLT 1<2");
        
        // 测试9: SLT - 不小于设置
        Mod = `OP_SLT;
        A = 32'h00000005;
        B = 32'h00000002;
        #10;
        display_result(32'h00000000, create_flags(0, 0, 1, 0), "SLT 5<2 (false)");
        
        // 测试10: AND操作
        Mod = `OP_AND;
        A = 32'h12345678;
        B = 32'h0000ffff;
        #10;
        display_result(32'h00005678, create_flags(0, 0, 0, 0), "AND mask");
        
        // 测试11: OR操作
        Mod = `OP_OR;
        A = 32'h12340000;
        B = 32'h00005678;
        #10;
        display_result(32'h12345678, create_flags(0, 0, 0, 0), "OR combine");
        
        // 测试12: XOR操作
        Mod = `OP_XOR;
        A = 32'h12345678;
        B = 32'h12345678;
        #10;
        display_result(32'h00000000, create_flags(0, 0, 1, 0), "XOR self (zero)");
        
        // 测试13: SLL - 逻辑左移
        Mod = `OP_SLL;
        A = 32'h0000000f;  // 15
        B = 32'h00000004;  // 移位4位
        #10;
        display_result(32'h000000f0, create_flags(0, 0, 0, 0), "SLL 0xf << 4");
        
        // 测试14: SLL - 左移1位，测试溢出
        Mod = `OP_SLL;
        A = 32'h40000000;
        B = 32'h00000001;
        #10;
        display_result(32'h80000000, create_flags(0, 1, 0, 1), "SLL sign change");
        
        // 测试15: SRL - 逻辑右移
        Mod = `OP_SRL;
        A = 32'hf0000000;
        B = 32'h00000004;  // 移位4位
        #10;
        display_result(32'h0f000000, create_flags(0, 0, 0, 0), "SRL 0xf0000000 >> 4");
        
        // 测试16: SRA - 算术右移正数
        Mod = `OP_SRA;
        A = 32'h0f000000;  // 正数
        B = 32'h00000004;  // 移位4位
        #10;
        display_result(32'h00f00000, create_flags(0, 0, 0, 0), "SRA positive");
        
        // 测试17: SRA - 算术右移负数
        Mod = `OP_SRA;
        A = 32'hf0000000;  // 负数
        B = 32'h00000004;  // 移位4位
        #10;
        display_result(32'hff000000, create_flags(0, 0, 0, 1), "SRA negative");
        
        // 测试18: 移位0位
        Mod = `OP_SRL;
        A = 32'h12345678;
        B = 32'h00000000;  // 不移位
        #10;
        display_result(32'h12345678, create_flags(0, 0, 0, 0), "SRL by 0");
        
        // 测试19: 移位31位（最大值）
        Mod = `OP_SLL;
        A = 32'h00000001;
        B = 32'h0000001f;  // 移位31位
        #10;
        display_result(32'h80000000, create_flags(0, 0, 0, 1), "SLL by 31");
        
        // 测试20: ZF标志测试
        Mod = `OP_ADD;
        A = 32'h00000000;
        B = 32'h00000000;
        #10;
        display_result(32'h00000000, create_flags(0, 0, 1, 0), "Zero flag test");
        
        // 额外的测试：测试有符号数的SLT
        $display("Additional Test: Signed SLT with negative numbers");
        Mod = `OP_SLT;
        A = 32'hffffffff;  // -1
        B = 32'h00000001;  // 1
        #10;
        display_result(32'h00000001, create_flags(0, 0, 0, 0), "SLT -1<1");
        
        $display("\n========================================");
        $display("Test Summary:");
        $display("  Total Tests: %0d", test_count);
        $display("  Passed:      %0d", pass_count);
        $display("  Failed:      %0d", fail_count);
        
        if (fail_count == 0) begin
            $display("All tests PASSED!");
        end else begin
            $display("Some tests FAILED!");
        end
        
        $display("========================================\n");
        
        // 结束仿真
        #100;
        $finish;
    end
    
    // 可选：生成波形文件
    initial begin
        $dumpfile("alu_wave.vcd");
        $dumpvars(0, ALU_test);
    end
    
endmodule