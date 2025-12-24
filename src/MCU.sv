`include "includes/OP_code.svh"
`include "includes/ALUOp_Mod.svh"

module MCU(
    input wire [5:0] op_code,  // OP_Code (6位)
    output wire Branch,  // b型指令信号
    output wire Jump,  // j型指令信号
    output wire MemtoReg,  // 用于多路选择器
    output wire [`ALUOp_WIRENUM-1:0] ALUOp,  // 用于控制ALUCU new-------
    output wire MemWr,  // 用于控制DMem的写信号
    output wire MemRd,  // 用于控制DMem的读信号
    output wire ALUSrc,  // 用于多路选择器
    output wire RegDst,  // 用于多路选择器
    output wire RegWr,  // 用于RF的写信号
    output wire sigext_high
);
    
    reg Branch_reg;
    reg Jump_reg;
    reg MemtoReg_reg;
    reg [`ALUOp_WIRENUM-1:0] ALUOp_reg;
    reg MemWr_reg;
    reg MemRd_reg;
    reg ALUSrc_reg;
    reg RegDst_reg;
    reg RegWr_reg;
    reg sigext_high_reg;

    // 使用阻塞赋值实现组合逻辑
    always @(*) begin
        // 默认值
        Branch_reg = 1'b0;
        Jump_reg = 1'b0;
        MemtoReg_reg = 1'b0;
        ALUOp_reg = `ALUOp_WIRENUM'b0000;
        MemWr_reg = 1'b0;
        MemRd_reg = 1'b0;
        ALUSrc_reg = 1'b0;
        RegDst_reg = 1'b0;
        RegWr_reg = 1'b0;
        sigext_high_reg = 1'b0;

        // 根据op_code设置控制信号
        case (op_code)
            `OP_CODE_RR: begin  // R型指令 (000000)
                RegDst_reg = 1'b1;
                ALUSrc_reg = 1'b0;
                MemtoReg_reg = 1'b0;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_R;
                Jump_reg = 1'b0;
            end
            `OP_CODE_LW: begin    // 加载字指令 (100011)
                RegDst_reg = 1'b0;
                ALUSrc_reg = 1'b1;
                MemtoReg_reg = 1'b1;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b1;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_ADD;
                Jump_reg = 1'b0;
            end
            `OP_CODE_SW: begin    // 存储字指令 (101011)
                ALUSrc_reg = 1'b1;
                RegWr_reg = 1'b0;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b1;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_ADD;
                Jump_reg = 1'b0;
            end
            `OP_CODE_BEQ: begin   // 相等分支指令 (000100)
                ALUSrc_reg = 1'b0;
                RegWr_reg = 1'b0;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b1;
                ALUOp_reg = `ALUOp_SUB;
                Jump_reg = 1'b0;
            end
            `OP_CODE_BNE: begin   // 不相等分支指令 (000101)
                ALUSrc_reg = 1'b0;
                RegWr_reg = 1'b0;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b1;
                ALUOp_reg = `ALUOp_SUB;
                Jump_reg = 1'b0;
            end
            `OP_CODE_BLEZ: begin   // 小于等于0分支指令 (000110)
                ALUSrc_reg = 1'b0;
                RegWr_reg = 1'b0;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b1;
                ALUOp_reg = `ALUOp_SUB;
                Jump_reg = 1'b0;
            end
            `OP_CODE_BGTZ: begin   // 大于0分支指令 (000111)
                ALUSrc_reg = 1'b0;
                RegWr_reg = 1'b0;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b1;
                ALUOp_reg = `ALUOp_SUB;
                Jump_reg = 1'b0;
            end
            `OP_CODE_BLTZ: begin   // 小于0分支指令 (000001)
                ALUSrc_reg = 1'b0;
                RegWr_reg = 1'b0;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b1;
                ALUOp_reg = `ALUOp_SUB;
                Jump_reg = 1'b0;
            end
            `OP_CODE_BGEZ: begin   // 大于等于0分支指令 (000001)
                ALUSrc_reg = 1'b0;
                RegWr_reg = 1'b0;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b1;
                ALUOp_reg = `ALUOp_SUB;
                Jump_reg = 1'b0;
            end
            `OP_CODE_J: begin     // 跳转指令 (000010)
                RegWr_reg = 1'b0;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                Jump_reg = 1'b1;
            end
            `OP_CODE_ADDI: begin  // 立即数加法-有符号 (001000)
                RegDst_reg = 1'b0;
                ALUSrc_reg = 1'b1;
                MemtoReg_reg = 1'b0;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_ADD;
                Jump_reg = 1'b0;
            end
            `OP_CODE_ADDIU: begin  // 立即数加法-无符号 (001001)
                RegDst_reg = 1'b0;
                ALUSrc_reg = 1'b1;
                MemtoReg_reg = 1'b0;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_ADDU;
                Jump_reg = 1'b0;
            end
            `OP_CODE_ANDI: begin  // 立即数与运算 (001100)
                RegDst_reg = 1'b0;
                ALUSrc_reg = 1'b1;
                MemtoReg_reg = 1'b0;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_AND;
                Jump_reg = 1'b0;
            end
            `OP_CODE_ORI: begin   // 立即数或运算 (001101)
                RegDst_reg = 1'b0;
                ALUSrc_reg = 1'b1;
                MemtoReg_reg = 1'b0;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_OR;
                Jump_reg = 1'b0;
            end
            `OP_CODE_XORI: begin   // 立即数异或运算 (001110)
                RegDst_reg = 1'b0;
                ALUSrc_reg = 1'b1;
                MemtoReg_reg = 1'b0;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_XOR;
                Jump_reg = 1'b0;
            end
            `OP_CODE_SLTI: begin   // 小于立即数置1-有符号 (001010)
                RegDst_reg = 1'b0;
                ALUSrc_reg = 1'b1;
                MemtoReg_reg = 1'b0;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_SLT;
                Jump_reg = 1'b0;
            end
            `OP_CODE_SLTIU: begin   // 小于立即数置1-无符号 (001011)
                RegDst_reg = 1'b0;
                ALUSrc_reg = 1'b1;
                MemtoReg_reg = 1'b0;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_SLTU;
                Jump_reg = 1'b0;
            end
            `OP_CODE_LUI:begin      //new-------
                RegDst_reg = 1'b0;
                ALUSrc_reg = 1'b1;
                MemtoReg_reg = 1'b0;
                RegWr_reg = 1'b1;
                MemRd_reg = 1'b0;
                MemWr_reg = 1'b0;
                Branch_reg = 1'b0;
                ALUOp_reg = `ALUOp_ADD; //add
                Jump_reg = 1'b0;
                sigext_high_reg = 1'b1;
            end
            default: begin   // 默认情况
                // 保持默认值（无操作）
            end
        endcase
    end

    assign Branch = Branch_reg;
    assign Jump = Jump_reg;
    assign MemtoReg = MemtoReg_reg;
    assign ALUOp = ALUOp_reg;
    assign MemWr = MemWr_reg;
    assign MemRd = MemRd_reg;
    assign ALUSrc = ALUSrc_reg;
    assign RegDst = RegDst_reg;
    assign RegWr = RegWr_reg;
    assign sigext_high = sigext_high_reg;

endmodule
