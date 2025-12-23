`include "includes/Flags.svh"
`include "includes/Cond_Mod.svh"

module FLAGS (
    input wire jump,
    input wire branch,
    input wire CLK,
    input wire rst_n,
    input FLAGS_t flags,
    input wire [`COND_WIRENUM-1:0] cond,
    output wire jumpmux,
    output wire branchmux
);
    FLAGS_t flags_old;
    FLAGS_t flags_temp;
    reg cond_stf;
    
    wire [1:0] jb;
    assign jb = {jump, branch};

    always_ff @(posedge CLK or negedge rst_n) begin
        if(~rst_n)
            flags_old <= '0;
        else
            flags_old <= flags;
    end

    always_comb begin
        case (jb)
            2'b10:
                flags_temp = flags_old;
            2'b01:
                flags_temp = flags;
            default: 
                flags_temp = '0;
        endcase 

        case (cond)
            `COND_E: 
                cond_stf = flags_temp.ZF;
            `COND_NE: 
                cond_stf = ~flags_temp.ZF;
            `COND_A: 
                cond_stf = (~flags_temp.CF) && (~flags_temp.ZF);
            `COND_B: 
                cond_stf = flags_temp.CF;
            `COND_AE: 
                cond_stf = ~flags_temp.CF;
            `COND_BE: 
                cond_stf = flags_temp.CF || flags_temp.ZF;
            `COND_G: 
                cond_stf = (flags_temp.SF == flags_temp.OF && (~flags_temp.ZF));
            `COND_L: 
                cond_stf = (flags_temp.SF != flags_temp.OF);
            `COND_GE: 
                cond_stf = (flags_temp.SF == flags_temp.OF);
            `COND_LE: 
                cond_stf = (flags_temp.SF != flags_temp.OF || flags_temp.ZF);
            `COND_S: 
                cond_stf = flags_temp.SF;
            `COND_NS: 
                cond_stf = ~flags_temp.SF;
            `COND_O: 
                cond_stf = flags_temp.OF;
            `COND_NO: 
                cond_stf = ~flags_temp.OF;
            default: 
                cond_stf = 1'b0;
        endcase
    end

    assign jumpmux = jump && cond_stf;
    assign branchmux = branch && cond_stf;

endmodule