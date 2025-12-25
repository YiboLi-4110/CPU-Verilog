/*
    实现16到32位的位扩展
*/

module SigExt16_32 (
    input wire [15:0] input_data,
    input wire high_ext,
    output wire [31:0] output_data
);
    // 高16位扩展，扩展出的位全部为0
    reg [31:0] out;

    always_comb begin
        if(high_ext)
            out = {input_data, 16'b0};
        else
            out = {{16{input_data[15]}}, input_data};
    end

    assign output_data = out;
endmodule