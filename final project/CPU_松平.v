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
output wire  IO_stall;

parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 16, DRAM_NUMBER=2, WRIT_NUMBER=1;

// AXI Interface wire connecttion for pseudo DRAM read/write
/* Hint:
  your AXI-4 interface could be designed as convertor in submodule(which used reg for output signal),
  therefore I declared output of AXI as wire in CPU
*/



// axi write address channel
output  wire [WRIT_NUMBER * ID_WIDTH-1:0]        awid_m_inf;
output  reg [WRIT_NUMBER * ADDR_WIDTH-1:0]    awaddr_m_inf;
output  wire [WRIT_NUMBER * 3 -1:0]            awsize_m_inf;
output  wire [WRIT_NUMBER * 2 -1:0]           awburst_m_inf;
output  reg [WRIT_NUMBER * 7 -1:0]             awlen_m_inf;
output  reg [WRIT_NUMBER-1:0]                awvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                awready_m_inf;
// axi write data channel
output  reg [WRIT_NUMBER * DATA_WIDTH-1:0]     wdata_m_inf;
output  wire [WRIT_NUMBER-1:0]                  wlast_m_inf;
output  reg [WRIT_NUMBER-1:0]                 wvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                 wready_m_inf;
// axi write response channel
input   wire [WRIT_NUMBER * ID_WIDTH-1:0]         bid_m_inf;
input   wire [WRIT_NUMBER * 2 -1:0]             bresp_m_inf;
input   wire [WRIT_NUMBER-1:0]             	   bvalid_m_inf;
output  wire [WRIT_NUMBER-1:0]                 bready_m_inf;
// -----------------------------
// axi read address channel
output  wire [DRAM_NUMBER * ID_WIDTH-1:0]       arid_m_inf;
output  reg [DRAM_NUMBER * ADDR_WIDTH-1:0]   araddr_m_inf;
output  reg [DRAM_NUMBER * 7 -1:0]            arlen_m_inf;
output  wire [DRAM_NUMBER * 3 -1:0]           arsize_m_inf;
output  wire [DRAM_NUMBER * 2 -1:0]          arburst_m_inf;
output  reg [DRAM_NUMBER-1:0]               arvalid_m_inf;
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



//####################################################
//               reg & wire
//####################################################
parameter signed offset = 16'h1000;
reg [11:0] inst_pc;
reg [11:0] inst_pc_start;
wire signed [12:0] inst_pc_s1;
wire signed [12:0] inst_pc_signed;
reg [11:0] data_pc;
reg [11:0] data_pc_start;
reg [10:0] inst_round;
reg [0:0]  flag;
reg [0:0]  pc_flag;
reg [0:0]  pc_flag_data;
reg [0:0]  first_load_flag;

reg [2:0] opcode;
reg [3:0] rs, rt, rd;
reg func;
reg signed [4:0] imm;
reg [15:0] j_address;

reg  signed [15:0] rs_tmp;
reg  signed [15:0] rt_tmp;
reg  signed [15:0] rd_tmp;

reg  signed [15:0] data_addr;
//####################################################
//               SRAM reg&wire
//####################################################
wire[15:0] inst_sram_out;
reg [15:0] inst_sram_in;
reg wen;
reg [6:0] s_inst_addr ;
reg [7:0] s_addr_count;
reg [7:0] s_addr_fetch;

wire[15:0] data_sram_out;
reg [15:0] data_sram_in;
reg wen_data;
reg [6:0] s_data_addr ;
reg [7:0] s_addr_count_data;
reg [7:0] s_addr_fetch_data;




//####################################################
//               dram_io
//####################################################

//read//
assign arsize_m_inf={3'b001,3'b001};
assign arid_m_inf = 8'd0; 			// fixed id to 0
assign arburst_m_inf = {2'd1,2'd1};		// fixed mode to INCR mode

assign rready_m_inf=rvalid_m_inf;

//write//
assign awsize_m_inf=3'b001;
assign awid_m_inf = 3'd0; 			// fixed id to 0
assign awburst_m_inf = 2'd1;		// fixed mode to INCR mode

assign bready_m_inf=bvalid_m_inf;


