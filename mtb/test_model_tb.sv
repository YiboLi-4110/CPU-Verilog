`timescale 1ns/1ns
module test_model; // 顶层测试模块名，必须与Tcl脚本中的 `work.test_model` 一致
    logic a, b, c;
    // 实例化被测设计
    test_design u_dut (
        .a(a),
        .b(b),
        .c(c)
    );
    initial begin
        // 初始化信号
        a = 0;
        b = 0;
        #10;
        // 开始测试
        $display("Starting test...");
        a = 0; b = 0; #10; $display("a=%b, b=%b, c=%b", a, b, c);
        a = 0; b = 1; #10; $display("a=%b, b=%b, c=%b", a, b, c);
        a = 1; b = 0; #10; $display("a=%b, b=%b, c=%b", a, b, c);
        a = 1; b = 1; #10; $display("a=%b, b=%b, c=%b", a, b, c);
        $display("Test finished.");
        $finish; // 仿真结束，这会触发Tcl脚本中的 `run -all` 停止
    end
endmodule