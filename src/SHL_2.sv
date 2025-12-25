/*
    实现左移2位运算
*/

module SHL2#(parameter DATA_WIDTH = 8)(
    input wire [DATA_WIDTH-1:0] input_data,  // 输入数据
    output wire [DATA_WIDTH+1:0] output_data // 输出数据
);

    // 左移2位运算，保留所有有效位
    assign output_data = {input_data, 2'b00}; // 左移2位，这里使用拼接操作符{}
endmodule