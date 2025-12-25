`ifndef COND_DEFS
`define COND_DEFS

`define COND_WIRENUM 4

`define COND_NOP    4'b0000
`define COND_E      4'b0001
`define COND_NE     4'b0010
`define COND_A      4'b0011
`define COND_B      4'b0100

`define COND_AE     4'b0101
`define COND_NB     4'b0101

`define COND_BE     4'b0110
`define COND_NA     4'b0110

`define COND_G      4'b0111
`define COND_L      4'b1000

`define COND_GE     4'b1001
`define COND_NL     4'b1001

`define COND_LE     4'b1010
`define COND_NG     4'b1010

`define COND_S      4'b1011
`define COND_NS     4'b1100
`define COND_O      4'b1101
`define COND_NO     4'b1110


`endif