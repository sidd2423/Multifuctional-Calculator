module counter (clk, reset, output); 
    // Declare input ports "clk" and "reset"
    input clk, reset;
   // Define a parameter "n" with a default value of 50000000
    parameter n = 50000000;
    
    // Declare output port "output"
    output output;
    
    // Declare internal registers output and counter_value
    reg output;
    reg [25:0] counter_value;
    
    // Initialize counter_value to 0 at the start
    initial begin
        counter_value = 0;
    end
    
    // Always block triggered on the positive edge of clk or positive edge of reset
    always @(posedge clk or posedge reset) begin
        // Check if reset signal is active (reset == 1)
        if (reset) begin
            // If reset is active, set output to 0 and reset counter_value
            output <= 1'b0;
            counter_value <= 26'b0;
        end
        // Check if counter_value reaches the specified limit (n-1)
        else if (counter_value == (n-1)) begin
            // If counter_value reaches the limit, set output to 1 and reset counter_value
            counter_value <= 26'b0;
            output <= 1'b1;
        end
        // If neither reset nor the limit condition is met, increment counter_value
        else begin
            output <= 1'b0;
            counter_value <= counter_value + 1;
        end
    end
endmodule
