//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Si2 LAB @NYCU ED430
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Midterm Proejct            : MRA  
//   Author                     : Lin-Hung, Lai
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : MRA.v
//   Module Name : MRA
//   Release version : V2.0 (Release Date: 2023-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module MRA(
	// CHIP IO
	clk            	,	
	rst_n          	,	
	in_valid       	,	
	frame_id        ,	
	net_id         	,	  
	loc_x          	,	  
    loc_y         	,
	cost	 		,		
	busy         	,

    // AXI4 IO
	     arid_m_inf,
	   araddr_m_inf,
	    arlen_m_inf,
	   arsize_m_inf,
	  arburst_m_inf,
	  arvalid_m_inf,
	  arready_m_inf,
	
	      rid_m_inf,
	    rdata_m_inf,
	    rresp_m_inf,
	    rlast_m_inf,
	   rvalid_m_inf,
	   rready_m_inf,
	
	     awid_m_inf,
	   awaddr_m_inf,
	   awsize_m_inf,
	  awburst_m_inf,
	    awlen_m_inf,
	  awvalid_m_inf,
	  awready_m_inf,
	
	    wdata_m_inf,
	    wlast_m_inf,
	   wvalid_m_inf,
	   wready_m_inf,
	
	      bid_m_inf,
	    bresp_m_inf,
	   bvalid_m_inf,
	   bready_m_inf 
);

// ===============================================================
//  					Input / Output 
// ===============================================================

// << CHIP io port with system >>
input 			  	clk,rst_n;
input 			   	in_valid;
input  [4:0] 		frame_id;
input  [3:0]       	net_id;     
input  [5:0]       	loc_x; 
input  [5:0]       	loc_y; 
output reg [13:0] 	cost;
output reg          busy;       
  
// AXI Interface wire connection for pseudo DRAM read/write
/* Hint:
       Your AXI-4 interface could be designed as a bridge in submodule,
	   therefore I declared output of AXI as wire.  
	   Ex: AXI4_interface AXI4_INF(...);
*/
parameter ID_WIDTH=4, DATA_WIDTH=128, ADDR_WIDTH=32;    // DO NOT modify AXI4 Parameter
// ------------------------
// <<<<< AXI READ >>>>>
// ------------------------
// (1)	axi read address channel 
output wire [ID_WIDTH-1:0]      arid_m_inf;
output wire [1:0]            arburst_m_inf;
output wire [2:0]             arsize_m_inf;
output wire [7:0]              arlen_m_inf;
output wire                  arvalid_m_inf;
input  wire                  arready_m_inf;
output wire [ADDR_WIDTH-1:0]  araddr_m_inf;
// ------------------------
// (2)	axi read data channel 
input  wire [ID_WIDTH-1:0]       rid_m_inf;
input  wire                   rvalid_m_inf;
output wire                   rready_m_inf;
input  wire [DATA_WIDTH-1:0]   rdata_m_inf;
input  wire                    rlast_m_inf;
input  wire [1:0]              rresp_m_inf;
// ------------------------
// <<<<< AXI WRITE >>>>>
// ------------------------
// (1) 	axi write address channel 
output wire [ID_WIDTH-1:0]      awid_m_inf;
output wire [1:0]            awburst_m_inf;
output wire [2:0]             awsize_m_inf;
output wire [7:0]              awlen_m_inf;
output wire                  awvalid_m_inf;
input  wire                  awready_m_inf;
output wire [ADDR_WIDTH-1:0]  awaddr_m_inf;
// -------------------------
// (2)	axi write data channel 
output wire                   wvalid_m_inf;
input  wire                   wready_m_inf;
output wire [DATA_WIDTH-1:0]   wdata_m_inf;
output wire                    wlast_m_inf;
// -------------------------
// (3)	axi write response channel 
input  wire  [ID_WIDTH-1:0]      bid_m_inf;
input  wire                   bvalid_m_inf;
output wire                   bready_m_inf;
input  wire  [1:0]             bresp_m_inf;
// -----------------------------
reg [5:0] src_x [0:14]; // source x
reg [5:0] src_y [0:14]; // source y
reg [5:0] tar_x [0:14]; // target x
reg [5:0] tar_y [0:14]; // target y
reg src_or_tar; // 0: src, 1: tar
reg [3:0] netID_cnt;
reg [3:0] netID [0:14];
reg [6:0] cnt_127;
reg [4:0] frame_id_reg;
reg data_type;
reg [127:0] dram_output;
wire [3:0] curNetID;
reg [1:0] BFS_cnt;
reg [13:0] total_cost;
reg [5:0] cur_x;
reg [5:0] cur_y;
reg [3:0] weight_out_reg;
reg [127:0] map_out_reg;
reg cnt_1;
wire [5:0] offset;
wire isFound_tar;
wire isFound_src;
reg [127:0] dram_input;
reg [3:0] netID_idx;
reg weightdone;
// SRAM control signals
// map
reg [6:0]   map_addr;
reg [127:0] map_in;
reg [127:0] map_out;
reg         map_web;
// weight
reg [6:0]   weight_addr;
reg [127:0] weight_in;
reg [127:0] weight_out;
reg         weight_web;

reg [1:0] map_reg [0:63][0:63]; // 00: empty, 01: block, 

integer i, j, k;

parameter IDLE = 4'd0,
		  READ_INPUT = 4'd1,
		  DRAM_READ = 4'd2, // get map into map_reg and MAP(SRAM)
		  INIT_MAP = 4'd3,
		  GET_WEIGHT_AND_BFS = 4'd4,
		  RETRACE_PATH = 4'd5,
		  CLEAR_MAP_REG = 4'd6,
		  DRAM_WRITE = 4'd7,
		  BUFFER = 4'd8;

reg [3:0] curState, nextState;

