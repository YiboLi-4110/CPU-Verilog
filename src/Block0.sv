module BLOCK0 (
    input  reg CLK,
    output reg CLK_1
);

    always_ff @(posedge CLK) begin
        CLK_1 <= CLK;
    end

    always_ff @(negedge CLK) begin
        CLK_1 <= 1'b0;
    end

endmodule