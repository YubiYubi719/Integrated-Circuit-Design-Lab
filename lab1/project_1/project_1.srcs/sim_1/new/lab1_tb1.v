`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/21 14:37:38
// Design Name: 
// Module Name: lab1_tb1
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


module lab1_tb1(
    I_D_0,I_D_1,I_D_2,I_D_3,I_D_4,I_D_5,
    g_m_0,g_m_1,g_m_2,g_m_3,g_m_4,g_m_5,
    mode
    );
output reg [5:0] I_D_0,I_D_1,I_D_2,I_D_3,I_D_4,I_D_5;
output reg [5:0] g_m_0,g_m_1,g_m_2,g_m_3,g_m_4,g_m_5;
output reg [1:0] mode;
lab1_test test1(I_D_0,I_D_1,I_D_2,I_D_3,I_D_4,I_D_5,g_m_0,g_m_1,g_m_2,g_m_3,g_m_4,g_m_5,mode);
initial begin
I_D_0 = 0; I_D_1 = 0; I_D_2 = 0; I_D_3 = 0; I_D_4 = 0; I_D_5 = 0;
g_m_0 = 0; g_m_1 = 0; g_m_2 = 0; g_m_3 = 0; g_m_4 = 0; g_m_5 = 0;
mode = 0;

#100;
I_D_0 = 6'd2; I_D_1 = 6'd5; I_D_2 = 6'd3; I_D_3 = 6'd14; I_D_4 = 6'd8; I_D_5 = 6'd18;
mode = 2'b11;
end
endmodule
