//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2021 Final Project: Customized ISA Processor 
//   Author              : Hsi-Hao Huang
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : CPU.v
//   Module Name : CPU.v
//   Release version : V1.0 (Release Date: 2021-May)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module CPU(

				clk,
			  rst_n,
  
		   IO_stall,

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
       bready_m_inf,
                    
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
       rready_m_inf 

);
// Input port
input  wire clk, rst_n;
// Output port
output reg  IO_stall;

parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 16, DRAM_NUMBER=2, WRIT_NUMBER=1;

// AXI Interface wire connecttion for pseudo DRAM read/write
/* Hint:
  your AXI-4 interface could be designed as convertor in submodule(which used reg for output signal),
  therefore I declared output of AXI as wire in CPU
*/



// axi write address channel 
output  wire [WRIT_NUMBER * ID_WIDTH-1:0]        awid_m_inf;
output  wire [WRIT_NUMBER * ADDR_WIDTH-1:0]    awaddr_m_inf;
output  wire [WRIT_NUMBER * 3 -1:0]            awsize_m_inf;
output  wire [WRIT_NUMBER * 2 -1:0]           awburst_m_inf;
output  wire [WRIT_NUMBER * 7 -1:0]             awlen_m_inf;
output  wire [WRIT_NUMBER-1:0]                awvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                awready_m_inf;
// axi write data channel 
output  wire [WRIT_NUMBER * DATA_WIDTH-1:0]     wdata_m_inf;
output  wire [WRIT_NUMBER-1:0]                  wlast_m_inf;
output  wire [WRIT_NUMBER-1:0]                 wvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                 wready_m_inf;
// axi write response channel
input   wire [WRIT_NUMBER * ID_WIDTH-1:0]         bid_m_inf;
input   wire [WRIT_NUMBER * 2 -1:0]             bresp_m_inf;
input   wire [WRIT_NUMBER-1:0]             	   bvalid_m_inf;
output  wire [WRIT_NUMBER-1:0]                 bready_m_inf;
// -----------------------------
// axi read address channel 
output  wire [DRAM_NUMBER * ID_WIDTH-1:0]       arid_m_inf;
output  wire [DRAM_NUMBER * ADDR_WIDTH-1:0]   araddr_m_inf;
output  wire [DRAM_NUMBER * 7 -1:0]            arlen_m_inf;
output  wire [DRAM_NUMBER * 3 -1:0]           arsize_m_inf;
output  wire [DRAM_NUMBER * 2 -1:0]          arburst_m_inf;
output  wire [DRAM_NUMBER-1:0]               arvalid_m_inf;
input   wire [DRAM_NUMBER-1:0]               arready_m_inf;
// -----------------------------
// axi read data channel 
input   wire [DRAM_NUMBER * ID_WIDTH-1:0]         rid_m_inf;
input   wire [DRAM_NUMBER * DATA_WIDTH-1:0]     rdata_m_inf;
input   wire [DRAM_NUMBER * 2 -1:0]             rresp_m_inf;
input   wire [DRAM_NUMBER-1:0]                  rlast_m_inf;
input   wire [DRAM_NUMBER-1:0]                 rvalid_m_inf;
output  wire [DRAM_NUMBER-1:0]                 rready_m_inf;
// -----------------------------

//
//
// 
/* Register in each core:
  There are sixteen registers in your CPU. You should not change the name of those registers.
  TA will check the value in each register when your core is not busy.
  If you change the name of registers below, you must get the fail in this lab.
*/

reg signed [15:0] core_r0 , core_r1 , core_r2 , core_r3 ;
reg signed [15:0] core_r4 , core_r5 , core_r6 , core_r7 ;
reg signed [15:0] core_r8 , core_r9 , core_r10, core_r11;
reg signed [15:0] core_r12, core_r13, core_r14, core_r15;


//###########################################
//
// Wrtie down your design below
//
//###########################################

