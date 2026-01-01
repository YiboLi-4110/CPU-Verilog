`include "includes/OP_code.svh"
`include "includes/ALUOP_Mod.svh"

module MCU2(
    input wire [5:0] op_code,
    input wire [2:0] [4:0] layer_WB,
    input wire [2:0] [4:0] layer_MA,
    input wire [2:0] [4:0] layer_EX,
    output wire [1:0] ALUSrcA,
    output wire [1:0] ALUSrcB,
    output wire [`ALUOp_WIRENUM-1:0] ALUOp,
    output wire AnstoRt // 用来规避sw作为第三条指令时的数据冒险
);

    reg [1:0] ALUSrcA_reg;
    reg [1:0] ALUSrcB_reg;
    reg [`ALUOp_WIRENUM-1:0] ALUOp_reg;
    reg AnstoRt_reg;

    always @(*) begin
        // 默认值
        ALUSrcA_reg = 2'b00;
        ALUSrcB_reg = 2'b00;
        ALUOp_reg = `ALUOp_WIRENUM'b0000;
        AnstoRt_reg = 1'b0;

        case (op_code)
            `OP_CODE_LW: begin
                ALUOp_reg = `ALUOp_ADD;
                ALUSrcB_reg = 2'b11;
            end 
            `OP_CODE_SW: begin
                ALUOp_reg = `ALUOp_ADD;
                ALUSrcB_reg = 2'b11;
            end
            `OP_CODE_RR: begin
                ALUOp_reg = `ALUOp_R;
            end
            `OP_CODE_BEQ: begin
                ALUOp_reg = `ALUOp_SUB;
            end
            `OP_CODE_BNE: begin
                ALUOp_reg = `ALUOp_SUB;
            end
            `OP_CODE_BLEZ: begin
                ALUOp_reg = `ALUOp_SUB;
            end
            `OP_CODE_BGTZ: begin
                ALUOp_reg = `ALUOp_SUB;
            end
            `OP_CODE_BLTZ: begin
                ALUOp_reg = `ALUOp_SUB;
            end
            `OP_CODE_BGEZ: begin
                ALUOp_reg = `ALUOp_SUB;
            end
            `OP_CODE_ADDI: begin
                ALUOp_reg = `ALUOp_ADD;
                ALUSrcB_reg = 2'b11;
            end
            `OP_CODE_ADDIU: begin
                ALUOp_reg = `ALUOp_ADDU;
                ALUSrcB_reg = 2'b11;
            end
            `OP_CODE_ANDI: begin
                ALUOp_reg = `ALUOp_AND;
                ALUSrcB_reg = 2'b11;
            end
            `OP_CODE_ORI: begin
                ALUOp_reg = `ALUOp_OR;
                ALUSrcB_reg = 2'b11;
            end
            `OP_CODE_XORI: begin
                ALUOp_reg = `ALUOp_XOR;
                ALUSrcB_reg = 2'b11;
            end
            `OP_CODE_SLTI: begin
                ALUOp_reg = `ALUOp_SLT;
                ALUSrcB_reg = 2'b11;
            end
            `OP_CODE_SLTIU: begin
                ALUOp_reg = `ALUOp_SLTU;
                ALUSrcB_reg = 2'b11;
            end
            `OP_CODE_LUI: begin
                ALUOp_reg = `ALUOp_ADD;
                ALUSrcB_reg = 2'b11;
            end
        endcase

        // 根据冒险情况，设置ALUSrcA和ALUSrcB
        // 连续两条的情况
        if ((layer_EX[0]==layer_MA[2]) && (layer_EX[0]!=0)) begin
            ALUSrcA_reg = 2'b01;
        end
        if ((layer_EX[1]==layer_MA[2]) && (layer_EX[1]!=0)) begin
            if (op_code!=`OP_CODE_SW) begin
                ALUSrcB_reg = 2'b01;
            end
        end
        // 连续三条的情况
        // 针对其他情况的冒险解决
        if ((layer_EX[0]==layer_WB[2]) && (layer_EX[0]!=0)) begin
            ALUSrcA_reg = 2'b10;
        end
        if ((layer_EX[1]==layer_WB[2]) && (layer_EX[1]!=0)) begin
            if (op_code==`OP_CODE_SW) begin
                AnstoRt_reg = 1'b1;
            end
            else begin
                ALUSrcB_reg = 2'b10;
            end
        end
    end

    assign ALUSrcA = ALUSrcA_reg;
    assign ALUSrcB = ALUSrcB_reg;
    assign ALUOp = ALUOp_reg;
    assign AnstoRt = AnstoRt_reg;
endmodule