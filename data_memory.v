module data_memory(
    input clk,
    input [31:0] address,
    input [31:0] write_data,
    input write_enable,
    input read_enable,
    output reg [31:0] read_data
);

    reg [31:0] memory [0:1023];  // 4KB memory
    
    // Initialize memory
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            memory[i] = 32'b0;
    end
    
    // Read operation
    always @(*) begin
        if (read_enable)
            read_data = memory[address[31:2]];  // Word aligned
        else
            read_data = 32'b0;
    end
    
    // Write operation
    always @(posedge clk) begin
        if (write_enable) begin
            memory[address[31:2]] <= write_data;
            $display("Memory Write: addr=%h data=%h", address, write_data);
        end
    end

endmodule