//####################################################
//               reg & wire
//####################################################
reg [11:0] inst_ptr;
reg [11:0] inst_startAddr;
reg [11:0] data_ptr;
reg [11:0] data_startAddr;
reg signed [12:0] inst_ptr_signed;
reg [2:0] opcode;
reg [3:0] rs, rt, rd;
reg signed [15:0] rs_data, rt_data, rd_data;
reg func;
reg [12:0] j_addr;
reg signed [4:0] I; // immediate
reg firstLoad;
reg [15:0] inst_in;
reg [15:0] inst_out, data_out;
reg [15:0] data_in;
reg [15:0] dram_input;

reg [6:0] instAddr, dataAddr;
reg inst_web, data_web;

assign inst_ptr_signed = {1'b0,inst_ptr};

parameter IDLE = 0,
          READ_INST = 1,
          FETCH = 2,
          DECODE = 3,
          EXE = 4,
          LW = 5,
          SW = 6,
          WB = 7,
          READ_DATADRAM = 8,
          WAIT_DATASRAM = 9,
          CHECK_INSTPTR = 10,
          BUFFER_LW = 11,
          PRE_FETCH = 12,
          PRE_LW = 13,
          WB_BUFFER = 14,
          PRE_DECODE = 15;
reg [4:0] curState, nextState;
reg [6:0] cnt_127;

mySRAM_128X16 INST(
	.A0  (instAddr[0]),   .A1  (instAddr[1]),   .A2  (instAddr[2]),   .A3  (instAddr[3]),   .A4  (instAddr[4]),   .A5  (instAddr[5]),   .A6  (instAddr[6]),

	.DO0 (inst_out[0]),   .DO1 (inst_out[1]),   .DO2 (inst_out[2]),   .DO3 (inst_out[3]),   .DO4 (inst_out[4]),   .DO5 (inst_out[5]),   .DO6 (inst_out[6]),   .DO7 (inst_out[7]),
	.DO8 (inst_out[8]),   .DO9 (inst_out[9]),   .DO10(inst_out[10]),  .DO11(inst_out[11]),  .DO12(inst_out[12]),  .DO13(inst_out[13]),  .DO14(inst_out[14]),  .DO15(inst_out[15]),

	.DI0 (inst_in[0]),   .DI1 (inst_in[1]),   .DI2 (inst_in[2]),   .DI3 (inst_in[3]),   .DI4 (inst_in[4]),   .DI5 (inst_in[5]),   .DI6 (inst_in[6]),   .DI7 (inst_in[7]),
	.DI8 (inst_in[8]),   .DI9 (inst_in[9]),   .DI10(inst_in[10]),  .DI11(inst_in[11]),  .DI12(inst_in[12]),  .DI13(inst_in[13]),  .DI14(inst_in[14]),  .DI15(inst_in[15]),

	.CK(clk), .WEB(inst_web), .OE(1'b1), .CS(1'b1)
);

mySRAM_128X16 DATA(
	.A0  (dataAddr[0]),   .A1  (dataAddr[1]),   .A2  (dataAddr[2]),   .A3  (dataAddr[3]),   .A4  (dataAddr[4]),   .A5  (dataAddr[5]),   .A6  (dataAddr[6]),

	.DO0 (data_out[0]),   .DO1 (data_out[1]),   .DO2 (data_out[2]),   .DO3 (data_out[3]),   .DO4 (data_out[4]),   .DO5 (data_out[5]),   .DO6 (data_out[6]),   .DO7 (data_out[7]),
	.DO8 (data_out[8]),   .DO9 (data_out[9]),   .DO10(data_out[10]),  .DO11(data_out[11]),  .DO12(data_out[12]),  .DO13(data_out[13]),  .DO14(data_out[14]),  .DO15(data_out[15]),

	.DI0 (data_in[0]),   .DI1 (data_in[1]),   .DI2 (data_in[2]),   .DI3 (data_in[3]),   .DI4 (data_in[4]),   .DI5 (data_in[5]),   .DI6 (data_in[6]),   .DI7 (data_in[7]),
	.DI8 (data_in[8]),   .DI9 (data_in[9]),   .DI10(data_in[10]),  .DI11(data_in[11]),  .DI12(data_in[12]),  .DI13(data_in[13]),  .DI14(data_in[14]),  .DI15(data_in[15]),

	.CK(clk), .WEB(data_web), .OE(1'b1), .CS(1'b1)
);

AXI4_READ axi4_r(
// input signals
  .clk(clk), .rst_n(rst_n),
	.curState(curState),
	.arready_m_inf(arready_m_inf),
	.rid_m_inf(rid_m_inf),
	.rvalid_m_inf(rvalid_m_inf),
	.rdata_m_inf(rdata_m_inf),
	.rlast_m_inf(rlast_m_inf),
	.rresp_m_inf(rresp_m_inf),
  .inst_ptr(inst_ptr),
  .data_ptr(data_ptr),
// output signals
	.arid_m_inf(arid_m_inf),
 	.arburst_m_inf(arburst_m_inf),
  .arsize_m_inf(arsize_m_inf),
	.arlen_m_inf(arlen_m_inf),
	.arvalid_m_inf(arvalid_m_inf),
	.araddr_m_inf(araddr_m_inf),
	.rready_m_inf(rready_m_inf),
  .inst_startAddr(inst_startAddr),
  .data_startAddr(data_startAddr)
);

AXI4_WRITE axi4_w(
// input signals
	.clk(clk), .rst_n(rst_n),
	.curState(curState),
	.dram_input(dram_input),
	.awready_m_inf(awready_m_inf),
	.wready_m_inf(wready_m_inf),
	.bid_m_inf(bid_m_inf),
 	.bvalid_m_inf(bvalid_m_inf),
	.bresp_m_inf(bresp_m_inf),
  .data_ptr(data_ptr),
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

// IO_stall
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) IO_stall <= 1'b1;
  else begin
    if(curState == LW && nextState != LW) IO_stall <= 1'b0;
    else if(curState == SW && nextState != SW) IO_stall <= 1'b0;
    else if(curState == EXE && nextState == CHECK_INSTPTR) IO_stall <= 1'b0;
    else if(curState == WB_BUFFER) IO_stall <= 1'b0;
    else IO_stall <= 1'b1;
  end
end

// curState
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) curState <= IDLE;
  else curState <= nextState;
