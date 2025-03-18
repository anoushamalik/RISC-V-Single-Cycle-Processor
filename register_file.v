module register_file(
    input clk,
    input rst,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input reg_write,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
);

    // Register file
    reg [31:0] registers [0:31];
    integer i;

    // Initialize registers
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    // Read ports are combinational
    always @(*) begin
        // x0 is hardwired to 0
        read_data1 = (rs1 == 0) ? 32'b0 : registers[rs1];
        read_data2 = (rs2 == 0) ? 32'b0 : registers[rs2];
    end

    // Write port is synchronous
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (reg_write && rd != 0) begin // x0 cannot be written
            registers[rd] <= write_data;
            $display("Register Write: x%0d = %0h", rd, write_data);
        end
    end

endmodule
