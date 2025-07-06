`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2023 07:37:44 PM
// Design Name: 
// Module Name: testbench
// Project Name: 
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


module testbench();
    reg clk;
    wire [31:0] pc; 
    wire [31:0] dinstOut;
    wire ewreg, em2reg, ewmem, mwreg, mm2reg, mwmem, wwreg, wm2reg;
    wire [3:0] ealuc;
    wire ealuimm;
    wire [31:0] eqa; 
    wire [31:0] eqb;
    wire [31:0] mr;
    wire [31:0] wr;
    wire [31:0] mqb;
    wire [31:0] eimm32;
    wire [4:0] edestReg;
    wire [4:0] mdestReg;
    wire [4:0] wdestReg;
    wire [31:0] wdo;
 
    datapath datapathTb (clk, pc, dinstOut, ewreg, em2reg, ewmem, ealuimm, eqa, eqb, eimm32, ealuc, edestReg, 
                         mwreg, mm2reg, mwmem, mqb, mr, mdestReg, wwreg, wm2reg, wdestReg, wr, wdo);
 
    initial begin
       clk = 0;
    end
    always begin
       #5;
       clk = ~clk;
    end
endmodule
