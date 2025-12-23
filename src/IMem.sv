/*
    实现MIPS中的指令存储器
*/

module IMem (
    input wire [31:0] instruction_addr,
    output wire [31:0] instruction
);
    // 初始化指令存储器
    reg [31:0] instruction_mem [0:1023];

    // 读指令地址
    integer i;
    initial begin
        $readmemh("hexcode/test-big_dmem_and_lui.hex", instruction_mem);

        // 未初始化的指令应执行nop
        for (i=0; i<1024; i=i+1) begin
            if (instruction_mem[i] === 1'bx) begin
                instruction_mem[i] = 32'h00000000;
            end
        end
    end

    // 读出指令（地址最多支持2^12个字节，同时要除以4以得到指令的字地址）
    assign instruction = instruction_mem[instruction_addr[11:2]];

endmodule