MEM MAP(
	.A0  (map_addr[0]),   .A1  (map_addr[1]),   .A2  (map_addr[2]),   .A3  (map_addr[3]),   .A4  (map_addr[4]),   .A5  (map_addr[5]),   .A6  (map_addr[6]),

	.DO0 (map_out[0]),   .DO1 (map_out[1]),   .DO2 (map_out[2]),   .DO3 (map_out[3]),   .DO4 (map_out[4]),   .DO5 (map_out[5]),   .DO6 (map_out[6]),   .DO7 (map_out[7]),
	.DO8 (map_out[8]),   .DO9 (map_out[9]),   .DO10(map_out[10]),  .DO11(map_out[11]),  .DO12(map_out[12]),  .DO13(map_out[13]),  .DO14(map_out[14]),  .DO15(map_out[15]),
	.DO16(map_out[16]),  .DO17(map_out[17]),  .DO18(map_out[18]),  .DO19(map_out[19]),  .DO20(map_out[20]),  .DO21(map_out[21]),  .DO22(map_out[22]),  .DO23(map_out[23]),
	.DO24(map_out[24]),  .DO25(map_out[25]),  .DO26(map_out[26]),  .DO27(map_out[27]),  .DO28(map_out[28]),  .DO29(map_out[29]),  .DO30(map_out[30]),  .DO31(map_out[31]),
	.DO32(map_out[32]),  .DO33(map_out[33]),  .DO34(map_out[34]),  .DO35(map_out[35]),  .DO36(map_out[36]),  .DO37(map_out[37]),  .DO38(map_out[38]),  .DO39(map_out[39]),
	.DO40(map_out[40]),  .DO41(map_out[41]),  .DO42(map_out[42]),  .DO43(map_out[43]),  .DO44(map_out[44]),  .DO45(map_out[45]),  .DO46(map_out[46]),  .DO47(map_out[47]),
	.DO48(map_out[48]),  .DO49(map_out[49]),  .DO50(map_out[50]),  .DO51(map_out[51]),  .DO52(map_out[52]),  .DO53(map_out[53]),  .DO54(map_out[54]),  .DO55(map_out[55]),
	.DO56(map_out[56]),  .DO57(map_out[57]),  .DO58(map_out[58]),  .DO59(map_out[59]),  .DO60(map_out[60]),  .DO61(map_out[61]),  .DO62(map_out[62]),  .DO63(map_out[63]),
	.DO64(map_out[64]),  .DO65(map_out[65]),  .DO66(map_out[66]),  .DO67(map_out[67]),  .DO68(map_out[68]),  .DO69(map_out[69]),  .DO70(map_out[70]),  .DO71(map_out[71]),
	.DO72(map_out[72]),  .DO73(map_out[73]),  .DO74(map_out[74]),  .DO75(map_out[75]),  .DO76(map_out[76]),  .DO77(map_out[77]),  .DO78(map_out[78]),  .DO79(map_out[79]),
	.DO80(map_out[80]),  .DO81(map_out[81]),  .DO82(map_out[82]),  .DO83(map_out[83]),  .DO84(map_out[84]),  .DO85(map_out[85]),  .DO86(map_out[86]),  .DO87(map_out[87]),
	.DO88(map_out[88]),  .DO89(map_out[89]),  .DO90(map_out[90]),  .DO91(map_out[91]),  .DO92(map_out[92]),  .DO93(map_out[93]),  .DO94(map_out[94]),  .DO95(map_out[95]),
	.DO96(map_out[96]),  .DO97(map_out[97]),  .DO98(map_out[98]),  .DO99(map_out[99]),  .DO100(map_out[100]),.DO101(map_out[101]),.DO102(map_out[102]),.DO103(map_out[103]),
	.DO104(map_out[104]),.DO105(map_out[105]),.DO106(map_out[106]),.DO107(map_out[107]),.DO108(map_out[108]),.DO109(map_out[109]),.DO110(map_out[110]),.DO111(map_out[111]),
	.DO112(map_out[112]),.DO113(map_out[113]),.DO114(map_out[114]),.DO115(map_out[115]),.DO116(map_out[116]),.DO117(map_out[117]),.DO118(map_out[118]),.DO119(map_out[119]),
	.DO120(map_out[120]),.DO121(map_out[121]),.DO122(map_out[122]),.DO123(map_out[123]),.DO124(map_out[124]),.DO125(map_out[125]),.DO126(map_out[126]),.DO127(map_out[127]),

	.DI0 (map_in[0]),   .DI1 (map_in[1]),   .DI2 (map_in[2]),   .DI3 (map_in[3]),   .DI4 (map_in[4]),   .DI5 (map_in[5]),   .DI6 (map_in[6]),   .DI7 (map_in[7]),
	.DI8 (map_in[8]),   .DI9 (map_in[9]),   .DI10(map_in[10]),  .DI11(map_in[11]),  .DI12(map_in[12]),  .DI13(map_in[13]),  .DI14(map_in[14]),  .DI15(map_in[15]),
	.DI16(map_in[16]),  .DI17(map_in[17]),  .DI18(map_in[18]),  .DI19(map_in[19]),  .DI20(map_in[20]),  .DI21(map_in[21]),  .DI22(map_in[22]),  .DI23(map_in[23]),
	.DI24(map_in[24]),  .DI25(map_in[25]),  .DI26(map_in[26]),  .DI27(map_in[27]),  .DI28(map_in[28]),  .DI29(map_in[29]),  .DI30(map_in[30]),  .DI31(map_in[31]),
	.DI32(map_in[32]),  .DI33(map_in[33]),  .DI34(map_in[34]),  .DI35(map_in[35]),  .DI36(map_in[36]),  .DI37(map_in[37]),  .DI38(map_in[38]),  .DI39(map_in[39]),
	.DI40(map_in[40]),  .DI41(map_in[41]),  .DI42(map_in[42]),  .DI43(map_in[43]),  .DI44(map_in[44]),  .DI45(map_in[45]),  .DI46(map_in[46]),  .DI47(map_in[47]),
	.DI48(map_in[48]),  .DI49(map_in[49]),  .DI50(map_in[50]),  .DI51(map_in[51]),  .DI52(map_in[52]),  .DI53(map_in[53]),  .DI54(map_in[54]),  .DI55(map_in[55]),
	.DI56(map_in[56]),  .DI57(map_in[57]),  .DI58(map_in[58]),  .DI59(map_in[59]),  .DI60(map_in[60]),  .DI61(map_in[61]),  .DI62(map_in[62]),  .DI63(map_in[63]),
	.DI64(map_in[64]),  .DI65(map_in[65]),  .DI66(map_in[66]),  .DI67(map_in[67]),  .DI68(map_in[68]),  .DI69(map_in[69]),  .DI70(map_in[70]),  .DI71(map_in[71]),
	.DI72(map_in[72]),  .DI73(map_in[73]),  .DI74(map_in[74]),  .DI75(map_in[75]),  .DI76(map_in[76]),  .DI77(map_in[77]),  .DI78(map_in[78]),  .DI79(map_in[79]),
	.DI80(map_in[80]),  .DI81(map_in[81]),  .DI82(map_in[82]),  .DI83(map_in[83]),  .DI84(map_in[84]),  .DI85(map_in[85]),  .DI86(map_in[86]),  .DI87(map_in[87]),
	.DI88(map_in[88]),  .DI89(map_in[89]),  .DI90(map_in[90]),  .DI91(map_in[91]),  .DI92(map_in[92]),  .DI93(map_in[93]),  .DI94(map_in[94]),  .DI95(map_in[95]),
	.DI96(map_in[96]),  .DI97(map_in[97]),  .DI98(map_in[98]),  .DI99(map_in[99]),  .DI100(map_in[100]),.DI101(map_in[101]),.DI102(map_in[102]),.DI103(map_in[103]),
	.DI104(map_in[104]),.DI105(map_in[105]),.DI106(map_in[106]),.DI107(map_in[107]),.DI108(map_in[108]),.DI109(map_in[109]),.DI110(map_in[110]),.DI111(map_in[111]),
	.DI112(map_in[112]),.DI113(map_in[113]),.DI114(map_in[114]),.DI115(map_in[115]),.DI116(map_in[116]),.DI117(map_in[117]),.DI118(map_in[118]),.DI119(map_in[119]),
	.DI120(map_in[120]),.DI121(map_in[121]),.DI122(map_in[122]),.DI123(map_in[123]),.DI124(map_in[124]),.DI125(map_in[125]),.DI126(map_in[126]),.DI127(map_in[127]),

	.CK(clk), .WEB(map_web), .OE(1'b1), .CS(1'b1)
);
MEM WEIGHT(
	.A0  (weight_addr[0]),   .A1  (weight_addr[1]),   .A2  (weight_addr[2]),   .A3  (weight_addr[3]),   .A4  (weight_addr[4]),   .A5  (weight_addr[5]),   .A6  (weight_addr[6]),

	.DO0 (weight_out[0]),   .DO1 (weight_out[1]),   .DO2 (weight_out[2]),   .DO3 (weight_out[3]),   .DO4 (weight_out[4]),   .DO5 (weight_out[5]),   .DO6 (weight_out[6]),   .DO7 (weight_out[7]),
	.DO8 (weight_out[8]),   .DO9 (weight_out[9]),   .DO10(weight_out[10]),  .DO11(weight_out[11]),  .DO12(weight_out[12]),  .DO13(weight_out[13]),  .DO14(weight_out[14]),  .DO15(weight_out[15]),
	.DO16(weight_out[16]),  .DO17(weight_out[17]),  .DO18(weight_out[18]),  .DO19(weight_out[19]),  .DO20(weight_out[20]),  .DO21(weight_out[21]),  .DO22(weight_out[22]),  .DO23(weight_out[23]),
	.DO24(weight_out[24]),  .DO25(weight_out[25]),  .DO26(weight_out[26]),  .DO27(weight_out[27]),  .DO28(weight_out[28]),  .DO29(weight_out[29]),  .DO30(weight_out[30]),  .DO31(weight_out[31]),
	.DO32(weight_out[32]),  .DO33(weight_out[33]),  .DO34(weight_out[34]),  .DO35(weight_out[35]),  .DO36(weight_out[36]),  .DO37(weight_out[37]),  .DO38(weight_out[38]),  .DO39(weight_out[39]),
	.DO40(weight_out[40]),  .DO41(weight_out[41]),  .DO42(weight_out[42]),  .DO43(weight_out[43]),  .DO44(weight_out[44]),  .DO45(weight_out[45]),  .DO46(weight_out[46]),  .DO47(weight_out[47]),
	.DO48(weight_out[48]),  .DO49(weight_out[49]),  .DO50(weight_out[50]),  .DO51(weight_out[51]),  .DO52(weight_out[52]),  .DO53(weight_out[53]),  .DO54(weight_out[54]),  .DO55(weight_out[55]),
	.DO56(weight_out[56]),  .DO57(weight_out[57]),  .DO58(weight_out[58]),  .DO59(weight_out[59]),  .DO60(weight_out[60]),  .DO61(weight_out[61]),  .DO62(weight_out[62]),  .DO63(weight_out[63]),
	.DO64(weight_out[64]),  .DO65(weight_out[65]),  .DO66(weight_out[66]),  .DO67(weight_out[67]),  .DO68(weight_out[68]),  .DO69(weight_out[69]),  .DO70(weight_out[70]),  .DO71(weight_out[71]),
	.DO72(weight_out[72]),  .DO73(weight_out[73]),  .DO74(weight_out[74]),  .DO75(weight_out[75]),  .DO76(weight_out[76]),  .DO77(weight_out[77]),  .DO78(weight_out[78]),  .DO79(weight_out[79]),
	.DO80(weight_out[80]),  .DO81(weight_out[81]),  .DO82(weight_out[82]),  .DO83(weight_out[83]),  .DO84(weight_out[84]),  .DO85(weight_out[85]),  .DO86(weight_out[86]),  .DO87(weight_out[87]),
	.DO88(weight_out[88]),  .DO89(weight_out[89]),  .DO90(weight_out[90]),  .DO91(weight_out[91]),  .DO92(weight_out[92]),  .DO93(weight_out[93]),  .DO94(weight_out[94]),  .DO95(weight_out[95]),
	.DO96(weight_out[96]),  .DO97(weight_out[97]),  .DO98(weight_out[98]),  .DO99(weight_out[99]),  .DO100(weight_out[100]),.DO101(weight_out[101]),.DO102(weight_out[102]),.DO103(weight_out[103]),
	.DO104(weight_out[104]),.DO105(weight_out[105]),.DO106(weight_out[106]),.DO107(weight_out[107]),.DO108(weight_out[108]),.DO109(weight_out[109]),.DO110(weight_out[110]),.DO111(weight_out[111]),
	.DO112(weight_out[112]),.DO113(weight_out[113]),.DO114(weight_out[114]),.DO115(weight_out[115]),.DO116(weight_out[116]),.DO117(weight_out[117]),.DO118(weight_out[118]),.DO119(weight_out[119]),
	.DO120(weight_out[120]),.DO121(weight_out[121]),.DO122(weight_out[122]),.DO123(weight_out[123]),.DO124(weight_out[124]),.DO125(weight_out[125]),.DO126(weight_out[126]),.DO127(weight_out[127]),

	.DI0 (weight_in[0]),   .DI1 (weight_in[1]),   .DI2 (weight_in[2]),   .DI3 (weight_in[3]),   .DI4 (weight_in[4]),   .DI5 (weight_in[5]),   .DI6 (weight_in[6]),   .DI7 (weight_in[7]),
	.DI8 (weight_in[8]),   .DI9 (weight_in[9]),   .DI10(weight_in[10]),  .DI11(weight_in[11]),  .DI12(weight_in[12]),  .DI13(weight_in[13]),  .DI14(weight_in[14]),  .DI15(weight_in[15]),
	.DI16(weight_in[16]),  .DI17(weight_in[17]),  .DI18(weight_in[18]),  .DI19(weight_in[19]),  .DI20(weight_in[20]),  .DI21(weight_in[21]),  .DI22(weight_in[22]),  .DI23(weight_in[23]),
	.DI24(weight_in[24]),  .DI25(weight_in[25]),  .DI26(weight_in[26]),  .DI27(weight_in[27]),  .DI28(weight_in[28]),  .DI29(weight_in[29]),  .DI30(weight_in[30]),  .DI31(weight_in[31]),
	.DI32(weight_in[32]),  .DI33(weight_in[33]),  .DI34(weight_in[34]),  .DI35(weight_in[35]),  .DI36(weight_in[36]),  .DI37(weight_in[37]),  .DI38(weight_in[38]),  .DI39(weight_in[39]),
	.DI40(weight_in[40]),  .DI41(weight_in[41]),  .DI42(weight_in[42]),  .DI43(weight_in[43]),  .DI44(weight_in[44]),  .DI45(weight_in[45]),  .DI46(weight_in[46]),  .DI47(weight_in[47]),
	.DI48(weight_in[48]),  .DI49(weight_in[49]),  .DI50(weight_in[50]),  .DI51(weight_in[51]),  .DI52(weight_in[52]),  .DI53(weight_in[53]),  .DI54(weight_in[54]),  .DI55(weight_in[55]),
	.DI56(weight_in[56]),  .DI57(weight_in[57]),  .DI58(weight_in[58]),  .DI59(weight_in[59]),  .DI60(weight_in[60]),  .DI61(weight_in[61]),  .DI62(weight_in[62]),  .DI63(weight_in[63]),
	.DI64(weight_in[64]),  .DI65(weight_in[65]),  .DI66(weight_in[66]),  .DI67(weight_in[67]),  .DI68(weight_in[68]),  .DI69(weight_in[69]),  .DI70(weight_in[70]),  .DI71(weight_in[71]),
	.DI72(weight_in[72]),  .DI73(weight_in[73]),  .DI74(weight_in[74]),  .DI75(weight_in[75]),  .DI76(weight_in[76]),  .DI77(weight_in[77]),  .DI78(weight_in[78]),  .DI79(weight_in[79]),
	.DI80(weight_in[80]),  .DI81(weight_in[81]),  .DI82(weight_in[82]),  .DI83(weight_in[83]),  .DI84(weight_in[84]),  .DI85(weight_in[85]),  .DI86(weight_in[86]),  .DI87(weight_in[87]),
	.DI88(weight_in[88]),  .DI89(weight_in[89]),  .DI90(weight_in[90]),  .DI91(weight_in[91]),  .DI92(weight_in[92]),  .DI93(weight_in[93]),  .DI94(weight_in[94]),  .DI95(weight_in[95]),
	.DI96(weight_in[96]),  .DI97(weight_in[97]),  .DI98(weight_in[98]),  .DI99(weight_in[99]),  .DI100(weight_in[100]),.DI101(weight_in[101]),.DI102(weight_in[102]),.DI103(weight_in[103]),
	.DI104(weight_in[104]),.DI105(weight_in[105]),.DI106(weight_in[106]),.DI107(weight_in[107]),.DI108(weight_in[108]),.DI109(weight_in[109]),.DI110(weight_in[110]),.DI111(weight_in[111]),
	.DI112(weight_in[112]),.DI113(weight_in[113]),.DI114(weight_in[114]),.DI115(weight_in[115]),.DI116(weight_in[116]),.DI117(weight_in[117]),.DI118(weight_in[118]),.DI119(weight_in[119]),
	.DI120(weight_in[120]),.DI121(weight_in[121]),.DI122(weight_in[122]),.DI123(weight_in[123]),.DI124(weight_in[124]),.DI125(weight_in[125]),.DI126(weight_in[126]),.DI127(weight_in[127]),

	.CK(clk), .WEB(weight_web), .OE(1'b1), .CS(1'b1)
);
AXI4_READ axi_read(
	// input signals
		.clk(clk), .rst_n(rst_n), .data_type(data_type),
		.curState(curState),
		.frame_id(frame_id_reg),
		.arready_m_inf(arready_m_inf),
		.rid_m_inf(rid_m_inf),
		.rvalid_m_inf(rvalid_m_inf),
		.rdata_m_inf(rdata_m_inf),
		.rlast_m_inf(rlast_m_inf),
		.rresp_m_inf(rresp_m_inf),
		.weightdone(weightdone),
	// output signals
		.dram_output(dram_output),
		.arid_m_inf(arid_m_inf),
		.arburst_m_inf(arburst_m_inf),
		.arsize_m_inf(arsize_m_inf),
		.arlen_m_inf(arlen_m_inf),
		.arvalid_m_inf(arvalid_m_inf),
		.araddr_m_inf(araddr_m_inf),
		.rready_m_inf(rready_m_inf)
);
AXI4_WRITE axi_write(
	// input signals
		.clk(clk), .rst_n(rst_n),
		.curState(curState),
		.frame_id(frame_id_reg),
		.dram_input(map_out), //todo
		.awready_m_inf(awready_m_inf),
		.wready_m_inf(wready_m_inf),
		.bid_m_inf(bid_m_inf),
		.bvalid_m_inf(bvalid_m_inf),
		.bresp_m_inf(bresp_m_inf),
	// output signals
		.awid_m_inf(awid_m_inf),
		.awburst_m_inf(awburst_m_inf),
		.awsize_m_inf(awsize_m_inf),
		.awlen_m_inf(awlen_m_inf),
		.awvalid_m_inf(awvalid_m_inf),
		.awaddr_m_inf(awaddr_m_inf),
		.wvalid_m_inf(wvalid_m_inf),
		.wdata_m_inf(wdata_m_inf),
		.wlast_m_inf(wlast_m_inf),
		.bready_m_inf(bready_m_inf)
);

