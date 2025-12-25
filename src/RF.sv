/*
    实现寄存器组中的32个32位寄存器
*/

module RegFile(
    input wire clk, // 时钟信号

    // 写端口
    input wire we, // 写使能信号
    input wire [4:0] waddr, // 写寄存器地址
    input wire [31:0] wdata, // 写数据

    // 读端口1
    input wire [4:0] raddr1, // 读寄存器地址1
    output wire [31:0] rdata1, // 读数据1

    // 读端口2
    input wire [4:0] raddr2, // 读寄存器地址2
    output wire [31:0] rdata2 // 读数据2
);

    // 32个32位寄存
    reg [31:0] register_file [0:31];

    // 初始化所有寄存器为0
    integer i;
    initial begin
        for (i=0; i<32; i=i+1) begin
            register_file[i] = 32'b0;
        end
    end

    // 写数据
    always @(posedge clk) begin
        if (we && waddr != 0) begin  // $0寄存器保护
            register_file[waddr] <= wdata;
        end
    end

    // 读数据1
    assign rdata1 = (raddr1 != 0) ? register_file[raddr1]:0;

    // 读数据2
    assign rdata2 = (raddr2 != 0) ? register_file[raddr2]:0;

endmodule