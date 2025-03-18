
# RISC-V Single Cycle Processor Design

## Overview
This project presents the design and implementation of a RISC-V single-cycle processor in Verilog. The processor supports a subset of RISC-V instructions and is capable of executing arithmetic, logical, memory access, and branch operations in a single clock cycle. The design includes an instruction memory, a register file, an ALU, and a control unit, ensuring correct instruction execution.

## Features
- Implements a subset of the RISC-V ISA.
- Executes each instruction in a single clock cycle.
- Modular design including:
  - Program Counter (PC)
  - Instruction Memory
  - Register File
  - Arithmetic Logic Unit (ALU)
  - Control Unit
  - Data Memory
  - Immediate Generator
- Designed and verified using Verilog.
- Tested with assembly and C programs.

## Instruction Set Architecture (ISA)
The processor supports the following RISC-V instruction types:
- **R-Type**: `add, sub, and, or, xor, sll, slt, srl, sra`
- **I-Type**: `addi, andi, ori, xori, slti, slli, srli`
- **S-Type**: `sb, sh, sw`
- **L-Type**: `lb, lh, lw`
- **B-Type**: `beq, bne, blt, bge`
- **J-Type**: `JAL, JALR`  

## Processor Components
### 1. **Program Counter (PC)**
Holds the address of the current instruction and increments by 4 after each cycle.

### 2. **Instruction Memory**
Stores the program instructions and fetches the current instruction based on the PC value.

### 3. **Register File**
Contains 32 registers used for storing intermediate results and operands.

### 4. **Control Unit**
Decodes instructions and generates control signals to coordinate data flow and operations.

### 5. **Arithmetic Logic Unit (ALU)**
Performs arithmetic and logical operations based on the instruction's control signals.

### 6. **Data Memory**
Stores and retrieves data required for `load` and `store` instructions.

### 7. **Immediate Generator**
Extracts and extends immediate values from instructions for computation.

## Implementation
The processor was implemented in Verilog, following a modular design approach. Each component was designed separately and integrated into the final processor.

## Testing and Validation
### **Assembly-Level Testing**
- Various assembly programs were executed to verify correct functionality.
- RISC-V instructions were tested for correct execution and output verification.

### **C Program Compilation and Execution**
- A set of C programs were compiled using the RISC-V GCC toolchain.
- Assembly code was generated from the C programs and executed on the processor.
- The execution flow was verified using memory dumps and register values.

## Compilation and Simulation
### **Compiling and Running Assembly Code**
1. Assemble the RISC-V program:
   ```sh
   riscv64-unknown-elf-as -march=rv32i -o program.o program.s
   ```
2. Convert the object file into a hex file:
   ```sh
   riscv64-unknown-elf-objcopy -O verilog program.o program.hex
   ```
3. Load the hex file into the processor for simulation.

### **Compiling C Code for Execution**
1. Compile the C program to RISC-V assembly:
   ```sh
   riscv32-unknown-elf-gcc -S -march=rv32i -mabi=ilp32 program.c -o program.s
   ```
2. Follow the same steps as assembly to generate the hex file.

## Challenges Faced
- Data hazards due to instruction dependencies.
- Handling control signals for different instruction types.
- Debugging assembly-level execution issues.

## Acknowledgments

RISC-V community for open-source ISA resources.
Open-source Verilog tools for implementation and testing.
Contributors and academic references that guided the project development.