assign offset = (cnt_127[0])? 6'd32:6'd0;
assign isFound_tar = (map_reg[tar_y[netID_idx]][tar_x[netID_idx]] != 0)? 1'b1:1'b0;
assign isFound_src = (cur_x == src_x[netID_idx] && cur_y == src_y[netID_idx])? 1'b1:1'b0;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) weightdone<=0;
	else begin
		if (curState==GET_WEIGHT_AND_BFS&&rlast_m_inf) weightdone<=1;
		else if (curState==IDLE) weightdone<=0;
	end
end

// curState
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) curState <= IDLE;
	else curState <= nextState;
end
// nextState
always @(*) begin
	if(!rst_n) nextState = IDLE;
	else begin
		case(curState)
		IDLE: begin
			if(in_valid) nextState = READ_INPUT;
			else nextState = curState;
		end
		READ_INPUT: begin
			if(!in_valid) nextState = DRAM_READ;
			else nextState = curState;
		end
		DRAM_READ: begin
			if(rlast_m_inf) nextState = INIT_MAP;
			else nextState = curState;
		end
		INIT_MAP: begin
			nextState = GET_WEIGHT_AND_BFS;
		end
		GET_WEIGHT_AND_BFS: begin
			if(netID_idx == 0 && rlast_m_inf) nextState = RETRACE_PATH;
			else if(netID_idx != 0 && map_reg[tar_y[netID_idx]][tar_x[netID_idx]][1]) nextState = RETRACE_PATH;
			else nextState = curState;
		end
		RETRACE_PATH: begin
			if(cur_x == src_x[netID_idx] && cur_y == src_y[netID_idx] && netID_idx == netID_cnt - 1) nextState = DRAM_WRITE;
			else if(cur_x == src_x[netID_idx] && cur_y == src_y[netID_idx]) nextState = CLEAR_MAP_REG;
			else nextState = curState;
		end
		CLEAR_MAP_REG: begin
			nextState = INIT_MAP;
		end
		DRAM_WRITE: begin
			if(cnt_127 == 127) nextState = BUFFER;
			else nextState = curState;
		end
		BUFFER: begin
			nextState = IDLE;
		end
		default: nextState = IDLE;
		endcase
	end
