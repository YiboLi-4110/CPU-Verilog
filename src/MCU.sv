/*
    实现了MIPS指令集，对应的多周期CPU中的主控制单元
*/
`include "src/includes/OP_code.svh"
`include "src/includes/ALUOp_Mod.svh"

module MCU (
    input clk,
    input wire [5:0] op_code,
    output wire PCWr,
    output wire IorD,
    output wire MemRd,
    output wire MemWr,
    output wire IRWr,
    output wire MemtoReg,
    output wire [1:0] PCSrc,
    output wire [3:0] ALUOp,
    output wire [1:0] ALUSrcB,
    output wire ALUSrcA,
    output wire RegWr,
    output wire [1:0] RegDst,
    output wire FLAGSWr,
    output wire Branch,
    output wire Jump,
    output wire SigHigh,
    output wire RegPCWr
);

    // 定义自动机状态}
    typedef enum reg [4:0] {
        S0,  S1,  S2,  S3,  S4,  S5,  S6,  S7,  S8,  S9,  S10, S11, S12, S13, S14, S15, 
        S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31
    } state_t;
    
    state_t state, next_state;

    reg PCWr_reg;
    reg IorD_reg;
    reg MemRd_reg;
    reg MemWr_reg;
    reg IRWr_reg;
    reg MemtoReg_reg;
    reg [1:0] PCSrc_reg;
    reg [3:0] ALUOp_reg;
    reg [1:0] ALUSrcB_reg;
    reg ALUSrcA_reg;
    reg RegWr_reg;
    reg [1:0] RegDst_reg;
    reg FLAGSWr_reg;
    reg Branch_reg;
    reg Jump_reg;
    reg SigHigh_reg;
    reg RegPCWr_reg;


    // 根据时钟切换状态
    always @(posedge clk) begin
        state <= next_state;
    end

    // 根据状态选择控制信号
    always @(*) begin
        // 初始化所有控制信号为默认值
        PCWr_reg = 1'b0;
        IorD_reg = 1'b0;
        MemRd_reg = 1'b0;
        MemWr_reg = 1'b0;
        IRWr_reg = 1'b0;
        MemtoReg_reg = 1'b0;
        PCSrc_reg = 2'b00;
        ALUOp_reg = 4'b0000;
        ALUSrcB_reg = 2'b00;
        ALUSrcA_reg = 1'b0;
        RegWr_reg = 1'b0;
        RegDst_reg = 2'b00;
        FLAGSWr_reg = 1'b0;
        Branch_reg = 1'b0;
        Jump_reg = 1'b0;
        SigHigh_reg = 1'b0;
        RegPCWr_reg = 1'b0;

        next_state = S0;
        
        // 根据状态进行转移
        case (state)
            S0: begin // 取指令状态
                MemRd_reg = 1'b1;
                IRWr_reg = 1'b1;
                IorD_reg = 1'b0;
                ALUSrcA_reg = 1'b0;
                ALUSrcB_reg = 2'b01;
                PCWr_reg = 1'b1;
                ALUOp_reg = 4'b0000;
                PCSrc_reg = 2'b00;
                next_state = S1;  // 下一状态
            end 
            S1: begin // 指令译码/寄存器取数据
                ALUSrcA_reg = 1'b0;
                ALUSrcB_reg = 2'b11;
                ALUOp_reg = 4'b0000;
                // 下一状态
                case (op_code)
                    `OP_CODE_LW: next_state = S2; // lw
                    `OP_CODE_SW: next_state = S2; // sw
                    `OP_CODE_RR: next_state = S6; // R 型指令
                    `OP_CODE_BEQ: next_state = S8; // beq
                    `OP_CODE_BGEZ: next_state = S8; // bgez
                    `OP_CODE_BGTZ: next_state = S8; // bgtz
                    `OP_CODE_BLEZ: next_state = S8; // blez
                    `OP_CODE_BLTZ: next_state = S8; // bltz
                    `OP_CODE_BNE: next_state = S8; // bne
                    `OP_CODE_J: next_state = S9; // j
                    `OP_CODE_ADDI: next_state = S10; //addi
                    `OP_CODE_ADDIU: next_state = S11; //addiu
                    `OP_CODE_ANDI: next_state = S12; //andi
                    `OP_CODE_LUI: next_state = S13; //lui
                    `OP_CODE_ORI: next_state = S14; //ori
                    `OP_CODE_SLTI: next_state = S15; //slti
                    `OP_CODE_SLTIU: next_state = S16; //sltiu
                    `OP_CODE_XORI: next_state = S17; //xori
                    `OP_CODE_JAL: next_state = S19; //jal
                    default: next_state = S0; 
                endcase
            end
            S2: begin // Op = 'lw' or 'sw'
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b10;
                ALUOp_reg = 4'b0000;
                FLAGSWr_reg = 1'b1;
                // 下一状态
                case (op_code)
                    `OP_CODE_LW: next_state = S3; // lw
                    `OP_CODE_SW: next_state = S5; // sw
                endcase
            end
            S3: begin // Op = 'lw'
                MemRd_reg = 1'b1;
                IorD_reg = 1'b1;
                next_state = S4; // 下一状态
            end
            S4: begin // 寄存器写
                RegDst_reg = 2'b00;
                RegWr_reg = 1'b1;
                MemtoReg_reg = 1'b1;
                next_state = S0; // 下一状态
            end
            S5: begin // Op = 'sw'
                MemWr_reg = 1'b1;
                IorD_reg = 1'b1;
                next_state = S0; // 下一状态
            end
            S6: begin // R型指令
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b00;
                ALUOp_reg = `ALUOp_R;
                FLAGSWr_reg = 1'b1;
                next_state = S7; // 下一状态
            end
            S7: begin // 寄存器写
                RegDst_reg = 2'b01;
                RegWr_reg = 1'b1;
                MemtoReg_reg = 1'b0;
                ALUOp_reg = `ALUOp_R;
                next_state = S0; // 下一状态
            end
            S8: begin // b型分支转移
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b00;
                ALUOp_reg = `ALUOp_SUB;
                Branch_reg = 1'b1;
                PCSrc_reg = 2'b01;
                FLAGSWr_reg = 1'b1;
                next_state = S0;
            end
            S9: begin // j型分支转移
                Jump_reg = 1'b1;
                PCSrc_reg = 2'b10;
                next_state = S0; // 下一状态
            end
            S10: begin //addi
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b10;
                ALUOp_reg = `ALUOp_ADD;
                FLAGSWr_reg = 1'b1;
                next_state = S18;            
            end
            S11: begin //addiu
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b10;
                ALUOp_reg = `ALUOp_ADDU;
                FLAGSWr_reg = 1'b1;
                next_state = S18;   
            end
            S12: begin //andi
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b10;
                ALUOp_reg = `ALUOp_AND;
                FLAGSWr_reg = 1'b1;
                next_state = S18;   
            end
            S13: begin //lui
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b10;
                ALUOp_reg = `ALUOp_ADD;
                SigHigh_reg = 1'b1;
                next_state = S18;   
            end
            S14: begin //ori
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b10;
                ALUOp_reg = `ALUOp_OR;
                FLAGSWr_reg = 1'b1;
                next_state = S18;   
            end
            S15: begin //slti
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b10;
                ALUOp_reg = `ALUOp_SLT;
                FLAGSWr_reg = 1'b1;
                next_state = S18;   
            end
            S16: begin //sltiu
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b10;
                ALUOp_reg = `ALUOp_SLTU;
                FLAGSWr_reg = 1'b1;
                next_state = S18;   
            end
            S17: begin //xori
                ALUSrcA_reg = 1'b1;
                ALUSrcB_reg = 2'b10;
                ALUOp_reg = `ALUOp_XOR;
                FLAGSWr_reg = 1'b1;
                next_state = S18;   
            end
            S18: begin //RI型第二步
                MemtoReg_reg = 1'b0;
                RegDst_reg = 2'b00;
                RegWr_reg = 1'b1;
                next_state = S0;
            end
            S19: begin //jal型分支转移
                Jump_reg = 1'b1;
                PCSrc_reg = 2'b10;
                RegDst_reg = 2'b10; //31
                RegWr_reg = 1'b1;
                RegPCWr_reg = 1'b1;
                next_state = S0; 
            end
        endcase
    end

    assign PCWr = PCWr_reg;
    assign IorD = IorD_reg;    
    assign MemRd = MemRd_reg;  
    assign MemWr = MemWr_reg;   
    assign IRWr = IRWr_reg;    
    assign MemtoReg = MemtoReg_reg;
    assign PCSrc = PCSrc_reg;   
    assign ALUOp = ALUOp_reg;   
    assign ALUSrcB = ALUSrcB_reg; 
    assign ALUSrcA = ALUSrcA_reg; 
    assign RegWr = RegWr_reg;  
    assign RegDst = RegDst_reg;  
    assign FLAGSWr = FLAGSWr_reg; 
    assign Branch = Branch_reg;  
    assign Jump = Jump_reg;    
    assign SigHigh = SigHigh_reg; 
    assign RegPCWr = RegPCWr_reg;

endmodule