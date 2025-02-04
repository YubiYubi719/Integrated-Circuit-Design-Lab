//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2023/10
//		Version		: v1.0
//   	File Name   : SORT_IP.v
//   	Module Name : SORT_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module compAndSwap(
    // input signals
    a, b, wa, wb,
    // output signals
    bigger_id, smaller_id, bigger_w, smaller_w
);
    input [3:0] a, b;
    input [4:0] wa, wb;
    
    output reg [3:0] bigger_id, smaller_id;
    output reg [4:0] bigger_w, smaller_w;

    always @(*) begin
        if(wa >= wb) begin
            if(wa == wb && a >= b) begin
                bigger_id = a;
                smaller_id = b;
                bigger_w = wa;
                smaller_w = wb;
            end
            else if(wa == wb && a < b) begin
                bigger_id = b;
                smaller_id = a;
                bigger_w = wb;
                smaller_w = wa;
            end
            else begin
                bigger_id = a;
                smaller_id = b;
                bigger_w = wa;
                smaller_w = wb;
            end 
        end
        else begin // wa < wb
            bigger_id = b;
            smaller_id = a;
            bigger_w = wb;
            smaller_w = wa;
        end
    end
endmodule

module SORT_IP #(parameter IP_WIDTH = 8) (
    // Input signals
    IN_character, IN_weight,
    // Output signals
    OUT_character
);

// ===============================================================
// Input & Output
// ===============================================================
input [IP_WIDTH*4-1:0]  IN_character;
input [IP_WIDTH*5-1:0]  IN_weight;

output [IP_WIDTH*4-1:0] OUT_character;

// ===============================================================
// Design
// ===============================================================