end

// busy
always @(*) begin
	busy = 1;
	if(curState == IDLE || curState == READ_INPUT) busy = 0;
end
// src_or_tar
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) src_or_tar <= 0;
	else if(curState == IDLE && nextState == IDLE) src_or_tar <= 0;
	else if(nextState == READ_INPUT) begin
		if(src_or_tar == 1) src_or_tar <= 0;
		else src_or_tar <= src_or_tar + 1;
	end
end
// netID_cnt
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) netID_cnt <= 0;
	else if(curState == IDLE && nextState == IDLE) netID_cnt <= 0;
	else if(nextState == READ_INPUT && src_or_tar == 1) begin
		netID_cnt <= netID_cnt + 1;
	end
end
// netID
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 15; i = i+1) begin
			netID[i] <= 0;
		end
	end
	else if(curState == IDLE && nextState == IDLE) begin
		for(i = 0; i < 15; i = i+1) begin
			netID[i] <= 0;
		end
	end
	else if(nextState == READ_INPUT && src_or_tar == 0) begin
		netID[netID_cnt] <= net_id;
	end
end
// netID_idx
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) netID_idx <= 0;
	else if(curState == IDLE) netID_idx <= 0;
	else if(curState == CLEAR_MAP_REG) netID_idx <= netID_idx + 1;
