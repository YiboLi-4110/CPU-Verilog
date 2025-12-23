/*
    实现MIPS中的数据存储器
*/

module DMem(
    input CLK,
    input wire we,   // 写使能信号
    input wire re,   // 读使能信号
    input wire [31:0] data_addr,  // 数据地址
    input wire [31:0] data_write, // 写入的数据
    output reg [31:0] data_read  // 读出的数据
);
    parameter word_num = 1048576;
    parameter width = 20;

    // 初始化数据存储器
    reg [31:0] data_mem [0:word_num-1];
    integer i;
    initial begin
        // 从hex文件中读取数据到存储器
        $readmemh("hexcode/data.hex", data_mem);

        // 为初始化的数据设置为0
        for (i=0; i<word_num; i=i+1) begin
            if (data_mem[i] === 32'hxxxxxxxx) begin
                data_mem[i] = 32'h00000000;
            end
        end
    end

    // 写操作
    wire [width-1:0] word_addr = data_addr[width+1:2];  // 字节地址转换为字地址
    always @(posedge CLK) begin
        if (we && (word_addr < word_num)) begin
            data_mem[word_addr] = data_write;
        end
    end

    // 读操作
    always @(*) begin
        if (re && (word_addr < word_num)) begin
            data_read = data_mem[word_addr];
        end
        else begin
            data_read = 32'hz;  // 表示高阻态
        end
    end

endmodule