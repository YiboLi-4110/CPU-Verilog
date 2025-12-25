/*
    实现多路选择器（二路）
*/

module MUX_2#(parameter DATA_WIDTH = 32) (
    input wire [DATA_WIDTH-1:0] input0, // 输入数据1
    input wire [DATA_WIDTH-1:0] input1, // 输入数据2
    input wire select, // 选择信号
    output wire [DATA_WIDTH-1:0] out_data// 输出数据
);
    // 根据选择信号选择输入数据
    assign out_data = select ? input1 : input0;

endmodule