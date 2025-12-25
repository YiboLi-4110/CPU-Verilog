/*
    实现MIPS指令集CPU中的指令寄存器
*/

module IR (
    input clk,   // 时钟信号
    input wire IRWr,  // 写使能信号
    input wire [31:0] input_inst,  // 写入的指令
    output reg[31:0] output_inst   // 输出的指令
);

    // 初始化输出寄存器
    initial begin
        output_inst = 32'h00000000;
    end

    // 开始写入指令
    always @(posedge clk) begin
        if (IRWr) begin
            output_inst <= input_inst;
        end
    end
    
endmodule