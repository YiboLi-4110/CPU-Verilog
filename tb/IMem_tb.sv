`timescale 1ns/1ps

module IMem_tb;

    reg  [31:0] addr;
    wire [31:0] instr;

    // 实例化 IMem
    IMem uut (
        .instruction_addr(addr),
        .instruction(instr)
    );

    initial begin
        $display("---- IMem Testbench Start ----");

        // 从地址 0 开始，每隔 4 字节读一条
        addr = 0;
        repeat (8) begin
            #10;
            $display("Time=%0t  addr=%h  instruction=%h", $time, addr, instr);
            addr = addr + 4;
        end

        $display("---- Test End ----");
        $finish;
    end

    initial begin
        $dumpfile("wave/IMem_tb.vcd");
        $dumpvars(0, IMem_tb);
    end

endmodule
