module factorial(num, res, clk);
    // Declare input port "clk" for the clock signal
    input clk;
    
    // Declare input port "num" as a 4-bit vector
    input [3:0] num;
    
    // Declare output port "res" as a 16-bit vector
    output [15:0] res;
    
    // Declare internal registers "res" and "counter"
    reg [15:0] res;
    reg [15:0] counter; // Integer counter
    
    // Initialize the counter to 0 and res to 1 (factorial of 0)
    initial begin
        counter = 0;
        res = 16'b1;
    end
    
    // Always block triggered on the positive edge of clk
    always @(posedge clk) begin
        // Increment the counter by 1 in each clock cycle
        counter = counter + 1;
        
        // Calculate the factorial: res = res * counter
        res = res * counter;
    end
endmodule
