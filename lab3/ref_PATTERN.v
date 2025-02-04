
`ifdef RTL
    `define CYCLE_TIME 10.0
`endif
`ifdef GATE
    `define CYCLE_TIME 10.0
`endif

module PATTERN(
           clk,
           rst_n,
           in_valid,
           guy,
           in0,
           in1,
           in2,
           in3,
           in4,
           in5,
           in6,
           in7,

           out_valid,
           out
       );

output reg       clk, rst_n;
output reg       in_valid;
output reg [2:0] guy;
output reg [1:0] in0, in1, in2, in3, in4, in5, in6, in7;
input            out_valid;
input      [1:0] out;

real CYCLE = `CYCLE_TIME;
integer SEED;
integer  counter, total_latency, i, source, destination, diff, space, adj, blockType;
integer patcount, j, wait_val_time, person, currentRow, currentHieght, preheight;
reg [1:0]map[63:0][7:0];
reg [2:0]start_point;
//================================================================
// clock
//================================================================
initial
begin
    clk = 0;
end
always #(CYCLE/2.0) clk = ~clk;

initial
begin
    SEED=311580053;
    rst_n = 1'b1;
    in_valid = 1'b0;
    guy = 3'bx;
    in0=2'bx;
    in1=2'bx;
    in2=2'bx;
    in3=2'bx;
    in4=2'bx;
    in5=2'bx;
    in6=2'bx;
    in7=2'bx;
    force clk = 0;
    total_latency = 0;

    reset_signal_task;

    for(patcount=0; patcount<80; patcount=patcount+1)
    begin
        general_mapType1;
        input_task;
        wait_out_valid;
        check_ans;
    end
    for(patcount=0; patcount<80; patcount=patcount+1)
    begin
        general_mapType2;
        input_task;
        wait_out_valid;
        check_ans;
    end
    for(patcount=0; patcount<80; patcount=patcount+1)
    begin
        general_mapType3;
        input_task;
        wait_out_valid;
        check_ans;
    end
    YOU_PASS_task;
end

task check_ans;
    begin
        person=start_point;
        currentRow=0;
        currentHieght=0;
        for(j=0;j<63;j=j+1)
        begin
            @(negedge clk);
            checkspec7;
            checkspec8;
        end
    end
endtask

task wait_out_valid;
    begin
        wait_val_time = 0;
        @(negedge clk);
        while(out_valid != 1)
        begin
            wait_val_time = wait_val_time + 1;
            if(wait_val_time == 3000)
            begin
                $display("***************************************************************");
                $display("*                      SPEC 6 IS FAIL!                        *");
                $display("*         The execution latency are over 3000 cycles          *");
                $display("***************************************************************");
                $finish;
            end
            @(negedge clk);
        end
    end
endtask

task input_task;
    begin
        for(j=0;j<64;j++)
        begin
            @(negedge clk);
            in_valid = 1'b1;
            checkspec4_5;
            if(j==0)
                guy = start_point;
            else
                guy = 3'bx;
            in0 = map[i][0];
            in1 = map[i][1];
            in2 = map[i][2];
            in3 = map[i][3];
            in4 = map[i][4];
            in5 = map[i][5];
            in6 = map[i][6];
            in7 = map[i][7];
        end
        @(negedge clk);
        in_valid = 1'b0;
        in0=2'bx;
        in1=2'bx;
        in2=2'bx;
        in3=2'bx;
        in4=2'bx;
        in5=2'bx;
        in6=2'bx;
        in7=2'bx;
    end
endtask

task checkspec8;
    begin
        if(currentHieght==0)
        begin
            currentRow=currentRow+1;
            if(out==2'd0)
            begin
                if(map[currentRow][person]==2'b11 || map[currentRow][person]==2'b01)
                    printspec8_1;
            end
            else if(out==2'd1)
            begin
                person=person+1;
                if(person>7 || map[currentRow][person]==2'b11 || map[currentRow][person]==2'b01)
                    printspec8_1;
            end
            else if(out==2'd2)
            begin
                person=person-1;
                if(person<0 || map[currentRow][person]==2'b11 || map[currentRow][person]==2'b01)
                    printspec8_1;
            end
            else if(out==2'd3)
            begin
                preheight=currentHieght;
                currentHieght=currentHieght+1;
                if(map[currentRow][person]==2'b11 || map[currentRow][person]==2'b10)
                    printspec8_1;
            end
        end
        else if(currentHieght==1)
        begin
            if(map[currentRow][person]==2'b01)
            begin
                currentRow=currentRow+1;
                if(out==2'd0)
                begin
                    preheight=currentHieght;
                    currentHieght=currentHieght-1;
                    if(map[currentRow][person]==2'b11 || map[currentRow][person]==2'b01)
                        printspec8_1;
                end
                else if(out==2'd1)
                begin
                    person=person+1;
                    preheight=currentHieght;
                    currentHieght=currentHieght-1;
                    if(person>7 || map[currentRow][person]==2'b11 || map[currentRow][person]==2'b01)
                        printspec8_1;
                end
                else if(out==2'd2)
                begin
                    person=person-1;
                    preheight=currentHieght;
                    currentHieght=currentHieght-1;
                    if(person<0 || map[currentRow][person]==2'b11 || map[currentRow][person]==2'b01)
                        printspec8_1;
                end
                else if(out==2'd3)
                begin
                    preheight=currentHieght;
                    currentHieght=currentHieght+1;
                end
            end
            else
            begin
                if(out!=0)
                begin
                    if(preheight>currentHieght)
                        printspec8_2;
                    else
                        printspec8_3;
                end
                else
                begin
                    preheight=currentHieght;
                    currentHieght=currentHieght-1;
                    currentRow=currentRow+1;
                    if(map[currentRow][person]==2'b11 || map[currentRow][person]==2'b01)
                        printspec8_1;
                end
            end
        end
        else if(currentHieght==2)
        begin
            if(out==0)
            begin
                preheight=currentHieght;
                currentHieght=currentHieght-1;
                currentRow=currentRow+1;
                if(map[currentRow][person]==2'b11 || map[currentRow][person]==2'b10)
                    printspec8_1;
            end
            else
            begin
                printspec8_3;
            end
        end
    end
endtask

task printspec8_1;
    begin
        $display("**************************************************************");
        $display("*                     SPEC 8-1 IS FAIL!                      *");
        $display("*                      ANSWER is WRONG                       *");
        $display("**************************************************************");
        $finish;
    end
endtask

task printspec8_2;
    begin
        $display("**************************************************************");
        $display("*                     SPEC 8-2 IS FAIL!                      *");
        $display("*            SEQUENCE WRONG (jump from high to low)          *");
        $display("**************************************************************");
        $finish;
    end
endtask

task printspec8_3;
    begin
        $display("**************************************************************");
        $display("*                     SPEC 8-3 IS FAIL!                      *");
        $display("*             SEQUENCE WRONG (jump from same hight)          *");
        $display("**************************************************************");
        $finish;
    end
endtask

task checkspec7;
    begin
        if(out_valid!=1)
        begin
            $display("**************************************************************");
            $display("*                      SPEC 7 IS FAIL!                       *");
            $display("*   OUT and OUT_VALID must be done in 63 cycles at %4t       *",$time);
            $display("**************************************************************");
            $finish;
        end
    end
endtask


task checkspec4_5;
    begin
        if(out_valid)
        begin
            $display("**************************************************************");
            $display("*                      SPEC 5 IS FAIL!                       *");
            $display("*   OUT_VALID should be 0 when IN_VALID is high at %4t       *",$time);
            $display("**************************************************************");
            $finish;
        end
        else
        begin
            if(out!=0)
            begin
                $display("**************************************************************");
                $display("*                      SPEC 4 IS FAIL!                       *");
                $display("*   OUT should be 0 when OUT_VALID is low at %4t             *",$time);
                $display("**************************************************************");
                $finish;
            end
        end
    end
endtask

task reset_signal_task;
    begin
        #CYCLE;
        rst_n=0;
        #CYCLE;
        if((out_valid !== 0)||(out !== 0))
        begin
            $display("**************************************************************");
            $display("*                      SPEC 3 IS FAIL!                       *");
            $display("*   Output signal should be 0 after initial RESET at %4t     *",$time);
            $display("**************************************************************");
            $finish;
        end
        #CYCLE;
        rst_n=1;
        #CYCLE;
        release clk;
    end
endtask

task general_mapType1;
    begin
        counter=0;
        start_point=$urandom(SEED)%8;
        source=start_point;
        while (counter<64)
        begin
            if(counter==0)
            begin
                general_space;
                counter=counter+1;
            end
            else if(counter==1)
            begin
                adj=1;
                blockType=2'b01;
                general_set;
            end
            else
            begin
                adj=2;
                blockType=2'b01;
                general_set;
            end
        end
    end
endtask

task general_mapType2;
    begin
        counter=0;
        start_point=$urandom(SEED)%8;
        source=start_point;
        while (counter<64)
        begin
            if(counter==0)
            begin
                general_space;
                counter=counter+1;
            end
            else if(counter==1)
            begin
                adj=1;
                blockType=2'b10;
                general_set;
            end
            else
            begin
                adj=2;
                blockType=2'b10;
                general_set;
            end
        end
    end
endtask

task general_mapType3;
    begin
        counter=0;
        start_point=$urandom(SEED)%8;
        source=start_point;
        while (counter<64)
        begin
            if(counter==0)
            begin
                general_space;
                counter=counter+1;
            end
            else if(counter==1)
            begin
                adj=1;
                space=$urandom(SEED)%1;
                if(space)
                    blockType=2'b01;
                else
                    blockType=2'b10;
                general_set;
            end
            else
            begin
                adj=2;
                space=$urandom(SEED)%1;
                if(space)
                    blockType=2'b01;
                else
                    blockType=2'b10;
                general_set;
            end
        end
    end
endtask

task general_space;
    begin
        for(i=0;i<8;i=i+1)
            map[counter][i]=2'b00;
    end
endtask
task general_block;
    begin
        for(i=0;i<8;i=i+1)
            map[counter][i]=2'b00;
    end
endtask

task general_set;
    begin
        destination=$urandom(SEED)%8;
        if(destination>source)
            diff=destination-source-adj;
        else
            diff=source-destination-adj;
        while(diff>0 && counter<64)
        begin
            general_space;
            counter=counter+1;
            diff=diff-1;
        end
        space=$urandom(SEED)%1;
        while(space==1 && counter<64)
        begin
            general_space;
            counter=counter+1;
            space=$urandom(SEED)%1;
        end
        if(counter<64)
        begin
            general_block;
            map[counter][destination]=blockType;
            source=destination;
            counter=counter+1;
        end
        if(counter<64)
        begin
            general_space;
            counter=counter+1;
        end
    end
endtask

task YOU_PASS_task;
    begin
        $display ("--------------------------------------------------------------------");
        $display ("          ~(￣▽￣)~(＿△＿)~(￣▽￣)~(＿△＿)~(￣▽￣)~            ");
        $display ("                         Congratulations!                           ");
        $display ("                  You have passed all patterns!                     ");
        $display ("--------------------------------------------------------------------");
        $finish;
    end
endtask

endmodule
