module alu(
    input [31:0] operand1,
    input [31:0] operand2,
    input [3:0] alu_control,
    output reg [31:0] result,
    output reg branch_condition
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

    wire signed [31:0] signed_op1;
    wire signed [31:0] signed_op2;
    assign signed_op1 = operand1;
    assign signed_op2 = operand2;

    always @(*) begin
        // Default values
        result = 32'b0;
        branch_condition = 1'b0;

        case(alu_control)
            ALU_ADD:  result = operand1 + operand2;
            ALU_SUB:  result = operand1 - operand2;
            ALU_AND:  result = operand1 & operand2;
            ALU_OR:   result = operand1 | operand2;
            ALU_XOR:  result = operand1 ^ operand2;
            ALU_SLL:  result = operand1 << operand2[4:0];
            ALU_SRL:  result = operand1 >> operand2[4:0];
            ALU_SRA:  result = signed_op1 >>> operand2[4:0];
            ALU_SLT:  result = (signed_op1 < signed_op2) ? 32'b1 : 32'b0;
            ALU_SLTU: result = (operand1 < operand2) ? 32'b1 : 32'b0;
            
            // Branch operations
            ALU_BEQ:  branch_condition = (operand1 == operand2);
            ALU_BNE:  branch_condition = (operand1 != operand2);
            ALU_BLT:  branch_condition = (signed_op1 < signed_op2);
            ALU_BGE:  branch_condition = (signed_op1 >= signed_op2);
            ALU_BLTU: branch_condition = (operand1 < operand2);
            ALU_BGEU: branch_condition = (operand1 >= operand2);
            
            default: begin
                result = 32'b0;
                branch_condition = 1'b0;
            end
        endcase
    end

endmodule
