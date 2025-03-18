module immediate_gen(
    input [31:0] instruction,
    output reg [31:0] imm_out
);

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    
    always @(*) begin
        case(opcode)
            7'b0010011: // I-type
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
                
            7'b0000011: // Load
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
                
            7'b0100011: // Store
                imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
                
            7'b1100011: begin // Branch
                imm_out = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
                $display("Branch Imm Gen: inst=%h imm=%h", instruction, imm_out);
            end
            
            7'b1101111: begin // JAL
                imm_out = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
                $display("JAL Imm Gen: inst=%h imm=%h", instruction, imm_out);
            end
            
            7'b1100111: // JALR
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
                
            7'b0110111: // LUI
                imm_out = {instruction[31:12], 12'b0};
                
            7'b0010111: // AUIPC
                imm_out = {instruction[31:12], 12'b0};
                
            default:
                imm_out = 32'b0;
        endcase
    end

endmodule
