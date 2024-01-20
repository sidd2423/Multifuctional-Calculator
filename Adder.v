module Adder(x, y, carryin, carryout, sum);
    parameter N = 1;  // Define a parameter 'N' 
    
    input [N-1:0] x, y; // Declare input vectors x and y, each of size N bits
    input carryin;      // Declare input carryin
    output carryout;    // Declare output carryout
    output [N-1:0] sum; // Declare output sum as an N-bit vector
    
    wire [N:0] carry;   // Declare an array of wires for carrying bits
    assign carryout = carry[N]; // Assign carryout to the most significant bit of the carry array
    assign carry[0] = carryin;  // Assign the input carryin to the least significant bit of the carry array
    
    genvar i; // Declare a generate variable i
    
    // Generate a fullAdder instance for each bit of the input vectors
    generate
        for(i = 0; i < N; i = i + 1) begin : f_adder_loop
            fullAdder fad (
                .x(x[i]),
                .y(y[i]),
                .carryin(carry[i]),
                .carryout(carry[i+1]),
                .sum(sum[i])
            );
        end
    endgenerate

endmodule

//full adder module
module fullAdder (x, y, carryin, carryout, sum);
    input x, y, carryin;    // Declare input signals x, y, and carryin
    output carryout, sum;   // Declare output signals carryout and sum
    
    // Calculate the sum and carryout based on input signals
    assign sum = x ^ y ^ carryin;                 // Calculate the sum using XOR gates
    assign carryout = (x & y) | (x & carryin) | (y & carryin); // Calculate carryout using OR and AND gates
endmodule
