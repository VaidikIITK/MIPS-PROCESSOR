

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
 
wire [5:0] opcode;
wire [5:0] func;
wire [4:0] shift_amount;
wire [4:0] src1_addr;
wire [4:0] src2_addr;
wire [4:0] dest_addr;
 
wire [31:0] src1;
wire [31:0] src2;
wire [31:0] dest_data;
wire dest_valid;
 
reg [31:0] io_reg[0:3];
reg [1:0] io_index;
 
assign io_reg1 = io_reg[0];
assign io_reg2 = io_reg[1];
assign io_reg3 = io_reg[2];
assign io_reg4 = io_reg[3];
 
assign opcode = ins[31:26];
assign src1_addr = ins[25:21];
assign src2_addr = ins[20:16];
assign dest_addr = (opcode==`OP_REG)? ins[15:11] : ins[20:16];
assign shift_amount = ins[10:6];
assign func = ins[5:0];
 
RegisterFile rf(
src1_addr,src2_addr,
src1,src2,
dest_addr,
dest_data,
dest_valid,
clk
);
 
ALU alu(
src1,
src2,
shift_amount,
opcode,
func,
dest_data,
dest_valid
);
 
always @(posedge clk)
begin
if(reset)
pc <= 0;
else
pc <= halt ? pc : pc + 1;
end
 
always @(negedge clk)
begin
if(opcode==`OP_REG && func==`FUNC_SYSCALL && src1==`SYS_write)
begin
io_reg[io_index] <= src2;
io_index <= io_index + 1;
end
end
 
assign halt =
(opcode==`OP_REG && func==`FUNC_SYSCALL && src1==`SYS_exit);
 
endmodule
 
 
 
