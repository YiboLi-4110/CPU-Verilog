module MUX_3#(parameter DATA_WIDTH = 32) (
    input wire [DATA_WIDTH-1:0] input0, // 输入数据1
    input wire [DATA_WIDTH-1:0] input1, // 输入数据2
    input wire [DATA_WIDTH-1:0] input2, // 输入数据3
    input wire [1:0] select, // 选择信号
    output wire [DATA_WIDTH-1:0] out_data// 输出数据
);
    // 根据选择信号选择输入数据
    reg [DATA_WIDTH-1:0] out_data_reg;
    always_comb begin
        case (select)
            2'b00:
                out_data_reg = input0;
            2'b01:
                out_data_reg = input1;
            default:
                out_data_reg = input2; 
        endcase
    end

    assign out_data = out_data_reg;

endmodule