generate
    if(IP_WIDTH == 3) begin
        wire [3:0] input_id     [0:2];
        wire [4:0] input_weight [0:2];
        // output signals
        wire [3:0] id [0:5];
        wire [4:0] w  [0:5];

        assign input_id[0] = IN_character [11:8];
        assign input_id[1] = IN_character [7:4];
        assign input_id[2] = IN_character [3:0];

        assign input_weight[0] = IN_weight [14:10];
        assign input_weight[1] = IN_weight [9:5];
        assign input_weight[2] = IN_weight [4:0];

        assign OUT_character = {id[2], id[4], id[5]};

        compAndSwap cas0(.a(input_id[0]), .b(input_id[2]), .wa(input_weight[0]), .wb(input_weight[2]),
                         .bigger_id(id[0]), .smaller_id(id[1]),
                         .bigger_w(w[0]), .smaller_w(w[1]));
        compAndSwap cas1(.a(id[0]), .b(input_id[1]), .wa(w[0]), .wb(input_weight[1]),
                         .bigger_id(id[2]), .smaller_id(id[3]),
                         .bigger_w(w[2]), .smaller_w(w[3]));
        compAndSwap cas2(.a(id[3]), .b(id[1]), .wa(w[3]), .wb(w[1]),
                         .bigger_id(id[4]), .smaller_id(id[5]),
                         .bigger_w(w[4]), .smaller_w(w[5]));

    end
    else if(IP_WIDTH == 4) begin
        wire [3:0] input_id     [0:3];
        wire [4:0] input_weight [0:3];
        // output signals
        wire [3:0] id [0:9];
        wire [4:0] w  [0:9];
        
        assign input_id[0] = IN_character [15:12];
        assign input_id[1] = IN_character [11:8];
        assign input_id[2] = IN_character [7:4];
        assign input_id[3] = IN_character [3:0];

        assign input_weight[0] = IN_weight [19:15];
        assign input_weight[1] = IN_weight [14:10];
        assign input_weight[2] = IN_weight [9:5];
        assign input_weight[3] = IN_weight [4:0];

        assign OUT_character = {id[4], id[8], id[9], id[7]};

        compAndSwap cas0(.a(input_id[0]), .b(input_id[2]), .wa(input_weight[0]), .wb(input_weight[2]),
                         .bigger_id(id[0]), .smaller_id(id[1]),
                         .bigger_w(w[0]), .smaller_w(w[1]));
        compAndSwap cas1(.a(input_id[1]), .b(input_id[3]), .wa(input_weight[1]), .wb(input_weight[3]),
                         .bigger_id(id[2]), .smaller_id(id[3]),
                         .bigger_w(w[2]), .smaller_w(w[3]));
        compAndSwap cas2(.a(id[0]), .b(id[2]), .wa(w[0]), .wb(w[2]),
                         .bigger_id(id[4]), .smaller_id(id[5]),
                         .bigger_w(w[4]), .smaller_w(w[5]));
        compAndSwap cas3(.a(id[1]), .b(id[3]), .wa(w[1]), .wb(w[3]),
                         .bigger_id(id[6]), .smaller_id(id[7]),
                         .bigger_w(w[6]), .smaller_w(w[7]));
        compAndSwap cas4(.a(id[5]), .b(id[6]), .wa(w[5]), .wb(w[6]),
                         .bigger_id(id[8]), .smaller_id(id[9]),
                         .bigger_w(w[8]), .smaller_w(w[9]));

    end
    else if(IP_WIDTH == 5) begin
        wire [3:0] input_id     [0:4];
        wire [4:0] input_weight [0:4];
        // output signals
        wire [3:0] id [0:17];
        wire [4:0] w  [0:17];

        assign OUT_character = {id[8], id[12], id[16], id[17], id[15]};
        
        assign input_id[0] = IN_character [19:16];
        assign input_id[1] = IN_character [15:12];
        assign input_id[2] = IN_character [11:8];
        assign input_id[3] = IN_character [7:4];
        assign input_id[4] = IN_character [3:0];

        assign input_weight[0] = IN_weight [24:20];
        assign input_weight[1] = IN_weight [19:15];
        assign input_weight[2] = IN_weight [14:10];
        assign input_weight[3] = IN_weight [9:5];
        assign input_weight[4] = IN_weight [4:0];

        compAndSwap cas0(.a(input_id[0]), .b(input_id[3]), .wa(input_weight[0]), .wb(input_weight[3]),
                         .bigger_id(id[0]), .smaller_id(id[1]),
                         .bigger_w(w[0]), .smaller_w(w[1]));
        compAndSwap cas1(.a(input_id[1]), .b(input_id[4]), .wa(input_weight[1]), .wb(input_weight[4]),
                         .bigger_id(id[2]), .smaller_id(id[3]),
                         .bigger_w(w[2]), .smaller_w(w[3]));
        compAndSwap cas2(.a(id[0]), .b(input_id[2]), .wa(w[0]), .wb(input_weight[2]),
                         .bigger_id(id[4]), .smaller_id(id[5]),
                         .bigger_w(w[4]), .smaller_w(w[5]));
        compAndSwap cas3(.a(id[2]), .b(id[1]), .wa(w[2]), .wb(w[1]),
                         .bigger_id(id[6]), .smaller_id(id[7]),
                         .bigger_w(w[6]), .smaller_w(w[7]));
        compAndSwap cas4(.a(id[4]), .b(id[6]), .wa(w[4]), .wb(w[6]),
                         .bigger_id(id[8]), .smaller_id(id[9]),
                         .bigger_w(w[8]), .smaller_w(w[9]));
        compAndSwap cas5(.a(id[5]), .b(id[3]), .wa(w[5]), .wb(w[3]),
                         .bigger_id(id[10]), .smaller_id(id[11]),
                         .bigger_w(w[10]), .smaller_w(w[11]));
        compAndSwap cas6(.a(id[9]), .b(id[10]), .wa(w[9]), .wb(w[10]),
                         .bigger_id(id[12]), .smaller_id(id[13]),
                         .bigger_w(w[12]), .smaller_w(w[13]));
        compAndSwap cas7(.a(id[7]), .b(id[11]), .wa(w[7]), .wb(w[11]),
                         .bigger_id(id[14]), .smaller_id(id[15]),
                         .bigger_w(w[14]), .smaller_w(w[15]));
        compAndSwap cas8(.a(id[13]), .b(id[14]), .wa(w[13]), .wb(w[14]),
                         .bigger_id(id[16]), .smaller_id(id[17]),
                         .bigger_w(w[16]), .smaller_w(w[17]));              
    end
    else if(IP_WIDTH == 6) begin
        wire [3:0] input_id     [0:5];
        wire [4:0] input_weight [0:5];
        // output signals
        wire [3:0] id [0:23];
        wire [4:0] w  [0:23];

        assign OUT_character = {id[14], id[20], id[21], id[22], id[23], id[19]};
        
        assign input_id[0] = IN_character [23:20];
        assign input_id[1] = IN_character [19:16];
        assign input_id[2] = IN_character [15:12];
        assign input_id[3] = IN_character [11:8];
        assign input_id[4] = IN_character [7:4];
        assign input_id[5] = IN_character [3:0];

        assign input_weight[0] = IN_weight [29:25];
        assign input_weight[1] = IN_weight [24:20];
        assign input_weight[2] = IN_weight [19:15];
        assign input_weight[3] = IN_weight [14:10];
        assign input_weight[4] = IN_weight [9:5];
        assign input_weight[5] = IN_weight [4:0];

        compAndSwap cas0(.a(input_id[1]), .b(input_id[3]), .wa(input_weight[1]), .wb(input_weight[3]),
                         .bigger_id(id[0]), .smaller_id(id[1]),
                         .bigger_w(w[0]), .smaller_w(w[1]));
        compAndSwap cas1(.a(input_id[0]), .b(input_id[5]), .wa(input_weight[0]), .wb(input_weight[5]),
                         .bigger_id(id[2]), .smaller_id(id[3]),
                         .bigger_w(w[2]), .smaller_w(w[3]));              
        compAndSwap cas2(.a(input_id[2]), .b(input_id[4]), .wa(input_weight[2]), .wb(input_weight[4]),
                         .bigger_id(id[4]), .smaller_id(id[5]),
                         .bigger_w(w[4]), .smaller_w(w[5])); 
        compAndSwap cas3(.a(id[0]), .b(id[4]), .wa(w[0]), .wb(w[4]),
                         .bigger_id(id[6]), .smaller_id(id[7]),
                         .bigger_w(w[6]), .smaller_w(w[7]));
        compAndSwap cas4(.a(id[1]), .b(id[5]), .wa(w[1]), .wb(w[5]),
                         .bigger_id(id[8]), .smaller_id(id[9]),
                         .bigger_w(w[8]), .smaller_w(w[9]));
        compAndSwap cas5(.a(id[2]), .b(id[8]), .wa(w[2]), .wb(w[8]),
                         .bigger_id(id[10]), .smaller_id(id[11]),
                         .bigger_w(w[10]), .smaller_w(w[11]));
        compAndSwap cas6(.a(id[7]), .b(id[3]), .wa(w[7]), .wb(w[3]),
                         .bigger_id(id[12]), .smaller_id(id[13]),
                         .bigger_w(w[12]), .smaller_w(w[13]));
        compAndSwap cas7(.a(id[10]), .b(id[6]), .wa(w[10]), .wb(w[6]),
                         .bigger_id(id[14]), .smaller_id(id[15]),
                         .bigger_w(w[14]), .smaller_w(w[15]));
        compAndSwap cas8(.a(id[12]), .b(id[11]), .wa(w[12]), .wb(w[11]),
                         .bigger_id(id[16]), .smaller_id(id[17]),
                         .bigger_w(w[16]), .smaller_w(w[17]));   
        compAndSwap cas9(.a(id[9]), .b(id[13]), .wa(w[9]), .wb(w[13]),
                         .bigger_id(id[18]), .smaller_id(id[19]),
                         .bigger_w(w[18]), .smaller_w(w[19]));   
        compAndSwap cas10(.a(id[15]), .b(id[16]), .wa(w[15]), .wb(w[16]),
                         .bigger_id(id[20]), .smaller_id(id[21]),
                         .bigger_w(w[20]), .smaller_w(w[21]));   
        compAndSwap cas11(.a(id[17]), .b(id[18]), .wa(w[17]), .wb(w[18]),
                         .bigger_id(id[22]), .smaller_id(id[23]),
                         .bigger_w(w[22]), .smaller_w(w[23]));                    
    end
    else if(IP_WIDTH == 7) begin
        wire [3:0] input_id     [0:6];
        wire [4:0] input_weight [0:6];
        // output signals
        wire [3:0] id [0:31];
        wire [4:0] w  [0:31];

        assign OUT_character = {id[12], id[26], id[27], id[28], id[29], id[30], id[31]};
        
        assign input_id[0] = IN_character [27:24];
        assign input_id[1] = IN_character [23:20];
        assign input_id[2] = IN_character [19:16];
        assign input_id[3] = IN_character [15:12];
        assign input_id[4] = IN_character [11:8];
        assign input_id[5] = IN_character [7:4];
        assign input_id[6] = IN_character [3:0];

        assign input_weight[0] = IN_weight [34:30];
        assign input_weight[1] = IN_weight [29:25];
        assign input_weight[2] = IN_weight [24:20];
        assign input_weight[3] = IN_weight [19:15];
        assign input_weight[4] = IN_weight [14:10];
        assign input_weight[5] = IN_weight [9:5];
        assign input_weight[6] = IN_weight [4:0];

        compAndSwap cas0(.a(input_id[0]), .b(input_id[6]), .wa(input_weight[0]), .wb(input_weight[6]),
                         .bigger_id(id[0]), .smaller_id(id[1]),
                         .bigger_w(w[0]), .smaller_w(w[1]));
        compAndSwap cas1(.a(input_id[2]), .b(input_id[3]), .wa(input_weight[2]), .wb(input_weight[3]),
                         .bigger_id(id[2]), .smaller_id(id[3]),
                         .bigger_w(w[2]), .smaller_w(w[3])); 
        compAndSwap cas2(.a(input_id[4]), .b(input_id[5]), .wa(input_weight[4]), .wb(input_weight[5]),
                         .bigger_id(id[4]), .smaller_id(id[5]),
                         .bigger_w(w[4]), .smaller_w(w[5])); 
        compAndSwap cas3(.a(input_id[1]), .b(id[4]), .wa(input_weight[1]), .wb(w[4]),
                         .bigger_id(id[6]), .smaller_id(id[7]),
                         .bigger_w(w[6]), .smaller_w(w[7]));
        compAndSwap cas4(.a(id[0]), .b(id[2]), .wa(w[0]), .wb(w[2]),
                         .bigger_id(id[8]), .smaller_id(id[9]),
                         .bigger_w(w[8]), .smaller_w(w[9]));
        compAndSwap cas5(.a(id[3]), .b(id[1]), .wa(w[3]), .wb(w[1]),
                         .bigger_id(id[10]), .smaller_id(id[11]),
                         .bigger_w(w[10]), .smaller_w(w[11]));
        compAndSwap cas6(.a(id[8]), .b(id[6]), .wa(w[8]), .wb(w[6]),
                         .bigger_id(id[12]), .smaller_id(id[13]),
                         .bigger_w(w[12]), .smaller_w(w[13]));
        compAndSwap cas7(.a(id[10]), .b(id[7]), .wa(w[10]), .wb(w[7]),
                         .bigger_id(id[14]), .smaller_id(id[15]),
                         .bigger_w(w[14]), .smaller_w(w[15]));
        compAndSwap cas8(.a(id[9]), .b(id[5]), .wa(w[9]), .wb(w[5]),
                         .bigger_id(id[16]), .smaller_id(id[17]),
                         .bigger_w(w[16]), .smaller_w(w[17]));
        compAndSwap cas9(.a(id[13]), .b(id[16]), .wa(w[13]), .wb(w[16]),
                         .bigger_id(id[18]), .smaller_id(id[19]),
                         .bigger_w(w[18]), .smaller_w(w[19]));  
        compAndSwap cas10(.a(id[15]), .b(id[11]), .wa(w[15]), .wb(w[11]),
                         .bigger_id(id[20]), .smaller_id(id[21]),
                         .bigger_w(w[20]), .smaller_w(w[21])); 
        compAndSwap cas11(.a(id[19]), .b(id[14]), .wa(w[19]), .wb(w[14]),
                         .bigger_id(id[22]), .smaller_id(id[23]),
                         .bigger_w(w[22]), .smaller_w(w[23]));  
        compAndSwap cas12(.a(id[20]), .b(id[17]), .wa(w[20]), .wb(w[17]),
                         .bigger_id(id[24]), .smaller_id(id[25]),
                         .bigger_w(w[24]), .smaller_w(w[25]));    
        compAndSwap cas13(.a(id[18]), .b(id[22]), .wa(w[18]), .wb(w[22]),
                         .bigger_id(id[26]), .smaller_id(id[27]),
                         .bigger_w(w[26]), .smaller_w(w[27]));
        compAndSwap cas14(.a(id[23]), .b(id[24]), .wa(w[23]), .wb(w[24]),
                         .bigger_id(id[28]), .smaller_id(id[29]),
                         .bigger_w(w[28]), .smaller_w(w[29]));
        compAndSwap cas15(.a(id[25]), .b(id[21]), .wa(w[25]), .wb(w[21]),
                         .bigger_id(id[30]), .smaller_id(id[31]),
                         .bigger_w(w[30]), .smaller_w(w[31]));
    end
    else if(IP_WIDTH == 8) begin
        wire [3:0] input_id     [0:7];
        wire [4:0] input_weight [0:7];
        // output signals
        wire [3:0] id [0:37];
        wire [4:0] w  [0:37];

        assign OUT_character = {id[16], id[32], id[33], id[34], id[35], id[36], id[37], id[23]};
        
        assign input_id[0] = IN_character [31:28];
        assign input_id[1] = IN_character [27:24];
        assign input_id[2] = IN_character [23:20];
        assign input_id[3] = IN_character [19:16];
        assign input_id[4] = IN_character [15:12];
        assign input_id[5] = IN_character [11:8];
        assign input_id[6] = IN_character [7:4];
        assign input_id[7] = IN_character [3:0];

        assign input_weight[0] = IN_weight [39:35];
        assign input_weight[1] = IN_weight [34:30];
        assign input_weight[2] = IN_weight [29:25];
        assign input_weight[3] = IN_weight [24:20];
        assign input_weight[4] = IN_weight [19:15];
        assign input_weight[5] = IN_weight [14:10];
        assign input_weight[6] = IN_weight [9:5];
        assign input_weight[7] = IN_weight [4:0];

        compAndSwap cas0(.a(input_id[1]), .b(input_id[3]), .wa(input_weight[1]), .wb(input_weight[3]),
                         .bigger_id(id[0]), .smaller_id(id[1]),
                         .bigger_w(w[0]), .smaller_w(w[1]));
        compAndSwap cas1(.a(input_id[4]), .b(input_id[6]), .wa(input_weight[4]), .wb(input_weight[6]),
                         .bigger_id(id[2]), .smaller_id(id[3]),
                         .bigger_w(w[2]), .smaller_w(w[3])); 
        compAndSwap cas2(.a(input_id[0]), .b(input_id[2]), .wa(input_weight[0]), .wb(input_weight[2]),
                         .bigger_id(id[4]), .smaller_id(id[5]),
                         .bigger_w(w[4]), .smaller_w(w[5])); 
        compAndSwap cas3(.a(input_id[5]), .b(input_id[7]), .wa(input_weight[5]), .wb(input_weight[7]),
                         .bigger_id(id[6]), .smaller_id(id[7]),
                         .bigger_w(w[6]), .smaller_w(w[7]));
        compAndSwap cas4(.a(id[4]), .b(id[2]), .wa(w[4]), .wb(w[2]),
                         .bigger_id(id[8]), .smaller_id(id[9]),
                         .bigger_w(w[8]), .smaller_w(w[9]));
        compAndSwap cas5(.a(id[0]), .b(id[6]), .wa(w[0]), .wb(w[6]),
                         .bigger_id(id[10]), .smaller_id(id[11]),
                         .bigger_w(w[10]), .smaller_w(w[11]));
        compAndSwap cas6(.a(id[5]), .b(id[3]), .wa(w[5]), .wb(w[3]),
                         .bigger_id(id[12]), .smaller_id(id[13]),
                         .bigger_w(w[12]), .smaller_w(w[13]));
        compAndSwap cas7(.a(id[1]), .b(id[7]), .wa(w[1]), .wb(w[7]),
                         .bigger_id(id[14]), .smaller_id(id[15]),
                         .bigger_w(w[14]), .smaller_w(w[15]));
        compAndSwap cas8(.a(id[8]), .b(id[10]), .wa(w[8]), .wb(w[10]),
                         .bigger_id(id[16]), .smaller_id(id[17]),
                         .bigger_w(w[16]), .smaller_w(w[17]));
        compAndSwap cas9(.a(id[12]), .b(id[14]), .wa(w[12]), .wb(w[14]),
                         .bigger_id(id[18]), .smaller_id(id[19]),
                         .bigger_w(w[18]), .smaller_w(w[19]));  
        compAndSwap cas10(.a(id[9]), .b(id[11]), .wa(w[9]), .wb(w[11]),
                         .bigger_id(id[20]), .smaller_id(id[21]),
                         .bigger_w(w[20]), .smaller_w(w[21])); 
        compAndSwap cas11(.a(id[13]), .b(id[15]), .wa(w[13]), .wb(w[15]),
                         .bigger_id(id[22]), .smaller_id(id[23]),
                         .bigger_w(w[22]), .smaller_w(w[23]));  
        compAndSwap cas12(.a(id[18]), .b(id[20]), .wa(w[18]), .wb(w[20]),
                         .bigger_id(id[24]), .smaller_id(id[25]),
                         .bigger_w(w[24]), .smaller_w(w[25]));    
        compAndSwap cas13(.a(id[19]), .b(id[21]), .wa(w[19]), .wb(w[21]),
                         .bigger_id(id[26]), .smaller_id(id[27]),
                         .bigger_w(w[26]), .smaller_w(w[27]));
        compAndSwap cas14(.a(id[17]), .b(id[25]), .wa(w[17]), .wb(w[25]),
                         .bigger_id(id[28]), .smaller_id(id[29]),
                         .bigger_w(w[28]), .smaller_w(w[29]));
        compAndSwap cas15(.a(id[26]), .b(id[22]), .wa(w[26]), .wb(w[22]),
                         .bigger_id(id[30]), .smaller_id(id[31]),
                         .bigger_w(w[30]), .smaller_w(w[31]));
        compAndSwap cas16(.a(id[28]), .b(id[24]), .wa(w[28]), .wb(w[24]),
                         .bigger_id(id[32]), .smaller_id(id[33]),
                         .bigger_w(w[32]), .smaller_w(w[33]));
        compAndSwap cas17(.a(id[30]), .b(id[29]), .wa(w[30]), .wb(w[29]),
                         .bigger_id(id[34]), .smaller_id(id[35]),
                         .bigger_w(w[34]), .smaller_w(w[35]));
        compAndSwap cas18(.a(id[27]), .b(id[31]), .wa(w[27]), .wb(w[31]),
                         .bigger_id(id[36]), .smaller_id(id[37]),
                         .bigger_w(w[36]), .smaller_w(w[37]));
    end
    else begin
        wire [3:0] input_id     [0:7];
        wire [4:0] input_weight [0:7];
        // output signals
        wire [3:0] id [0:37];
        wire [4:0] w  [0:37];

        assign OUT_character = {id[16], id[32], id[33], id[34], id[35], id[36], id[37], id[23]};
        
        assign input_id[0] = IN_character [31:28];
        assign input_id[1] = IN_character [27:24];
        assign input_id[2] = IN_character [23:20];
        assign input_id[3] = IN_character [19:16];
        assign input_id[4] = IN_character [15:12];
        assign input_id[5] = IN_character [11:8];
        assign input_id[6] = IN_character [7:4];
        assign input_id[7] = IN_character [3:0];

        assign input_weight[0] = IN_weight [39:35];
        assign input_weight[1] = IN_weight [34:30];
        assign input_weight[2] = IN_weight [29:25];
        assign input_weight[3] = IN_weight [24:20];
        assign input_weight[4] = IN_weight [19:15];
        assign input_weight[5] = IN_weight [14:10];
        assign input_weight[6] = IN_weight [9:5];
        assign input_weight[7] = IN_weight [4:0];

        compAndSwap cas0(.a(input_id[1]), .b(input_id[3]), .wa(input_weight[1]), .wb(input_weight[3]),
                         .bigger_id(id[0]), .smaller_id(id[1]),
                         .bigger_w(w[0]), .smaller_w(w[1]));
        compAndSwap cas1(.a(input_id[4]), .b(input_id[6]), .wa(input_weight[4]), .wb(input_weight[6]),
                         .bigger_id(id[2]), .smaller_id(id[3]),
                         .bigger_w(w[2]), .smaller_w(w[3])); 
        compAndSwap cas2(.a(input_id[0]), .b(input_id[2]), .wa(input_weight[0]), .wb(input_weight[2]),
                         .bigger_id(id[4]), .smaller_id(id[5]),
                         .bigger_w(w[4]), .smaller_w(w[5])); 
        compAndSwap cas3(.a(input_id[5]), .b(input_id[7]), .wa(input_weight[5]), .wb(input_weight[7]),
                         .bigger_id(id[6]), .smaller_id(id[7]),
                         .bigger_w(w[6]), .smaller_w(w[7]));
        compAndSwap cas4(.a(id[4]), .b(id[2]), .wa(w[4]), .wb(w[2]),
                         .bigger_id(id[8]), .smaller_id(id[9]),
                         .bigger_w(w[8]), .smaller_w(w[9]));
        compAndSwap cas5(.a(id[0]), .b(id[6]), .wa(w[0]), .wb(w[6]),
                         .bigger_id(id[10]), .smaller_id(id[11]),
                         .bigger_w(w[10]), .smaller_w(w[11]));
        compAndSwap cas6(.a(id[5]), .b(id[3]), .wa(w[5]), .wb(w[3]),
                         .bigger_id(id[12]), .smaller_id(id[13]),
                         .bigger_w(w[12]), .smaller_w(w[13]));
        compAndSwap cas7(.a(id[1]), .b(id[7]), .wa(w[1]), .wb(w[7]),
                         .bigger_id(id[14]), .smaller_id(id[15]),
                         .bigger_w(w[14]), .smaller_w(w[15]));
        compAndSwap cas8(.a(id[8]), .b(id[10]), .wa(w[8]), .wb(w[10]),
                         .bigger_id(id[16]), .smaller_id(id[17]),
                         .bigger_w(w[16]), .smaller_w(w[17]));
        compAndSwap cas9(.a(id[12]), .b(id[14]), .wa(w[12]), .wb(w[14]),
                         .bigger_id(id[18]), .smaller_id(id[19]),
                         .bigger_w(w[18]), .smaller_w(w[19]));  
        compAndSwap cas10(.a(id[9]), .b(id[11]), .wa(w[9]), .wb(w[11]),
                         .bigger_id(id[20]), .smaller_id(id[21]),
                         .bigger_w(w[20]), .smaller_w(w[21])); 
        compAndSwap cas11(.a(id[13]), .b(id[15]), .wa(w[13]), .wb(w[15]),
                         .bigger_id(id[22]), .smaller_id(id[23]),
                         .bigger_w(w[22]), .smaller_w(w[23]));  
        compAndSwap cas12(.a(id[18]), .b(id[20]), .wa(w[18]), .wb(w[20]),
                         .bigger_id(id[24]), .smaller_id(id[25]),
                         .bigger_w(w[24]), .smaller_w(w[25]));    
        compAndSwap cas13(.a(id[19]), .b(id[21]), .wa(w[19]), .wb(w[21]),
                         .bigger_id(id[26]), .smaller_id(id[27]),
                         .bigger_w(w[26]), .smaller_w(w[27]));
        compAndSwap cas14(.a(id[17]), .b(id[25]), .wa(w[17]), .wb(w[25]),
                         .bigger_id(id[28]), .smaller_id(id[29]),
                         .bigger_w(w[28]), .smaller_w(w[29]));
        compAndSwap cas15(.a(id[26]), .b(id[22]), .wa(w[26]), .wb(w[22]),
                         .bigger_id(id[30]), .smaller_id(id[31]),
                         .bigger_w(w[30]), .smaller_w(w[31]));
        compAndSwap cas16(.a(id[28]), .b(id[24]), .wa(w[28]), .wb(w[24]),
                         .bigger_id(id[32]), .smaller_id(id[33]),
                         .bigger_w(w[32]), .smaller_w(w[33]));
        compAndSwap cas17(.a(id[30]), .b(id[29]), .wa(w[30]), .wb(w[29]),
                         .bigger_id(id[34]), .smaller_id(id[35]),
                         .bigger_w(w[34]), .smaller_w(w[35]));
        compAndSwap cas18(.a(id[27]), .b(id[31]), .wa(w[27]), .wb(w[31]),
                         .bigger_id(id[36]), .smaller_id(id[37]),
                         .bigger_w(w[36]), .smaller_w(w[37]));
    end
endgenerate


endmodule