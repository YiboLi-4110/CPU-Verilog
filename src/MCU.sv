/*
    实现MIPS中的MCU控制器
*/
`include "include/OP_code.svh"

module MCU(
    input wire [5:0] op_code,  // OP_Code (6位)
    output wire Branch,  // b型指令信号
    output wire Jump,  // j型指令信号
    output wire MemtoReg,  // 用于多路选择器
    output wire [1:0] ALUOp,  // 用于控制ALUCU
    output wire MemWr,  // 用于控制DMem的写信号
    output wire MemRd,  // 用于控制DMem的读信号
    output wire ALUSrc,  // 用于多路选择器
    output wire RegDst,  // 用于多路选择器
    output wire Reg,m Wr  // 用于RF的写信号
);

    // 使用阻塞赋值实现组合逻辑
    always @(*) begin
        // 默认值
        Branch = 1'b0;
        Jump = 1'b0;
        MemtoReg = 1'b0;
        ALUOp = 2'b00;
        MemWr = 1'b0;
        MemRd = 1'b0;
        ALUSrc = 1'b0;
        RegDst = 1'b0;
        RegWr = 1'b0;

        // 根据op_code设置控制信号
        case (op_code)
            `OP_CODE_RR: begin  // R型指令 (000000)
                RegDst = 1'b1;
                ALUSrc = 1'b0;
                MemtoReg = 1'b0;
                RegWr = 1'b1;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            `OP_CODE_LW: begin    // 加载字指令 (100011)
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b1;
                RegWr = 1'b1;
                MemRd = 1'b1;
                MemWr = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
            end
            `OP_CODE_SW: begin    // 存储字指令 (101011)
                ALUSrc = 1'b1;
                RegWr = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b1;
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
            end
            `OP_CODE_BEQ: begin   // 相等分支指令 (000100)
                ALUSrc = 1'b0;
                RegWr = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b1;
                ALUOp = 2'b01;
                Jump = 1'b0;
            end
            `OP_CODE_BNE: begin   // 不相等分支指令 (000101)
                ALUSrc = 1'b0;
                RegWr = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b1;
                ALUOp = 2'b01;
                Jump = 1'b0;
            end
            `OP_CODE_BLEZ: begin   // 小于等于0分支指令 (000110)
                ALUSrc = 1'b0;
                RegWr = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b1;
                ALUOp = 2'b01;
                Jump = 1'b0;
            end
            `OP_CODE_BGTZ: begin   // 大于0分支指令 (000111)
                ALUSrc = 1'b0;
                RegWr = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b1;
                ALUOp = 2'b01;
                Jump = 1'b0;
            end
            `OP_CODE_BLTZ: begin   // 小于0分支指令 (000001)
                ALUSrc = 1'b0;
                RegWr = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b1;
                ALUOp = 2'b01;
                Jump = 1'b0;
            end
            `OP_CODE_BGEZ: begin   // 大于等于0分支指令 (000001)
                ALUSrc = 1'b0;
                RegWr = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b1;
                ALUOp = 2'b01;
                Jump = 1'b0;
            end
            `OP_CODE_J: begin     // 跳转指令 (000010)
                RegWr = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b0;
                Jump = 1'b1;
            end
            `OP_CODE_ADDI: begin  // 立即数加法-有符号 (001000)
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWr = 1'b1;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            `OP_CODE_ADDIU: begin  // 立即数加法-无符号 (001001)
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWr = 1'b1;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            `OP_CODE_ANDI: begin  // 立即数与运算 (001100)
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWr = 1'b1;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            `OP_CODE_ORI: begin   // 立即数或运算 (001101)
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWr = 1'b1;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            `OP_CODE_XORI: begin   // 立即数异或运算 (001110)
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWr = 1'b1;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            `OP_CODE_SLTI: begin   // 小于立即数置1-有符号 (001010)
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWr = 1'b1;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            `OP_CODE_SLTIU: begin   // 小于立即数置1-无符号 (001011)
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                MemtoReg = 1'b0;
                RegWr = 1'b1;
                MemRd = 1'b0;
                MemWr = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            default: begin   // 默认情况
                // 保持默认值（无操作）
            end
        endcase
    end

endmodule
