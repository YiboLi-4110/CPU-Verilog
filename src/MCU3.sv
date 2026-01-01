`include "includes/OP_code.svh"
`include "includes/ALUOP_Mod.svh"

module MCU3(
    input wire [5:0] op_code,
    input wire [2:0] [4:0] layer_WB,
    input wire [2:0] [4:0] layer_MA,
    input wire [2:0] [4:0] layer_EX,
    output wire Branch,
    output wire Jump,
    output wire MemRd,
    output wire MemWr,
    output wire MemSrc
);

    reg Branch_reg;
    reg Jump_reg;
    reg MemRd_reg;
    reg MemWr_reg;
    reg MemSrc_reg;

    always @(*) begin
        // 默认值
        Branch_reg = 1'b0;
        Jump_reg = 1'b0;
        MemRd_reg = 1'b0;
        MemWr_reg = 1'b0;
        MemSrc_reg = 1'b0;

        case (op_code)
            `OP_CODE_LW: begin
                MemRd_reg = 1'b1;
            end 
            `OP_CODE_SW: begin
                MemWr_reg = 1'b1;
            end
            `OP_CODE_BEQ: begin
                Branch_reg = 1'b1;
            end
            `OP_CODE_BNE: begin
                Branch_reg = 1'b1;
            end
            `OP_CODE_BLEZ: begin
                Branch_reg = 1'b1;
            end
            `OP_CODE_BGTZ: begin
                Branch_reg = 1'b1;
            end
            `OP_CODE_BLTZ: begin
                Branch_reg = 1'b1;
            end
            `OP_CODE_BGEZ: begin
                Branch_reg = 1'b1;
            end
            `OP_CODE_J: begin
                Jump_reg = 1'b1;
            end
        endcase

        // 根据冒险情况，设置MemSrc
        // 连续两条的情况: 第二条为sw
        if ((layer_MA[1]==layer_WB[2]) && (layer_MA[1]!=0)) begin
            MemSrc_reg = 1'b1;
        end
    end

    assign Branch = Branch_reg;
    assign Jump = Jump_reg;
    assign MemRd = MemRd_reg;
    assign MemWr = MemWr_reg;
    assign MemSrc = MemSrc_reg;
endmodule