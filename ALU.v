module ALU (
    input [5:0] opcode,
    input [5:0] func,
    input [31:0] src1,
    input [31:0] src2,
    input [31:0] pc,
    input [31:0] branch_offset,
    input [4:0] rt,
    output reg [31:0] dest,
    output reg dest_valid,
    output reg branch_taken
);

    always @(*) begin
        // Default assignments to prevent latches
        dest = 32'd0;
        dest_valid = 1'b0;
        branch_taken = 1'b0;

        case(opcode)
            6'h00: begin // R-type instructions
                case(func)
                    6'h08: begin // jr
                        branch_taken = 1'b1;
                        dest_valid = 1'b0;
                    end
                    6'h09: begin // jalr
                        branch_taken = 1'b1;
                        dest = pc + 1;
                        dest_valid = 1'b1; // Writes pc+1 to rd (31)
                    end
                    6'h2a: begin // slt
                        dest = ($signed(src1) < $signed(src2)) ? 32'd1 : 32'd0;
                        dest_valid = 1'b1;
                    end
                    6'h2b: begin // sltu
                        dest = (src1 < src2) ? 32'd1 : 32'd0;
                        dest_valid = 1'b1;
                    end
                    // ... (Include your other R-type ALU cases like ADD, SUB, etc.)
                endcase
            end

            6'h01: begin // bltz or bgez (distinguished by rt)
                if (rt == 5'd0) begin // bltz
                    branch_taken = ($signed(src1) < 0) ? 1'b1 : 1'b0;
                end else if (rt == 5'd1) begin // bgez
                    branch_taken = ($signed(src1) >= 0) ? 1'b1 : 1'b0;
                end
                dest = pc + branch_offset;
                dest_valid = 1'b0;
            end

            6'h02: begin // j
                branch_taken = 1'b1;
                dest_valid = 1'b0;
            end

            6'h03: begin // jal
                branch_taken = 1'b1;
                dest = pc + 1;     // jal saves pc+1 to the $ra register
                dest_valid = 1'b1;
            end

            6'h04: begin // beq
                branch_taken = (src1 == src2) ? 1'b1 : 1'b0;
                dest = pc + branch_offset;
                dest_valid = 1'b0;
            end

            6'h05: begin // bne
                branch_taken = (src1 != src2) ? 1'b1 : 1'b0;
                dest = pc + branch_offset;
                dest_valid = 1'b0;
            end

            6'h06: begin // blez
                branch_taken = ($signed(src1) <= 0) ? 1'b1 : 1'b0;
                dest = pc + branch_offset;
                dest_valid = 1'b0;
            end

            6'h07: begin // bgtz
                branch_taken = ($signed(src1) > 0) ? 1'b1 : 1'b0;
                dest = pc + branch_offset;
                dest_valid = 1'b0;
            end

            6'h0A: begin // slti
                dest = ($signed(src1) < $signed(branch_offset)) ? 32'd1 : 32'd0;
                dest_valid = 1'b1;
            end

            6'h0B: begin // sltiu
                dest = (src1 < branch_offset) ? 32'd1 : 32'd0; 
                dest_valid = 1'b1;
            end

            // ... (Include your other I-type operations like ADDI, ORI, etc.)
        endcase
    end
endmodule
