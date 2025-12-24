`include "includes/ALU_Mod.svh"
`include "includes/Flags.svh"

module ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [`ALUCTRL_WIRENUM-1:0] Mod,
    output wire [31:0] C,
    output FLAGS_t flags
);
    
    FLAGS_t flags_reg;
    reg [32:0] C_reg;
    reg [31:0] C_temp;

    wire [4:0] shamt; 
    assign shamt = A[4:0];
    
    always @(*) begin
        flags_reg = '0;
        C_reg = 33'b0;
        
        case (Mod)
            `OP_ADD: begin
                C_reg = $signed({A[31], A}) + $signed({B[31], B});
                C_temp = C_reg[31:0];
                
                flags_reg.CF = C_reg[32];
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31];
                flags_reg.OF = (~A[31] & ~B[31] & C_temp[31]) | (A[31] & B[31] & ~C_temp[31]);
            end

            `OP_ADDU: begin
                C_reg = {1'b0, A} + {1'b0, B};
                C_temp = C_reg[31:0];
                
                flags_reg.CF = C_reg[32];
                flags_reg.ZF = (C_temp == 32'b0);
            end

            `OP_SUB: begin
                C_reg = $signed({A[31], A}) - $signed({B[31], B});
                C_temp = C_reg[31:0];
                
                flags_reg.CF = C_reg[32];
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31];
                flags_reg.OF = (~A[31] & B[31] & C_temp[31]) | (A[31] & ~B[31] & ~C_temp[31]);
            end

            `OP_SUBU: begin
                C_reg = {1'b0, A} - {1'b0, B};
                C_temp = C_reg[31:0];
                
                flags_reg.CF = C_reg[32];
                flags_reg.ZF = (C_temp == 32'b0);
            end

            `OP_SLT: begin
                C_temp = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31];
            end

            `OP_SLTU: begin
                C_temp = A < B ? 32'b1 : 32'b0;
                flags_reg.ZF = (C_temp == 32'b0);
            end

            `OP_AND: begin
                C_temp = A & B;
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31];
            end

            `OP_OR: begin
                C_temp = A | B;
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31];
            end

            `OP_XOR: begin
                C_temp = A ^ B;
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31];
            end

            `OP_NOR: begin
                C_temp = ~(A | B);
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31];
            end 

            `OP_SLL: begin  
                C_temp = B << shamt;
                flags_reg.CF = (shamt > 0) ? A[32 - shamt] : 1'b0;
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31];
                flags_reg.OF = (shamt == 1) ? (A[31] ^ C_temp[31]) : 1'b0;  //只在左移一位的时候检查
            end
            
            `OP_SRL: begin  
                C_temp = B >> shamt;
                flags_reg.CF = (shamt > 0) ? A[shamt - 1] : 1'b0;
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31]; 
                flags_reg.OF = 1'b0;  
            end
            
            `OP_SRA: begin  
                C_temp = $signed(B) >>> shamt;

                flags_reg.CF = (shamt > 0) ? A[shamt - 1] : 1'b0;
                flags_reg.ZF = (C_temp == 32'b0);
                flags_reg.SF = C_temp[31];
            end

            default: begin
                C_temp = '0;
            end
        endcase
    end
    
    assign C = C_temp;
    assign flags = flags_reg;

endmodule