end

// src_x, src_y, tar_x, tar_y
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 15; i = i+1) begin
			src_x[i] <= 0;
			src_y[i] <= 0;
			tar_x[i] <= 0;
			tar_y[i] <= 0;
		end
	end
	else if(curState == IDLE && nextState == IDLE) begin
		for(i = 0; i < 15; i = i+1) begin
			src_x[i] <= 0;
			src_y[i] <= 0;
			tar_x[i] <= 0;
			tar_y[i] <= 0;
		end
	end
	else begin
		if(nextState == READ_INPUT) begin
			if(src_or_tar == 0) begin
				src_x[netID_cnt] <= loc_x;
				src_y[netID_cnt] <= loc_y;
			end
			else if(src_or_tar == 1) begin
				tar_x[netID_cnt] <= loc_x;
				tar_y[netID_cnt] <= loc_y;
			end
		end
	end
end
// frame_id_reg
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) frame_id_reg <= 0;
	else if(curState == IDLE && nextState == IDLE) frame_id_reg <= 0;
	else if(nextState == READ_INPUT) frame_id_reg <= frame_id;
end
// data_type
always @(*) begin
	if(curState == DRAM_READ) data_type = 0;
	else  data_type = 1;
end

// map_reg
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 64; i = i+1) begin
			for(j = 0; j < 64; j = j+1) begin
				map_reg[i][j] <= 0;
			end
		end
	end
	// else if(curState == IDLE) begin
	// 	for(i = 0; i < 64; i = i+1) begin
	// 		for(j = 0; j < 64; j = j+1) begin
	// 			map_reg[i][j] <= 0;
	// 		end
	// 	end
	// end
	else if(curState == DRAM_READ && rvalid_m_inf) begin
		map_reg[cnt_127[6:1]][offset + 0] <= rdata_m_inf[3:0]? 1:0;
		map_reg[cnt_127[6:1]][offset + 1] <= rdata_m_inf[7:4]? 1:0;
		map_reg[cnt_127[6:1]][offset + 2] <= rdata_m_inf[11:8]? 1:0;
		map_reg[cnt_127[6:1]][offset + 3] <= rdata_m_inf[15:12]? 1:0;
		map_reg[cnt_127[6:1]][offset + 4] <= rdata_m_inf[19:16]? 1:0;
		map_reg[cnt_127[6:1]][offset + 5] <= rdata_m_inf[23:20]? 1:0;
		map_reg[cnt_127[6:1]][offset + 6] <= rdata_m_inf[27:24]? 1:0;
		map_reg[cnt_127[6:1]][offset + 7] <= rdata_m_inf[31:28]? 1:0;
		map_reg[cnt_127[6:1]][offset + 8] <= rdata_m_inf[35:32]? 1:0;
		map_reg[cnt_127[6:1]][offset + 9] <= rdata_m_inf[39:36]? 1:0;
		map_reg[cnt_127[6:1]][offset + 10] <= rdata_m_inf[43:40]? 1:0;
		map_reg[cnt_127[6:1]][offset + 11] <= rdata_m_inf[47:44]? 1:0;
		map_reg[cnt_127[6:1]][offset + 12] <= rdata_m_inf[51:48]? 1:0;
		map_reg[cnt_127[6:1]][offset + 13] <= rdata_m_inf[55:52]? 1:0;
		map_reg[cnt_127[6:1]][offset + 14] <= rdata_m_inf[59:56]? 1:0;
		map_reg[cnt_127[6:1]][offset + 15] <= rdata_m_inf[63:60]? 1:0;
		map_reg[cnt_127[6:1]][offset + 16] <= rdata_m_inf[67:64]? 1:0;
		map_reg[cnt_127[6:1]][offset + 17] <= rdata_m_inf[71:68]? 1:0;
		map_reg[cnt_127[6:1]][offset + 18] <= rdata_m_inf[75:72]? 1:0;
		map_reg[cnt_127[6:1]][offset + 19] <= rdata_m_inf[79:76]? 1:0;
		map_reg[cnt_127[6:1]][offset + 20] <= rdata_m_inf[83:80]? 1:0;
		map_reg[cnt_127[6:1]][offset + 21] <= rdata_m_inf[87:84]? 1:0;
		map_reg[cnt_127[6:1]][offset + 22] <= rdata_m_inf[91:88]? 1:0;
		map_reg[cnt_127[6:1]][offset + 23] <= rdata_m_inf[95:92]? 1:0;
		map_reg[cnt_127[6:1]][offset + 24] <= rdata_m_inf[99:96]? 1:0;
		map_reg[cnt_127[6:1]][offset + 25] <= rdata_m_inf[103:100]? 1:0;
		map_reg[cnt_127[6:1]][offset + 26] <= rdata_m_inf[107:104]? 1:0;
		map_reg[cnt_127[6:1]][offset + 27] <= rdata_m_inf[111:108]? 1:0;
		map_reg[cnt_127[6:1]][offset + 28] <= rdata_m_inf[115:112]? 1:0;
		map_reg[cnt_127[6:1]][offset + 29] <= rdata_m_inf[119:116]? 1:0;
		map_reg[cnt_127[6:1]][offset + 30] <= rdata_m_inf[123:120]? 1:0;
		map_reg[cnt_127[6:1]][offset + 31] <= rdata_m_inf[127:124]? 1:0;
	end
	else if(curState == INIT_MAP) begin
		map_reg[src_y[netID_idx]][src_x[netID_idx]] <= 2;
		map_reg[tar_y[netID_idx]][tar_x[netID_idx]] <= 0;
	end
	else if(curState == GET_WEIGHT_AND_BFS && !isFound_tar) begin
		// when BFS_cnt is 0 or 1 (2'b00 or 2'b01), we save 2 (2'b10) into map_reg
		// when BFS_cnt is 2 or 3 (2'b10 or 2'b11), we save 3 (2'b11) into map_reg
		
		// the top of map_reg only needs to check right, left, down side
		for(i = 1; i < 63; i = i+1) begin
			if(map_reg[0][i] == 0 && (map_reg[0][i-1][1] | map_reg[0][i+1][1] | map_reg[1][i][1])) begin
				map_reg[0][i] <= {1'b1,BFS_cnt[1]};
			end
		end
		// the bottom of map_reg only needs to check right, left, up side
		for(i = 1; i < 63; i = i+1) begin
			if(map_reg[63][i] == 0 && (map_reg[63][i-1][1] | map_reg[63][i+1][1] | map_reg[62][i][1])) begin
				map_reg[63][i] <= {1'b1,BFS_cnt[1]};
			end
		end
		// the leftside of map_reg only needs to check right, up, down side 
		for(i = 1; i < 63; i = i+1) begin
			if(map_reg[i][0] == 0 && (map_reg[i-1][0][1] | map_reg[i+1][0][1] | map_reg[i][1][1])) begin
				map_reg[i][0] <= {1'b1,BFS_cnt[1]};
			end
		end
		// the rightside of map_reg only needs to check left, up, down side 
		for(i = 1; i < 63; i = i+1) begin
			if(map_reg[i][63] == 0 && (map_reg[i-1][63][1] | map_reg[i+1][63][1] | map_reg[i][62][1])) begin
				map_reg[i][63] <= {1'b1,BFS_cnt[1]};
			end
		end
		// upper-left only needs to check right, down side
		if(map_reg[0][0] == 0 && (map_reg[0][1][1] | map_reg[1][0][1])) begin
			map_reg[0][0] <= {1'b1,BFS_cnt[1]};	
		end
		// upper-right only needs to check left, down side
		if(map_reg[0][63] == 0 && (map_reg[0][62][1] | map_reg[1][63][1])) begin
			map_reg[0][63] <= {1'b1,BFS_cnt[1]};
		end
		// lower-left only needs to check right, up side
		if(map_reg[63][0] == 0 && (map_reg[63][1][1] | map_reg[62][0][1])) begin
			map_reg[63][0] <= {1'b1,BFS_cnt[1]};
		end
		// lower-right only needs to check left, up side
		if(map_reg[63][63] == 0 && (map_reg[63][62][1] | map_reg[62][63][1])) begin
			map_reg[63][63] <= {1'b1,BFS_cnt[1]};
		end
		// middle of map_reg needs to check all 4 sides
		for(i = 1; i < 63; i = i+1) begin
			for(j = 1; j < 63; j = j+1) begin
				if(map_reg[i][j] == 0 && (map_reg[i-1][j][1] | map_reg[i+1][j][1] | map_reg[i][j-1][1] | map_reg[i][j+1][1])) begin
					map_reg[i][j] <= {1'b1,BFS_cnt[1]};
				end
			end
		end
	end
	else if(curState == RETRACE_PATH) begin
		map_reg[cur_y][cur_x] <= 1;
	end
	else if(curState == CLEAR_MAP_REG) begin
		for(i = 0; i < 64; i = i+1) begin
			for(j = 0; j < 64; j = j+1) begin
				if(map_reg[i][j][1]) map_reg[i][j] <= 0;
			end
		end
	end
end
// BFS_cnt
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) BFS_cnt <= 1;
	else if(curState == IDLE) BFS_cnt <= 1;
	else if(curState == GET_WEIGHT_AND_BFS) begin
		if(!isFound_tar) BFS_cnt <= BFS_cnt + 1;
	end
	else if(curState == RETRACE_PATH) begin
		if(cnt_1 == 1'b1) BFS_cnt <= BFS_cnt - 1;
	end
end
// cnt_1
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) cnt_1 <= 0;
	else if(curState == IDLE) cnt_1 <= 0;
	else if(curState == RETRACE_PATH) begin
		cnt_1 <= cnt_1 + 1;
	end
end
// cur_x, cur_y
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cur_x <= 0;
		cur_y <= 0;
	end
	else if(curState == GET_WEIGHT_AND_BFS) begin
		cur_x <= tar_x[netID_idx];
		cur_y <= tar_y[netID_idx];
	end
	else if(curState == RETRACE_PATH && !isFound_src && cnt_1 == 1) begin
		case(BFS_cnt[1])
			1'b0: begin
				// we should find 3
				if(map_reg[cur_y+1][cur_x] == 3 && ~&cur_y) cur_y <= cur_y + 1;
				else if(map_reg[cur_y-1][cur_x] == 3 && |cur_y) cur_y <= cur_y - 1;
				else if(map_reg[cur_y][cur_x+1] == 3 && ~&cur_x) cur_x <= cur_x + 1;
				else cur_x <= cur_x - 1;
			end
			1'b1: begin
				// we should find 2
				if(map_reg[cur_y+1][cur_x] == 2 && ~&cur_y) cur_y <= cur_y + 1;
				else if(map_reg[cur_y-1][cur_x] == 2 && |cur_y) cur_y <= cur_y - 1;
				else if(map_reg[cur_y][cur_x+1] == 2 && ~&cur_x) cur_x <= cur_x + 1;
				else cur_x <= cur_x - 1;
			end
		endcase
	end
end
// cost
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) cost <= 0;
	else if(curState == IDLE) cost <= 0;
	else if(curState == RETRACE_PATH && cnt_1 == 1'b1 && !(cur_x == tar_x[netID_idx] && cur_y == tar_y[netID_idx])) begin
		cost <= cost + weight_out[cur_x[4:0]*4 +: 4];
	end
end
// weight_out_reg
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) weight_out_reg <= 0;
	else if(curState == INIT_MAP) weight_out_reg <= 0;
	else if(curState == RETRACE_PATH) begin
		if(cur_x == tar_x[netID_idx] && cur_y == tar_y[netID_idx]) weight_out_reg <= 0;
		else weight_out_reg <= weight_out[cur_x[4:0]*4 +: 4];
	end
end
// map_out_reg
// always @(posedge clk or negedge rst_n) begin
// 	if(!rst_n) map_out_reg <= 0;
// 	else if(curState == RETRACE_PATH) begin
// 		map_out_reg <= map_out;
// 	end
// end

// curNetID
// always @(posedge clk or negedge rst_n) begin
// 	if(!rst_n) curNetID <= 0;
// 	else begin
// 		curNetID <= netID[netID_idx];
// 	end
// end
assign curNetID = netID[netID_idx];

// cnt_127
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) cnt_127 <= 0;
	else if(curState == IDLE) cnt_127 <= 0;
	else if(curState == DRAM_READ && rvalid_m_inf) begin
		if(cnt_127 == 127) cnt_127 <= 0;
		else cnt_127 <= cnt_127 + 1;
	end
	else if(curState == GET_WEIGHT_AND_BFS && rvalid_m_inf) begin
		if(cnt_127 == 127) cnt_127 <= 0;
		else cnt_127 <= cnt_127 + 1;
	end
	else if(curState == RETRACE_PATH) cnt_127 <= 1;
	else if(curState == DRAM_WRITE && wready_m_inf) begin
		if(cnt_127 == 127) cnt_127 <= 0;
		else cnt_127 <= cnt_127 + 1;
	end
end

// map_addr
always @(*) begin
	map_addr = 0;
	if(curState == DRAM_READ && rvalid_m_inf) map_addr = cnt_127;
	else if(curState == RETRACE_PATH || nextState == RETRACE_PATH) map_addr = {cur_y,cur_x[5]};
	else if(curState == DRAM_WRITE) begin
		if(wready_m_inf) map_addr = cnt_127;
		else map_addr = 0;
	end
end
// map_in
always @(*) begin
	map_in = 0;
	if(curState == DRAM_READ && rvalid_m_inf) map_in = rdata_m_inf;
	else if(curState == RETRACE_PATH && cnt_1 == 1'b1) begin
		for(i = 0; i < 32; i = i+1) begin
			if(cur_x[4:0] == i)	map_in[i*4 +: 4] = curNetID;
			else map_in[i*4 +: 4] = map_out[i*4 +: 4];
		end
	end
end
// map_web
always @(*) begin
	map_web = 1;
	if(curState == DRAM_READ && rvalid_m_inf) map_web = 0;
	else if (curState == RETRACE_PATH && cnt_1 == 1'b1) map_web = 0;
end
// weight_addr
always @(*) begin
	weight_addr = 0;
	if(curState == GET_WEIGHT_AND_BFS && rvalid_m_inf) weight_addr = cnt_127;
	else if(curState == RETRACE_PATH || nextState == RETRACE_PATH) weight_addr = {cur_y,cur_x[5]};
end
// weight_in
always @(*) begin
	weight_in = 0;
	if(curState == GET_WEIGHT_AND_BFS && rvalid_m_inf) weight_in = rdata_m_inf;
end
// weight_web
always @(*) begin
	weight_web = 1;
	if(curState == GET_WEIGHT_AND_BFS && rvalid_m_inf && netID_idx == 0) weight_web = 0;
end

endmodule

module AXI4_READ(
// input signals
	clk,rst_n,data_type,
	curState,
	frame_id,
	arready_m_inf,
	rid_m_inf,
	rvalid_m_inf,
	rdata_m_inf,
	rlast_m_inf,
	rresp_m_inf,
	weightdone,
// output signals
	dram_output,
	arid_m_inf,
 	arburst_m_inf,
  	arsize_m_inf,
	arlen_m_inf,
	arvalid_m_inf,
	araddr_m_inf,
	rready_m_inf
);
input clk, rst_n, data_type;
input [3:0] curState;
input [4:0] frame_id;
input weightdone;
output reg [127:0] dram_output;

// read address channel 
input             arready_m_inf;
output [3:0]      arid_m_inf;
output [1:0]      arburst_m_inf;
output [2:0]      arsize_m_inf;
output [7:0]      arlen_m_inf;
output reg        arvalid_m_inf;
output reg [31:0] araddr_m_inf;
// read data channel 
input         rvalid_m_inf;
input [3:0]   rid_m_inf;
input [1:0]   rresp_m_inf;
input [127:0] rdata_m_inf;
input         rlast_m_inf;
output reg    rready_m_inf;

// state of main FSM
parameter DRAM_READ = 4'd2,
  		  GET_WEIGHT_AND_BFS = 4'd4;
// state of AXI4_READ
parameter AR_VALID = 2'd0,
		  R_VALID  = 2'd1;

reg [1:0] curState_r, nextState_r;

assign arid_m_inf = 0;
assign arburst_m_inf = 2'b01; // mode = INCR 
assign arsize_m_inf = 3'b100; // size = 16 bytes
assign arlen_m_inf = 127;     // burst length = 127 + 1

// curState_r
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) curState_r <= AR_VALID;
	else curState_r <= nextState_r;
end
always @(*) begin
	nextState_r=curState_r;
	araddr_m_inf=0;
	arvalid_m_inf=0;
	rready_m_inf=0;
	dram_output=0;
	case (curState_r)
		AR_VALID:begin
			if (curState==DRAM_READ) begin
				araddr_m_inf={16'd1,frame_id,11'd0};
				arvalid_m_inf=1;
				if (arready_m_inf) nextState_r=R_VALID;
			end
			if (weightdone) begin
				nextState_r=AR_VALID;
			end
			else if(curState==GET_WEIGHT_AND_BFS)begin
				araddr_m_inf={16'd2,frame_id,11'd0};
				arvalid_m_inf=1;
				if (arready_m_inf) nextState_r=R_VALID;
			end
		end 
		R_VALID:begin
			rready_m_inf=1;
			if (rvalid_m_inf) begin
				dram_output=rdata_m_inf;
			end
			if (rlast_m_inf) nextState_r=AR_VALID;
		end 
	endcase
end

endmodule

module AXI4_WRITE(
// input signals
	clk, rst_n,
	curState,
	frame_id,
	dram_input,
	awready_m_inf,
	wready_m_inf,
	bid_m_inf,
 	bvalid_m_inf,
	bresp_m_inf,
// output signals
	awid_m_inf,
	awburst_m_inf,
	awsize_m_inf,
	awlen_m_inf,
	awvalid_m_inf,
	awaddr_m_inf,
	wvalid_m_inf,
	wdata_m_inf,
	wlast_m_inf,
	bready_m_inf
);
input clk,rst_n;
input [3:0]   curState;
input [4:0]   frame_id;
input [127:0] dram_input;
// write address channel
input              awready_m_inf;
output [1:0]       awburst_m_inf;
output [2:0]       awsize_m_inf;
output [3:0]       awid_m_inf;
output [7:0]       awlen_m_inf;
output reg         awvalid_m_inf;
output reg  [31:0] awaddr_m_inf;
// write data channel
input          wready_m_inf;
output reg     wvalid_m_inf;
output reg     wlast_m_inf;
output [127:0] wdata_m_inf;
// write response channel
input       bvalid_m_inf;
input [1:0] bresp_m_inf;
input [3:0] bid_m_inf;
output reg  bready_m_inf;

// state of main FSM
parameter DRAM_WRITE = 4'd7;
// state of AXI4_READ
parameter AW_VALID  = 2'd0,
		  W_VALID   = 2'd1;

reg [1:0] curState_w, nextState_w;
reg [7:0] cnt_w;

assign awid_m_inf = 0;
assign awburst_m_inf = 2'b01;
assign awsize_m_inf = 3'b100;
assign wdata_m_inf = dram_input;
assign awlen_m_inf = 127;

// curState_w
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) curState_w <= AW_VALID;
	else curState_w <= nextState_w;
end
// nextState_w
always @(*) begin
	if(!rst_n) nextState_w = AW_VALID;
	else begin
		case(curState_w)
			AW_VALID: begin
				if(curState == DRAM_WRITE && awready_m_inf == 1) nextState_w = W_VALID;
				else nextState_w = curState_w;
			end
			W_VALID: begin
				if (bvalid_m_inf == 1) nextState_w = AW_VALID;
				else nextState_w = curState_w;
			end
			default: nextState_w = AW_VALID;
		endcase
	end
end
// cnt_w
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) cnt_w <= 0;
	else begin
		if(bvalid_m_inf == 1) cnt_w <= 0;
		else if(wready_m_inf == 1) cnt_w <= cnt_w + 1;
	end
end

// awaddr_m_inf
always @(*) begin
	awaddr_m_inf = 0;
	if(curState == DRAM_WRITE && curState_w == AW_VALID) awaddr_m_inf = 20'h10000 + frame_id * (12'h800);
end
// awvalid_m_inf
always @(*) begin
	awvalid_m_inf = 0;
	if(curState == DRAM_WRITE && curState_w == AW_VALID) awvalid_m_inf = 1;
end
// wvalid_m_inf
always @(*) begin
	wvalid_m_inf = 0;
	if(curState_w == W_VALID) wvalid_m_inf = 1;
end
// bready_m_inf
always @(*) begin
	bready_m_inf = 0;
	if(curState_w == W_VALID) bready_m_inf = 1;
end
// wlast_m_inf
always @(*) begin
	wlast_m_inf = 0;
	if(cnt_w == awlen_m_inf) wlast_m_inf = 1;
end

endmodule