end

// nextState
always @(*) begin
  nextState = curState;
  if(!rst_n) nextState = IDLE;
  else begin
    case(curState)
      IDLE: nextState = READ_INST;
      READ_INST: begin
        if(rlast_m_inf[1]) nextState = PRE_FETCH;
      end
      PRE_FETCH: nextState = FETCH;
      FETCH: nextState = DECODE;
      PRE_DECODE: nextState = DECODE;
      DECODE: nextState = EXE;
      EXE: begin
        case(opcode)
          3'b010: nextState = BUFFER_LW; // lw
          3'b011: nextState = SW; // sw
          3'b100: nextState = CHECK_INSTPTR; // beq
          3'b101: nextState = CHECK_INSTPTR; // j
          default: nextState = WB; // R-type
        endcase
      end
      BUFFER_LW: begin
        if(firstLoad || (data_ptr > data_startAddr+255 || data_ptr < data_startAddr))
          nextState = READ_DATADRAM;
        else 
          nextState = WAIT_DATASRAM;
      end
      READ_DATADRAM: if(rlast_m_inf[0]) nextState = WAIT_DATASRAM;
      WAIT_DATASRAM: nextState = PRE_LW;
      CHECK_INSTPTR: nextState = (inst_ptr > inst_startAddr+255 || inst_ptr < inst_startAddr)? READ_INST:PRE_DECODE;
      PRE_LW: nextState = LW;
      LW: nextState = (inst_ptr > inst_startAddr+255 || inst_ptr < inst_startAddr)? READ_INST:PRE_DECODE;
      SW: if(bvalid_m_inf) nextState = (inst_ptr > inst_startAddr+255 || inst_ptr < inst_startAddr)? READ_INST:PRE_DECODE;
      WB: nextState = WB_BUFFER;
      WB_BUFFER: nextState = (inst_ptr > inst_startAddr+255 || inst_ptr < inst_startAddr)? READ_INST:PRE_DECODE;
    endcase
  end
