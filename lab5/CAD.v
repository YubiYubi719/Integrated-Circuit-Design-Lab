module CAD(
    // input signals
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid), 
    .in_valid2(in_valid2),
    .mode(mode),
    .matrix_size(matrix_size),
    .matrix(matrix),
    .matrix_idx(matrix_idx),
    // output signals
    .out_valid(out_valid),
    .out_value(out_value)
    );

input clk;
input rst_n;
input in_valid;
input in_valid2;
input [1:0] matrix_size;
input [7:0] matrix;
input [3:0] matrix_idx;
input mode;

output reg out_valid;
output reg out_value;

reg [9:0] input_cnt;
reg       input_cnt_2;
reg [3:0] matrix_cnt;
reg signed [7:0] matrix_reg;
reg [4:0] init_cnt;
reg [13:0] img_addr_cnt;
reg [8:0]  ker_addr_cnt;
reg       maxpool_cnt_1;
reg signed [4:0] maxpool_cnt_2;
reg signed [4:0] maxpool_row;
reg [3:0] maxpooling_idx;


reg [1:0] matrix_size_reg;
reg [14:0] img_addr;
reg [8:0]  ker_addr;
reg [10:0] output_addr_a;
reg img_web;
reg ker_web;
reg output_web_a;
reg signed [19:0] output_do_a;
reg signed [19:0] output_di_a;
reg mode_reg;
reg [3:0] i_matrix_idx;
reg [3:0] k_matrix_idx;
reg signed [7:0] curKernel [0:4][0:4];
reg signed [7:0] curImg    [0:4][0:4];
reg signed [7:0] nextImg   [0:4][0:4];
reg signed [7:0] tmpImg    [0:4];
reg [5:0] imgWidth;
reg [14:0] img_pos;
reg [8:0]  ker_pos;
reg [3:0]  rowID;
reg [3:0]  colID;
reg [4:0]  rowID_d; // delay
reg [4:0]  colID_d; // delay
reg signed [7:0]  imgSRAM_out;
reg signed [7:0]  kerSRAM_out;
reg [4:0]  img_rowID_conv;
reg [4:0]  img_colID_conv;
reg [4:0]  img_rowID_conv_d; // delay
reg [4:0]  img_colID_conv_d; // delay
reg [4:0]  offset;
reg [2:0]  cal_rowID;
reg signed [19:0] row_output;
reg signed [19:0] sum;
reg signed [19:0] maxpooling [0:13];
reg [3:0]  poolWidth; // 8x8: width = 2, 16x16: width = 6, 32x32: width = 14
reg [10:0] output_addr_ub;
reg signed [19:0] bigger;

integer i, j, k;



parameter IDLE = 5'd0,
          READ_INPUT_IMG = 5'd1,
          READ_INPUT_KER = 5'd2,
          READ_INPUT_2 = 5'd3,
          CONV_INIT = 5'd4,
          DECONV_INIT = 5'd5,
          CONV = 5'd6,
          DECONV = 5'd7;

reg [4:0] curState, nextState;

