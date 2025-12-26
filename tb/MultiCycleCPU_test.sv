`include "src/ALU.sv"
`include "src/ALUCU.sv"
`include "src/BJA.sv"
`include "src/Memory.sv"
`include "src/FLAGS.sv"
`include "src/MCU.sv"
`include "src/MUX_2.sv"
`include "src/MUX_3.sv"
`include "src/MUX_4.sv"
`include "src/PC.sv"
`include "src/RF.sv"
`include "src/SHL2.sv"
`include "src/SigExt16_32.sv"

module MultiCycleCPU (

);
    wire [31:0] IR_out, PC_out, mux_0out, mux_1out, mux_3out, mux_4out, mux_5out, mux_6out, mux_7out, mux_8out;
    wire [31:0] Mem_R_data, Mem_W_data, MDR_out, SHL2_1out, R_data1, R_data2, A_out, B_out, ALU_out, ALUOut_out, splice;
    wire [31:0] PC4_out;

    wire [31:0] SigExt_out;
    wire [23:0] SHL2_2out;
    wire [7:0] FLAG;
    wire [4:0] mux_2out;
    wire [3:0] ALUCtrl, ALUOp, COND;

    wire [1:0] RegDst, PCSrc, ALUSrcB;

    wire IorD, IRWr, PCWr, Jump, Branch, RegWr, ALUSrcA, MemWr, MemRd, MemtoReg, SigHigh, RegAtoPC, shamt, RegPCWr, PCtoReg, FLAGSWr;
    wire JALR_JR, JALR, JBPCWr; 


    reg CLK;
    reg rst_n;
    parameter CLK_T = 10;

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

    assign splice = {PC_out[31:24], SHL2_2out};
    assign RegAtoPC = JALR_JR;
    assign PCtoReg = RegPCWr || JALR;

    PC pc(
        .CLK(CLK),
        .rst_n(rst_n),
        .PCWr(PCWr || JBPCWr),
        .pc_in_addr(mux_4out),
        .pc_out_addr(PC_out)
    );

    IR ir(
        .clk(CLK),
        .IRWr(IRWr),
        .input_inst(Mem_R_data),
        .output_inst(IR_out)
    );

    RegFile rf(
        .clk(CLK),
        .we(RegWr),
        .waddr(mux_2out),
        .wdata(mux_3out),
        .raddr1(IR_out[25:21]),
        .rdata1(R_data1),
        .raddr2(IR_out[20:16]),
        .rdata2(R_data2)
    );

    ALU alu(
        .A(mux_7out),
        .B(mux_6out),
        .C(ALU_out),
        .Mod(ALUCtrl),
        .flags(FLAG)
    );

    ALUCU alucu(
        .funct(IR_out[5:0]),
        .ALUOp(ALUOp),
        .ALUCTRL(ALUCtrl),
        .shift(shamt),
        .JALR_JR(JALR_JR),
        .JALR(JALR)
    );

    MUX_2 mux_0(
        .input0(PC_out),
        .input1(ALUOut_out),
        .select(IorD),
        .out_data(mux_0out)
    );

    MUX_2 mux_1(
        .input0(ALUOut_out),
        .input1(MDR_out),
        .select(MemtoReg),
        .out_data(mux_1out)
    );

    MUX_3 #(.DATA_WIDTH(5))mux_2(
        .input0(IR_out[20:16]),
        .input1(IR_out[15:11]),
        .input2(5'b11111),
        .select(RegDst),
        .out_data(mux_2out)
    );

    MUX_2 mux_3(
        .input0(mux_1out),
        .input1(PC4_out),
        .select(PCtoReg),
        .out_data(mux_3out)
    );

    MUX_2 mux_4(
        .input0(mux_8out),
        .input1(A_out),
        .select(RegAtoPC),
        .out_data(mux_4out)
    );

    MUX_2 mux_5(
        .input0(PC_out),
        .input1(A_out),
        .select(ALUSrcA),
        .out_data(mux_5out)
    );

    MUX_4 mux_6(
        .input0(B_out),
        .input1(32'd4),
        .input2(SigExt_out),
        .input3(SHL2_1out),
        .select(ALUSrcB),
        .out_data(mux_6out)
    );

    MUX_2 mux_7(
        .input0(mux_5out),
        .input1({27'b0, IR_out[10:6]}),
        .select(shamt),
        .out_data(mux_7out)
    );

    MUX_3 mux_8(
        .input0(ALU_out),
        .input1(ALUOut_out),
        .input2(splice),
        .select(PCSrc),
        .out_data(mux_8out)
    );

    Memory mem(
        .clk(CLK),
        .re(MemRd),
        .we(MemWr),
        .data_addr(mux_0out),
        .data_write(B_out),
        .data_read(Mem_R_data)
    );

    Temp_Reg MDR(
        .clk(CLK),
        .input_data(Mem_R_data),
        .output_data(MDR_out)
    );

    Temp_Reg pc4(
        .clk(CLK),
        .input_data(PC_out),
        .output_data(PC4_out)
    );

    Temp_Reg A(
        .clk(CLK),
        .input_data(R_data1),
        .output_data(A_out)
    );

    Temp_Reg B(
        .clk(CLK),
        .input_data(R_data2),
        .output_data(B_out)
    );

    Temp_Reg ALUOut(
        .clk(CLK),
        .input_data(ALU_out),
        .output_data(ALUOut_out)
    );

    SigExt16_32 sigext(
        .input_data(IR_out[15:0]),
        .high_ext(SigHigh),
        .output_data(SigExt_out)
    );

    SHL2 #(.DATA_WIDTH(32))shl2_1(
        .input_data(SigExt_out),
        .output_data(SHL2_1out)
    );

    SHL2 #(.DATA_WIDTH(22))shl2_2(
        .input_data(IR_out[21:0]),
        .output_data(SHL2_2out)
    );

    BJA bja(
        .jump(Jump || JALR_JR),
        .branch(Branch),
        .inst(IR_out),
        .cond(COND)
    );

    FLAGS flags(
        .jump(Jump || JALR_JR),
        .branch(Branch),
        .CLK(CLK),
        .FLAGSWr(FLAGSWr),
        .rst_n(rst_n),
        .flags(FLAG),
        .cond(COND),
        .PCWr(JBPCWr)
    );

    MCU mcu(
        .clk(CLK),
        .op_code(IR_out[31:26]),
        .PCWr(PCWr),
        .IorD(IorD),
        .MemRd(MemRd),
        .MemWr(MemWr),
        .IRWr(IRWr),
        .MemtoReg(MemtoReg),
        .PCSrc(PCSrc),
        .ALUOp(ALUOp),
        .ALUSrcB(ALUSrcB),
        .ALUSrcA(ALUSrcA),
        .RegWr(RegWr),
        .RegDst(RegDst),
        .FLAGSWr(FLAGSWr),
        .Branch(Branch),
        .Jump(Jump),
        .SigHigh(SigHigh),
        .RegPCWr(RegPCWr)
    );

endmodule