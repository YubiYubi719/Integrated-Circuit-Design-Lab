//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Siamese Neural Network
//   Author     		: Jia-Yu Lee (maggie8905121@gmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : PATTERN.v
//   Module Name : PATTERN
//   Release version : V1.0 (Release Date: 2023-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`define CYCLE_TIME      50.0
`define SEED_NUMBER     28825252
`define PATTERN_NUMBER 10000

module PATTERN(
    //Output Port
    clk,
    rst_n,
    in_valid,
    in_valid2,
    mode,
    matrix_size,
	matrix,
    matrix_idx,
    //Input Port
    out_valid,
    out_value
    );

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
output reg         clk, rst_n, in_valid, in_valid2;
output reg signed [7:0]  matrix;
output reg [1:0]  matrix_size;
output reg [3:0]  matrix_idx;
output reg  mode;
input     out_valid;
input     out_value;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------


real CYCLE = `CYCLE_TIME;
integer a, b, c, d, e, Img_read, Kernel_read, matrix_size_read, matrix_idx_read, mode_read;

always #(CYCLE/2.0) clk = ~clk;

initial begin
    clk = 0;

    Img_read = $fopen("../00_TESTBED/Img.txt", "r");
    Kernel_read = $fopen("../00_TESTBED/Kernel.txt", "r");
    matrix_size_read = $fopen("../00_TESTBED/matrix_size.txt", "r");
    matrix_idx_read = $fopen("../00_TESTBED/matrix_idx.txt", "r");
    mode_read = $fopen("../00_TESTBED/mode.txt", "r");

    reset_signal_task;

    input_task;

    $fclose(Img_read);
    $fclose(Kernel_read);
    $fclose(matrix_size_read);
    $fclose(matrix_idx_read);

    $display("End pattern");
    $finish;
end

task reset_signal_task; begin
    
    clk = 1'b0;
    rst_n = 1'b1;
    in_valid = 1'b0;
    in_valid2 = 1'b0;

    matrix = 8'b0;
    matrix_size = 2'b0;
    matrix_idx = 4'b0;
    mode = 1'b0;


    force clk = 1'b0;
    
    #(CYCLE);

    rst_n = 1'b0;

    #(100);

    
    rst_n = 1'b1;

    
    #(120);
    release clk;

    
end
endtask


task input_task; begin


    repeat(5) @(negedge clk);

    
    in_valid = 1'b1;

    // $fscanf(Img_read, "%d", matrix);
    // $fscanf(Kernel_read, "%d", matrix);
    // $fscanf(matrix_size_read, "%d", matrix_size);
    // $fscanf(matrix_idx_read, "%d", matrix_idx);

    

    for(a = 1; a <= 1; a = a + 1) begin
        $fscanf(matrix_size_read, "%d", matrix_size);
        $fscanf(Img_read, "%d", matrix);
        @(negedge clk);
    end
    matrix_size = 1'b0;

    for(b = 2; b <= 1024; b = b + 1) begin
        $fscanf(Img_read, "%d", matrix);
        @(negedge clk);
    end

    for(c = 1025; c <= 1424; c = c + 1) begin
        $fscanf(Kernel_read, "%d", matrix);
        // $display(matrix);
        @(negedge clk);
    end
    matrix = 1'b0;
    in_valid = 1'b0;


    repeat(3)@(negedge clk);

    in_valid2 = 1'b1;
    $fscanf(matrix_idx_read, "%d", matrix_idx);
    $fscanf(mode_read, "%d", mode);
    @(negedge clk);

    $fscanf(matrix_idx_read, "%d", matrix_idx);
    @(negedge clk);
    
    matrix_idx = 1'b0;
    in_valid2 = 1'b0;

    repeat(5000)@(negedge clk);

end
endtask

endmodule


