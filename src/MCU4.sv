`include "includes/OP_code.svh"
`include "includes/ALUOP_Mod.svh"

module MCU4(
    input wire [5:0] op_code,
    output wire MemtoReg,
    output wire RegDst,
    output wire RegWr
);

    reg RegDst_reg;
    reg MemtoReg_reg;
    reg RegWr_reg;

    always_comb begin
        // 默认值
        RegDst_reg = 1'b0;
        MemtoReg_reg = 1'b0;
        RegWr_reg = 1'b0;

        case (op_code)
            `OP_CODE_LW: begin
                MemtoReg_reg = 1'b1;
                RegWr_reg = 1'b1;
            end 
            `OP_CODE_RR: begin
                RegDst_reg = 1'b1;
                RegWr_reg = 1'b1;
            end
            `OP_CODE_ADDI: begin
                RegWr_reg = 1'b1;
            end
            `OP_CODE_ADDIU: begin
                RegWr_reg = 1'b1;
            end
            `OP_CODE_ANDI: begin
                RegWr_reg = 1'b1;
            end
            `OP_CODE_ORI: begin
                RegWr_reg = 1'b1;
            end
            `OP_CODE_XORI: begin
                RegWr_reg = 1'b1;
            end
            `OP_CODE_SLTI: begin
                RegWr_reg = 1'b1;
            end
            `OP_CODE_SLTIU: begin
                RegWr_reg = 1'b1;
            end
        endcase
    end

    assign MemtoReg = MemtoReg_reg;
    assign RegDst = RegDst_reg;
    assign RegWr = RegWr_reg;
endmodule