mySRAM_img Img0 (.A0(img_addr[0]), .A1(img_addr[1]), .A2(img_addr[2]), .A3(img_addr[3]), .A4(img_addr[4]), .A5(img_addr[5]), .A6(img_addr[6]), .A7(img_addr[7]), .A8(img_addr[8]), .A9(img_addr[9]), .A10(img_addr[10]), .A11(img_addr[11]), .A12(img_addr[12]), .A13(img_addr[13]), .A14(img_addr[14]),
            .DO0(imgSRAM_out[0]), .DO1(imgSRAM_out[1]), .DO2(imgSRAM_out[2]), .DO3(imgSRAM_out[3]), .DO4(imgSRAM_out[4]), .DO5(imgSRAM_out[5]), .DO6(imgSRAM_out[6]), .DO7(imgSRAM_out[7]), 
            .DI0(matrix_reg[0]), .DI1(matrix_reg[1]), .DI2(matrix_reg[2]), .DI3(matrix_reg[3]), .DI4(matrix_reg[4]), .DI5(matrix_reg[5]), .DI6(matrix_reg[6]), .DI7(matrix_reg[7]), 
            .CK(clk), 
            .WEB(img_web),
            .OE(1'b1), 
            .CS(1'b1)
            );

mySRAM_kernel Kernel0 (.A0(ker_addr[0]), .A1(ker_addr[1]), .A2(ker_addr[2]), .A3(ker_addr[3]), .A4(ker_addr[4]), .A5(ker_addr[5]), .A6(ker_addr[6]), .A7(ker_addr[7]), .A8(ker_addr[8]), 
                    .DO0(kerSRAM_out[0]), .DO1(kerSRAM_out[1]), .DO2(kerSRAM_out[2]), .DO3(kerSRAM_out[3]), .DO4(kerSRAM_out[4]), .DO5(kerSRAM_out[5]), .DO6(kerSRAM_out[6]), .DO7(kerSRAM_out[7]), 
                    .DI0(matrix_reg[0]), .DI1(matrix_reg[1]), .DI2(matrix_reg[2]), .DI3(matrix_reg[3]), .DI4(matrix_reg[4]), .DI5(matrix_reg[5]), .DI6(matrix_reg[6]), .DI7(matrix_reg[7]), 
                    .CK(clk), 
                    .WEB(ker_web), 
                    .OE(1'b1), 
                    .CS(1'b1)
                    );

mySRAM_output Output0 (.A0(output_addr_a[0]),.A1(output_addr_a[1]),.A2(output_addr_a[2]),.A3(output_addr_a[3]),.A4(output_addr_a[4]),.A5(output_addr_a[5]),.A6(output_addr_a[6]),.A7(output_addr_a[7]),.A8(output_addr_a[8]),.A9(output_addr_a[9]),.A10(output_addr_a[10]),
                .DOA0(output_do_a[0]),.DOA1(output_do_a[1]),.DOA2(output_do_a[2]),.DOA3(output_do_a[3]),.DOA4(output_do_a[4]),.DOA5(output_do_a[5]),.DOA6(output_do_a[6]),.DOA7(output_do_a[7]),.DOA8(output_do_a[8]),.DOA9(output_do_a[9]),.DOA10(output_do_a[10]),.DOA11(output_do_a[11]),.DOA12(output_do_a[12]),.DOA13(output_do_a[13]),.DOA14(output_do_a[14]),.DOA15(output_do_a[15]),.DOA16(output_do_a[16]),.DOA17(output_do_a[17]),.DOA18(output_do_a[18]),.DOA19(output_do_a[19]),
                .DIA0(output_di_a[0]),.DIA1(output_di_a[1]),.DIA2(output_di_a[2]),.DIA3(output_di_a[3]),.DIA4(output_di_a[4]),.DIA5(output_di_a[5]),.DIA6(output_di_a[6]),.DIA7(output_di_a[7]),.DIA8(output_di_a[8]),.DIA9(output_di_a[9]),.DIA10(output_di_a[10]),.DIA11(output_di_a[11]),.DIA12(output_di_a[12]),.DIA13(output_di_a[13]),.DIA14(output_di_a[14]),.DIA15(output_di_a[15]),.DIA16(output_di_a[16]),.DIA17(output_di_a[17]),.DIA18(output_di_a[18]),.DIA19(output_di_a[19]),
                .WEAN(output_web_a),
                .CSA(1'b1),
                .OEA(1'b1),
                .CKA(clk)
                // .B0(addr_read[0]),.B1(addr_read[1]),.B2(addr_read[2]),.B3(addr_read[3]),.B4(addr_read[4]),.B5(addr_read[5]),.B6(addr_read[6]),.B7(addr_read[7]),.B8(addr_read[8]),.B9(addr_read[9]),.B10(addr_read[10]),
                // .DOB0(DO_read[0]),.DOB1(DO_read[1]),.DOB2(DO_read[2]),.DOB3(DO_read[3]),.DOB4(DO_read[4]),.DOB5(DO_read[5]),.DOB6(DO_read[6]),.DOB7(DO_read[7]),.DOB8(DO_read[8]),.DOB9(DO_read[9]),.DOB10(DO_read[10]),.DOB11(DO_read[11]),.DOB12(DO_read[12]),.DOB13(DO_read[13]),.DOB14(DO_read[14]),.DOB15(DO_read[15]),.DOB16(DO_read[16]),.DOB17(DO_read[17]),.DOB18(DO_read[18]),.DOB19(DO_read[19]),
                // .DIB0(DI_read[0]),.DIB1(DI_read[1]),.DIB2(DI_read[2]),.DIB3(DI_read[3]),.DIB4(DI_read[4]),.DIB5(DI_read[5]),.DIB6(DI_read[6]),.DIB7(DI_read[7]),.DIB8(DI_read[8]),.DIB9(DI_read[9]),.DIB10(DI_read[10]),.DIB11(DI_read[11]),.DIB12(DI_read[12]),.DIB13(DI_read[13]),.DIB14(DI_read[14]),.DIB15(DI_read[15]),.DIB16(DI_read[16]),.DIB17(DI_read[17]),.DIB18(DI_read[18]),.DIB19(DI_read[19]),
                // .WEBN(web_read),
                // .CKB(clk),
                // .CSB(1'b1),
                // .OEB(1'b1)
                );

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
        out_value <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) curState <= IDLE;
    else curState <= nextState;
end

always @(*) begin
    if(!rst_n) nextState = IDLE;
    else begin
        case(curState)
            IDLE: begin
                if(in_valid) nextState = READ_INPUT_IMG;
                else nextState = curState;
            end
            READ_INPUT_IMG: begin
                if(matrix_size_reg == 2'b00 && matrix_cnt == 15 && input_cnt == 63) nextState = READ_INPUT_KER;
                else if(matrix_size_reg == 2'b01 && matrix_cnt == 15 && input_cnt == 255) nextState = READ_INPUT_KER;
                else if(matrix_size_reg == 2'b10 && matrix_cnt == 15 && input_cnt == 1023) nextState = READ_INPUT_KER;
                else nextState = curState;
            end
            READ_INPUT_KER: begin
                if(matrix_cnt == 15 && input_cnt == 24) nextState = READ_INPUT_2;
                else nextState = curState;
            end
            READ_INPUT_2: begin
                if(input_cnt_2 == 1'b1) begin
                    if(mode_reg == 0) nextState = CONV_INIT;
                    else nextState = DECONV_INIT;
                end
                else nextState = curState;
            end
            CONV_INIT: begin
                if(rowID_d == 4 && colID_d == 4) nextState = CONV;
                else nextState = curState;
            end
            DECONV_INIT: begin
                if(rowID_d == 4 && colID_d == 4) nextState = DECONV;
                else nextState = curState;
            end
            CONV: begin
                if(output_addr_a == output_addr_ub - 1 && maxpool_cnt_1 == 1 && img_rowID_conv == 2) nextState = IDLE;
                else nextState = curState;
            end
            DECONV: begin
                nextState = DECONV;
            end
            default: nextState = IDLE;
        endcase
    end
end

// matrix_size_reg
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) matrix_size_reg <= 0;
    else if(curState == IDLE && in_valid) matrix_size_reg <= matrix_size;
end
// imgWidth
always @(*) begin
    imgWidth = 0;
    if(matrix_size_reg == 0) imgWidth = 6'd8;
    else if(matrix_size_reg == 1) imgWidth = 6'd16;
    else if(matrix_size_reg == 2) imgWidth = 6'd32;
end
// poolWidth
always @(*) begin
    poolWidth = 0;
    if(matrix_size_reg == 0) begin
        poolWidth = 4'd2;
    end
    else if(matrix_size_reg == 1) begin
        poolWidth = 4'd6;
    end
    else if(matrix_size_reg == 2) begin
        poolWidth = 4'd14;
    end
end
// output_addr_ub
always @(*) begin
    output_addr_ub = 0;
    if(matrix_size_reg == 0) begin
        output_addr_ub = 4;
    end
    else if(matrix_size_reg == 1) begin
        output_addr_ub = 36;
    end
    else if(matrix_size_reg == 2) begin
        output_addr_ub = 196;
    end
end
// input_cnt
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) input_cnt <= 0;
    else if(curState == READ_INPUT_IMG)begin
        if(matrix_size_reg == 2'b00) begin
            if(input_cnt == 63) begin
                input_cnt <= 0;
            end
            else input_cnt <= input_cnt + 1'b1;
        end
        else if(matrix_size_reg == 2'b01) begin
            if(input_cnt == 255) begin
                input_cnt <= 0;
            end
            else input_cnt <= input_cnt + 1'b1;
        end
        else if(matrix_size_reg == 2'b10) begin
            if(input_cnt == 1023) begin
                input_cnt <= 0;
            end
            else input_cnt <= input_cnt + 1'b1;
        end
    end
    else if(curState == READ_INPUT_KER) begin
        if(input_cnt == 24) input_cnt <= 0;
        else input_cnt <= input_cnt + 1;
    end
    else input_cnt <= 0;
end
// matrix_cnt
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) matrix_cnt <= 0;
    else if(curState == READ_INPUT_IMG) begin
        if(matrix_size_reg == 2'b00) begin
            if(matrix_cnt == 15 && input_cnt == 63) matrix_cnt <= 0;
            else if(input_cnt == 63) matrix_cnt <= matrix_cnt + 1;
        end
        else if(matrix_size_reg == 2'b01) begin
            if(matrix_cnt == 15 && input_cnt == 255) matrix_cnt <= 0;
            else if(input_cnt == 255) matrix_cnt <= matrix_cnt + 1;
        end
        else if(matrix_size_reg == 2'b10) begin
            if(matrix_cnt == 15 && input_cnt == 1023) matrix_cnt <= 0;
            else if(input_cnt == 1023) matrix_cnt <= matrix_cnt + 1;
        end
    end
    else if(curState == READ_INPUT_KER) begin
        if(matrix_cnt == 15 && input_cnt == 24) matrix_cnt <= 0;
        else if(input_cnt == 24) matrix_cnt <= matrix_cnt + 1'b1;
    end
    else matrix_cnt <= 0;
end

// matrix_reg
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) matrix_reg <= 0;
    else if(in_valid) matrix_reg <= matrix;
    else if(curState == READ_INPUT_KER && nextState == READ_INPUT_2) matrix_reg <= 0; 
end
// img_addr
always @(*) begin
    img_addr = 0;
    if(curState == IDLE) img_addr = 0;
    else if(curState == READ_INPUT_IMG) img_addr = img_addr_cnt;
    else if(curState == CONV_INIT)      img_addr = img_pos;
    else if(curState == CONV)           img_addr = img_pos;
    else if(curState == DECONV_INIT)    img_addr = img_pos;
    else if(curState == DECONV)         img_addr = img_pos;
    else if(curState == READ_INPUT_2 && nextState == READ_INPUT_2) img_addr = 16385;
end
// ker_addr
always @(*) begin
    ker_addr = 0;
    if(curState == IDLE) ker_addr = 0;
    else if(curState == READ_INPUT_KER) ker_addr = ker_addr_cnt;
    else if(curState == CONV_INIT) ker_addr = ker_pos;
    else if(curState == DECONV_INIT) ker_addr = ker_pos;
end
// img_addr_cnt
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) img_addr_cnt <= 0;
    else if(curState == IDLE) img_addr_cnt <= 0;
    else if(curState == READ_INPUT_IMG) img_addr_cnt <= img_addr_cnt + 1;
end
// ker_addr_cnt
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) ker_addr_cnt <= 0;
    else if(curState == IDLE) ker_addr_cnt <= 0;
    else if(curState == READ_INPUT_KER) ker_addr_cnt <= ker_addr_cnt + 1;
end
// img_web
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) img_web <= 1;
    else if(curState == IDLE && in_valid) img_web <= 1'b0;
    else if(curState == READ_INPUT_IMG && matrix_cnt == 15) begin
        if(matrix_size_reg == 2'b00 && input_cnt == 63) img_web <= 1'b1; 
        else if(matrix_size_reg == 2'b01 && input_cnt == 255) img_web <= 1'b1;
        else if(matrix_size_reg == 2'b10 && input_cnt == 1023) img_web <= 1'b1;
    end
    else if(curState == READ_INPUT_KER && nextState == READ_INPUT_2) img_web <= 0;
    else if(curState == READ_INPUT_2 && img_web == 0)img_web <= 1;
end
// ker_web
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) ker_web <= 1'b1;
    else if(curState == READ_INPUT_IMG && matrix_cnt == 15) begin
        if(matrix_size_reg == 2'b00 && input_cnt == 63) ker_web <= 1'b0; 
        else if(matrix_size_reg == 2'b01 && input_cnt == 255) ker_web <= 1'b0;
        else if(matrix_size_reg == 2'b10 && input_cnt == 1023) ker_web <= 1'b0;
    end
    else if(curState == READ_INPUT_KER && matrix_cnt == 15 && input_cnt == 24) ker_web <= 1'b1;
end
// input_cnt_2
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) input_cnt_2 <= 0;
    else if(curState == READ_INPUT_2 && in_valid2) input_cnt_2 <= input_cnt_2 + 1'b1;
    else input_cnt_2 <= 0;
end
// mode_reg
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) mode_reg <= 0;
    else if(curState == IDLE) mode_reg <= 0;
    else if(curState == READ_INPUT_2 && input_cnt_2 == 0) mode_reg <= mode;
end
// i_matrix_idx
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) i_matrix_idx <= 0;
    else if(curState == IDLE) i_matrix_idx <= 0;
    else if(curState == READ_INPUT_2 && in_valid2 && input_cnt_2 == 0) i_matrix_idx <= matrix_idx; 
end
// k_matrix_idx
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) k_matrix_idx <= 0;
    else if(curState == IDLE) k_matrix_idx <= 0;
    else if(curState == READ_INPUT_2 && in_valid2 && input_cnt_2 == 1) k_matrix_idx <= matrix_idx;
end

//==========================CONV============================
// init_cnt
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) init_cnt <= 0;
    else if(curState == CONV_INIT) begin
        if(init_cnt == 24) init_cnt <= 0;
        else init_cnt <= init_cnt + 1'b1;
    end
    else init_cnt <= 0;
end
// rowID
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) rowID <= 0;
    else if(curState == CONV_INIT) begin
        if(rowID == 4) rowID <= 0;
        else rowID <= rowID + 1;
    end
    else if(curState == DECONV_INIT) begin
        if(colID == 4 && rowID == 4) rowID <= 0;
        else if(colID == 4) rowID <= rowID + 1;
    end
    else rowID <= 0;
end
// colID
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) colID <= 0;
    else if(curState == CONV_INIT) begin
        if(colID == 4 && rowID == 4) colID <= 0;
        else if(rowID == 4) colID <= colID + 1;
    end
    else if(curState == DECONV_INIT) begin
        if(colID == 4) colID <= 0;
        else colID <= colID + 1;
    end
    else colID <= 0;
end
// rowID_d
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) rowID_d <= 0;
    else rowID_d <= rowID;
end
// colID_d
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) colID_d <= 0;
    else colID_d <= colID;
end
// img_pos
always @(*) begin
    img_pos = 0;
    if(curState == CONV_INIT) img_pos = i_matrix_idx*imgWidth*imgWidth + rowID*imgWidth + colID;
    else if(curState == CONV && img_colID_conv == 4) img_pos = i_matrix_idx*imgWidth*imgWidth + (img_colID_conv+offset)*imgWidth + img_rowID_conv;
    else if(curState == CONV) img_pos = i_matrix_idx*imgWidth*imgWidth + (img_rowID_conv+offset)*imgWidth + img_colID_conv;
    else if(curState == DECONV_INIT) begin
        if(rowID < 4 || colID < 4) img_pos = 16385;
        else img_pos = i_matrix_idx*imgWidth*imgWidth;
    end
    else if(curState == DECONV) begin
        if(img_rowID_conv + offset < 4 || img_rowID_conv + offset > imgWidth + 3
        || (img_colID_conv == 4 && img_rowID_conv < 4) || img_colID_conv > imgWidth + 3) begin
            img_pos = 16385; // mySRAM_img[16385] = 0
        end
        else if(img_colID_conv == 4) img_pos = i_matrix_idx*imgWidth*imgWidth + (img_colID_conv + offset-4)*imgWidth + img_rowID_conv-4;
        else img_pos = i_matrix_idx*imgWidth*imgWidth + (img_rowID_conv + offset - 4)*imgWidth + img_colID_conv-4;
    end
end
// ker_pos
always @(*) begin
    ker_pos = 0;
    if(curState == CONV_INIT) ker_pos = k_matrix_idx*25 + rowID*5 + colID;
    else if(curState == DECONV_INIT) ker_pos = k_matrix_idx*25 + rowID*5 + colID;
end
// curImg
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                curImg[i][j] <= 0;
            end
        end
    end
    else if(curState == IDLE) begin
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                curImg[i][j] <= 0;
            end
        end
    end
    // CONV
    else if(curState == CONV_INIT)begin
        curImg[rowID_d][colID_d] <= imgSRAM_out;
    end
    else if(curState == CONV && rowID_d == 0 && img_colID_conv == 5 && img_rowID_conv == 1) begin // shift left most
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                curImg[i][j] <= nextImg[i][j];
            end
        end
    end
    else if(curState == CONV && rowID_d == 0 && cal_rowID == 4) begin // shift right
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                curImg[i][j-1] <= curImg[i][j];
                if(j == 4) curImg[i][j] <= tmpImg[i];
            end
        end
    end
    // DECONV
    else if(curState == DECONV_INIT)begin
        curImg[rowID_d][colID_d] <= imgSRAM_out;
    end
    else if(curState == DECONV && rowID_d == 0 && img_colID_conv == 5 && img_rowID_conv == 1) begin // shift left most
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                curImg[i][j] <= nextImg[i][j];
            end
        end
    end
    else if(curState == DECONV && rowID_d == 0 && cal_rowID == 4 && !(offset == 0 && img_colID_conv == 5)) begin // shift right
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                curImg[i][j-1] <= curImg[i][j];
                if(j == 4) curImg[i][j] <= tmpImg[i];
            end
        end
    end
end
// nextImg
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                nextImg[i][j] <= 0;
            end
        end
    end
    else if(curState == IDLE) begin
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                nextImg[i][j] <= 0;
            end
        end
    end
    else if(curState == CONV && img_colID_conv == 5 && img_rowID_conv == 2) begin // save first curImg's row1 to row4
        for(i = 0; i < 4; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                nextImg[i][j] <= curImg[i+1][j];
            end
        end
    end
    else if(curState == CONV) begin
        nextImg[4][img_rowID_conv_d] <= imgSRAM_out;
    end
    else if(curState == DECONV && img_colID_conv == 5 && img_rowID_conv == 2) begin // save first curImg's row1 to row4
        for(i = 0; i < 4; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                nextImg[i][j] <= curImg[i+1][j];
            end
        end
    end
    else if(curState == DECONV) begin
        nextImg[4][img_rowID_conv_d] <= imgSRAM_out;
    end
end
// curKernel
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                curKernel[i][j] <= 0;
            end
        end
    end
    else if(curState == IDLE) begin
        for(i = 0; i < 5; i = i+1) begin
            for(j = 0; j < 5; j = j+1) begin
                curKernel[i][j] <= 0;
            end
        end
    end
    else if(curState == CONV_INIT)begin
        curKernel[rowID_d][colID_d] <= kerSRAM_out;
    end
    else if(curState == DECONV_INIT) begin
        curKernel[0][0] <= kerSRAM_out;
        curKernel[0][1] <= curKernel[0][0];
        curKernel[0][2] <= curKernel[0][1];
        curKernel[0][3] <= curKernel[0][2];
        curKernel[0][4] <= curKernel[0][3];

        curKernel[1][0] <= curKernel[0][4];
        curKernel[1][1] <= curKernel[1][0];
        curKernel[1][2] <= curKernel[1][1];
        curKernel[1][3] <= curKernel[1][2];
        curKernel[1][4] <= curKernel[1][3];

        curKernel[2][0] <= curKernel[1][4];
        curKernel[2][1] <= curKernel[2][0];
        curKernel[2][2] <= curKernel[2][1];
        curKernel[2][3] <= curKernel[2][2];
        curKernel[2][4] <= curKernel[2][3];

        curKernel[3][0] <= curKernel[2][4];
        curKernel[3][1] <= curKernel[3][0];
        curKernel[3][2] <= curKernel[3][1];
        curKernel[3][3] <= curKernel[3][2];
        curKernel[3][4] <= curKernel[3][3];

        curKernel[4][0] <= curKernel[3][4];
        curKernel[4][1] <= curKernel[4][0];
        curKernel[4][2] <= curKernel[4][1];
        curKernel[4][3] <= curKernel[4][2];
        curKernel[4][4] <= curKernel[4][3];
    end
end

// img_rowID_conv
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) img_rowID_conv <= 0;
    else if(curState == IDLE) img_rowID_conv <= 0;
    else if(curState == CONV) begin
        if(img_rowID_conv == 4) img_rowID_conv <= 0;
        else img_rowID_conv <= img_rowID_conv + 1;
    end
    else if(curState == DECONV) begin
        if(img_rowID_conv == 4) img_rowID_conv <= 0;
        else img_rowID_conv <= img_rowID_conv + 1;
    end
end
// img_colID_conv
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) img_colID_conv <= 5;
    else if(curState == IDLE) img_colID_conv <= 5;
    else if(curState == CONV) begin
        if(img_colID_conv == imgWidth - 1 && img_rowID_conv == 4) img_colID_conv <= 4;
        else if(img_rowID_conv == 4) img_colID_conv <= img_colID_conv + 1;
    end
    else if(curState == DECONV) begin
        if(img_colID_conv == imgWidth + 7 && img_rowID_conv == 4) img_colID_conv <= 4;
        else if(img_rowID_conv == 4) img_colID_conv <= img_colID_conv + 1;
    end
end
// img_rowID_conv_d
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) img_rowID_conv_d <= 0;
    else if(curState == IDLE) img_rowID_conv_d <= 0;
    else img_rowID_conv_d <= img_rowID_conv;
end
// img_colID_conv_d
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) img_colID_conv_d <= 0;
    else if(curState == IDLE) img_colID_conv_d <= 0;
    else img_colID_conv_d <= img_colID_conv;
end

// offset
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) offset <= 0;
    else if(curState == IDLE) offset <= 0;
    else if(curState == CONV) begin
        if(offset == imgWidth - 5 && img_colID_conv == imgWidth - 1 && img_rowID_conv == 4) offset <= 0;
        else if(img_colID_conv == imgWidth - 1 && img_rowID_conv == 4) offset <= offset + 1;
    end
    else if(curState == DECONV) begin
        if(offset == imgWidth + 3 && img_colID_conv == imgWidth + 7 && img_rowID_conv == 4) offset <= 0;
        else if(img_colID_conv == imgWidth + 7 && img_rowID_conv == 4) offset <= offset + 1;
    end
end
// tmpImg
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        tmpImg[0] <= 0;
        tmpImg[1] <= 0;
        tmpImg[2] <= 0;
        tmpImg[3] <= 0;
        tmpImg[4] <= 0;
    end
    else if(curState == IDLE) begin
        tmpImg[0] <= 0;
        tmpImg[1] <= 0;
        tmpImg[2] <= 0;
        tmpImg[3] <= 0;
        tmpImg[4] <= 0;
    end
    else if(curState == CONV) begin
        tmpImg[img_rowID_conv_d] <= imgSRAM_out;
    end
    else if(curState == DECONV) begin
        tmpImg[img_rowID_conv_d] <= imgSRAM_out;
    end
end
// cal_rowID
always @(*) begin
    cal_rowID = 0;
    if(curState == CONV) begin
        case(img_rowID_conv)
            2: cal_rowID = 0;
            3: cal_rowID = 1;
            4: cal_rowID = 2;
            0: cal_rowID = 3;
            1: cal_rowID = 4;
        endcase
    end
    if(curState == DECONV) begin
        case(img_rowID_conv)
            2: cal_rowID = 0;
            3: cal_rowID = 1;
            4: cal_rowID = 2;
            0: cal_rowID = 3;
            1: cal_rowID = 4;
        endcase
    end
end
// row_output
always @(*) begin
    row_output = curImg[cal_rowID][0]*curKernel[cal_rowID][0]
               + curImg[cal_rowID][1]*curKernel[cal_rowID][1]
               + curImg[cal_rowID][2]*curKernel[cal_rowID][2]
               + curImg[cal_rowID][3]*curKernel[cal_rowID][3]
               + curImg[cal_rowID][4]*curKernel[cal_rowID][4];
end
// sum
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) sum <= 0;
    if(curState == IDLE) sum <= 0;
    else if(curState == CONV) begin
        if(cal_rowID == 0) sum <= row_output;
        else sum <= sum + row_output;
    end
