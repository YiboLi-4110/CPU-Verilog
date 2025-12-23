`include "includes/ALU_Mod.svh"
`include "includes/Funct_Mod.svh"

module ALUCU (
    input wire [5:0] funct,
    input wire [1:0] ALUOp,
    output wire [`ALUCTRL_WIRENUM-1: 0] ALUCTRL,
    output wire shift
);
    reg [`ALUCTRL_WIRENUM-1: 0] ALUCTRL_reg;
    reg shift_reg = 1'b0;
    always @(*) begin
        if(ALUOp[1] == 1'b0)
            begin
                case (funct)
                    `FUNC_ADD:
                        begin
                            ALUCTRL_reg = `OP_ADD;
                        end 
                    `FUNC_ADDU:
                        begin
                            ALUCTRL_reg = `OP_ADDU;
                        end 
                    `FUNC_SUB:
                        begin
                            ALUCTRL_reg = `OP_SUB;
                        end 
                    `FUNC_SUBU:
                        begin
                            ALUCTRL_reg = `OP_SUBU;
                        end 
                    `FUNC_AND:
                        begin
                            ALUCTRL_reg = `OP_AND;
                        end 
                    `FUNC_OR:
                        begin
                            ALUCTRL_reg = `OP_OR;
                        end 
                    `FUNC_XOR:
                        begin
                            ALUCTRL_reg = `OP_XOR;
                        end 
                    `FUNC_NOR:
                        begin
                            ALUCTRL_reg = `OP_NOR;
                        end 
                    `FUNC_SLT:
                        begin
                            ALUCTRL_reg = `OP_SLT;
                        end 
                    `FUNC_SLTU:
                        begin
                            ALUCTRL_reg = `OP_SLTU;
                        end 
                    `FUNC_SLL:
                        begin
                            ALUCTRL_reg = `OP_SLL;
                            shift_reg = 1'b0;
                        end 
                    `FUNC_SRL:
                        begin
                            ALUCTRL_reg = `OP_SRL;
                            shift_reg = 1'b0;
                        end 
                    `FUNC_SRA:
                        begin
                            ALUCTRL_reg = `OP_SRA;
                            shift_reg = 1'b0;
                        end 
                    `FUNC_JR:
                        begin
                            ALUCTRL_reg = `OP_NOP;
                        end 
                    default: 
                        ALUCTRL_reg = `OP_NOP;
                endcase
            end
        else
            begin
                case (ALUOp)
                    2'b00:
                        ALUCTRL_reg = `OP_ADD;
                    2'b01:
                        ALUCTRL_reg = `OP_SUB;
                    default: 
                        ALUCTRL_reg = `OP_NOP;
                endcase
            end
    end
    
    assign ALUCTRL = ALUCTRL_reg;
    assign shift = shift_reg;
    
endmodule