`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/21 13:21:30
// Design Name: 
// Module Name: lab1_test
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


module lab1_test(
    I_D_0,I_D_1,I_D_2,I_D_3,I_D_4,I_D_5,
    g_m_0,g_m_1,g_m_2,g_m_3,g_m_4,g_m_5,
    mode
    );
input [5:0] I_D_0,I_D_1,I_D_2,I_D_3,I_D_4,I_D_5;
input [5:0] g_m_0,g_m_1,g_m_2,g_m_3,g_m_4,g_m_5;
input [1:0] mode;
// reg and wire for sort
wire [5:0] arr [0:5];

reg [5:0] input_data [5:0];
reg [5:0] largerData_1, largerData_2, largerData_3;
reg [5:0] smallerData_1, smallerData_2, smallerData_3;

reg [5:0] largerData_4, largerData_5;
reg [5:0] smallerData_4, smallerData_5;

reg [5:0] largerData_6, largerData_7;
reg [5:0] smallerData_6, smallerData_7;

reg [5:0] largerData_8, largerData_9;
reg [5:0] smallerData_8, smallerData_9;

reg [5:0] largerData_10;
reg [5:0] smallerData_10;


assign arr[0] = largerData_6;
assign arr[1] = largerData_8;
assign arr[2] = largerData_10;
assign arr[3] = smallerData_10;
assign arr[4] = smallerData_9;
assign arr[5] = smallerData_7;

always @(*) begin
  if(mode[0] == 1'b1)begin
    input_data[0] = I_D_0;
    input_data[1] = I_D_1;
    input_data[2] = I_D_2;
    input_data[3] = I_D_3;
    input_data[4] = I_D_4;
    input_data[5] = I_D_5;
  end
  else begin
    input_data[0] = g_m_0;
    input_data[1] = g_m_1;
    input_data[2] = g_m_2;
    input_data[3] = g_m_3;
    input_data[4] = g_m_4;
    input_data[5] = g_m_5;
  end

  // {largerData_1,smallerData_1} = (input_data[0] > input_data[1])? {input_data[0],input_data[1]}:{input_data[1],input_data[0]};
  // {largerData_2,smallerData_2} = (input_data[2] > input_data[3])? {input_data[2],input_data[3]}:{input_data[3],input_data[2]};
  // {largerData_3,smallerData_3} = (input_data[4] > input_data[5])? {input_data[4],input_data[5]}:{input_data[5],input_data[4]};

  // {largerData_4,smallerData_4} = (largerData_1 > largerData_2)?   {largerData_1,largerData_2}:{largerData_2,largerData_1};
  // {largerData_5,smallerData_5} = (smallerData_2 > smallerData_3)? {smallerData_2,smallerData_3}:{smallerData_3,smallerData_2};

  // {largerData_6,smallerData_6} = (largerData_4 > largerData_3)?   {largerData_4,largerData_3}:{largerData_3,largerData_4};
  // {largerData_7,smallerData_7} = (smallerData_1 > smallerData_5)? {smallerData_1,smallerData_5}:{smallerData_5,smallerData_1};

  // {largerData_8,smallerData_8} = (smallerData_6 > smallerData_4)? {smallerData_6,smallerData_4}:{smallerData_4,smallerData_6};
  // {largerData_9,smallerData_9} = (largerData_5 > largerData_7)?   {largerData_5,largerData_7}:{largerData_7,largerData_5};

  // {largerData_10,smallerData_10} = (smallerData_8 > largerData_9)?{smallerData_8,largerData_9}:{largerData_9,smallerData_9};
  if(input_data[0] > input_data[1]) begin
    largerData_1 = input_data[0];
    smallerData_1 = input_data[1];
  end
  else begin
    largerData_1 = input_data[1];
    smallerData_1 = input_data[0];
  end

  if(input_data[2] > input_data[3]) begin
    largerData_2 = input_data[2];
    smallerData_2 = input_data[3];
  end
  else begin
    largerData_2 = input_data[3];
    smallerData_2 = input_data[2];
  end

  if(input_data[4] > input_data[5]) begin
    largerData_3 = input_data[4];
    smallerData_3 = input_data[5];
  end
  else begin
    largerData_3 = input_data[5];
    smallerData_3 = input_data[4];
  end

  if(largerData_1 > largerData_2) begin
    largerData_4 = largerData_1;
    smallerData_4 = largerData_2;
  end
  else begin
    largerData_4 = largerData_2;
    smallerData_4 = largerData_1;
  end

  if(smallerData_2 > smallerData_3) begin
    largerData_5 = smallerData_2;
    smallerData_5 = smallerData_3;
  end
  else begin
    largerData_5 = smallerData_3;
    smallerData_5 = smallerData_2;
  end

  if(largerData_4 > largerData_3) begin
    largerData_6 = largerData_4;
    smallerData_6 = largerData_3;
  end
  else begin
    largerData_6 = largerData_3;
    smallerData_6 = largerData_4;
  end

  if(smallerData_1 > smallerData_5) begin
    largerData_7 = smallerData_1;
    smallerData_7 = smallerData_5;
  end
  else begin
    largerData_7 = smallerData_5;
    smallerData_7 = smallerData_1;
  end

  if(smallerData_6 > smallerData_4) begin
    largerData_8 = smallerData_6;
    smallerData_8 = smallerData_4;
  end
  else begin
    largerData_8 = smallerData_4;
    smallerData_8 = smallerData_6;
  end

  if(largerData_5 > largerData_7) begin
    largerData_9 = largerData_5;
    smallerData_9 = largerData_7;
  end
  else begin
    largerData_9 = largerData_7;
    smallerData_9 = largerData_5;
  end

  if(smallerData_8 > largerData_9) begin
    largerData_10 = smallerData_8;
    smallerData_10 = largerData_9;
  end
  else begin
    largerData_10 = largerData_9;
    smallerData_10 = largerData_8;
  end

end

endmodule