//###########################################
// FSM
//###########################################
reg  [4:0] P, P_next;
localparam [4:0]
           S_MAIN_init         =0,
           S_MAIN_out          =1,
           S_MAIN_rdram_inst_1 =2,
           S_MAIN_wait_inst_1  =3,
           S_MAIN_get_inst_1   =4,
           S_MAIN_fetch        =5,
           S_MAIN_decode       =6,
           S_MAIN_load         =7,
           S_MAIN_store        =8,
           S_MAIN_execute      =9,
           S_MAIN_write_back   =10,
           S_MAIN_wait_decode  =11,
           S_MAIN_rdram_data_1 =12,
           S_MAIN_wait_data_1  =13,
           S_MAIN_get_data_1   =14,
           S_MAIN_wait_data    =15,
           S_MAIN_write_dram   =16

           ;


always @(posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    P <= S_MAIN_init;
  end
  else
    P <= P_next;
end

always @(*) begin
  case (P)
    S_MAIN_init:
      P_next=S_MAIN_rdram_inst_1;
    S_MAIN_rdram_inst_1:
      P_next=(arready_m_inf[1]==1)?S_MAIN_wait_inst_1:S_MAIN_rdram_inst_1;
    S_MAIN_wait_inst_1:
      P_next=(rvalid_m_inf[1]==1)?S_MAIN_get_inst_1:S_MAIN_wait_inst_1;
    S_MAIN_get_inst_1:
      P_next=(rvalid_m_inf==0&&s_addr_count>127)?S_MAIN_fetch:S_MAIN_get_inst_1;
    S_MAIN_fetch:
      P_next=S_MAIN_decode;
    S_MAIN_decode:
      P_next=S_MAIN_execute;
    S_MAIN_execute: begin
      if (opcode==3'b010&&(first_load_flag==0||data_pc>=data_pc_start+256||data_pc<data_pc_start))
        P_next = S_MAIN_rdram_data_1  ;
      else if (opcode==3'b010) begin
        P_next = S_MAIN_wait_data;
      end
      else if (opcode==3'b011)
        P_next = S_MAIN_store      ;
      else if (opcode[2]==1'b1)
        P_next = S_MAIN_wait_decode;
      else
        P_next = S_MAIN_write_back ;
    end
    S_MAIN_wait_decode:
      P_next=(inst_pc>=inst_pc_start+256||inst_pc<inst_pc_start)?S_MAIN_rdram_inst_1:S_MAIN_decode;
    S_MAIN_write_back:
      P_next=(inst_pc<inst_pc_start+256)?S_MAIN_decode:S_MAIN_rdram_inst_1;

    S_MAIN_rdram_data_1:
      P_next=(arready_m_inf[0]==1)?S_MAIN_wait_data_1:S_MAIN_rdram_data_1;
    S_MAIN_wait_data_1:
      P_next=(rvalid_m_inf[0]==1)?S_MAIN_get_data_1:S_MAIN_wait_data_1;
    S_MAIN_get_data_1:
      P_next=(rvalid_m_inf==0&&s_addr_count_data>127)?S_MAIN_wait_data:S_MAIN_get_data_1;
    S_MAIN_wait_data:
      P_next=S_MAIN_load;
    S_MAIN_load:
      P_next=(inst_pc<inst_pc_start+256)?S_MAIN_decode:S_MAIN_rdram_inst_1;
    S_MAIN_store:
      P_next=(awready_m_inf == 1)?S_MAIN_write_dram:S_MAIN_store;
    S_MAIN_write_dram:
      P_next=(bresp_m_inf==1||bvalid_m_inf==0)?S_MAIN_write_dram:(bresp_m_inf==0&&bvalid_m_inf==1&&inst_pc<inst_pc_start+256)?S_MAIN_decode:S_MAIN_rdram_inst_1;
    S_MAIN_out:
      P_next=S_MAIN_init;

    default:
      P_next=P;
  endcase
end




//###########################################
// Sram inst
//###########################################

RA1SH sram_inst (.Q(inst_sram_out),.CLK(clk),.CEN(1'b0),.WEN(wen),.A(s_inst_addr),.D(inst_sram_in),.OEN(1'b0));

//control_addr_count
always @(posedge clk,negedge rst_n) begin
  if (!rst_n) begin
    s_addr_count<=0;
  end
  else if (P_next==S_MAIN_get_inst_1) begin
    s_addr_count<=s_addr_count+1;
  end
  else if (P_next==S_MAIN_rdram_inst_1) begin
    s_addr_count<=0;
  end
end

/*
always @(posedge clk,negedge rst_n) begin
  if (!rst_n) begin
    s_addr_fetch<=0;
  end
  else if (P_next==S_MAIN_execute) begin
    s_addr_fetch<=(inst_pc-inst_pc_start)>>1;
  end
end
*/
always @(*) begin
  if (P_next==S_MAIN_get_inst_1) begin
    s_inst_addr=s_addr_count;
  end
  else
    s_inst_addr=(inst_pc-inst_pc_start)>>1;
end



//control wen
always @(*) begin
  if (P_next==S_MAIN_get_inst_1) begin
    wen=0;
    inst_sram_in=rdata_m_inf[31:16];
  end
  else begin
    wen=1;
    inst_sram_in=0;
  end
end

//###########################################
// Sram data
//###########################################
RA1SH sram_data (.Q(data_sram_out),.CLK(clk),.CEN(1'b0),.WEN(wen_data),.A(s_data_addr),.D(data_sram_in),.OEN(1'b0));

always @(posedge clk,negedge rst_n) begin
  if (!rst_n) begin
    s_addr_count_data<=0;
  end
  else if (P_next==S_MAIN_get_data_1) begin
    s_addr_count_data<=s_addr_count_data+1;
  end
  else if (P_next==S_MAIN_rdram_data_1) begin
    s_addr_count_data<=0;
  end
end

always @(*) begin
  if (P_next==S_MAIN_get_data_1) begin
    s_data_addr=s_addr_count_data;
  end
  else
    s_data_addr=(data_pc-data_pc_start)>>1;
end

always @(*) begin
  if (P_next==S_MAIN_get_data_1) begin
    wen_data=0;
    data_sram_in=rdata_m_inf[15:0];
  end
  else if (P==S_MAIN_execute) begin  //modify sram when store hit
    if (data_pc<data_pc_start+256&&data_pc>=data_pc_start&&opcode==3'b011) begin
      wen_data=0;
      data_sram_in=rt_tmp;
    end
    else begin
      wen_data=1;
      data_sram_in=0;
    end
  end
  else begin
    wen_data=1;
    data_sram_in=0;
  end
end


//###########################################
// design
//###########################################

assign IO_stall=(P==S_MAIN_write_back||P==S_MAIN_wait_decode||P==S_MAIN_load||bvalid_m_inf)?0:1;
assign inst_pc_s1={1'b0,inst_pc};
assign inst_pc_signed=inst_pc_s1+2+imm*2;

always @(posedge clk ,negedge rst_n) begin
  if (!rst_n) begin
    inst_pc<=12'h000;
    //inst_pc_start<=0;
    flag<=0;

    data_pc<=12'h000;
    //data_pc_start<=0;
    first_load_flag<=0;
    //--------------
    core_r0 <=0;
    core_r1 <=0;
    core_r2 <=0;
    core_r3 <=0;
    core_r4 <=0;
    core_r5 <=0;
    core_r6 <=0;
    core_r7 <=0;
    core_r8 <=0;
    core_r9 <=0;
    core_r10<=0;
    core_r11<=0;
    core_r12<=0;
    core_r13<=0;
    core_r14<=0;
    core_r15<=0;


    //------------
  end
  else if (P_next==S_MAIN_fetch) begin
    //inst_pc_start<=inst_pc;
  end
  else if (P_next==S_MAIN_decode) begin
    opcode <= inst_sram_out[15:13] ;
    rs     <= inst_sram_out[12: 9] ;
    rt     <= inst_sram_out[ 8: 5] ;
    rd     <= inst_sram_out[ 4: 1] ;
    func   <= inst_sram_out[0] ;
    imm    <= inst_sram_out[ 4: 0] ;
    j_address<={3'd0,inst_sram_out[12:0]};

    case (inst_sram_out[12: 9])
      0:
        rs_tmp<=core_r0;
      1:
        rs_tmp<=core_r1;
      2:
        rs_tmp<=core_r2;
      3:
        rs_tmp<=core_r3;
      4:
        rs_tmp<=core_r4;
      5:
        rs_tmp<=core_r5;
      6:
        rs_tmp<=core_r6;
      7:
        rs_tmp<=core_r7;
      8:
        rs_tmp<=core_r8;
      9:
        rs_tmp<=core_r9;
      10:
        rs_tmp<=core_r10;
      11:
        rs_tmp<=core_r11;
      12:
        rs_tmp<=core_r12;
      13:
        rs_tmp<=core_r13;
      14:
        rs_tmp<=core_r14;
      15:
        rs_tmp<=core_r15;
      default:
        ;
    endcase
    case (inst_sram_out[ 8: 5])
      0:
        rt_tmp<=core_r0;
      1:
        rt_tmp<=core_r1;
      2:
        rt_tmp<=core_r2;
      3:
        rt_tmp<=core_r3;
      4:
        rt_tmp<=core_r4;
      5:
        rt_tmp<=core_r5;
      6:
        rt_tmp<=core_r6;
      7:
        rt_tmp<=core_r7;
      8:
        rt_tmp<=core_r8;
      9:
        rt_tmp<=core_r9;
      10:
        rt_tmp<=core_r10;
      11:
        rt_tmp<=core_r11;
      12:
        rt_tmp<=core_r12;
      13:
        rt_tmp<=core_r13;
      14:
        rt_tmp<=core_r14;
      15:
        rt_tmp<=core_r15;
      default:
        ;
    endcase
  end

  else if (P_next==S_MAIN_execute) begin
    if (opcode==3'd0) begin
      inst_pc<=inst_pc+2;
      if (func==0) begin
        rd_tmp<=rs_tmp+rt_tmp;
      end
      else begin
        rd_tmp<=rs_tmp-rt_tmp;
      end
    end
    else if (opcode==3'd1) begin
      inst_pc<=inst_pc+2;
      if (func==0) begin
        rd_tmp<=(rs_tmp<rt_tmp)?1:0;
      end
      else
        rd_tmp<=rs_tmp*rt_tmp;
    end
    else if (opcode==3'b100) begin
      if (rs_tmp==rt_tmp) begin
        inst_pc<=inst_pc_signed;
      end
      else
        inst_pc<=inst_pc+2;
    end
    else if (opcode==3'b101) begin
      inst_pc<=j_address;
    end
    else if (opcode[1]==1'b1) begin  //load&store
      inst_pc<=inst_pc+2;
      //data_pc<=offset+(rs_tmp+imm)<<1;
      data_pc<=(rs_tmp+imm)<<1;
    end

  end
  else if (P_next==S_MAIN_load) begin
    first_load_flag<=1;
    case (rt)
      0 :
        core_r0<= data_sram_out;
      1 :
        core_r1<= data_sram_out;
      2 :
        core_r2<= data_sram_out;
      3 :
        core_r3<= data_sram_out;
      4 :
        core_r4<= data_sram_out;
      5 :
        core_r5<= data_sram_out;
      6 :
        core_r6<= data_sram_out;
      7 :
        core_r7<= data_sram_out;
      8 :
        core_r8<= data_sram_out;
      9 :
        core_r9<= data_sram_out;
      10:
        core_r10<= data_sram_out;
      11:
        core_r11<= data_sram_out;
      12:
        core_r12<= data_sram_out;
      13:
        core_r13<= data_sram_out;
      14:
        core_r14<= data_sram_out;
      15:
        core_r15<= data_sram_out;
      default:
        ;
    endcase
  end
  else if (P_next==S_MAIN_write_back) begin
    case (rd)
      0 :
        core_r0<= rd_tmp;
      1 :
        core_r1<= rd_tmp;
      2 :
        core_r2<= rd_tmp;
      3 :
        core_r3<= rd_tmp;
      4 :
        core_r4<= rd_tmp;
      5 :
        core_r5<= rd_tmp;
      6 :
        core_r6<= rd_tmp;
      7 :
        core_r7<= rd_tmp;
      8 :
        core_r8<= rd_tmp;
      9 :
        core_r9<= rd_tmp;
      10:
        core_r10<= rd_tmp;
      11:
        core_r11<= rd_tmp;
      12:
        core_r12<= rd_tmp;
      13:
        core_r13<= rd_tmp;
      14:
        core_r14<= rd_tmp;
      15:
        core_r15<= rd_tmp;
      default:
        ;
    endcase
  end



end


//axi4
always @(posedge clk ,negedge rst_n) begin
  if (!rst_n) begin
    //read
    arlen_m_inf  <=0;
    arvalid_m_inf<=0;
    araddr_m_inf <=0;
    pc_flag<=0;
    pc_flag_data<=0;
    inst_pc_start<=0;
    data_pc_start<=0;
    //write
    awlen_m_inf <= 0;
    awvalid_m_inf <= 0;
    awaddr_m_inf <= 0;
    wvalid_m_inf <= 0;

  end
  else if (P_next==S_MAIN_rdram_inst_1) begin
    arlen_m_inf<={7'd127,7'd127};
    arvalid_m_inf<=2'b10;
    if (inst_pc>3840) begin
      araddr_m_inf<={20'h00001,12'd3840,16'd0,16'h1000};
      inst_pc_start<=3840;
    end
    /*
        else if (inst_pc<62) begin
          araddr_m_inf<={20'h00001,12'd0,16'd0,16'h1000};
          inst_pc_start<=0;
        end*/
    else begin
      /*
      araddr_m_inf<={20'h00001,inst_pc-12'd62,16'd0,16'h1000};
      inst_pc_start<=(pc_flag==0)?inst_pc-12'd62:inst_pc_start;
      pc_flag<=1;*/

      araddr_m_inf<={20'h00001,inst_pc,16'd0,16'h1000};
      inst_pc_start<=inst_pc;
    end
  end
  else if (P_next==S_MAIN_wait_inst_1) begin
    pc_flag<=0;
    arvalid_m_inf<=0;
    araddr_m_inf <=0;
    arvalid_m_inf<=2'b00;
  end
  else if (P_next==S_MAIN_rdram_data_1) begin
    arlen_m_inf<={7'd127,7'd127};
    arvalid_m_inf<=2'b01;
    if (data_pc>3840) begin
      araddr_m_inf<={20'h00001,12'd0,20'h00001,12'd3840};
      data_pc_start<=3840;
    end

    else if (data_pc<62) begin
      araddr_m_inf<={20'h00001,12'd0,20'h00001,12'd0};
      data_pc_start<=0;
    end
    else begin

      araddr_m_inf<={20'h00001,12'd0,20'h00001,data_pc-12'd62};
      data_pc_start<=(pc_flag_data==0)?data_pc-12'd62:data_pc_start;
      pc_flag_data<=1;
      /*
            araddr_m_inf<={20'h00001,12'd0,20'h00001,data_pc};
            data_pc_start<=data_pc;*/
    end
  end
  else if (P_next==S_MAIN_wait_data_1) begin
    pc_flag_data<=0;
    arvalid_m_inf<=0;
    araddr_m_inf <=0;
    arvalid_m_inf<=2'b00;
  end
  else if (P_next==S_MAIN_store) begin
    awlen_m_inf<=0;
    awvalid_m_inf<=1;
    awaddr_m_inf<={20'h00001,12'd0,20'h00001,data_pc};
  end
  else if (P_next==S_MAIN_write_dram) begin
    awaddr_m_inf<={20'h00001,12'd0,20'h00001,12'd0};
    awvalid_m_inf<=0;
    wvalid_m_inf<=1;
  end
  else begin
    wvalid_m_inf<=0;
  end

end

//write back
assign wlast_m_inf=wvalid_m_inf;
always @(*) begin
  if (wvalid_m_inf==1) begin
    wdata_m_inf=rt_tmp;
  end
  else
    wdata_m_inf=0;
end


endmodule



















