`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:56:04 AM
// Design Name: 
// Module Name: Data_Mem
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


module Data_Mem(
    input         clk,
    input         memory_write,
    input         memory_read,
    input  [31:0] address,
    input  [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:4095];  // 32-bit memory repeated 2^12 rtimes

    wire [11:0] word_address = (address- 32'h10010000) >> 2;

    always @(posedge clk) begin
        if (memory_write)
            memory[word_address] <= write_data;
    end

    always @(*) begin
        read_data = memory_read ? memory[word_address] : 32'b0;
    end
endmodule