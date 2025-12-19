/*
    测试二路选择器（MUX_2）模块
*/
module MUX_2_tb;
    // 定义参数
    parameter DATA_WIDTH = 32;

    // 定义输入输出信号
    reg [DATA_WIDTH-1:0] input0, input1;
    reg select;
    wire [DATA_WIDTH-1:0] out_data;  // 与模块输出一致

    // 实例化MUX_2模块
    MUX_2 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .input0(input0),
        .input1(input1),
        .select(select),
        .out_data(out_data)  // 对应修改
    );

    // 初始化输入信号
    initial begin
        input0 = 32'h00000001;
        input1 = 32'h00000010;
        select = 1'b0;

        // 模拟不同的条件
        #10; // 等待10个时间单位
        select = 1'b1;

        #10; // 再等待10个时间单位
        
        // 添加更多测试
        #10;
        input0 = 32'hFFFFFFFF;
        input1 = 32'hAAAA5555;
        select = 1'b0;
        
        #10;
        select = 1'b1;
        
        #10;
        // 结束仿真
        $finish;
    end

    // 监控输出信号的变化
    initial begin
        $monitor("Time=%0t: select=%b, input0=%h, input1=%h, out_data=%h", 
                 $time, select, input0, input1, out_data);
    end

    // 生成VCD文件用于gtkwave
    initial begin
        $dumpfile("mux_2_wave.vcd");
        $dumpvars(0, MUX_2_tb);
    end
    
endmodule