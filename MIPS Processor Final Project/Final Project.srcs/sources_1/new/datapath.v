`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2023 04:34:21 PM
// Design Name: 
// Module Name: datapath
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


//Datapath: Runs all the modules together
module datapath(input clock, output wire [31:0] pc, wire [31:0] dinstOut, wire ewreg, em2reg, ewmem, ealuimm, wire [31:0] eqa,
                wire [31:0] eqb, wire [31:0] eimm32, wire [3:0] ealuc, wire [4:0] edestReg, wire mwreg, mm2reg, mwmem, wire [31:0] mqb, 
                wire [31:0] mr, wire [4:0] mdestReg, wire wwreg, wm2reg, wire [4:0] wdestReg, wire [31:0] wr, wire [31:0] wdo);
    
    //Non-Output Wires
    wire [31:0] nextPc;
    wire [31:0] instOut;
    wire [31:0] qa;
    wire [31:0] qb;
    wire [31:0] imm32;
    wire [31:0] b;
    wire [31:0] r;
    wire wreg, m2reg, wmem, aluimm, regrt;
    wire [3:0] aluc;
    wire [4:0] destReg;
    wire [31:0] mdo;
    wire [31:0] wbData;
    wire [31:0] newa;
    wire [31:0] newb;
    wire [1:0] fwda;
    wire [1:0] fwdb;
    
    
    //PC/IF Stage
    progCounter progCounter0 (nextPc, clock, pc);
    instMem insteMem0 (pc, instOut);
    pcAdder pcAdder0 (pc, nextPc);
    
    //IF/ID Stage
    ifidPipeReg ifidPipeReg0 (instOut, clock, dinstOut);
    contUnit contUnit0 (dinstOut[31:26], dinstOut[5:0], dinstOut[25:21], dinstOut[20:16], ewreg, em2reg, edestReg, 
                        mwreg, mm2reg, mdestReg, wreg, m2reg, wmem, aluc, aluimm, regrt, fwda, fwdb);
    
    fwdMuxA fwdMuxA0 (qa, r, mr, do, fwda, newa);
    fwdMuxB fwdMuxB0 (qb, r, mr, do, fwdb, newb);
    regrtMulx regrtMulx0 (dinstOut[20:16], dinstOut[15:11], regrt, destReg);
    immExt immExt0 (dinstOut[15:0], imm32);
    
    //ID/EXE Stage
    idexePipeReg idexePipeReg0 (wreg, m2reg, wmem, aluc, aluimm, destReg, newa, newb, imm32, clock, 
                                ewreg, em2reg, ewmem, ealuc, ealuimm, edestReg, eqa, eqb, eimm32);
    aluMux aluMux0 (eqb, eimm32, ealuimm, b);
    alu alu0 (eqa, b, ealuc, r);
    
    //EXE/MEM Stage
     exeMemPipeReg exeMemPipeReg0 (ewreg, em2reg, ewmem, edestReg, r, eqb, clock, mwreg, mm2reg, mwmem, mdestReg, mr, mqb);
     datMem datMem0 (mr, mqb, mwmem, clock, mdo);
     
     //MEM/WB Stage
     memWbPipeReg memWbPipeReg0 (mwreg, mm2reg, mdestReg, mr, mdo, clock, wwreg, wm2reg, wdestReg, wr, wdo);
     wbMux wbMux0 (wr, wdo, wm2reg, wbData);
     regFile regFile0 (dinstOut[25:21], dinstOut[20:16], wdestReg, wbData, wwreg, clock, qa, qb, foo);
     
endmodule