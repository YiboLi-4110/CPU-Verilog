`include "src/ALU.sv"
`include "src/ALUCU.sv"
`include "src/BJA.sv"
`include "src/DMem.sv"
`include "src/FLAGS.sv"
`include "src/IMem.sv"
`include "src/MCU.sv"
`include "src/MUX_2.sv"
`include "src/PC.sv"
`include "src/RF.sv"
`include "src/SHL2.sv"
`include "src/SigExt16_32.sv"

module SingleCycleCPU (

);
    wire [33:0] SHL2_1out;
    wire [31:0] Inst, PCout, mux_1out, mux_2out, mux_3out, mux_4out, mux_5out, mux_6out, mux_7out, add_1out, add_2out, ALU_out, splice, SigExtout, R_data1, R_data2, Mem_data;
    wire [23:0] SHL2_0out;
    wire [7:0]  FLAG;
    wire [4:0]  mux_0out;
    wire [3:0]  ALUCtrl, COND;
    wire [3:0]  ALUOp;
    wire [1:0]  RegDst;
    wire RegWr, Jump, Branch, ALUSrc, MemWr, MemRd, MemtoReg, shamt, branchmux, jumpmux;
    wire RegPCWr, RegtoPC, RegPCWr_alu;
    wire sigext_high;

    reg CLK;
    reg rst_n;
    parameter CLK_T = 40;

    initial begin
        CLK = 0;

        #30
        rst_n = 0;
        #30;
        rst_n = 1;

        repeat (100) begin
            #(CLK_T/2) CLK = 0;
            #(CLK_T/2) CLK = 1;
        end        
    end


    assign splice = {add_1out[31:24], SHL2_0out};

    PC pc(
        .CLK(CLK),
        .rst_n(rst_n),
        .pc_in_addr(mux_3out),
        .pc_out_addr(PCout)
    );

    IMem imem(
        .instruction_addr(PCout),
        .instruction(Inst)
    );

    DMem dmem(
        .CLK(CLK),
        .we(MemWr),
        .re(MemRd),
        .data_addr(ALU_out),
        .data_write(R_data2),
        .data_read(Mem_data)
    );

    RegFile rf(
        .clk(CLK),
        .we(RegWr),
        .waddr(mux_0out),
        .wdata(mux_1out),
        .raddr1(Inst[25:21]),
        .raddr2(Inst[20:16]),
        .rdata1(R_data1),
        .rdata2(R_data2)
    );

    ALU add1(
        .A(32'd4),
        .B(PCout),
        .Mod(4'b0001),
        .C(add_1out)
    );

    ALU add2(
        .A(add_1out),
        .B(SHL2_1out[31:0]),
        .Mod(4'b0001),
        .C(add_2out)
    );

    ALU alu(
        .A(mux_2out), //rdata1
        .B(mux_4out),
        .Mod(ALUCtrl),
        .flags(FLAG),
        .C(ALU_out)
    );

    MUX_3 #(.DATA_WIDTH(5)) mux_0(
        .input0(Inst[20:16]),
        .input1(Inst[15:11]),
        .input2(5'b11111),
        .select(RegDst),
        .out_data(mux_0out)
    );

    MUX_2 mux_1(
        .input0(mux_7out),
        .input1(add_1out),
        .select(RegPCWr | RegPCWr_alu),
        .out_data(mux_1out)
    );

    MUX_2 mux_2(
        .input0(R_data1),   //rdata2
        .input1({27'b0, Inst[10:6]}),
        .select(shamt),
        .out_data(mux_2out)
    );

    MUX_2 mux_3(
        .input0(mux_6out),
        .input1(R_data1),
        .select(RegtoPC),
        .out_data(mux_3out)
    );

    MUX_2 mux_4(
        .input0(R_data2), //mux_2out
        .input1(SigExtout),
        .select(ALUSrc),
        .out_data(mux_4out)
    );

    MUX_2 mux_5(
        .input0(add_1out),
        .input1(add_2out),
        .select(branchmux),
        .out_data(mux_5out)
    );

    MUX_2 mux_6(
        .input0(mux_5out),
        .input1(splice),
        .select(jumpmux),
        .out_data(mux_6out)
    );

    MUX_2 mux_7(
        .input0(ALU_out),
        .input1(Mem_data),
        .select(MemtoReg),
        .out_data(mux_7out)
    );

    SigExt16_32 sigext(
        .high_ext(sigext_high),
        .input_data(Inst[15:0]),
        .output_data(SigExtout)
    );

    SHL2 #(.DATA_WIDTH(22)) shl2_0(
        .input_data(Inst[21:0]),
        .output_data(SHL2_0out)
    );

    SHL2 #(.DATA_WIDTH(32)) shl2_1(
        .input_data(SigExtout),
        .output_data(SHL2_1out)
    );

    ALUCU alucu(
        .funct(Inst[5:0]),
        .ALUOp(ALUOp),
        .ALUCTRL(ALUCtrl),
        .shift(shamt),
        .RegtoPC(RegtoPC),
        .RegPCWr(RegPCWr_alu)
    );

    BJA bja(
        .inst(Inst),
        .branch(Branch),
        .jump(Jump),
        .cond(COND)
    );

    FLAGS flags(
        .CLK(CLK),
        .jump(Jump),
        .branch(Branch),
        .rst_n(rst_n),
        .flags(FLAG),
        .cond(COND),
        .jumpmux(jumpmux),
        .branchmux(branchmux)
    );

    MCU mcu(
        .op_code(Inst[31:26]),
        .Branch(Branch),
        .Jump(Jump),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWr(MemWr),
        .MemRd(MemRd),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .RegWr(RegWr),
        .sigext_high(sigext_high),
        .RegPCWr(RegPCWr)
    );

endmodule


