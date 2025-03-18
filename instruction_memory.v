module instruction_memory(
    input [31:0] pc,
    output reg [31:0] instruction
);

    // Internal memory
    reg [31:0] mem [0:63];  // 64 words of memory
    
    // Initialize with test program
    initial begin
        // Basic arithmetic and logic test sequence
        mem[0]  = 32'h00500113;    // ADDI x2, x0, 5      # x2 = 5
        mem[1]  = 32'h00300193;    // ADDI x3, x0, 3      # x3 = 3
        mem[2]  = 32'h00318233;    // ADD  x4, x3, x3     # x4 = x3 + x3 = 6
        mem[3]  = 32'h402182B3;    // SUB  x5, x3, x2     # x5 = x3 - x2 = -2
        
        // Test branch instructions
        mem[4]  = 32'h00320463;    // BEQ  x4, x3, 8      # Skip next if x4 == x3
        mem[5]  = 32'h00200113;    // ADDI x2, x0, 2      # x2 = 2 (should execute)
        mem[6]  = 32'h00418A63;    // BEQ  x3, x4, 20     # Branch if x3 == x4
        mem[7]  = 32'h00100113;    // ADDI x2, x0, 1      # x2 = 1 (should execute)
        mem[8]  = 32'hFE320AE3;    // BEQ  x4, x3, -12    # Branch back if x4 == x3
        
        // Test JAL and JALR
        mem[9]  = 32'h00C000EF;    // JAL  x1, 12         # Jump to PC+12, save PC+4 in x1
        mem[10] = 32'h00100113;    // ADDI x2, x0, 1      # (should be skipped)
        mem[11] = 32'h00200113;    // ADDI x2, x0, 2      # (should be skipped)
        mem[12] = 32'h00300113;    // ADDI x2, x0, 3      # x2 = 3
        mem[13] = 32'h000080E7;    // JALR x1, x1, 0      # Return to saved address
        
        // Test more branch conditions
        mem[14] = 32'h0041C463;    // BLT  x3, x4, 8      # Branch if x3 < x4
        mem[15] = 32'h00500113;    // ADDI x2, x0, 5      # (should be skipped)
        mem[16] = 32'h00600113;    // ADDI x2, x0, 6      # x2 = 6
        
        // End program with infinite loop
        mem[17] = 32'h0000006F;    // JAL  x0, 0          # Infinite loop
        
        $display("Instruction memory initialized with test program");
    end
    
    // Read instruction
    always @(*) begin
        instruction = mem[pc[31:2]];  // Word aligned
        $display("Fetch: pc=%h inst=%h", pc, instruction);
    end

endmodule
