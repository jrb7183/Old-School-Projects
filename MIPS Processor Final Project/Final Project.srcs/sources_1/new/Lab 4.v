`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2023 02:55:00 PM
// Design Name: 
// Module Name: aluMux, alu, exeMemPipeReg, datMem, memWbPipeReg
// Project Name: Lab4
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

// ALU Multiplexor: Determines the second input of the ALU (b) based on the value of ealuimm
module aluMux(input [31:0] eqb, [31:0] eimm32, ealuimm, output reg [31:0] b);
    always @(*) begin
        if (ealuimm != 1) begin
            b <= eqb;
        end
        else begin
            b <= eimm32;
        end
    end
endmodule

// Arithmetic Logic Unit: performs an arithmetic logic operation determined by ealuc on the other two inputs
module alu(input [31:0] eqa, [31:0] b, [3:0] ealuc, output reg [31:0] r);
    always @(*) begin
        case (ealuc)
            4'b0000: r <= eqa & b; // AND
            
            4'b0001: r <= eqa | b; // OR
        
            4'b0010: r <= eqa + b; // Add
            
            4'b0011: r <= eqa ^ b; // XOR
            
            4'b0110: r <= eqa - b; // Subtract
            
            4'b0111: r <= (eqa < b) ? 1 : 0; // Set on less than (slt)
        endcase
    end
endmodule

// EXEMEM Pipeline Register: Sets values for variables in MEM stage using those in the EXE stage
module exeMemPipeReg(input ewreg, em2reg, ewmem, [4:0] edestReg, [31:0] r, [31:0] eqb, clock, output reg mwreg, 
                    mm2reg, mwmem, reg [4:0] mdestReg, reg [31:0] mr, reg [31:0] mqb);
                    
    always @(posedge clock) begin
        mwreg <= ewreg;
        mm2reg <= em2reg;
        mwmem <= ewmem;
        mdestReg <= edestReg;
        mr <= r;
        mqb <= eqb;
    end
endmodule

//Data Memory: Initializes values within data memory and reads and writes them
module datMem(input [31:0] mr,[31:0] mqb, mwmem, clock, output reg [31:0] mdo);
    reg [31:0] memory [0:63];
    
    initial begin
        memory[0] <= 32'hA00000AA;
        memory[1] <= 32'h10000011;
        memory[2] <= 32'h20000022;
        memory[3] <= 32'h30000033;
        memory[4] <= 32'h40000044;
        memory[5] <= 32'h50000055;
        memory[6] <= 32'h60000066;
        memory[7] <= 32'h70000077;
        memory[8] <= 32'h80000088;
        memory[9] <= 32'h90000099;
    end
    
    always @(*) mdo <= memory[mr[7:2]];
 
    always @(negedge clock) begin
        if (mwmem != 0) begin
            memory[mr[7:2]] <= mqb;
        end
    end
endmodule

// MEMWB Pipeline Register: Sets values for variables in WB stage using those in the MEM stage
module memWbPipeReg(input mwreg, mm2reg, [4:0] mdestReg, [31:0] mr, [31:0] mdo, clock, output reg wwreg, 
                    wm2reg, reg [4:0] wdestReg, reg [31:0] wr, reg [31:0] wdo);
                    
    always @(posedge clock) begin
        wwreg <= mwreg;
        wm2reg <= mm2reg;
        wdestReg <= mdestReg;
        wr <= mr;
        wdo <= mdo;
    end
endmodule
