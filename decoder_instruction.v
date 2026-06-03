`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 10:53:17 PM
// Design Name: 
// Module Name: decoder_instruction
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


module instruction_decoder (
    input [31:0] instruction,
    output [5:0] opcode,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] shamt,
    output [5:0] funct,
    output [15:0] immediate,
    output [25:0] address
);
    assign opcode    = instruction[31:26];
    assign rs        = instruction[25:21];
    assign rt        = instruction[20:16];
    assign rd        = instruction[15:11];
    assign shamt     = instruction[10:6];
    assign funct     = instruction[5:0];
    assign immediate = instruction[15:0];
    assign address   = instruction[25:0];
endmodule
