`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:56:04 AM
// Design Name: 
// Module Name: PC
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

//If the program resets, pointer is taken to starting of mips program
//Else the current address accepts the next address of the code.
module PC(
    input clk,
    input reset,
    input branched,
    input [31:0] next_pc,
    output reg [31:0] current_pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_pc <= 32'h00400000;
        else if(branched) 
               current_pc <= next_pc;
        else
            current_pc <= current_pc+4;
    end
endmodule

module instruction_fetch (
    input clk,
    input reset,
    input init_mode,
    input write_enable,
    input [11:0] init_address,
    input [31:0] init_instruction,

    input [31:0] next_pc,
    input branch_taken,

    output reg [31:0] pc,
    output [31:0] instruction
);
    
instruction_memory I (
        .clk(clk),
        .init_mode(init_mode),
        .init_address(init_address),
        .init_instruction(init_instruction),
        .write_enable(write_enable),
        .address(pc),
        .instruction(instruction)
    );
    PC p(.clk(clk),.reset(reset),.branched(branch_taken),.next_pc(nect_pc),.current_pc(pc));
endmodule




























