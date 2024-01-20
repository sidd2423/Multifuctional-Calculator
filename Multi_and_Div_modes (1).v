module Multi_and_Div_modes(x, y, output);
    // Define a parameter "N" with a default value of 8
    parameter N = 8;

    // Declare input ports "x" and "y" as N-bit vectors
    input [N-1:0] x, y;

    // Declare output port "output" as a 2N-bit vector for mul and div result
    output [(2*N)-1:0] output;

    // Declare wires for intermediate signals
    wire [N-1:0] sum[N-1:0];
    wire [N-1:0] input_A[N-1:1];
    wire [N-1:0] input_B[N-1:1];
    
    // Declare an array of wires for carry signals produced by each N-bit full adder
    wire carry_wires[N-1:1];

    // Define generate-for loops using genvar
    genvar i, f;

    // Assign the output bits
    assign output[0] = sum[0][0];
    assign output[2*N-1 -: N+1] = {carry_wires[N-1], sum[N-1]};

    // Generate assignments for intermediate bits
    generate
        for (i = 1; i < N; i = i + 1) begin : output_loop
            assign output[i] = sum[i][0];
        end
    endgenerate

    // Generate assignments for the first level of bitwise AND operations
    generate
        for (i = 0; i < N; i = i + 1) begin : loop_f_lev
            assign sum[0][i] = x[i] & y[0];
        end
    endgenerate

    // Assign values to input_A and input_B for the second level of additions
    assign input_A[1] = {1'b0, sum[0][N-1:1]};
    assign input_B[1] = x & {N{y[1]}};

    // Instantiate an Adder module for the second level of additions
    Adder Adder_instance2 (.x(input_A[1]),
                  .y(input_B[1]), 
                  .input_carry(1'b0), 
                  .output_carry(carry_wires[1]), 
                  .sum(sum[1])
                  );
    defparam Adder_instance2.N = N;

    // Generate assignments for the subsequent levels of additions
    generate
        for (f = 2; f < N; f = f + 1) begin : loop_l_lev
            assign input_A[f] = {carry_wires[f-1], sum[f-1][N-1:1]};
            assign input_B[f] = x & {N{y[f]}};

            // Instantiate an Adder module for the current level of additions
            Adder Adder_instance (.x(input_A[f]),
                          .y(input_B[f]),
                          .input_carry(1'b0),
                          .output_carry(carry_wires[f]),
                          .sum(sum[f])
                          );
            defparam Adder_instance.N = N;
        end
    endgenerate

endmodule
