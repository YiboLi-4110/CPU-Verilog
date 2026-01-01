`include "includes/OP_code.svh"

module DA (
    input wire [31:0] Inst,
    input wire [31:0] Inst_foward,
    input wire CLK,
    input wire rst_n,
    output wire [2:0] [4:0] layer_WB,
    output wire [2:0] [4:0] layer_MA,
    output wire [2:0] [4:0] layer_EX,
    output reg bubble
);
    reg [2:0] [4:0] WB_reg = '0;
    reg [2:0] [4:0] MA_reg = '0;
    reg [2:0] [4:0] EX_reg = '0;
    reg [2:0] [4:0] ID_reg = '0;

    reg [2:0] [4:0] FI_reg;

    reg bubble_reg;

    wire [5:0] op_code;
    assign op_code = Inst[31:26];

    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;

    assign rs = Inst[25:21];
    assign rt = Inst[20:16];
    assign rd = Inst[15:11];

    always_ff @(posedge CLK or negedge rst_n) begin
        if (!rst_n)
        begin
            bubble <= 1'b0;
        end
        else 
        begin
            WB_reg <= MA_reg;
            MA_reg <= EX_reg;
            EX_reg <= ID_reg;
            ID_reg <= FI_reg;

            bubble <= bubble_reg;
        end
    end

    always_comb begin
        bubble_reg = 1'b0;

        case (op_code)
            `OP_CODE_RR: begin
                FI_reg[0] = rs;
                FI_reg[1] = rt;
                FI_reg[2] = rd;
            end
                
            `OP_CODE_LW: begin
                FI_reg[0] = rs;
                FI_reg[1] = 5'b00000;
                FI_reg[2] = rt;
                case (Inst_foward[31:26])
                    `OP_CODE_RR: begin
                        if((Inst_foward[25:21] == rt && rt != 5'b00000) || (Inst_foward[20:16] == rt && rt != 5'b00000))
                            bubble_reg = 1'b1;
                        else
                            bubble_reg = 1'b0;
                    end

                    `OP_CODE_LW: begin
                        if(Inst_foward[25:21] == rt && rt != 5'b00000)
                            bubble_reg = 1'b1;
                        else
                            bubble_reg = 1'b0;
                    end 

                    `OP_CODE_SW: begin
                        if(Inst_foward[25:21] == rt && rt != 5'b00000)
                            bubble_reg = 1'b1;
                        else
                            bubble_reg = 1'b0;
                    end 

                    default: 
                        bubble_reg = 1'b0;
                endcase
            end

            `OP_CODE_SW: begin
                FI_reg[0] = rs;
                FI_reg[1] = rt;
                FI_reg[2] = 5'b00000;
            end


            `OP_CODE_ADDI: begin
                FI_reg[0] = rs;
                FI_reg[1] = 5'b00000;
                FI_reg[2] = rt;
            end

            `OP_CODE_ADDIU: begin
                FI_reg[0] = rs;
                FI_reg[1] = 5'b00000;
                FI_reg[2] = rt;
            end

            `OP_CODE_ANDI: begin
                FI_reg[0] = rs;
                FI_reg[1] = 5'b00000;
                FI_reg[2] = rt;
            end

            `OP_CODE_ORI: begin
                FI_reg[0] = rs;
                FI_reg[1] = 5'b00000;
                FI_reg[2] = rt;
            end

            `OP_CODE_XORI: begin
                FI_reg[0] = rs;
                FI_reg[1] = 5'b00000;
                FI_reg[2] = rt;
            end

            `OP_CODE_SLTI: begin
                FI_reg[0] = rs;
                FI_reg[1] = 5'b00000;
                FI_reg[2] = rt;
            end

            `OP_CODE_SLTIU: begin
                FI_reg[0] = rs;
                FI_reg[1] = 5'b00000;
                FI_reg[2] = rt;
            end

            default: begin
                FI_reg[0] = 5'b00000;
                FI_reg[1] = 5'b00000;
                FI_reg[2] = 5'b00000;
            end
        endcase
        
    end

    assign layer_WB = WB_reg;
    assign layer_MA = MA_reg;
    assign layer_EX = EX_reg;

endmodule