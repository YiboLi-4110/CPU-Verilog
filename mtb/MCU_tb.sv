`timescale 1ns/1ps
`include "includes/OP_code.svh"  // 保持你的原始 include

module MCU_tb;

    reg [5:0] op_code;
    wire Branch, Jump, MemtoReg, MemWr, MemRd, ALUSrc, RegDst, RegWr;
    wire [1:0] ALUOp;

    // 实例化 DUT
    MCU dut (
        .op_code(op_code),
        .Branch(Branch),
        .Jump(Jump),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWr(MemWr),
        .MemRd(MemRd),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .RegWr(RegWr)
    );

    initial begin
        $display("op_code    | RegDst ALUSrc MemtoReg RegWr MemRd MemWr Branch ALUOp Jump");
        $display("-----------|----------------------------------------------------");

        // 测试主要指令
        op_code = `OP_CODE_RR;    #10; display();
        op_code = `OP_CODE_LW;    #10; display();
        op_code = `OP_CODE_SW;    #10; display();
        op_code = `OP_CODE_BEQ;   #10; display();
        op_code = `OP_CODE_BNE;   #10; display();
        op_code = `OP_CODE_J;     #10; display();
        op_code = `OP_CODE_ADDI;  #10; display();
        op_code = `OP_CODE_ORI;   #10; display();
        op_code = 6'b000001;      #10; display();  // REGIMM (BLTZ/BGEZ)
        op_code = 6'b111111;      #10; display();  // 未知指令，应为默认全0

        #20 $finish;
    end

    task display;
        begin
            $display("%b |   %b     %b      %b     %b     %b     %b      %b    %b    %b",
                     op_code, RegDst, ALUSrc, MemtoReg, RegWr, MemRd, MemWr, Branch, ALUOp, Jump);
        end
    endtask

    // 生成 VCD 波形
    initial begin
        $dumpfile("MCU_tb.vcd");
        $dumpvars(0, MCU_tb);
    end

endmodule