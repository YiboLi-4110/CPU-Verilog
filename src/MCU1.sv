`include "includes/OP_code.svh"
`include "includes/ALUOP_Mod.svh"

module MCU1(
    input wire [5:0] op_code,
    output wire SigHigh
);

    reg SigHigh_reg;

    always @(*) begin
        SigHigh_reg = 1'b0;

        case (op_code)
            `OP_CODE_LUI:
                SigHigh_reg = 1'b1;
            default:
                SigHigh_reg = 1'b0;
        endcase
    end

    assign SigHigh = SigHigh_reg;

endmodule