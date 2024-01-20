module top_module(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, MAX10_CLK1_50, additionX, additionY, SumTotal, ps, MultiX, MultiY, Finalmult, dividefinal);
    //inputs and outputs
//switches 
    input [9:0] SW;
//displys
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
//keys 
    input [1:0] KEY;

//clock
    input MAX10_CLK1_50;
//for operations (mil & div)
    output [7:0] Finalmult;
    output [5:0] dividefinal;
//for addition and subtraction  
  output [3:0] SumTotal, ps;
    integer i;
   
    // Clock Code Block
    wire systemclk = MAX10_CLK1_50 / 2;
    reg [10:0] Siscnt = 0;  
    wire [6:0] sevensegdecoder[5:0];
    reg onesecrst, halfsecrst;
    wire onesecopt, halfsecopt;

    // Clock dividers
    generate
        counter #(2) onesec (
            .clk(systemclk),
            .reset(onesecrst),
            .ot(onesecopt)
        );
    endgenerate

    generate
        counter #(2) halfsec (
            .clk(onesecopt),
            .reset(halfsecrst),
            .ot(halfsecopt)
        );

    

    /* This code block handles the present state of the machine
       when we select operations using keys
    */
    reg [4:0] sevendecoderReg [5:0];
    reg [2:0] psopSeln = 4'b0000;
    reg [2:0] nsopSeln = 4'b0001;
    reg operationSel = 1'b0;
    assign ps = {operationSel, psopSeln};

    // Asynchronous input
    wire key0f, key1f, inpkey0, inpkey1;

    // Asynchronous input
    assign inpkey0 = KEY[0];
    assign inpkey1 = KEY[1];

    // Operation Selection
    always @(negedge inpkey0 or negedge inpkey1) begin
        if (inpkey0 == 1'b0) begin
            case (nsopSeln)
                3'b000: nsopSeln <= 3'b001;
                3'b001: nsopSeln <= 3'b010;
                3'b010: nsopSeln <= 3'b011;
                3'b011: nsopSeln <= 3'b100;
                3'b100: nsopSeln <= 3'b101;
                3'b101: nsopSeln <= 3'b110;
                3'b110: nsopSeln <= 3'b000;
                default: nsopSeln <= 3'b000;
            endcase
        end

        if (inpkey1 == 1'b0) begin
            operationSel <= ~operationSel;
        end
    end

    assign HEX3 = sevensegdecoder[3];
    assign HEX4 = sevensegdecoder[4];
    assign HEX5 = sevensegdecoder[5];

    // add & subtract Module
    reg [3:0] additionX, additionY;
    reg addCin;
    wire addCout;
    wire [3:0] SumTotal;
    Adder addMod (.x(additionX), 
                  .y(additionY), 
                  .carryin(addCin),
                  .carryout(addCout),
                  .sum(SumTotal)
                  );
    defparam addMod.n = 4;

    // multiply & division module
    reg [3:0] MultiX, MultiY;
    wire [7:0] Finalmult;
    Multi_and_Div_modes Mmult (.x(MultiX),
                               .y(MultiY),
                               .multOut(Finalmult)
                               );
    defparam Mmult.n = 4;

    reg [3:0] numberF;
    wire [7:0] resultF;
    reg clk;
    factorial fact(
        .number(numberF),
        .result(resultF),
        .clk(clk)
    );

    // Selection States
    always @(ps) begin
        /* do reset task */
        for (i = 0; i < 5; i = i + 1) begin : sevene_loop
            sevendecoderReg[i] = {5{1'b1}};
        end
        
        additionX = 4'b0000;
        additionY = 4'b0000;

        case (ps)
            4'b0000 : begin : select_and_display_sub
                addCin = 1'b0;
                
                sevendecoderReg[0] = {5'b01011}; // s-u-b
                sevendecoderReg[1] = {5'b10010};
                sevendecoderReg[2] = {5'b00101};
                sevendecoderReg[3] = {5{1'b1}};
                sevendecoderReg[4] = {5{1'b1}};
                sevendecoderReg[5] = {5{1'b1}};
            end
            4'b1000 : begin : start_Sub
                additionX = SW[3:0];
                additionY = SW[7:4];
                
                sevendecoderReg[0] = {1'b0, SW[3:0] - (SW[3:0]/10)*10};
                sevendecoderReg[1] = {1'b0, SW[3:0] / 10};
                sevendecoderReg[2] = {1'b0, SW[7:4] - (SW[7:4]/10)*10};
                sevendecoderReg[3] = {1'b0, SW[7:4] / 10};
                sevendecoderReg[4] = {1'b0, {addCout, SumTotal} - ({addCout, SumTotal}/10)*10};
                sevendecoderReg[5] = {1'b0, {addCout, SumTotal} / 10};
            end
            4'b0001 : begin : select_and_display_Add
                sevendecoderReg[0] = {5'b01101}; // a-d-d
                sevendecoderReg[1] = {5'b01101};
                sevendecoderReg[2] = {5'b01010};
                sevendecoderReg[3] = {5{1'b1}};
                sevendecoderReg[4] = {5{1'b1}};
                sevendecoderReg[5] = {5{1'b1}};
            end
            4'b1001 : begin : start_add
                additionX = SW[3:0];
                additionY = SW[7:4]; 
                addCin = SW[8];
                
                sevendecoderReg[0] = {1'b0, {addCout, SumTotal} - ({addCout, SumTotal}/10)*10};
                sevendecoderReg[1] = {1'b0, {addCout, SumTotal} / 10};
                sevendecoderReg[2] = {1'b0, SW[7:4] - (SW[7:4]/10)*10};
                sevendecoderReg[3] = {1'b0, SW[7:4] / 10};
                sevendecoderReg[4] = {1'b0, SW[3:0] - (SW[3:0]/10)*10};
                sevendecoderReg[5] = {1'b0, SW[3:0] / 10};        
            end
            4'b0010 : begin : select_and_div
                            sevendecoderReg[0] = {5'b10010}; // d-i-v
                sevendecoderReg[1] = {5'b00001};
                sevendecoderReg[2] = {5'b01101};      
                sevendecoderReg[3] = {5{1'b1}};
                sevendecoderReg[4] = {5{1'b1}};
                sevendecoderReg[5] = {5{1'b1}};  
            end
            4'b1010 : begin: start_div
                MultiX = SW[3:0];
                MultiY = SW[7:4];

                if (MultiX == 4'b0000 && MultiY == 4'b0000) begin 
                    // Set an error 
                    sevendecoderReg[0] = {5'b10110}; // error
                    sevendecoderReg[1] = {5'b10111};
                    sevendecoderReg[2] = {5'b10110};      
                    sevendecoderReg[3] = {5'b10110};
                    sevendecoderReg[4] = {5'b01110};
                    sevendecoderReg[5] = {5{1'b1}};
                end
                sevendecoderReg[0] = {1'b0, SW[3:0] - (SW[3:0]/10)*10};
                sevendecoderReg[1] = {1'b0, SW[3:0] / 10};
                sevendecoderReg[2] = {1'b0, SW[7:4] - (SW[7:4]/10)*10};
                sevendecoderReg[3] = {1'b0, SW[7:4] / 10};
                sevendecoderReg[4] = {1'b0, Finalmult - (Finalmult/10)*10};
                sevendecoderReg[5] = {1'b0, Finalmult /10};                        
            end
            4'b0011 : begin : select_and_display_multiplication
                sevendecoderReg[0] = {5'b10011}; // muL 
                sevendecoderReg[1] = {5'b10010};
                sevendecoderReg[2] = {5'b10100};      
                sevendecoderReg[3] = {5'b10100};
                sevendecoderReg[4] = {5{1'b1}};
                sevendecoderReg[5] = {5{1'b1}};  
            end
            4'b1011 : begin: start_multiplication
                MultiX = SW[3:0];
                MultiY = SW[7:4];
                
                sevendecoderReg[0] = {1'b0, Finalmult - (Finalmult/10)*10};
                sevendecoderReg[1] = {1'b0, Finalmult /10};
                sevendecoderReg[2] = {1'b0, SW[7:4] - (SW[7:4]/10)*10};
                sevendecoderReg[3] = {1'b0, SW[7:4] / 10};
                sevendecoderReg[4] = {1'b0, SW[3:0] - (SW[3:0]/10)*10};    
                sevendecoderReg[5] = {1'b0, SW[3:0] / 10};
            end
            4'b0100 : begin : select_and_display_fac
                sevendecoderReg[0] = {5'b01100}; // f-a-c
                sevendecoderReg[1] = {5'b01010};
                sevendecoderReg[2] = {5'b01111};
                sevendecoderReg[3] = {5{1'b1}};
                sevendecoderReg[4] = {5{1'b1}};
                sevendecoderReg[5] = {5{1'b1}};
            end
            4'b1100 : begin : start_fac
                numberF[3:0] = SW[3:0];
                
                /*sevendecoderReg[0] = {1'b0, SW[3:0] == 1 ? 1 : SW[3:0] == 2 ? 2 : SW[3:0] == 3 ? 6 : SW[3:0] == 4 ? 4 : SW[3:0] == 5 ? 0 : SW[3:0] == 6 ? 0 : 0};
                
                sevendecoderReg[1] = {1'b0, SW[3:0] == 4 ? 2 : SW[3:0] == 5 ? 2 : SW[3:0] == 6 ? 2 : 0};
                sevendecoderReg[2] = {1'b0, SW[3:0] == 5 ? 1 : SW[3:0] == 6 ? 7 : 0};
                
                sevendecoderReg[5] = {1'b0, SW[3:0]}; */// Display SW[3:0] on hex5
                
                sevendecoderReg[0] = {1'b0, SW[3:0] == 1 ? 1 : SW[3:0] == 2 ? 2 : SW[3:0] == 3 ? 6 : SW[3:0] == 4 ? 4 : SW[3:0] == 5 ? 0 : SW[3:0] == 6 ? 0 : SW[3:0] == 7 ? 0 : SW[3:0] == 8 ? 0 : SW[3:0] == 9 ? 0 : 0};
                
                sevendecoderReg[1] = {1'b0, SW[3:0] == 4 ? 2 : SW[3:0] == 5 ? 2 : SW[3:0] == 6 ? 2 : SW[3:0] == 7 ? 4 : SW[3:0] == 8 ? 2 : SW[3:0] == 9 ? 8: 0};
                sevendecoderReg[2] = {1'b0, SW[3:0] == 5 ? 1 : SW[3:0] == 6 ? 7 : SW[3:0] == 7 ? 0 : SW[3:0] == 8 ? 3 : SW[3:0] == 9 ? 8 : 0};
                sevendecoderReg[3] = {1'b0, SW[3:0] == 8 ? 4 : SW[3:0] == 9 ? 72 : 0};
            end
            default : begin : default_case
                sevendecoderReg[0] = {5'b11111}; // error
                sevendecoderReg[1] = {5'b11111};
                sevendecoderReg[2] = {5'b11111};      
                sevendecoderReg[3] = {5'b11111};
                sevendecoderReg[4] = {5'b11111};
                sevendecoderReg[5] = {5'b11111};
            end
        endcase
    end

    // seven segement decoder is being called .
    sevenseg sevensegdecoder[5:0](
        .in(sevendecoderReg[0]),
        .out(HEX0)
    );
    sevenseg sevensegdecoder[5:1](
        .in(sevendecoderReg[1]),
        .out(HEX1)
    );
    sevenseg sevensegdecoder[5:2](
        .in(sevendecoderReg[2]),
        .out(HEX2)
    );
    sevenseg sevensegdecoder[5:3](
        .in(sevendecoderReg[3]),
        .out(HEX3)
    );
    sevenseg sevensegdecoder[5:4](
        .in(sevendecoderReg[4]),
        .out(HEX4)
    );
    sevenseg sevensegdecoder[5:5](
        .in(sevendecoderReg[5]),
        .out(HEX5)
    );
endmodule
