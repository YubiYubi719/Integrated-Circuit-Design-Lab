module CHIP(
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
output [3:0] awid_m_inf;
output [31:0] awaddr_m_inf;
output [2:0] awsize_m_inf;
output [1:0] awburst_m_inf;
output [6:0] awlen_m_inf;
output [0:0] awvalid_m_inf;
input [0:0] awready_m_inf;
output [15:0] wdata_m_inf;
output [0:0] wlast_m_inf;
output [0:0] wvalid_m_inf;
input [0:0] wready_m_inf;
input [3:0] bid_m_inf;
input [1:0] bresp_m_inf;
input [0:0] bvalid_m_inf;
output [0:0] bready_m_inf;
output [7:0] arid_m_inf;
output [63:0] araddr_m_inf;
output [13:0] arlen_m_inf;
output [5:0] arsize_m_inf;
output [3:0] arburst_m_inf;
output [1:0] arvalid_m_inf;
input [1:0] arready_m_inf;
input [7:0] rid_m_inf;
input [31:0] rdata_m_inf;
input [3:0] rresp_m_inf;
input [1:0] rlast_m_inf;
input [1:0] rvalid_m_inf;
output [1:0] rready_m_inf;
input clk, rst_n;
output IO_stall;

wire [3:0] C_awid_m_inf;
wire [31:0] C_awaddr_m_inf;
wire [2:0] C_awsize_m_inf;
wire [1:0] C_awburst_m_inf;
wire [6:0] C_awlen_m_inf;
wire [0:0] C_awvalid_m_inf;
wire [0:0] C_awready_m_inf;
wire [15:0] C_wdata_m_inf;
wire [0:0] C_wlast_m_inf;
wire [0:0] C_wvalid_m_inf;
wire [0:0] C_wready_m_inf;
wire [3:0] C_bid_m_inf;
wire [1:0] C_bresp_m_inf;
wire [0:0] C_bvalid_m_inf;
wire [0:0] C_bready_m_inf;
wire [7:0] C_arid_m_inf;
wire [63:0] C_araddr_m_inf;
wire [13:0] C_arlen_m_inf;
wire [5:0] C_arsize_m_inf;
wire [3:0] C_arburst_m_inf;
wire [1:0] C_arvalid_m_inf;
wire [1:0] C_arready_m_inf;
wire [7:0] C_rid_m_inf;
wire [31:0] C_rdata_m_inf;
wire [3:0] C_rresp_m_inf;
wire [1:0] C_rlast_m_inf;
wire [1:0] C_rvalid_m_inf;
wire [1:0] C_rready_m_inf;
wire C_clk, C_rst_n;
wire C_IO_stall;

CPU CORE(
    .clk(C_clk), 
    .rst_n(C_rst_n), 
    .IO_stall(C_IO_stall), 
    .awid_m_inf(C_awid_m_inf), 
    .awaddr_m_inf(C_awaddr_m_inf), 
    .awsize_m_inf(C_awsize_m_inf), 
    .awburst_m_inf(C_awburst_m_inf), 
    .awlen_m_inf(C_awlen_m_inf), 
    .awvalid_m_inf(C_awvalid_m_inf), 
    .awready_m_inf(C_awready_m_inf), 
    .wdata_m_inf(C_wdata_m_inf), 
    .wlast_m_inf(C_wlast_m_inf), 
    .wvalid_m_inf(C_wvalid_m_inf), 
    .wready_m_inf(C_wready_m_inf), 
    .bid_m_inf(C_bid_m_inf), 
    .bresp_m_inf(C_bresp_m_inf), 
    .bvalid_m_inf(C_bvalid_m_inf), 
    .bready_m_inf(C_bready_m_inf), 
    .arid_m_inf(C_arid_m_inf), 
    .araddr_m_inf(C_araddr_m_inf), 
    .arlen_m_inf(C_arlen_m_inf), 
    .arsize_m_inf(C_arsize_m_inf), 
    .arburst_m_inf(C_arburst_m_inf), 
    .arvalid_m_inf(C_arvalid_m_inf), 
    .arready_m_inf(C_arready_m_inf), 
    .rid_m_inf(C_rid_m_inf), 
    .rdata_m_inf(C_rdata_m_inf), 
    .rresp_m_inf(C_rresp_m_inf), 
    .rlast_m_inf(C_rlast_m_inf), 
    .rvalid_m_inf(C_rvalid_m_inf), 
    .rready_m_inf(C_rready_m_inf) 
);
// 3:0
YA2GSD  O_awid_m_inf_0( .I(C_awid_m_inf[0]), .O(awid_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awid_m_inf_1( .I(C_awid_m_inf[1]), .O(awid_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awid_m_inf_2( .I(C_awid_m_inf[2]), .O(awid_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awid_m_inf_3( .I(C_awid_m_inf[3]), .O(awid_m_inf[3]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_awaddr_m_inf_0( .I(C_awaddr_m_inf[0]), .O(awaddr_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_1( .I(C_awaddr_m_inf[1]), .O(awaddr_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_2( .I(C_awaddr_m_inf[2]), .O(awaddr_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_3( .I(C_awaddr_m_inf[3]), .O(awaddr_m_inf[3]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_4( .I(C_awaddr_m_inf[4]), .O(awaddr_m_inf[4]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_5( .I(C_awaddr_m_inf[5]), .O(awaddr_m_inf[5]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_6( .I(C_awaddr_m_inf[6]), .O(awaddr_m_inf[6]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_7( .I(C_awaddr_m_inf[7]), .O(awaddr_m_inf[7]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_8( .I(C_awaddr_m_inf[8]), .O(awaddr_m_inf[8]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_9( .I(C_awaddr_m_inf[9]), .O(awaddr_m_inf[9]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_10( .I(C_awaddr_m_inf[10]), .O(awaddr_m_inf[10]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_11( .I(C_awaddr_m_inf[11]), .O(awaddr_m_inf[11]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_12( .I(C_awaddr_m_inf[12]), .O(awaddr_m_inf[12]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_13( .I(C_awaddr_m_inf[13]), .O(awaddr_m_inf[13]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_14( .I(C_awaddr_m_inf[14]), .O(awaddr_m_inf[14]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_15( .I(C_awaddr_m_inf[15]), .O(awaddr_m_inf[15]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_16( .I(C_awaddr_m_inf[16]), .O(awaddr_m_inf[16]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_17( .I(C_awaddr_m_inf[17]), .O(awaddr_m_inf[17]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_18( .I(C_awaddr_m_inf[18]), .O(awaddr_m_inf[18]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_19( .I(C_awaddr_m_inf[19]), .O(awaddr_m_inf[19]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_20( .I(C_awaddr_m_inf[20]), .O(awaddr_m_inf[20]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_21( .I(C_awaddr_m_inf[21]), .O(awaddr_m_inf[21]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_22( .I(C_awaddr_m_inf[22]), .O(awaddr_m_inf[22]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_23( .I(C_awaddr_m_inf[23]), .O(awaddr_m_inf[23]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_24( .I(C_awaddr_m_inf[24]), .O(awaddr_m_inf[24]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_25( .I(C_awaddr_m_inf[25]), .O(awaddr_m_inf[25]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_26( .I(C_awaddr_m_inf[26]), .O(awaddr_m_inf[26]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_27( .I(C_awaddr_m_inf[27]), .O(awaddr_m_inf[27]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_28( .I(C_awaddr_m_inf[28]), .O(awaddr_m_inf[28]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_29( .I(C_awaddr_m_inf[29]), .O(awaddr_m_inf[29]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_30( .I(C_awaddr_m_inf[30]), .O(awaddr_m_inf[30]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awaddr_m_inf_31( .I(C_awaddr_m_inf[31]), .O(awaddr_m_inf[31]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_awsize_m_inf_0( .I(C_awsize_m_inf[0]), .O(awsize_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awsize_m_inf_1( .I(C_awsize_m_inf[1]), .O(awsize_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awsize_m_inf_2( .I(C_awsize_m_inf[2]), .O(awsize_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_awburst_m_inf_0( .I(C_awburst_m_inf[0]), .O(awburst_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awburst_m_inf_1( .I(C_awburst_m_inf[1]), .O(awburst_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_awlen_m_inf_0( .I(C_awlen_m_inf[0]), .O(awlen_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awlen_m_inf_1( .I(C_awlen_m_inf[1]), .O(awlen_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awlen_m_inf_2( .I(C_awlen_m_inf[2]), .O(awlen_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awlen_m_inf_3( .I(C_awlen_m_inf[3]), .O(awlen_m_inf[3]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awlen_m_inf_4( .I(C_awlen_m_inf[4]), .O(awlen_m_inf[4]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awlen_m_inf_5( .I(C_awlen_m_inf[5]), .O(awlen_m_inf[5]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_awlen_m_inf_6( .I(C_awlen_m_inf[6]), .O(awlen_m_inf[6]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_awvalid_m_inf_0( .I(C_awvalid_m_inf), .O(awvalid_m_inf), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

XMD  I_awready_m_inf_0( .O(C_awready_m_inf[0]), .I(awready_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

YA2GSD  O_wdata_m_inf_0( .I(C_wdata_m_inf[0]), .O(wdata_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_1( .I(C_wdata_m_inf[1]), .O(wdata_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_2( .I(C_wdata_m_inf[2]), .O(wdata_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_3( .I(C_wdata_m_inf[3]), .O(wdata_m_inf[3]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_4( .I(C_wdata_m_inf[4]), .O(wdata_m_inf[4]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_5( .I(C_wdata_m_inf[5]), .O(wdata_m_inf[5]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_6( .I(C_wdata_m_inf[6]), .O(wdata_m_inf[6]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_7( .I(C_wdata_m_inf[7]), .O(wdata_m_inf[7]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_8( .I(C_wdata_m_inf[8]), .O(wdata_m_inf[8]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_9( .I(C_wdata_m_inf[9]), .O(wdata_m_inf[9]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_10( .I(C_wdata_m_inf[10]), .O(wdata_m_inf[10]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_11( .I(C_wdata_m_inf[11]), .O(wdata_m_inf[11]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_12( .I(C_wdata_m_inf[12]), .O(wdata_m_inf[12]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_13( .I(C_wdata_m_inf[13]), .O(wdata_m_inf[13]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_14( .I(C_wdata_m_inf[14]), .O(wdata_m_inf[14]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_wdata_m_inf_15( .I(C_wdata_m_inf[15]), .O(wdata_m_inf[15]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_wlast_m_inf_0( .I(C_wlast_m_inf), .O(wlast_m_inf), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_wvalid_m_inf_0( .I(C_wvalid_m_inf), .O(wvalid_m_inf), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

XMD  I_wready_m_inf_0( .O(C_wready_m_inf[0]), .I(wready_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

XMD  I_bid_m_inf_0( .O(C_bid_m_inf[0]), .I(bid_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_bid_m_inf_1( .O(C_bid_m_inf[1]), .I(bid_m_inf[1]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_bid_m_inf_2( .O(C_bid_m_inf[2]), .I(bid_m_inf[2]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_bid_m_inf_3( .O(C_bid_m_inf[3]), .I(bid_m_inf[3]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

XMD  I_bresp_m_inf_0( .O(C_bresp_m_inf[0]), .I(bresp_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_bresp_m_inf_1( .O(C_bresp_m_inf[1]), .I(bresp_m_inf[1]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

XMD  I_bvalid_m_inf_0( .O(C_bvalid_m_inf[0]), .I(bvalid_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

YA2GSD  O_bready_m_inf_0( .I(C_bready_m_inf[0]), .O(bready_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_arid_m_inf_0( .I(C_arid_m_inf[0]), .O(arid_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arid_m_inf_1( .I(C_arid_m_inf[1]), .O(arid_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arid_m_inf_2( .I(C_arid_m_inf[2]), .O(arid_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arid_m_inf_3( .I(C_arid_m_inf[3]), .O(arid_m_inf[3]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arid_m_inf_4( .I(C_arid_m_inf[4]), .O(arid_m_inf[4]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arid_m_inf_5( .I(C_arid_m_inf[5]), .O(arid_m_inf[5]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arid_m_inf_6( .I(C_arid_m_inf[6]), .O(arid_m_inf[6]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arid_m_inf_7( .I(C_arid_m_inf[7]), .O(arid_m_inf[7]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_araddr_m_inf_0( .I(C_araddr_m_inf[0]), .O(araddr_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_1( .I(C_araddr_m_inf[1]), .O(araddr_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_2( .I(C_araddr_m_inf[2]), .O(araddr_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_3( .I(C_araddr_m_inf[3]), .O(araddr_m_inf[3]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_4( .I(C_araddr_m_inf[4]), .O(araddr_m_inf[4]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_5( .I(C_araddr_m_inf[5]), .O(araddr_m_inf[5]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_6( .I(C_araddr_m_inf[6]), .O(araddr_m_inf[6]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_7( .I(C_araddr_m_inf[7]), .O(araddr_m_inf[7]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_8( .I(C_araddr_m_inf[8]), .O(araddr_m_inf[8]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_9( .I(C_araddr_m_inf[9]), .O(araddr_m_inf[9]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_10( .I(C_araddr_m_inf[10]), .O(araddr_m_inf[10]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_11( .I(C_araddr_m_inf[11]), .O(araddr_m_inf[11]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_12( .I(C_araddr_m_inf[12]), .O(araddr_m_inf[12]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_13( .I(C_araddr_m_inf[13]), .O(araddr_m_inf[13]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_14( .I(C_araddr_m_inf[14]), .O(araddr_m_inf[14]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_15( .I(C_araddr_m_inf[15]), .O(araddr_m_inf[15]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_16( .I(C_araddr_m_inf[16]), .O(araddr_m_inf[16]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_17( .I(C_araddr_m_inf[17]), .O(araddr_m_inf[17]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_18( .I(C_araddr_m_inf[18]), .O(araddr_m_inf[18]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_19( .I(C_araddr_m_inf[19]), .O(araddr_m_inf[19]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_20( .I(C_araddr_m_inf[20]), .O(araddr_m_inf[20]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_21( .I(C_araddr_m_inf[21]), .O(araddr_m_inf[21]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_22( .I(C_araddr_m_inf[22]), .O(araddr_m_inf[22]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_23( .I(C_araddr_m_inf[23]), .O(araddr_m_inf[23]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_24( .I(C_araddr_m_inf[24]), .O(araddr_m_inf[24]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_25( .I(C_araddr_m_inf[25]), .O(araddr_m_inf[25]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_26( .I(C_araddr_m_inf[26]), .O(araddr_m_inf[26]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_27( .I(C_araddr_m_inf[27]), .O(araddr_m_inf[27]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_28( .I(C_araddr_m_inf[28]), .O(araddr_m_inf[28]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_29( .I(C_araddr_m_inf[29]), .O(araddr_m_inf[29]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_30( .I(C_araddr_m_inf[30]), .O(araddr_m_inf[30]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_31( .I(C_araddr_m_inf[31]), .O(araddr_m_inf[31]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_32( .I(C_araddr_m_inf[32]), .O(araddr_m_inf[32]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_33( .I(C_araddr_m_inf[33]), .O(araddr_m_inf[33]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_34( .I(C_araddr_m_inf[34]), .O(araddr_m_inf[34]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_35( .I(C_araddr_m_inf[35]), .O(araddr_m_inf[35]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_36( .I(C_araddr_m_inf[36]), .O(araddr_m_inf[36]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_37( .I(C_araddr_m_inf[37]), .O(araddr_m_inf[37]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_38( .I(C_araddr_m_inf[38]), .O(araddr_m_inf[38]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_39( .I(C_araddr_m_inf[39]), .O(araddr_m_inf[39]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_40( .I(C_araddr_m_inf[40]), .O(araddr_m_inf[40]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_41( .I(C_araddr_m_inf[41]), .O(araddr_m_inf[41]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_42( .I(C_araddr_m_inf[42]), .O(araddr_m_inf[42]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_43( .I(C_araddr_m_inf[43]), .O(araddr_m_inf[43]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_44( .I(C_araddr_m_inf[44]), .O(araddr_m_inf[44]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_45( .I(C_araddr_m_inf[45]), .O(araddr_m_inf[45]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_46( .I(C_araddr_m_inf[46]), .O(araddr_m_inf[46]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_47( .I(C_araddr_m_inf[47]), .O(araddr_m_inf[47]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_48( .I(C_araddr_m_inf[48]), .O(araddr_m_inf[48]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_49( .I(C_araddr_m_inf[49]), .O(araddr_m_inf[49]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_50( .I(C_araddr_m_inf[50]), .O(araddr_m_inf[50]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_51( .I(C_araddr_m_inf[51]), .O(araddr_m_inf[51]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_52( .I(C_araddr_m_inf[52]), .O(araddr_m_inf[52]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_53( .I(C_araddr_m_inf[53]), .O(araddr_m_inf[53]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_54( .I(C_araddr_m_inf[54]), .O(araddr_m_inf[54]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_55( .I(C_araddr_m_inf[55]), .O(araddr_m_inf[55]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_56( .I(C_araddr_m_inf[56]), .O(araddr_m_inf[56]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_57( .I(C_araddr_m_inf[57]), .O(araddr_m_inf[57]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_58( .I(C_araddr_m_inf[58]), .O(araddr_m_inf[58]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_59( .I(C_araddr_m_inf[59]), .O(araddr_m_inf[59]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_60( .I(C_araddr_m_inf[60]), .O(araddr_m_inf[60]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_61( .I(C_araddr_m_inf[61]), .O(araddr_m_inf[61]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_62( .I(C_araddr_m_inf[62]), .O(araddr_m_inf[62]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_araddr_m_inf_63( .I(C_araddr_m_inf[63]), .O(araddr_m_inf[63]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_arlen_m_inf_0( .I(C_arlen_m_inf[0]), .O(arlen_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_1( .I(C_arlen_m_inf[1]), .O(arlen_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_2( .I(C_arlen_m_inf[2]), .O(arlen_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_3( .I(C_arlen_m_inf[3]), .O(arlen_m_inf[3]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_4( .I(C_arlen_m_inf[4]), .O(arlen_m_inf[4]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_5( .I(C_arlen_m_inf[5]), .O(arlen_m_inf[5]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_6( .I(C_arlen_m_inf[6]), .O(arlen_m_inf[6]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_7( .I(C_arlen_m_inf[7]), .O(arlen_m_inf[7]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_8( .I(C_arlen_m_inf[8]), .O(arlen_m_inf[8]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_9( .I(C_arlen_m_inf[9]), .O(arlen_m_inf[9]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_10( .I(C_arlen_m_inf[10]), .O(arlen_m_inf[10]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_11( .I(C_arlen_m_inf[11]), .O(arlen_m_inf[11]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_12( .I(C_arlen_m_inf[12]), .O(arlen_m_inf[12]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arlen_m_inf_13( .I(C_arlen_m_inf[13]), .O(arlen_m_inf[13]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_arsize_m_inf_0( .I(C_arsize_m_inf[0]), .O(arsize_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arsize_m_inf_1( .I(C_arsize_m_inf[1]), .O(arsize_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arsize_m_inf_2( .I(C_arsize_m_inf[2]), .O(arsize_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arsize_m_inf_3( .I(C_arsize_m_inf[3]), .O(arsize_m_inf[3]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arsize_m_inf_4( .I(C_arsize_m_inf[4]), .O(arsize_m_inf[4]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arsize_m_inf_5( .I(C_arsize_m_inf[5]), .O(arsize_m_inf[5]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_arburst_m_inf_0( .I(C_arburst_m_inf[0]), .O(arburst_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arburst_m_inf_1( .I(C_arburst_m_inf[1]), .O(arburst_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arburst_m_inf_2( .I(C_arburst_m_inf[2]), .O(arburst_m_inf[2]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arburst_m_inf_3( .I(C_arburst_m_inf[3]), .O(arburst_m_inf[3]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

YA2GSD  O_arvalid_m_inf_0( .I(C_arvalid_m_inf[0]), .O(arvalid_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_arvalid_m_inf_1( .I(C_arvalid_m_inf[1]), .O(arvalid_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

XMD  I_arready_m_inf_0( .O(C_arready_m_inf[0]), .I(arready_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_arready_m_inf_1( .O(C_arready_m_inf[1]), .I(arready_m_inf[1]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

XMD  I_rid_m_inf_0( .O(C_rid_m_inf[0]), .I(rid_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rid_m_inf_1( .O(C_rid_m_inf[1]), .I(rid_m_inf[1]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rid_m_inf_2( .O(C_rid_m_inf[2]), .I(rid_m_inf[2]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rid_m_inf_3( .O(C_rid_m_inf[3]), .I(rid_m_inf[3]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rid_m_inf_4( .O(C_rid_m_inf[4]), .I(rid_m_inf[4]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rid_m_inf_5( .O(C_rid_m_inf[5]), .I(rid_m_inf[5]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rid_m_inf_6( .O(C_rid_m_inf[6]), .I(rid_m_inf[6]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rid_m_inf_7( .O(C_rid_m_inf[7]), .I(rid_m_inf[7]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

XMD  I_rdata_m_inf_0( .O(C_rdata_m_inf[0]), .I(rdata_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_1( .O(C_rdata_m_inf[1]), .I(rdata_m_inf[1]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_2( .O(C_rdata_m_inf[2]), .I(rdata_m_inf[2]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_3( .O(C_rdata_m_inf[3]), .I(rdata_m_inf[3]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_4( .O(C_rdata_m_inf[4]), .I(rdata_m_inf[4]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_5( .O(C_rdata_m_inf[5]), .I(rdata_m_inf[5]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_6( .O(C_rdata_m_inf[6]), .I(rdata_m_inf[6]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_7( .O(C_rdata_m_inf[7]), .I(rdata_m_inf[7]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_8( .O(C_rdata_m_inf[8]), .I(rdata_m_inf[8]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_9( .O(C_rdata_m_inf[9]), .I(rdata_m_inf[9]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_10( .O(C_rdata_m_inf[10]), .I(rdata_m_inf[10]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_11( .O(C_rdata_m_inf[11]), .I(rdata_m_inf[11]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_12( .O(C_rdata_m_inf[12]), .I(rdata_m_inf[12]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_13( .O(C_rdata_m_inf[13]), .I(rdata_m_inf[13]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_14( .O(C_rdata_m_inf[14]), .I(rdata_m_inf[14]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_15( .O(C_rdata_m_inf[15]), .I(rdata_m_inf[15]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_16( .O(C_rdata_m_inf[16]), .I(rdata_m_inf[16]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_17( .O(C_rdata_m_inf[17]), .I(rdata_m_inf[17]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_18( .O(C_rdata_m_inf[18]), .I(rdata_m_inf[18]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_19( .O(C_rdata_m_inf[19]), .I(rdata_m_inf[19]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_20( .O(C_rdata_m_inf[20]), .I(rdata_m_inf[20]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_21( .O(C_rdata_m_inf[21]), .I(rdata_m_inf[21]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_22( .O(C_rdata_m_inf[22]), .I(rdata_m_inf[22]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_23( .O(C_rdata_m_inf[23]), .I(rdata_m_inf[23]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_24( .O(C_rdata_m_inf[24]), .I(rdata_m_inf[24]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_25( .O(C_rdata_m_inf[25]), .I(rdata_m_inf[25]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_26( .O(C_rdata_m_inf[26]), .I(rdata_m_inf[26]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_27( .O(C_rdata_m_inf[27]), .I(rdata_m_inf[27]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_28( .O(C_rdata_m_inf[28]), .I(rdata_m_inf[28]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_29( .O(C_rdata_m_inf[29]), .I(rdata_m_inf[29]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_30( .O(C_rdata_m_inf[30]), .I(rdata_m_inf[30]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rdata_m_inf_31( .O(C_rdata_m_inf[31]), .I(rdata_m_inf[31]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

XMD  I_rresp_m_inf_0( .O(C_rresp_m_inf[0]), .I(rresp_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rresp_m_inf_1( .O(C_rresp_m_inf[1]), .I(rresp_m_inf[1]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rresp_m_inf_2( .O(C_rresp_m_inf[2]), .I(rresp_m_inf[2]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rresp_m_inf_3( .O(C_rresp_m_inf[3]), .I(rresp_m_inf[3]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

XMD  I_rlast_m_inf_0( .O(C_rlast_m_inf[0]), .I(rlast_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rlast_m_inf_1( .O(C_rlast_m_inf[1]), .I(rlast_m_inf[1]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

XMD  I_rvalid_m_inf_0( .O(C_rvalid_m_inf[0]), .I(rvalid_m_inf[0]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );
XMD  I_rvalid_m_inf_1( .O(C_rvalid_m_inf[1]), .I(rvalid_m_inf[1]), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

YA2GSD  O_rready_m_inf_0( .I(C_rready_m_inf[0]), .O(rready_m_inf[0]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );
YA2GSD  O_rready_m_inf_1( .I(C_rready_m_inf[1]), .O(rready_m_inf[1]), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

XMD  I_clk_0( .O(C_clk), .I(clk), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

XMD  I_rst_n_0( .O(C_rst_n), .I(rst_n), .PU(1'b0), .PD(1'b0), .SMT(1'b0) );

YA2GSD  O_IO_stall_0( .I(C_IO_stall), .O(IO_stall), .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0) );

//I/O power 3.3V pads x? (DVDD + DGND)
VCC3IOD VDDP0 ();
GNDIOD  GNDP0 ();
VCC3IOD VDDP1 ();
GNDIOD  GNDP1 ();
VCC3IOD VDDP2 ();
GNDIOD  GNDP2 ();
VCC3IOD VDDP3 ();
GNDIOD  GNDP3 ();

VCC3IOD VDDP4 ();
GNDIOD  GNDP4 ();
VCC3IOD VDDP5 ();
GNDIOD  GNDP5 ();
VCC3IOD VDDP6 ();
GNDIOD  GNDP6 ();
VCC3IOD VDDP7 ();
GNDIOD  GNDP7 ();

VCC3IOD VDDP8 ();
GNDIOD  GNDP8 ();
VCC3IOD VDDP9 ();
GNDIOD  GNDP9 ();
VCC3IOD VDDP10 ();
GNDIOD  GNDP10 ();
VCC3IOD VDDP11 ();
GNDIOD  GNDP11 ();

VCC3IOD VDDP12 ();
GNDIOD  GNDP12 ();
VCC3IOD VDDP13 ();
GNDIOD  GNDP13 ();
VCC3IOD VDDP14 ();
GNDIOD  GNDP14 ();
VCC3IOD VDDP15 ();
GNDIOD  GNDP15 ();

VCC3IOD VDDPA ();
GNDIOD  GNDPA ();
VCC3IOD VDDPB ();
GNDIOD  GNDPB ();
VCC3IOD VDDPC ();
GNDIOD  GNDPC ();
VCC3IOD VDDPD ();
GNDIOD  GNDPD ();



//Core poweri 1.8V pads x? (VDD + GND)
VCCKD VDDC0 ();
GNDKD GNDC0 ();
VCCKD VDDC1 ();
GNDKD GNDC1 ();
VCCKD VDDC2 ();
GNDKD GNDC2 ();
VCCKD VDDC3 ();
GNDKD GNDC3 ();

VCCKD VDDC4 ();
GNDKD GNDC4 ();
VCCKD VDDC5 ();
GNDKD GNDC5 ();
VCCKD VDDC6 ();
GNDKD GNDC6 ();
VCCKD VDDC7 ();
GNDKD GNDC7 ();

VCCKD VDDC8 ();
GNDKD GNDC8 ();
VCCKD VDDC9 ();
GNDKD GNDC9 ();
VCCKD VDDC10 ();
GNDKD GNDC10 ();
VCCKD VDDC11 ();
GNDKD GNDC11 ();

VCCKD VDDC12 ();
GNDKD GNDC12 ();
VCCKD VDDC13 ();
GNDKD GNDC13 ();
VCCKD VDDC14 ();
GNDKD GNDC14 ();
VCCKD VDDC15 ();
GNDKD GNDC15 ();

endmodule