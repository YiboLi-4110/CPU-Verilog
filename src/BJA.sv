`include "includes/Cond_Mod.svh"

module BJA (
    input wire jump,
    input wire branch,
    input wire [31:0] inst,
    output wire [`COND_WIRENUM-1:0] cond
);

    reg [`COND_WIRENUM-1:0] cond_reg;

    wire [1:0] jb;
    assign jb = {jump, branch};

    wire [5:0] opcode;
    assign opcode = inst[31:26];

    wire [4:0] bspe;
    assign bspe = inst[20:16];

    wire [4:0] jcode;
    assign jcode = inst[25:22];

    always_comb begin
        case (jb)
            2'b01:
                begin
                    case (opcode)
                        6'b000001:
                            case (bspe)
                                5'b00000:
                                    cond_reg = `COND_L;
                                5'b00001:
                                    cond_reg = `COND_G;
                                default: 
                                    cond_reg = `COND_NOP;
                            endcase
                        6'b000100:
                            cond_reg = `COND_E;
                        6'b000101:
                            cond_reg = `COND_NE;
                        6'b000110:
                            if(bspe == 5'b00000)
                                cond_reg = `COND_LE;
                            else
                                cond_reg = `COND_NOP;
                        6'b000111:
                            if(bspe == 5'b00000)
                                cond_reg = `COND_GE;
                            else
                                cond_reg = `COND_NOP;
                        default: 
                            cond_reg = `COND_NOP;
                    endcase
                end
            2'b10:
                begin
                    if(jcode != 4'b1111)
                        cond_reg = jcode;
                    else
                        cond_reg = 4'b0000;
                end
            default:
                cond_reg = 4'b0000; 
        endcase
    end

    assign cond = cond_reg;

endmodule