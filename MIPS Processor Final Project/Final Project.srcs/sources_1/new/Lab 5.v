`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2023 02:55:00 PM
// Design Name: 
// Module Name: wBMux, regFile
// Project Name: Lab5
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

// Writeback Multiplexor: Determines what data to write back to the register based on the value of wm2reg
module wbMux(input [31:0] wr, [31:0] wdo, wm2reg, output reg [31:0] wbData);
   always @(*) begin
        if (wm2reg != 1) begin
            wbData <= wr;
        end
        else begin
            wbData <= wdo;
        end
    end
    
endmodule

//Updated Register File: Output values in registers located at the addresses in the inputs and writes to the destination register when wwrreg is 1
module regFile(input [4:0] rs, [4:0] rt, [4:0] wdestReg, [31:0] wbData, wwreg, clk, output reg [31:0] qa, reg [31:0] qb, reg [31:0] foo);
    reg [31:0] registers [0:31];
    
    // Initialize all registers to 0
    initial begin
        registers[0] <= 32'h00000000;
        registers[1] <= 32'hA00000AA;
        registers[2] <= 32'h10000011;
        registers[3] <= 32'h20000022;
        registers[4] <= 32'h30000033;
        registers[5] <= 32'h40000044;
        registers[6] <= 32'h50000055;
        registers[7] <= 32'h60000066;
        registers[8] <= 32'h70000077;
        registers[9] <= 32'h80000088;
        registers[10] <= 32'h90000099;
        registers[11] <= 0;
        registers[12] <= 0;
        registers[13] <= 0;
        registers[14] <= 0;
        registers[15] <= 0;
        registers[16] <= 0;
        registers[17] <= 0;
        registers[18] <= 0;
        registers[19] <= 0;
        registers[20] <= 0;
        registers[21] <= 0;
        registers[22] <= 0;
        registers[23] <= 0;
        registers[24] <= 0;
        registers[25] <= 0;
        registers[26] <= 0;
        registers[27] <= 0;
        registers[28] <= 0;
        registers[29] <= 0;
        registers[30] <= 0;
        registers[31] <= 0;
    end
    
    always @(*) begin
        qa <= registers[rs];
        qb <= registers[rt];
    end
    
    always @(negedge clk) begin
        if (wwreg != 0) begin
            registers[wdestReg] <= wbData;
        end
    end
endmodule