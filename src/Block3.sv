module BLOCK3 (
    input  reg CLK,
    input  wire block,
    output wire JBPCSrc,
    output reg CLK_1
);

    reg [2:0] counter = 3'b000; 
    reg JBPCSrc_reg = 1'b0;
    
    always_ff @(posedge CLK) begin
        if (counter == 3'b000) 
        begin
            // 不在保持状态
            
            if (block == 1'b1) 
            begin
                CLK_1 <= 1'b0;
                JBPCSrc_reg <= 1'b1; 
                counter <= 3'b001;  
            end 
            else 
            begin
                JBPCSrc_reg <= 1'b0; 
                CLK_1 <= CLK;
            end
        end 
        else 
        begin
            if (counter == 3'b100) 
            begin
                CLK_1 <= CLK;  
                counter <= 3'b000;  
            end 
            else if (counter == 3'b010)
            begin
                CLK_1 <= 1'b0;  
                JBPCSrc_reg <= 1'b0;
                counter <= counter + 1'b1; 
            end
            else 
            begin
                CLK_1 <= 1'b0;  
                counter <= counter + 1'b1;
            end
        end
    end

    always_ff @(negedge CLK) begin
        CLK_1 <= 1'b0;
    end

    assign JBPCSrc = JBPCSrc_reg;

endmodule