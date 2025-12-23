`ifndef ALU_OP_DEFS
`define ALU_OP_DEFS

`define ALUCTRL_WIRENUM  4
`define OP_NOP      4'b0000     //空操作
`define OP_ADD      4'b0001     //加法
`define OP_ADDU     4'b0010     //无符号加法
`define OP_SUB      4'b0011     //减法
`define OP_SUBU     4'b0100     //无符号减法
`define OP_SLT      4'b0101     //rd =  rs < rt ? 1:0
`define OP_SLTU     4'b0110     //无符号，rd =  rs < rt ? 1:0
`define OP_AND      4'b0111     //按位与
`define OP_OR       4'b1000     //按位或
`define OP_XOR      4'b1001     //按位异或
`define OP_NOR      4'b1010     //按位或非
`define OP_SLL      4'b1101     //逻辑左移
`define OP_SRL      4'b1110     //逻辑右移
`define OP_SRA      4'b1111     //算数右移

`endif
