`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 230959
//231018
// Create Date: 04/09/2025 08:50:31 AM
// Design Name: 
// Module Name: CU
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


module CU(
    input [5:0] opcode,
    input [5:0] funct,
    output reg reg_dist, alu_src, mem_to_reg, reg_write,
    output reg mem_read, mem_write, branch, jump,
    output reg is_jal, is_jr,
    output reg [2:0] branchType,
    output reg [4:0] alu_op
);

    always @(*) begin
        // Default values
        reg_dist = 0; alu_src = 0; mem_to_reg = 0; reg_write = 0;
        mem_read = 0; mem_write = 0; branch = 0; jump = 0;
        is_jal = 0; is_jr = 0; alu_op = 0; branchType = 3'b000;

        case (opcode)
            6'b000000: begin // R-type
                reg_dist = 1;
                reg_write = 1;
                case (funct)
                    6'b100000: alu_op = 5'b00000; // add
                    6'b100010: alu_op = 5'b00001; // sub
                    6'b100001: alu_op = 5'b00010; // addu
                    6'b100011: alu_op = 5'b00011; // subu
                    6'b100100: alu_op = 5'b01000; // and
                    6'b100101: alu_op = 5'b01001; // or
                    6'b100110: alu_op = 5'b01010; // xor
                    6'b000000: alu_op = 5'b01100; // sll
                    6'b000010: alu_op = 5'b01101; // srl
                    6'b000011: alu_op = 5'b01110; // sra
                    6'b101010: alu_op = 5'b10000; // slt
                    6'b001000: begin              // jr
                        reg_write = 0;
                        is_jr = 1;
                    end
                endcase
            end

            // I-type
            6'b001000: begin alu_op = 5'b00000; alu_src = 1; reg_write = 1; end // addi
            6'b001001: begin alu_op = 5'b00010; alu_src = 1; reg_write = 1; end // addiu
            6'b001100: begin alu_op = 5'b01000; alu_src = 1; reg_write = 1; end // andi
            6'b001101: begin alu_op = 5'b01001; alu_src = 1; reg_write = 1; end // ori
            6'b001110: begin alu_op = 5'b01010; alu_src = 1; reg_write = 1; end // xori
            6'b001111: begin alu_op = 5'b01111; alu_src = 1; reg_write = 1; end // lui
            6'b100011: begin alu_op = 5'b00000; alu_src = 1; mem_read = 1; mem_to_reg = 1; reg_write = 1; end // lw
            6'b101011: begin alu_op = 5'b00000; alu_src = 1; mem_write = 1; end // sw
            6'b000100: begin branch = 1; branchType = 3'b000; alu_op = 5'b00001; end // beq
            6'b000101: begin branch = 1; branchType = 3'b001; alu_op = 5'b00001; end // bne

            // J-type
            6'b000010: begin jump = 1; end // j
            6'b000011: begin jump = 1; is_jal = 1; reg_write = 1; end // jal

            // Custom branch types — opcode = 6'b011111
            6'b011111: begin
                branch = 1;
                case (funct)
                    6'b010001: branchType = 3'b010; // bgt
                    6'b010010: branchType = 3'b011; // bgte
                    6'b010011: branchType = 3'b100; // ble
                    6'b010100: branchType = 3'b101; // bleq
                    6'b010101: branchType = 3'b110; // bleu
                    6'b010110: branchType = 3'b111; // bgtu
                    6'b011000: begin alu_op = 5'b10001; reg_write = 1; end // seq
                endcase
            end
        endcase
    end
endmodule