end

// cnt_127
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) cnt_127 <= 0;
  else if(curState == READ_INST && rvalid_m_inf[1]) cnt_127 <= cnt_127 + 1;
  else if(curState == READ_DATADRAM && rvalid_m_inf[0]) cnt_127 <= cnt_127 + 1;
end

// data_in
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) data_in <= 0;
  else if(curState == READ_DATADRAM) data_in <= rdata_m_inf[15:0];
  else if(curState == SW) data_in <= rt_data;
end

// firstLoad
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) firstLoad <= 1'b1;
  else if(curState == LW) firstLoad <= 1'b0;
end

// inst_ptr
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) inst_ptr <= 0;
  else if(curState == EXE) begin
    if(opcode == 3'b100) begin // branch
      if(rs_data == rt_data) inst_ptr <= inst_ptr_signed + 2 + I*2;
      else inst_ptr <= inst_ptr + 2;
    end
    else if(opcode == 3'b101) begin // j
      inst_ptr <= j_addr;
    end
    else inst_ptr <= inst_ptr + 2;
  end
end

// todo: instAddr
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) instAddr <= 0;
  else if(curState == READ_INST) instAddr <= cnt_127;
  else instAddr <= (inst_ptr-inst_startAddr) >> 1;
end

// todo: dataAddr
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) dataAddr <= 0;
  else if(curState == READ_DATADRAM) dataAddr <= cnt_127;
  else dataAddr <= (data_ptr-data_startAddr) >> 1;
end

// todo: inst_web, inst_in
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    inst_web <= 1;
    inst_in <= 1;
  end
  else if(curState == READ_INST) begin
    inst_web <= 0;
    inst_in <= rdata_m_inf[31:16];
  end
  else begin
    inst_web <= 1;
    inst_in <= 1;
  end
end

// todo: data_web
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) data_web <= 1;
  else if(curState == READ_DATADRAM) data_web <= 0;
  else if(curState == SW && (data_ptr >= data_startAddr && data_ptr <= data_startAddr + 255)) data_web <= 0;
  else data_web <= 1;
end

