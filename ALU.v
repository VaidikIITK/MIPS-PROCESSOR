`timescale 1ns / 1ps
`include "function.v"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:56:04 AM
// Design Name: 
// Module Name: ALU
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

module ALU(
    input clk,
    input rst,
    input  [31:0] A,         // Operand 1 (RS)
    input  [31:0] B,
    input  [4:0] ALU_Ctrl, // Operation selector         // Operand 2 (RT/I)
    input  [4:0] shift,      // Shift amount 
    input  [63:0] mult_in,  // Needed for multiplications current hi_lo value
    output reg [31:0] result,
    output reg [63:0] mult_res, // Output for mul/madd/maddu
    output reg is_zero,
    output reg is_negative,
    output reg is_overflow
);

    reg signed [31:0] A_signed, B_signed;
    reg [63:0] mult_result;

    always @(*) begin
        A_signed = A;
        B_signed = B;
        is_zero = 0;
        is_negative = 0;
        is_overflow = 0;
        hi_lo = 0;
        result = 0;

        case (ALU_Ctrl)
            // Arithmetic
            5'b00000: result = A + B;                             // add/addi
            5'b00001: result = A - B;                             // sub
            5'b00010: result = A + B;                             // addu/addiu (unsigned)
            5'b00011: result = A - B;                             // subu (unsigned)
            5'b00100: begin                                       // mul
                mult_result = A * B;
                mult_res = mult_result;
                result = mult_result[31:0];                       // lo part
            end
            5'b00101: begin                                       // madd
                mult_result = A * B;
                mult_res = mult_result;
                result = mult_result[31:0];                            // lo part
            end
            5'b00110: begin                                       // maddu
                mult_result = A * B;
                mult_res = mult_result;
                result = mult_result[31:0]; 
            end

            // Logical
            5'b01000: result = A & B;                             // and/andi
            5'b01001: result = A | B;                             // or/ori
            5'b01010: result = A ^ B;                             // xor/xori
            5'b01011: result = ~A;                                // not

            // Shifts
            5'b01100: result = B << shift;                        // sll
            5'b01101: result = B >> shift;                        // srl (logical)
            5'b01110: result = $signed(B) >>> shift;             // sra (arithmetic)
            5'b01111: result = $signed(B) <<< shift;             // sla (same as sll for signed)

            // Comparison
            5'b10000: result = ($signed(A) < $signed(B)) ? 1 : 0; // slt/slti
            5'b10001: result = (A == B) ? 1 : 0;                  // seq
            5'b10010: result = ($signed(A) > $signed(B)) ? 1 : 0; // bgt
            5'b10011: result = ($signed(A) >= $signed(B)) ? 1 : 0;// bgte
            5'b10100: result = ($signed(A) < $signed(B)) ? 1 : 0; // ble
            5'b10101: result = ($signed(A) <= $signed(B)) ? 1 : 0;// bleq
            5'b10110: result = (A < B) ? 1 : 0;                   // bleu (unsigned)
            5'b10111: result = (A > B) ? 1 : 0;                   // bgtu (unsigned)

            default: result = 0;
        endcase

        is_zero = (result == 0);
        is_negative = result[31];
    end
endmodule