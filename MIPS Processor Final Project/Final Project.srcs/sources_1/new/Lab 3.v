`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2023 03:33:55 PM
// Design Name: 
// Module Name: progCounter, insteMeme, pcAdder, ifidPipeReg, regrtMulx, immExt, idexePipeReg;
// Project Name: Lab3
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Program Counter: Sets the current pc to the next pc
module progCounter(input [31:0] nextPc, input clock, output reg [31:0] pc);
    initial pc <= 100;
    
    always @ (posedge clock) begin
        pc <= nextPc;
    end
endmodule


//Instruction Memory: Retreives the instruction stored in memory at the current pc 
module instMem(input [31:0] pc, output reg [31:0] instOut);
    // Memory initialization
    reg [31:0] memory [0:63];
    initial begin        
        memory[25] <= {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b100000};
        memory[26] <= {6'b000000, 5'b01001, 5'b00011, 5'b00100, 5'b00000, 6'b100010};
        memory[27] <= {6'b000000, 5'b00011, 5'b01001, 5'b00101, 5'b00000, 6'b100101};
        memory[28] <= {6'b000000, 5'b00011, 5'b01001, 5'b00110, 5'b00000, 6'b100110};
        memory[29] <= {6'b000000, 5'b00011, 5'b01001, 5'b00111, 5'b00000, 6'b100100};
    end    
    
    always @ (*) instOut <= memory[pc[7:2]];
endmodule


// Pc Adder: gets the address of the next pc
module pcAdder(input [31:0] pc, output reg [31:0] nextPc);
    wire [31:0] hwVal = 4; //Hard-wired value
    always @ (*) begin
        nextPc <= pc + hwVal;
    end
endmodule


// IFID Pipeline Register: feeds instOut into dinstOut
module ifidPipeReg(input [31:0] instOut, input clock, output reg [31:0] dinstOut);
    always @ (posedge clock) begin
        dinstOut <= instOut;
    end
endmodule

// Regrt Multiplexer: Chooses which register to use as a destination
module regrtMulx(input [4:0] rt, input [4:0] rd, input regrt, output reg [4:0] destReg);
    always @(*) begin
        case (regrt)
            0: destReg <= rd;

            1: destReg <= rt;
        endcase
    end

endmodule

//Immediate Extender: Takes a 16-bit immediate input and outputs a 32-bit one
module  immExt(input [15:0] imm, output reg [31:0] imm32);
    reg sign;
    always @(*) begin
        sign = imm[15];
        imm32 = {{16{sign}}, imm}; // Concatenate imm to a 16-bit string with bits set to the value of imm's sign bit
    end
endmodule

// IDEXE Pipeline Register: Sets values for variables in EXE stage using those in the ID stage
module idexePipeReg(input wreg, input m2reg, input wmem, input [3:0] aluc,
                    input aluimm, input [4:0] destReg, input [31:0] qa, input [31:0] qb,
                    input [31:0] imm32, input clock, output reg ewreg, output reg em2reg, output reg ewmem,
                    output reg [3:0] ealuc, output reg ealuimm, output reg [4:0] edestReg,
                    output reg [31:0] eqa, output reg [31:0] eqb, output reg [31:0] eimm32);
                    
    always @(posedge clock) begin
        ewreg <= wreg;
        em2reg <= m2reg;
        ewmem <= wmem;
        ealuc <= aluc;
        ealuimm <= aluimm;
        edestReg <= destReg;
        eqa <= qa;
        eqb <= qb;
        eimm32 <= imm32;        
    end
endmodule