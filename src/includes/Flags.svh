`ifndef FLAGS_DEFS
`define FLAGS_DEFS

`define FLAGS_WIDTH 8


typedef struct packed {
    logic CF;       //0
    logic OF;       //1 
    logic ZF;       //2 
    logic SF;       //3
    logic [3:0] unused;//4-7
} FLAGS_t;

typedef union packed {
    FLAGS_t fields;
    logic [`FLAGS_WIDTH-1:0] raw;
} FLAGS_u;

`endif