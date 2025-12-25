/*
    实现MIPS指令集的临时寄存器，主要用于保存ALU的输出
*/

module Temp_Reg(
    input wire clk,  // 时钟信号
    input wire [31:0] input_data,  // 写数据
    output reg [31:0] output_data  // 读出的数据
);

    // 根据时钟信号取出指令数据
    always @(posedge clk) begin
        output_data <= input_data;
    end
endmodule