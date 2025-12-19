/*
    实现MIPS中的数据存储器
*/

module DMem(
    input wire we,   // 写使能信号
    input wire re,   // 读使能信号
    input wire [31:0] data_addr,  // 数据地址
    input wire [31:0] data_write, // 写入的数据
    output reg [31:0] data_read  // 读出的数据
);

    // 初始化数据存储器
    reg [31:0] data_mem [0:1023];
    integer i;
    initial begin
        for (i=0; i<1024; i=i+1) begin
            data_mem[i] = 32'h00000000;
        end
    end

    // 写操作
    wire [9:0] word_addr = data_addr[11:2];  // 字节地址转换为字地址
    always @(*) begin
        if (we && (word_addr < 1024)) begin
            data_mem[word_addr] <= data_write;
        end
    end

    // 读操作
    always @(*) begin
        if (re && (word_addr < 1024)) begin
            data_read = data_mem[word_addr];
        end
        else begin
            data_read = 32'hz;  // 表示高阻态
        end
    end

endmodule
