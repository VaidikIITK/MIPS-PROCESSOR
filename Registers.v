`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:56:04 AM
// Design Name: 
// Module Name: Registers
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


module Registers(input clk,
    input [4:0] read_register1,//RS
    input [4:0] read_register2,//RT
    input [4:0] write_reg,//RD
    input [31:0] write_data,
    input register_write, 
    input register_Dist,
    output [31:0] read_data1,
    output [31:0] read_data2
);
reg [31:0] registers [0:31];//Initialize all registers to 0
    integer i;
    initial begin
      for (i = 0; i < 32; i = i + 1)
        registers[i] = 32'b0;
    end

    // Read operations
    assign read_data1 = registers[read_register1];
    //This is used for RS
    assign read_data2 = registers[read_register2];
     //This is used for RT
    reg [4:0] write_register;
    always @(*) begin
    if(register_Dist) write_register=write_reg;
    else write_register=read_register2;
    end
    //This is used for RT
    // Write operation
    always @(posedge clk) begin
        if (register_write && write_register!=0)  registers[write_register] <= write_data;
    end
endmodule

