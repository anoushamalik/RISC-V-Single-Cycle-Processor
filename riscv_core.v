module riscv_core(
    input clk,
    input rst
);

    // Program Counter
    reg [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    
    // Instruction Memory
    wire [31:0] instruction;
    
    // Register File
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] reg_write_data;
    wire [31:0] reg_read_data1;
    wire [31:0] reg_read_data2;
    
    // ALU
    wire [31:0] alu_operand1;
    wire [31:0] alu_operand2;
    wire [31:0] alu_result;
    wire branch_condition;
    
    // Control Unit
    wire [3:0] alu_control;
    wire mem_read;
    wire mem_to_reg;
    wire mem_write;
    wire alu_src;
    wire reg_write;
    wire branch;
    wire is_jump;
    wire branch_taken;
    
    // Immediate Generator
    wire [31:0] immediate;
    
    // Data Memory
    wire [31:0] mem_read_data;
    
    // Instruction fields
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd = instruction[11:7];
    
    // Program Counter Logic
    assign pc_plus_4 = pc + 4;
    assign branch_target = pc + immediate;
    assign next_pc = branch_taken ? branch_target : pc_plus_4;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'h0;
        else
            pc <= next_pc;
    end
    
    // Instantiate Instruction Memory
    instruction_memory imem (
        .pc(pc),
        .instruction(instruction)
    );
    
    // Instantiate Register File
    register_file reg_file (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(reg_write_data),
        .reg_write(reg_write),
        .read_data1(reg_read_data1),
        .read_data2(reg_read_data2)
    );
    
    // Instantiate Control Unit
    control_unit ctrl (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .branch_condition(branch_condition),
        .alu_control(alu_control),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .branch(branch),
        .is_jump(is_jump),
        .branch_taken(branch_taken)
    );
    
    // Instantiate Immediate Generator
    immediate_gen imm_gen (
        .instruction(instruction),
        .imm_out(immediate)
    );
    
    // ALU Input Muxing
    assign alu_operand1 = reg_read_data1;
    assign alu_operand2 = alu_src ? immediate : reg_read_data2;
    
    // Instantiate ALU
    alu alu_unit (
        .operand1(alu_operand1),
        .operand2(alu_operand2),
        .alu_control(alu_control),
        .result(alu_result),
        .branch_condition(branch_condition)
    );
    
    // Instantiate Data Memory
    data_memory dmem (
        .clk(clk),
        .address(alu_result),
        .write_data(reg_read_data2),
        .write_enable(mem_write),
        .read_enable(mem_read),
        .read_data(mem_read_data)
    );
    
    // Write Back Muxing
    assign reg_write_data = is_jump ? pc_plus_4 :
                           mem_to_reg ? mem_read_data : 
                           alu_result;
    
    // Debug
    always @(posedge clk) begin
        $display("PC: %h, Instruction: %h", pc, instruction);
        if (reg_write && rd != 0)
            $display("Register Write: x%d = %h", rd, reg_write_data);
        if (branch_taken)
            $display("Branch Taken: PC = %h -> %h", pc, branch_target);
    end

endmodule
