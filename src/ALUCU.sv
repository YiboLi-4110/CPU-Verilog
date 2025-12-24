`include "includes/ALU_Mod.svh"
`include "includes/ALUOp_Mod.svh"
`include "includes/Funct_Mod.svh"

module ALUCU (
    input wire [5:0] funct,
    input wire [`ALUOp_WIRENUM-1:0] ALUOp,
    output wire [`ALUCTRL_WIRENUM-1: 0] ALUCTRL,
    output wire shift,
    output wire RegtoPC,
    output wire RegPCWr
);
    reg [`ALUCTRL_WIRENUM-1: 0] ALUCTRL_reg;
    reg shift_reg;
    reg RegtoPC_reg;
    reg RegPCWr_reg;

    always_comb begin
        shift_reg = 1'b0;
        RegtoPC_reg = 1'b0;
        RegPCWr_reg = 1'b0;
        if(ALUOp == `ALUOp_R)
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
                            shift_reg = 1'b1;
                        end 
                    `FUNC_SRL:
                        begin
                            ALUCTRL_reg = `OP_SRL;
                            shift_reg = 1'b1;
                        end 
                    `FUNC_SRA:
                        begin
                            ALUCTRL_reg = `OP_SRA;
                            shift_reg = 1'b1;
                        end 
                    `FUNC_JR:
                        begin
                            ALUCTRL_reg = `OP_NOP;
                            RegtoPC_reg = 1'b1;
                        end
                    `FUNC_JALR:
                        begin
                            ALUCTRL_reg = `OP_NOP;
                            RegtoPC_reg = 1'b1;
                            RegPCWr_reg = 1'b1;
                        end 
                    default: 
                        ALUCTRL_reg = `OP_NOP;
                endcase
            end
        else
            begin
                case (ALUOp)
                    `ALUOp_ADD:
                        ALUCTRL_reg = `OP_ADD;
                    `ALUOp_SUB:
                        ALUCTRL_reg = `OP_SUB;
                    `ALUOp_ADDU:
                        ALUCTRL_reg = `OP_ADDU;
                    `ALUOp_SUBU:
                        ALUCTRL_reg = `OP_SUBU;
                    `ALUOp_AND:
                        ALUCTRL_reg = `OP_AND;
                    `ALUOp_OR:
                        ALUCTRL_reg = `OP_OR;
                    `ALUOp_XOR:
                        ALUCTRL_reg = `OP_XOR;
                    `ALUOp_SLT:
                        ALUCTRL_reg = `OP_SLT;
                    `ALUOp_SLTU:
                        ALUCTRL_reg = `OP_SLTU;

                    default: 
                        ALUCTRL_reg = `OP_NOP;
                endcase
            end
    end
    
    assign ALUCTRL = ALUCTRL_reg;
    assign shift = shift_reg;
    assign RegtoPC = RegtoPC_reg;
    assign RegPCWr = RegPCWr_reg;
    
endmodule