// dram_input
always @(*) begin
  dram_input = 0;
  if(curState == SW) dram_input = rt_data;
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    opcode <= 3'b0;
    rs <= 4'b0;
    rt <= 4'b0;
    rd <= 4'b0;
    func <= 1'b0;
    I <= 5'b0;
    j_addr <= 13'b0;
    rs_data <= 0;
    rt_data <= 0;
    rd_data <= 0;
    data_ptr <= 0;
  end
  else if(curState == DECODE) begin
    opcode <= inst_out[15:13];
    rs <= inst_out[12:9];
    rt <= inst_out[8:5];
    rd <= inst_out[4:1];
    func <= inst_out[0];
    I <= inst_out[4:0];
    j_addr <= inst_out[12:0];

    case(inst_out[12:9])
      0: rs_data <= core_r0;
      1: rs_data <= core_r1;
      2: rs_data <= core_r2;
      3: rs_data <= core_r3;
      4: rs_data <= core_r4;
      5: rs_data <= core_r5;
      6: rs_data <= core_r6;
      7: rs_data <= core_r7;
      8: rs_data <= core_r8;
      9: rs_data <= core_r9;
      10: rs_data <= core_r10;
      11: rs_data <= core_r11;
      12: rs_data <= core_r12;
      13: rs_data <= core_r13;
      14: rs_data <= core_r14;
      15: rs_data <= core_r15;
    endcase

    case(inst_out[8:5])
      0: rt_data <= core_r0;
      1: rt_data <= core_r1;
      2: rt_data <= core_r2;
      3: rt_data <= core_r3;
      4: rt_data <= core_r4;
      5: rt_data <= core_r5;
      6: rt_data <= core_r6;
      7: rt_data <= core_r7;
      8: rt_data <= core_r8;
      9: rt_data <= core_r9;
      10: rt_data <= core_r10;
      11: rt_data <= core_r11;
      12: rt_data <= core_r12;
      13: rt_data <= core_r13;
      14: rt_data <= core_r14;
      15: rt_data <= core_r15;
    endcase
  end
  else if(curState == EXE) begin
    if(opcode == 3'b0) begin
      if(func) rd_data <= rs_data - rt_data;
      else rd_data <= rs_data + rt_data;
    end
    else if(opcode == 3'b001) begin
      if(func) rd_data <= rs_data * rt_data;
      else rd_data <= (rs_data < rt_data)? 1'b1 : 1'b0;
    end
    else if(opcode[1]) begin
      data_ptr <= (rs_data + I) << 1;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    core_r0 <= 0;
    core_r1 <= 0;
    core_r2 <= 0;
    core_r3 <= 0;
    core_r4 <= 0;
    core_r5 <= 0;
    core_r6 <= 0;
    core_r7 <= 0;
    core_r8 <= 0;
    core_r9 <= 0;
    core_r10 <= 0;
    core_r11 <= 0;
    core_r12 <= 0;
    core_r13 <= 0;
    core_r14 <= 0;
    core_r15 <= 0;
  end
  else if(curState == LW) begin
    case(rt)
      0: core_r0 <= data_out;
      1: core_r1 <= data_out;
      2: core_r2 <= data_out;
      3: core_r3 <= data_out;
      4: core_r4 <= data_out;
      5: core_r5 <= data_out;
      6: core_r6 <= data_out;
      7: core_r7 <= data_out;
      8: core_r8 <= data_out;
      9: core_r9 <= data_out;
      10: core_r10 <= data_out;
      11: core_r11 <= data_out;
      12: core_r12 <= data_out;
      13: core_r13 <= data_out;
      14: core_r14 <= data_out;
      15: core_r15 <= data_out;
    endcase
  end
  else if(curState == WB) begin
    case(rd)
      0: core_r0 <= rd_data;
      1: core_r1 <= rd_data;
      2: core_r2 <= rd_data;
      3: core_r3 <= rd_data;
      4: core_r4 <= rd_data;
      5: core_r5 <= rd_data;
      6: core_r6 <= rd_data;
      7: core_r7 <= rd_data;
      8: core_r8 <= rd_data;
      9: core_r9 <= rd_data;
      10: core_r10 <= rd_data;
      11: core_r11 <= rd_data;
      12: core_r12 <= rd_data;
      13: core_r13 <= rd_data;
      14: core_r14 <= rd_data;
      15: core_r15 <= rd_data;
    endcase
  end
end

endmodule

//####################################################
//               AXI-4
//####################################################
module AXI4_READ(
// input signals
  clk, rst_n,
	curState,
	arready_m_inf,
	rid_m_inf,
	rvalid_m_inf,
	rdata_m_inf,
	rlast_m_inf,
	rresp_m_inf,
  inst_ptr,
  data_ptr,
// output signals
	arid_m_inf,
 	arburst_m_inf,
  arsize_m_inf,
	arlen_m_inf,
	arvalid_m_inf,
	araddr_m_inf,
	rready_m_inf,
  inst_startAddr,
  data_startAddr
);
parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 16, DRAM_NUMBER=2, WRIT_NUMBER=1;
input clk, rst_n;
input [4:0] curState;
input [11:0] inst_ptr;
input [11:0] data_ptr;
output reg [11:0] inst_startAddr, data_startAddr;

// axi read address channel 
input   wire [DRAM_NUMBER-1:0]               arready_m_inf;
output  wire [DRAM_NUMBER * ID_WIDTH-1:0]       arid_m_inf;
output  wire [DRAM_NUMBER * 7 -1:0]            arlen_m_inf;
output  wire [DRAM_NUMBER * 3 -1:0]           arsize_m_inf;
output  wire [DRAM_NUMBER * 2 -1:0]          arburst_m_inf;
output  reg  [DRAM_NUMBER * ADDR_WIDTH-1:0]   araddr_m_inf;
output  reg  [DRAM_NUMBER-1:0]               arvalid_m_inf;
// axi read data channel
input   wire [DRAM_NUMBER * ID_WIDTH-1:0]         rid_m_inf;
input   wire [DRAM_NUMBER * DATA_WIDTH-1:0]     rdata_m_inf;
input   wire [DRAM_NUMBER * 2 -1:0]             rresp_m_inf;
input   wire [DRAM_NUMBER-1:0]                  rlast_m_inf;
input   wire [DRAM_NUMBER-1:0]                 rvalid_m_inf;
output  reg  [DRAM_NUMBER-1:0]                 rready_m_inf;

// state of main FSM
parameter IDLE = 0,
          READ_INST = 1,
          FETCH = 2,
          DECODE = 3,
          EXE = 4,
          LW = 5,
          SW = 6,
          WB = 7,
          READ_DATADRAM = 8,
          WAIT_DATASRAM = 9,
          CHECK_INSTPTR = 10;

// state of AXI4_READ
parameter AR_VALID = 2'd0,
		      R_VALID  = 2'd1;
reg [1:0] curState_r, nextState_r;

assign arid_m_inf = 0;
assign arsize_m_inf = {3'b001,3'b001};
assign arburst_m_inf = {2'b01,2'b01};
assign arlen_m_inf = {7'd127,7'd127};

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) curState_r <= AR_VALID;
  else curState_r <= nextState_r;
end

always @(*) begin
  nextState_r = curState_r;
  araddr_m_inf = 0;
	arvalid_m_inf = 0;
	rready_m_inf = 0;
  if(!rst_n) nextState_r = AR_VALID;
  else begin
    case(curState_r)
      AR_VALID: begin
        if(curState == READ_INST) begin
          arvalid_m_inf = 2'b10;
          // addr
          if(inst_ptr > 3840) begin
            araddr_m_inf = {20'h00001,12'd3840,16'd0,16'h1000};
            // inst_startAddr = 3840;
          end
          else begin
            araddr_m_inf = {20'h00001,inst_ptr,16'd0,16'h1000};
            // inst_startAddr = inst_ptr;
          end

          if(arready_m_inf[1] == 1'b1) nextState_r = R_VALID;
        end
        else if(curState == READ_DATADRAM) begin
          arvalid_m_inf = 2'b01;
          // addr
          if(data_ptr > 3840) begin
            araddr_m_inf = {20'h00001,12'd0,20'h00001,12'd3840};
            // data_startAddr = 3840;
          end
          else begin
            araddr_m_inf = {20'h00001,12'd0,20'h00001,data_ptr};
            // data_startAddr = data_ptr;
          end

          if(arready_m_inf[0] == 1'b1) nextState_r = R_VALID;
        end
      end
      R_VALID: begin
        if(curState == READ_INST) begin
          rready_m_inf = 2'b10;
          if(rlast_m_inf[1] == 1'b1) nextState_r = AR_VALID;
        end
        else if(curState == READ_DATADRAM) begin
          rready_m_inf = 2'b01;
          if(rlast_m_inf[0] == 1'b1) nextState_r = AR_VALID;
        end
      end
    endcase
  end
end

// inst_startAddr
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) inst_startAddr <= 0;
  else if(curState_r == AR_VALID && curState == READ_INST) begin
    if(inst_ptr > 3840) inst_startAddr <= 3840;
    else inst_startAddr <= inst_ptr;
  end
end

// data_startAddr
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) data_startAddr <= 0;
  else if(curState_r == AR_VALID && curState == READ_DATADRAM) begin
    if(data_ptr > 3840) data_startAddr <= 3840;
    else data_startAddr <= data_ptr;
  end
end

endmodule

module AXI4_WRITE(
// input signals
	clk, rst_n,
	curState,
	dram_input,
	awready_m_inf,
	wready_m_inf,
	bid_m_inf,
 	bvalid_m_inf,
	bresp_m_inf,
  data_ptr,
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
parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 16, DRAM_NUMBER=2, WRIT_NUMBER=1;
input clk,rst_n;
input [4:0]   curState;
input [15:0] dram_input;
input [11:0] data_ptr;
// axi write address channel 
output  wire [WRIT_NUMBER * ID_WIDTH-1:0]        awid_m_inf;
output  reg  [WRIT_NUMBER * ADDR_WIDTH-1:0]    awaddr_m_inf;
output  wire [WRIT_NUMBER * 3 -1:0]            awsize_m_inf;
output  wire [WRIT_NUMBER * 2 -1:0]           awburst_m_inf;
output  wire [WRIT_NUMBER * 7 -1:0]             awlen_m_inf;
output  reg  [WRIT_NUMBER-1:0]                awvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                awready_m_inf;
// axi write data channel 
output  wire [WRIT_NUMBER * DATA_WIDTH-1:0]     wdata_m_inf;
output  reg  [WRIT_NUMBER-1:0]                  wlast_m_inf;
output  reg  [WRIT_NUMBER-1:0]                 wvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                 wready_m_inf;
// axi write response channel
input   wire [WRIT_NUMBER * ID_WIDTH-1:0]         bid_m_inf;
input   wire [WRIT_NUMBER * 2 -1:0]             bresp_m_inf;
input   wire [WRIT_NUMBER-1:0]             	   bvalid_m_inf;
output  reg  [WRIT_NUMBER-1:0]                 bready_m_inf;

// state of main FSM
parameter IDLE = 0,
          READ_INST = 1,
          FETCH = 2,
          DECODE = 3,
          EXE = 4,
          LW = 5,
          SW = 6,
          WB = 7,
          READ_DATADRAM = 8,
          WAIT_DATASRAM = 9,
          CHECK_INSTPTR = 10;

// state of AXI4_READ
parameter AW_VALID  = 2'd0,
		      W_VALID   = 2'd1;

reg [1:0] curState_w, nextState_w;

assign awid_m_inf = 0;
assign awburst_m_inf = 2'b01;
assign awsize_m_inf = 3'b001;
assign awlen_m_inf = 0;
assign wdata_m_inf = dram_input;

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
				if(curState == SW && awready_m_inf) nextState_w = W_VALID;
				else nextState_w = curState_w;
			end
			W_VALID: begin
				if (bvalid_m_inf) nextState_w = AW_VALID;
				else nextState_w = curState_w;
			end
			default: nextState_w = AW_VALID;
		endcase
	end
end

// awaddr_m_inf
always @(*) begin
	awaddr_m_inf = 0;
	if(curState == SW && curState_w == AW_VALID) awaddr_m_inf = {20'h00001,12'd0,20'h00001,data_ptr};
end
// awvalid_m_inf
always @(*) begin
	awvalid_m_inf = 0;
	if(curState == SW && curState_w == AW_VALID) awvalid_m_inf = 1;
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
	if(curState_w == W_VALID && curState == SW) wlast_m_inf = 1;
end

endmodule

















