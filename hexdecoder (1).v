// binary to hex (hex decoder) module
module hexdecoder(hexin, hexout);
    // Declare input port "hexin" as a 5-bit
    input [4:0] hexin; // The only reason this is 5 bits is to have more variables for hex display
    
    // Declare output port "hexout" as a 7-bit , representing a 7-segment display
    output reg [6:0] hexout;
    
    // Combinational logic for the 7-segment display decoder
    always @(*) begin
        // Case statement based on the value of "hexin" to display each number and letter 
        case(hexin)
            5'b00000 : hexout = 7'b1000000; // Display '0'
            5'b00001 : hexout = 7'b1111001; // Display '1'
            5'b00010 : hexout = 7'b0100100; // Display '2'
            5'b00011 : hexout = 7'b0110000; // Display '3'
            5'b00100 : hexout = 7'b0011001; // Display '4'
            5'b00101 : hexout = 7'b0010010; // Display '5'
            5'b00110 : hexout = 7'b0000010; // Display '6'
            5'b00111 : hexout = 7'b1111000; // Display '7'
            5'b01000 : hexout = 7'b0000000; // Display '8'
            5'b01001 : hexout = 7'b0011000; // Display '9'
            5'b01010 : hexout = 7'b0001000; // Display 'A'
            5'b01011 : hexout = 7'b0000011; // Display 'b'
            5'b01100 : hexout = 7'b1000110; // Display 'c'
            5'b01101 : hexout = 7'b0100001; // Display 'd'
            5'b01110 : hexout = 7'b0000110; // Display 'e'
            5'b01111 : hexout = 7'b0001110; // Display 'f'
            5'b10000 : hexout = 7'b0001100; // Display 'p'
            5'b10001 : hexout = 7'b0001001; // Display 'h'
            5'b10010 : hexout = 7'b1100011; // Display 'u'
            5'b10011 : hexout = 7'b1000111; // Display 'l'
            5'b10100 : hexout = 7'b0101011; // Display 'n'
            5'b10110 : hexout = 7'b0001111; // Display 'r'
            5'b10111 : hexout = 7'b0100011; // Display 'o'
            5'b11000 : hexout = 7'b0000111; // Display 't'
            default  : hexout = 7'b1111111; // Display a blank character
        endcase
    end
endmodule
