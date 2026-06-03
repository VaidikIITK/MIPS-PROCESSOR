`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 10:09:42 PM
// Design Name: 
// Module Name: MIPS
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MIPS (
    input clk,
    input reset,
    input init_mode,
    input write_enable,
    input [11:0] init_address,
    input [31:0] init_instruction,

    output [31:0] pc_out,
    output [31:0] instruction_out,
    output [31:0] debug_result
);
    wire [31:0] pc, instruction;
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] imm;
    wire [25:0] addr;
    wire [4:0] alu_control;
    wire [31:0] reg_rs_val, reg_rt_val, alu_result;
    wire [63:0] hi_lo;
    wire [31:0] next_pc;
    wire take_branch;
    wire branch_taken;

    wire regDst, aluSrc, memToReg, regWrite;
    wire memRead, memWrite;
    wire branch, jump, is_jal, is_jr;
    wire [2:0] branchType;
    wire [31:0] mem_out;

    // Branch signal
    assign branch_taken = branch && take_branch;

    // Instruction Fetch
    instruction_fetch IF (
        .clk(clk),
        .reset(reset),
        .init_mode(init_mode),
        .write_enable(write_enable),
        .init_address(init_address),
        .init_instruction(init_instruction),
        .next_pc(next_pc),
        .branch_taken(branch_taken),
        .pc(pc),
        .instruction(instruction)
    );

    // Instruction Decode
    instruction_decoder decoded(
        .instruction(instruction),
        .opcode(opcode), .rs(rs), .rt(rt), .rd(rd),
        .shamt(shamt), .funct(funct),
        .immediate(imm), .address(addr)
    );

    // Control Unit
    CU control_unit(
        .opcode(opcode), .funct(funct),
        .regDst(regDst), .aluSrc(aluSrc), .memToReg(memToReg),
        .regWrite(regWrite), .memRead(memRead), .memWrite(memWrite),
        .branch(branch), .jump(jump), .is_jal(is_jal), .is_jr(is_jr),
        .branchType(branchType), .aluOp(alu_control)
    );

    //LInking the Registers
    Registers RF (
        .clk(clk), .read_register1(rs), .read_register2(rt), .read_register3(rd), .register_write(regWrite),
        .write_data(memToReg ? mem_out : alu_result),
        .register_Dist(regDst),
        .read_data1(reg_rs_val), .read_data2(reg_rt_val)
    );

    // ALU
    ALU arithemetic_logic_unit(
        .A(reg_rs_val),
        .B(aluSrc ? {{16{imm[15]}}, imm} : reg_rt_val),
        .shamt(shamt),
        .alu_control(alu_control),
        .hi_lo_in(64'd0),
        .hi_lo(hi_lo),
        .result(alu_result)
    );

    // Data Memory
    Data_Mem  data_memory(
        .clk(clk),
        .memRead(memRead),
        .memWrite(memWrite),
        .address(alu_result),
        .writeData(reg_rt_val),
        .readData(mem_out)
    );

    // Branch Unit
    Branching B (
        .pc_current(pc),
        .rs_val(reg_rs_val),
        .rt_val(reg_rt_val),
        .immediate(imm),
        .jump_address(addr),
        .branch_control(branchType),
        .is_jump(jump),
        .is_jal(is_jal),
        .is_jr(is_jr),
        .next_pc(next_pc),
        .take_branch(take_branch)
    );

    assign pc_out = pc;
    assign instruction_out = instruction;
    assign debug_result = alu_result;
endmodule
