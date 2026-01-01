# CPU-Verilog
XJTU  COMP461805 CPU（Verilog）

# 指令集：80-MIPS-86
本仓库共实现了<font color='red'>89</font>条指令，与标准的X86-64和MIPS指令集均相似但不相同，具体如下：
| 功能分类 | 助记符与功能 |
|:-----:|:-----:|
| 加载 | LW(加载字) |
| 保存 | SW(存储字) |
| R-R运算 | ADD(加) ADDU(无符号加) SUB(减) SUBU(无符号减) SLL(逻辑左移) SRL(逻辑右移) SRA(算术右移) AND(与) OR(或) XOR(异或) NOR(或非) SLT(有符号小于置1) SLTU(无符号小于置1) |
| R-I运算 | ADDI(加立即数) ADDIU(无符号加立即数) ANDI(与立即数) ORI(或立即数) XORI(异或立即数) LUI(加载立即数至高位) SLTI(小于立即数置1) SLTIU(无符号小于立即数-无符号数) |
| 分支 | BEQ(等于0则分支) BNE(不等于0则分支) BLEZ(小于等于0则分支) BGTZ(大于0则分支) BLTZ(小于0则分支) BGEZ(大于等于0则分支) |
| 跳转 | J(跳转) JAL(跳转并链接) JALR(跳转并链接寄存器) JR(跳转至寄存器) |
| 有条件跳转一 | JE(等于0则跳转) JNE(不等于0则跳转) JA(无符号大于0跳转) JNA(无符号不大于0跳转) JB(无符号小于0则跳转) JNB(无符号不小于0则跳转) JG(有符号大于0则跳转) JNG(有符号小于等于0则跳转) JL(有符号小于0则跳转) JNL(有符号不小于0则跳转) JS(符号位为1则跳转) JNS(符号位为0则跳转) JO(溢出则跳转) JNO(不溢出则跳转) |
| 有条件跳转二（不同种类详见有条件跳转一） | JALE JALNE JALA JALNA JALB JALNB JALG JALNG JALL JALNL JALS JALNS JALO JALNO |
| 有条件跳转三（不同种类详见有条件跳转一） | JALRE JALRNE JALRA JALRNA JALRB JALRNB JALRG JALRNG JALRL JALRNL JALRS JALRNS JALRO JALRNO |
| 有条件跳转四（不同种类详见有条件跳转一） | JRE JRNE JRA JRNA JRB JRNB JRG JRNG JRL JRNL JRS JRNS JRO JRNO |
