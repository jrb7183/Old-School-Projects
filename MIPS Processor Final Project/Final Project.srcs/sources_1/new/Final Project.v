`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2023 03:33:55 PM
// Design Name: 
// Module Name: contUnit, fwdMuxA, fwdMuxB
// Project Name: Final Project
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

// Control Unit: takes in op and function and other values to determine output control values
module contUnit(input [5:0] op, [5:0] func, [4:0] rs, [4:0] rt, ewreg, em2reg, [4:0] edestReg, 
                mwreg, mm2reg, [4:0] mdestReg, output reg wreg, reg m2reg, reg wmem, 
                reg [3:0] aluc, reg aluimm, reg regrt, reg [1:0] fwda, reg [1:0] fwdb);
    
    always @ (*) begin
        case (op)
            6'b000000: // Case for R-type instructions
            begin
                wreg <= 1;
                m2reg <= 0;
                wmem <= 0;
                aluimm <= 0;
                regrt <= 0;
             
                case (func)
                    6'b100000: aluc <= 2; // Add
                    
                    6'b100010: aluc <= 6; // Subtract
                    
                    6'b100100: aluc <= 0; // AND
                    
                    6'b100101: aluc <= 1; // OR
                    
                    6'b100110: aluc <= 3; // XOR
                    
                    6'b101010: aluc <= 7; // Set on less than (slt)
                endcase
            end
            
            6'b100011: // Case for load word
            begin
                wreg <= 1;
                m2reg <= 1;
                wmem <= 0;
                aluc <= 2;
                aluimm <= 1;
                regrt <= 1;
            end
            
            6'b101011: // Case for save word
            begin
                wreg <= 0;
                wmem <= 1;
                aluc <= 2;
                aluimm <= 1;
            end
            
            6'b100011: // Case for branch
            begin
                wreg <= 0;
                wmem <= 0;
                aluc <= 6;
                aluimm <= 0;
            end
        endcase
        
        
        case (rs)
            edestReg: fwda <= (ewreg != 0) ? ((em2reg != 1) ? 1 : 0) : 0;
            
            mdestReg: fwda <= (mwreg != 0) ? ((mm2reg != 1) ? 2 : 3) : 0;
            
            default: fwda <= 0;
        endcase
        
        case (rt)
            edestReg: fwdb <= (ewreg != 0) ? ((em2reg != 1) ? 1 : 0) : 0;
            
            mdestReg: fwdb <= (mwreg != 0) ? ((mm2reg != 1) ? 2 : 3) : 0;
            
            default: fwdb <= 0;
        endcase
    end
    
endmodule


// Forward A Multiplexor: forwards data in transit to the first ALU input if necessary
module fwdMuxA(input [31:0] qa, [31:0] r, [31:0] mr, [31:0] do, [1:0] fwda, output reg [31:0] newa);
    always @(*) begin
        case (fwda)
            0: newa <= qa;
            
            1: newa <= r;
            
            2: newa <= mr;
            
            3: newa <= do;
        endcase
    end
endmodule


// Forward B Multiplexor: forwards data in transit to the second ALU input if necessary
module fwdMuxB(input [31:0] qb, [31:0] r, [31:0] mr, [31:0] do, [1:0] fwdb, output reg [31:0] newb);
    always @(*) begin
        case (fwdb)
            2'b00: newb <= qb;
            
            2'b01: newb <= r;
            
            2'b10: newb <= mr;
            
            2'b11: newb <= do;
        endcase
    end
endmodule


