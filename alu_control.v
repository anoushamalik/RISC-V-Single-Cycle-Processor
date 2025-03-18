module alu_control(
    input [2:0] funct3,
    input [6:0] funct7,
    input [1:0] alu_op,
    output reg [3:0] alu_control_out
);

    // ALU Control codes
    parameter ALU_ADD  = 4'b0000;
    parameter ALU_SUB  = 4'b0001;
    parameter ALU_AND  = 4'b0010;
    parameter ALU_OR   = 4'b0011;
    parameter ALU_XOR  = 4'b0100;
    parameter ALU_SLL  = 4'b0101;
    parameter ALU_SRL  = 4'b0110;
    parameter ALU_SRA  = 4'b0111;
    parameter ALU_SLT  = 4'b1000;
    parameter ALU_SLTU = 4'b1001;
    parameter ALU_BEQ  = 4'b1010;
    parameter ALU_BNE  = 4'b1011;
    parameter ALU_BLT  = 4'b1100;
    parameter ALU_BGE  = 4'b1101;
    parameter ALU_BLTU = 4'b1110;
    parameter ALU_BGEU = 4'b1111;

    always @(*) begin
        case(alu_op)
            2'b00: // Load/Store/JALR
                alu_control_out = ALU_ADD;
                
            2'b01: begin // Branch
                case(funct3)
                    3'b000: alu_control_out = ALU_BEQ;  // BEQ
                    3'b001: alu_control_out = ALU_BNE;  // BNE
                    3'b100: alu_control_out = ALU_BLT;  // BLT
                    3'b101: alu_control_out = ALU_BGE;  // BGE
                    3'b110: alu_control_out = ALU_BLTU; // BLTU
                    3'b111: alu_control_out = ALU_BGEU; // BGEU
                    default: alu_control_out = ALU_ADD;
                endcase
                $display("Debug: Branch ALU control: funct3=%b, control=%b", funct3, alu_control_out);
            end
            
            2'b10: begin // R-type/I-type
                case(funct3)
                    3'b000: begin
                        if (alu_op[1] && funct7[5]) // R-type SUB
                            alu_control_out = ALU_SUB;
                        else
                            alu_control_out = ALU_ADD; // ADD or ADDI
                    end
                    3'b001: alu_control_out = ALU_SLL;  // SLL/SLLI
                    3'b010: alu_control_out = ALU_SLT;  // SLT/SLTI
                    3'b011: alu_control_out = ALU_SLTU; // SLTU/SLTIU
                    3'b100: alu_control_out = ALU_XOR;  // XOR/XORI
                    3'b101: begin
                        if (funct7[5]) 
                            alu_control_out = ALU_SRA;   // SRA/SRAI
                        else
                            alu_control_out = ALU_SRL;   // SRL/SRLI
                    end
                    3'b110: alu_control_out = ALU_OR;   // OR/ORI
                    3'b111: alu_control_out = ALU_AND;  // AND/ANDI
                    default: alu_control_out = ALU_ADD;
                endcase
            end
            
            default: alu_control_out = ALU_ADD;
        endcase
    end

endmodule
