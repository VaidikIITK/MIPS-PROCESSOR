`include "defs.vh"
 
module Processor(
input clk,
output halt,
input reset,
output reg [7:0] pc,
input [31:0] ins,
output [31:0] io_reg1,
output [31:0] io_reg2,
output [31:0] io_reg3,
output [31:0] io_reg4
);
 
reg state;
 
wire [5:0] opcode;
wire [5:0] func;
wire [4:0] rs,rt,rd;
wire [4:0] shamt;
 
wire [31:0] src1,src2;
wire [31:0] alu_out;
wire alu_valid;
 
reg write_enable;
reg [4:0] write_addr;
reg [31:0] write_data;
 
assign opcode = ins[31:26];
assign rs = ins[25:21];
assign rt = ins[20:16];
assign rd = ins[15:11];
assign shamt = ins[10:6];
assign func = ins[5:0];
 
RegisterFile rf(
rs,rt,
src1,src2,
write_addr,
write_data,
write_enable,
clk
);
 
ALU alu(
src1,
src2,
shamt,
opcode,
func,
alu_out,
alu_valid
);
 
always @(posedge clk)
begin
 
if(reset)
begin
state <= 0;
pc <= 0;
end
 
else
 
case(state)
 
0:
begin
write_data <= alu_out;
write_addr <= (opcode==`OP_REG)? rd : rt;
write_enable <= alu_valid;
state <= 1;
end
 
1:
begin
pc <= pc + 1;
write_enable <= 0;
state <= 0;
end
 
endcase
 
end
 
assign halt =
(opcode==`OP_REG && func==`FUNC_SYSCALL && src1==`SYS_exit);
 
endmodule
