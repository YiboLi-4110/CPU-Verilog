`include "src/ALU.sv"
`include "src/ALUCU.sv"
`include "src/DA.sv"
`include "src/BJA.sv"
`include "src/DMem.sv"
`include "src/FLAGS.sv"
`include "src/IMem.sv"
`include "src/MCU1.sv"
`include "src/MCU2.sv"
`include "src/MCU3.sv"
`include "src/MCU4.sv"
`include "src/MUX_2.sv"
`include "src/PC.sv"
`include "src/RF.sv"
`include "src/SHL2.sv"
`include "src/SigExt16_32.sv"
`include "src/Temp_Reg.sv"
`include "src/Block0.sv"
`include "src/Block3.sv"

module PipelineCPU (

);
    wire [2:0] [4:0] layer_EX;
    wire [2:0] [4:0] layer_MA;
    wire [2:0] [4:0] layer_WB;

    wire [33:0] SHL2_0out;
    wire [31:0] mux_0out, mux_1out, mux_2out, mux_3out, mux_4out, mux_5out, mux_6out, mux_7out, mux_sout;
    wire [31:0] PC_out, add_1out, Imem_out, Imem_foward_out;
    wire [31:0] FI_ID_NPC1_out, FI_ID_IR_out, R_data1, R_data2, SigExt_out;
    wire [31:0] ID_EX_NPC1_out, ID_EX_Rs_out, ID_EX_Rt_out, ID_EX_Imm32_out, ID_EX_IR_out, add_2out, ALU_out, splice;
    wire [31:0] EX_MA_NPC1_out, EX_MA_NPC2_out, EX_MA_NPC3_out, EX_MA_ALUout_out, EX_MA_Rt_out, EX_MA_IR_out, DMem_out; 
    wire [31:0] MA_WB_ALUout_out, MA_WB_Memout_out, MA_WB_IR_out;

    wire [23:0] SHL2_1out;
    wire [7:0] FLAG, EX_MA_FLAG_out; 
    wire [4:0] mux_8out;
    wire [3:0] ALUCtrl, COND, ALUOp;

    wire [1:0] ALUSrc_A, ALUSrc_B;
    wire PCSrc, PCWr, Inst_bubble, RegWr, AnstoRt, MemSrc, Jump, Branch, jumpmux, branchmux, MemRd, MemWr, MemtoReg, RegDst;
    wire jb, JBPCSrc;
    wire SigHigh, shamt;
    wire CLK_1, FI_ID_CLK, ID_EX_CLK, EX_MA_CLK, MA_WB_CLK;

    reg CLK, rst_n;
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


    assign splice = {ID_EX_NPC1_out[31:24], SHL2_1out};
    assign jb = (jumpmux || branchmux);
    assign PCSrc = (jb && JBPCSrc);
    assign PCWr = 1'b1;

    BLOCK0 block0(
        .CLK(CLK),
        .CLK_1(CLK_1)
    );

    BLOCK3 block3(
        .CLK(CLK),
        .block(jb),
        .CLK_1(EX_MA_CLK),
        .JBPCSrc(JBPCSrc)
    );

    assign FI_ID_CLK = CLK_1;
    assign ID_EX_CLK = CLK_1;
    assign MA_WB_CLK = CLK_1;


    PC pc(
        .CLK(CLK_1),
        .rst_n(rst_n),
        .PCWr(PCWr && (!Inst_bubble)),
        .pc_in_addr(mux_0out),
        .pc_out_addr(PC_out)
    );

    IMem imem(
        .instruction_addr(PC_out),
        .instruction(Imem_out),
        .instruction_foward(Imem_foward_out)
    );

    ALU add1(
        .A(32'd4),
        .B(PC_out),
        .Mod(4'b0001),
        .C(add_1out)
    );

    ALU add2(
        .A(ID_EX_NPC1_out),
        .B(SHL2_0out[31:0]),
        .Mod(4'b0001),
        .C(add_2out)
    );

    ALU alu(
        .A(mux_sout),
        .B(mux_3out),
        .Mod(ALUCtrl),
        .flags(FLAG),
        .C(ALU_out)
    );

    RegFile rf(
        .clk(CLK),
        .we(RegWr),
        .waddr(mux_8out),
        .wdata(mux_7out),
        .raddr1(FI_ID_IR_out[25:21]),
        .raddr2(FI_ID_IR_out[20:16]),
        .rdata1(R_data1),
        .rdata2(R_data2)
    );

    SigExt16_32 sigext(
        .high_ext(SigHigh),
        .input_data(FI_ID_IR_out[15:0]),
        .output_data(SigExt_out)
    );

    SHL2 #(.DATA_WIDTH(32)) shl2_0(
        .input_data(ID_EX_Imm32_out),
        .output_data(SHL2_0out)
    );

    SHL2 #(.DATA_WIDTH(22)) shl2_1(
        .input_data(ID_EX_IR_out[21:0]),
        .output_data(SHL2_1out)
    );

    ALUCU alucu(
        .funct(ID_EX_IR_out[5:0]),
        .ALUOp(ALUOp),
        .ALUCTRL(ALUCtrl),
        .shift(shamt)
    );

    BJA bja(
        .inst(EX_MA_IR_out),
        .branch(Branch),
        .jump(Jump),
        .cond(COND)
    );

    FLAGS flags(
        .CLK(CLK_1 && (!jb)),
        .jump(Jump),
        .branch(Branch),
        .rst_n(rst_n),
        .flags(EX_MA_FLAG_out),
        .cond(COND),
        .jumpmux(jumpmux),
        .branchmux(branchmux)
    );

    DMem dmem(
        .CLK(CLK_1),
        .we(MemWr),
        .re(MemRd),
        .data_addr(EX_MA_ALUout_out),
        .data_write(mux_5out),
        .data_read(DMem_out)
    );

    DA da(
        .Inst(mux_1out),
        .Inst_foward(Imem_foward_out),
        .CLK(CLK_1),
        .rst_n(rst_n),
        .layer_EX(layer_EX),
        .layer_MA(layer_MA),
        .layer_WB(layer_WB),
        .bubble(Inst_bubble)
    );

    MUX_2 mux_0(
        .input0(add_1out),
        .input1(mux_6out),
        .select(PCSrc),
        .out_data(mux_0out)
    );

    MUX_2 mux_1(
        .input0(Imem_out),
        .input1(32'd0),
        .select(Inst_bubble),
        .out_data(mux_1out)
    );

    MUX_3 mux_2(
        .input0(ID_EX_Rs_out),
        .input1(EX_MA_ALUout_out),
        .input2(mux_7out),
        .select(ALUSrc_A),
        .out_data(mux_2out)
    );

    MUX_2 mux_shift(
        .input0(mux_2out),
        .input1({27'b0, ID_EX_IR_out[10:6]}),
        .select(shamt),
        .out_data(mux_sout)
    );

    MUX_4 mux_3(
        .input0(ID_EX_Rt_out),
        .input1(EX_MA_ALUout_out),
        .input2(mux_7out),
        .input3(ID_EX_Imm32_out),
        .select(ALUSrc_B),
        .out_data(mux_3out)
    );

    MUX_2 mux_4(
        .input0(ID_EX_Rt_out),
        .input1(mux_7out),
        .select(AnstoRt),
        .out_data(mux_4out)
    );

    MUX_2 mux_5(
        .input0(EX_MA_Rt_out),
        .input1(mux_7out),
        .select(MemSrc),
        .out_data(mux_5out)
    );

    MUX_3 mux_6(
        .input0(EX_MA_NPC1_out),
        .input1(EX_MA_NPC2_out),
        .input2(EX_MA_NPC3_out),
        .select({branchmux, jumpmux}),
        .out_data(mux_6out)
    );

    MUX_2 mux_7(
        .input0(MA_WB_ALUout_out),
        .input1(MA_WB_Memout_out),
        .select(MemtoReg),
        .out_data(mux_7out)
    );

    MUX_2 #(.DATA_WIDTH(5)) mux_8(
        .input0(MA_WB_IR_out[20:16]),
        .input1(MA_WB_IR_out[15:11]),
        .select(RegDst),
        .out_data(mux_8out)
    );

    //FI-ID级间
    Temp_Reg FI_ID_NPC1(
        .clk(FI_ID_CLK),
        .input_data(add_1out),
        .output_data(FI_ID_NPC1_out)
    );

    Temp_Reg FI_ID_IR(
        .clk(FI_ID_CLK),
        .input_data(mux_1out),
        .output_data(FI_ID_IR_out)
    );

    //ID-EX级间
    Temp_Reg ID_EX_NPC1(
        .clk(ID_EX_CLK),
        .input_data(FI_ID_NPC1_out),
        .output_data(ID_EX_NPC1_out)
    );

    Temp_Reg ID_EX_Rs(
        .clk(ID_EX_CLK),
        .input_data(R_data1),
        .output_data(ID_EX_Rs_out)
    );

    Temp_Reg ID_EX_Rt(
        .clk(ID_EX_CLK),
        .input_data(R_data2),
        .output_data(ID_EX_Rt_out)
    );

    Temp_Reg ID_EX_Imm32(
        .clk(ID_EX_CLK),
        .input_data(SigExt_out),
        .output_data(ID_EX_Imm32_out)
    );

    Temp_Reg ID_EX_IR(
        .clk(ID_EX_CLK),
        .input_data(FI_ID_IR_out),
        .output_data(ID_EX_IR_out)
    );

    //EX-MA级间
    Temp_Reg EX_MA_NPC1(
        .clk(EX_MA_CLK),
        .input_data(ID_EX_NPC1_out),
        .output_data(EX_MA_NPC1_out)
    );

    Temp_Reg EX_MA_NPC2(
        .clk(EX_MA_CLK),
        .input_data(splice),
        .output_data(EX_MA_NPC2_out)
    );

    Temp_Reg EX_MA_NPC3(
        .clk(EX_MA_CLK),
        .input_data(add_2out),
        .output_data(EX_MA_NPC3_out)
    );

    Temp_Reg #(.DATA_WIDTH(8)) EX_MA_FLAG(
        .clk(EX_MA_CLK),
        .input_data(FLAG),
        .output_data(EX_MA_FLAG_out)
    );

    Temp_Reg EX_MA_ALUout(
        .clk(EX_MA_CLK),
        .input_data(ALU_out),
        .output_data(EX_MA_ALUout_out)
    );

    Temp_Reg EX_MA_Rt(
        .clk(EX_MA_CLK),
        .input_data(mux_4out),
        .output_data(EX_MA_Rt_out)
    );

    Temp_Reg EX_MA_IR(
        .clk(EX_MA_CLK),
        .input_data(ID_EX_IR_out),
        .output_data(EX_MA_IR_out)
    );

    //MA-WB级间
    Temp_Reg MA_WB_ALUout(
        .clk(MA_WB_CLK),
        .input_data(EX_MA_ALUout_out),
        .output_data(MA_WB_ALUout_out)
    );

    Temp_Reg MA_WB_Memout(
        .clk(MA_WB_CLK),
        .input_data(DMem_out),
        .output_data(MA_WB_Memout_out)
    );

    Temp_Reg MA_WB_IR(
        .clk(MA_WB_CLK),
        .input_data(EX_MA_IR_out),
        .output_data(MA_WB_IR_out)
    );


    //MCU组------------------
    MCU1 mcu1(
        .op_code(FI_ID_IR_out[31:26]),
        .SigHigh(SigHigh)
    );

    MCU2 mcu2(
        .op_code(ID_EX_IR_out[31:26]),
        .layer_WB(layer_WB),
        .layer_MA(layer_MA),
        .layer_EX(layer_EX),
        .ALUSrcA(ALUSrc_A),
        .ALUSrcB(ALUSrc_B),
        .ALUOp(ALUOp),
        .AnstoRt(AnstoRt)
    );

    MCU3 mcu3(
        .op_code(EX_MA_IR_out[31:26]),
        .layer_WB(layer_WB),
        .layer_MA(layer_MA),
        .layer_EX(layer_EX),
        .Branch(Branch),
        .Jump(Jump),
        .MemRd(MemRd),
        .MemWr(MemWr),
        .MemSrc(MemSrc)
    );

    MCU4 mcu4(
        .op_code(MA_WB_IR_out[31:26]),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWr(RegWr)
    );


endmodule