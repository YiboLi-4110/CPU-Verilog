/*
    实现16到32位的位扩展
*/

module SigExt16_32 (
    input wire [15:0] input_data,
    output wire [31:0] output_data
);
    // 高16位扩展，扩展出的位全部为0
    assign output_data = {{16{input_data[15]}}, input_data};
endmodule