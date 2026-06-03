`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:56:04 AM
// Design Name: 
// Module Name: Instruction_Mem
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


module Instruction_Mem(
    input  [31:0] addr,
    output [31:0] instr
);
    reg [31:0] instr_mem [0:255]; // 256 instructions max

    initial begin
        // Address = index * 4 (word addressing)

        instr_mem[0]  = 32'h3c041000;     // lui $a0, 0x1000 (la $a0, array)
instr_mem[1]  = 32'h34840000;     // ori $a0, $a0, 0x0000
instr_mem[2]  = 32'h3c011000;     // lui $at, 0x1000 (lw $a1, array_size)
instr_mem[3]  = 32'h8c250060;     // lw $a1, 0x60($at)
instr_mem[4]  = 32'h0c000020;     // jal 0x00000080 (jal insertion_sort)
instr_mem[5]  = 32'h3402000a;     // ori $v0, $0, 10 (li $v0, 10)
instr_mem[6]  = 32'h0000000c;     // syscall
instr_mem[7]  = 32'h00000000;     // nop (delay slot)

// insertion_sort procedure
instr_mem[8]  = 32'h23bdfffc;     // addi $sp, $sp, -4
instr_mem[9]  = 32'hafbf0000;     // sw $ra, 0($sp)
instr_mem[10] = 32'h34080001;     // ori $t0, $0, 1 (li $t0, 1)

// outer_loop:
instr_mem[11] = 32'h0105082a;     // slt $at, $t0, $a1
instr_mem[12] = 32'h1020001c;     // beq $at, $0, 0x1c (end_outer)
instr_mem[13] = 32'h00084880;     // sll $t1, $t0, 2
instr_mem[14] = 32'h01094820;     // add $t1, $a0, $t1
instr_mem[15] = 32'h8d2a0000;     // lw $t2, 0($t1)
instr_mem[16] = 32'h2103ffff;     // addi $t3, $t0, -1

// inner_loop:
instr_mem[17] = 32'h0460000c;     // bltz $t3, 0x0c (end_inner)
instr_mem[18] = 32'h00036080;     // sll $t4, $t3, 2
instr_mem[19] = 32'h00846020;     // add $t4, $a0, $t4
instr_mem[20] = 32'h8d850000;     // lw $t5, 0($t4)
instr_mem[21] = 32'h0145082a;     // slt $at, $t2, $t5
instr_mem[22] = 32'h10200006;     // beq $at, $0, 0x06 (end_inner)
instr_mem[23] = 32'had850004;     // sw $t5, 4($t4)
instr_mem[24] = 32'h2063ffff;     // addi $t3, $t3, -1
instr_mem[25] = 32'h08100011;     // j 0x00000044 (inner_loop)

// end_inner:
instr_mem[26] = 32'h00037080;     // sll $t6, $t3, 2
instr_mem[27] = 32'h00847020;     // add $t6, $a0, $t6
instr_mem[28] = 32'hadc20004;     // sw $t2, 4($t6)
instr_mem[29] = 32'h21080001;     // addi $t0, $t0, 1
instr_mem[30] = 32'h0810000b;     // j 0x0000002c (outer_loop)

// end_outer:
instr_mem[31] = 32'h8fbf0000;     // lw $ra, 0($sp)
instr_mem[32] = 32'h23bd0004;     // addi $sp, $sp, 4
instr_mem[33] = 32'h03e00008;     // jr $ra
instr_mem[34] = 32'h00000000;     // nop (delay slot)

// Data Section (starting at 0x00001000)
instr_mem[35] = 32'h00000005;     // .word 5
instr_mem[36] = 32'h00000002;     // .word 2
instr_mem[37] = 32'h00000004;     // .word 4
instr_mem[38] = 32'h00000006;     // .word 6
instr_mem[39] = 32'h00000001;     // .word 1
instr_mem[40] = 32'h00000003;     // .word 3
instr_mem[41] = 32'h00000006;     // .word 6 (array_size)
// Text Segment (Instructions) Now we run float
instr_mem[42] = 32'h3c011000;  // lui $at, 0x1000
instr_mem[43] = 32'hc4210000;  // lwc1 $f1, 0x0000($at)
instr_mem[44] = 32'hc4220004;  // lwc1 $f2, 0x0004($at)
instr_mem[45] = 32'h46021881;  // sub.s $f3, $f1, $f2
instr_mem[46] = 32'he4230008;  // swc1 $f3, 0x0008($at)
instr_mem[47] = 32'h3402000a;  // ori $v0, $0, 10
instr_mem[48] = 32'h0000000c;  // syscall
instr_mem[49] = 32'h00000000;  // nop (delay slot)

// Data Segment (Floating-point values)
instr_mem[50] = 32'h40b00000;  // float1: 5.5 (IEEE 754)
instr_mem[51] = 32'h400ccccd;  // float2: 2.2 (IEEE 754)
instr_mem[52] = 32'h00000000;  // result: 0.0 (initialized)


// TEXT SEGMENT (Instructions) Now we Multiply
instr_mem[53] = 32'h3c081000;  // lui $t0, 0x1000       // Load upper address
instr_mem[54] = 32'h8d090000;  // lw $t1, 0($t0)        // Load int1 (7)
instr_mem[55] = 32'h8d0a0004;  // lw $t2, 4($t0)        // Load int2 (3)
instr_mem[56] = 32'h012a0018;  // mult $t1, $t2         // Multiply (HI/LO = 7×3)
instr_mem[57] = 32'h00005812;  // mflo $t3              // Get product (21)
instr_mem[58] = 32'had0b0008;  // sw $t3, 8($t0)        // Store result
instr_mem[59] = 32'h3402000a;  // ori $v0, $0, 10       // Exit syscall
instr_mem[60] = 32'h0000000c;  // syscall
instr_mem[61] = 32'h00000000;  // nop                   // Delay slot

// DATA SEGMENT
instr_mem[62] = 32'h00000007;  // int1: 7
instr_mem[63] = 32'h00000003;  // int2: 3
instr_mem[64] = 32'h00000015;  // result: 21 (after execution)
instr_mem[65] = 32'h3402000a;  // ori $v0, $0, 10       // li $v0, 10 (exit)
instr_mem[66] = 32'h0000000c;  // syscall               // program exit
end
 assign instr = instr_mem[addr[11:2]]; // Word-aligned access
 endmodule