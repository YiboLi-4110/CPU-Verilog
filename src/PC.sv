module PC (
    input wire CLK,
    input wire rst_n,
    input wire PCWr,
    input wire [31:0] pc_in_addr,
    output reg [31:0] pc_out_addr
);
    always_ff @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            pc_out_addr <= 32'h00400000;  // 异步复位
        end 
        else if(PCWr)
        begin
            pc_out_addr <= pc_in_addr;     // 正常更新
        end
    end
endmodule