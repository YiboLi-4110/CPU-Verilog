/*
    实现多路选择器（四路）
*/

module MUX_4#(parameter DATA_WIDTH = 32) (
    input wire [DATA_WIDTH-1:0] input0, // 输入数据1
    input wire [DATA_WIDTH-1:0] input1, // 输入数据2
    input wire [DATA_WIDTH-1:0] input2, // 输入数据3
    input wire [DATA_WIDTH-1:0] input3, // 输入数据4
    input wire [1:0] select, // 选择信号
    output wire [DATA_WIDTH-1:0] out_data// 输出数据
);
    // 根据选择信号选择输入数据
    assign out_data = (select == 2'b00) ? input0 :
                    (select == 2'b01) ? input1 :
                    (select == 2'b10) ? input2 :
                    input3; // select == 2'b11
endmodule