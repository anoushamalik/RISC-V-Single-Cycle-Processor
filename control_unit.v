module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input branch_condition,
    output reg [3:0] alu_control,
    output reg mem_read,
    output reg mem_to_reg,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg branch,
    output reg is_jump,
    output reg branch_taken
);

    // Debug signals
    integer debug_cycle = 0;
    initial debug_cycle = 0;
    always @(*) debug_cycle = debug_cycle + 1;

    // Opcode definitions
    parameter R_TYPE    = 7'b0110011;
    parameter I_TYPE    = 7'b0010011;
    parameter STORE     = 7'b0100011;
    parameter LOAD      = 7'b0000011;
    parameter BRANCH    = 7'b1100011;
    parameter JAL       = 7'b1101111;
    parameter JALR      = 7'b1100111;
    parameter LUI      = 7'b0110111;
    parameter AUIPC    = 7'b0010111;

    // ALU control codes
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
        // Default values
        mem_read = 0;
        mem_to_reg = 0;
        mem_write = 0;
        alu_src = 0;
        reg_write = 0;
        branch = 0;
        is_jump = 0;
        branch_taken = 0;
        alu_control = ALU_ADD;

        case(opcode)
            R_TYPE: begin
                reg_write = 1;
                case(funct3)
                    3'b000: alu_control = (funct7[5]) ? ALU_SUB : ALU_ADD;
                    3'b001: alu_control = ALU_SLL;
                    3'b010: alu_control = ALU_SLT;
                    3'b011: alu_control = ALU_SLTU;
                    3'b100: alu_control = ALU_XOR;
                    3'b101: alu_control = (funct7[5]) ? ALU_SRA : ALU_SRL;
                    3'b110: alu_control = ALU_OR;
                    3'b111: alu_control = ALU_AND;
                endcase
            end
            
            I_TYPE: begin
                reg_write = 1;
                alu_src = 1;
                case(funct3)
                    3'b000: alu_control = ALU_ADD;  // ADDI
                    3'b001: alu_control = ALU_SLL;  // SLLI
                    3'b010: alu_control = ALU_SLT;  // SLTI
                    3'b011: alu_control = ALU_SLTU; // SLTIU
                    3'b100: alu_control = ALU_XOR;  // XORI
                    3'b101: alu_control = (funct7[5]) ? ALU_SRA : ALU_SRL;
                    3'b110: alu_control = ALU_OR;   // ORI
                    3'b111: alu_control = ALU_AND;  // ANDI
                endcase
            end
            
            STORE: begin
                mem_write = 1;
                alu_src = 1;
                alu_control = ALU_ADD;
            end
            
            LOAD: begin
                mem_read = 1;
                mem_to_reg = 1;
                reg_write = 1;
                alu_src = 1;
                alu_control = ALU_ADD;
            end
            
            BRANCH: begin
                branch = 1;
                case(funct3)
                    3'b000: alu_control = ALU_BEQ;  // BEQ
                    3'b001: alu_control = ALU_BNE;  // BNE
                    3'b100: alu_control = ALU_BLT;  // BLT
                    3'b101: alu_control = ALU_BGE;  // BGE
                    3'b110: alu_control = ALU_BLTU; // BLTU
                    3'b111: alu_control = ALU_BGEU; // BGEU
                endcase
                branch_taken = branch_condition;
                $display("Debug: Branch ALU control: funct3=%b, control=%b", funct3, alu_control);
            end
            
            JAL: begin
                is_jump = 1;
                reg_write = 1;
                branch_taken = 1;
            end
            
            JALR: begin
                is_jump = 1;
                reg_write = 1;
                alu_src = 1;
                branch_taken = 1;
            end
            
            LUI: begin
                reg_write = 1;
                alu_src = 1;
                alu_control = ALU_ADD;  // Pass immediate directly
            end
            
            AUIPC: begin
                reg_write = 1;
                alu_src = 1;
                alu_control = ALU_ADD;  // Add immediate to PC
            end
            
            default: begin
                mem_read = 0;
                mem_to_reg = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
                branch = 0;
                is_jump = 0;
                branch_taken = 0;
                alu_control = ALU_ADD;
            end
        endcase
    end

endmodule