end
// maxpool_cnt_1
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) maxpool_cnt_1 <= 1;
    else if(curState == IDLE) maxpool_cnt_1 <= 1;
    else if(curState == CONV && img_rowID_conv == 2) begin
        maxpool_cnt_1 <= maxpool_cnt_1 + 1;
    end
end
// maxpool_cnt_2
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) maxpool_cnt_2 <= -1;
    else if(curState == IDLE) maxpool_cnt_2 <= -1;
    else if(curState == CONV) begin
        if(maxpool_cnt_2 == poolWidth - 1 && maxpool_cnt_1 == 1 && img_rowID_conv == 2) maxpool_cnt_2 <= 0; 
        else if(maxpool_cnt_1 == 1 && img_rowID_conv == 2) maxpool_cnt_2 <= maxpool_cnt_2 + 1;
    end
end
// maxpool_row
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) maxpool_row <= -1;
    else if(curState == IDLE) maxpool_row <= -1;
    else if(curState == CONV) begin
        if(maxpool_cnt_2 == poolWidth - 1 && maxpool_cnt_1 == 1 && img_rowID_conv == 2) maxpool_row <= maxpool_row + 1; 
    end
    else maxpool_row <= 0;
end

// maxpooling
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 14; i = i+1) begin
            maxpooling[i] <= 20'b10000000000000000000;
        end
    end
    else if(curState == IDLE) begin
        for(i = 0; i < 14; i = i+1) begin
            maxpooling[i] <= 20'b10000000000000000000;
        end
    end
    else if(curState == CONV) begin
        if(maxpool_row[0] == 0 && maxpool_cnt_1 == 0) maxpooling[maxpool_cnt_2] <= sum;
        else if(maxpool_row[0] == 0 && maxpool_cnt_1 == 1) maxpooling[maxpool_cnt_2] <= bigger;
        else if(maxpool_row[0] == 1) maxpooling[maxpool_cnt_2] <= bigger;
    end
end
// bigger
always @(*) begin
    bigger = maxpooling[maxpool_cnt_2];
    if(curState == CONV) begin
        if(maxpool_row[0] == 0 && maxpool_cnt_1 == 1) begin
            if(img_rowID_conv == 2) bigger = (sum > bigger)? sum:bigger;
        end
        else if(maxpool_row[0] == 1) begin
            if(img_rowID_conv == 2) bigger = (sum > bigger)? sum:bigger;
        end
    end
end
// output_web_a
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) output_web_a <= 1;
    else if(curState == CONV) begin
        if(output_web_a == 0) output_web_a <= 1;
        else if(maxpool_row[0] == 1 && maxpool_cnt_1 == 1 && img_rowID_conv == 1) output_web_a <= 0;
    end
    else output_web_a <= 1;
end
// output_addr_a
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) output_addr_a <= 0;
    else if(curState == CONV) begin
        if(output_addr_a == output_addr_ub - 1 && maxpool_cnt_1 == 1 && img_rowID_conv == 2) output_addr_a <= 0;
        else if(output_web_a == 0) output_addr_a <= output_addr_a + 1;
    end
end
// output_di_a
always @(*) begin
    output_di_a = 0;
    if(curState == CONV) begin
        output_di_a = bigger;
    end
end


endmodule