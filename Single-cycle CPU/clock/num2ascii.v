module num2ascii(num,ascii);
	input [3:0] num;
	output reg [7:0] ascii;
	
	always @(num)
		case (num)
				0: ascii = 8'h30;
				1: ascii = 8'h31;
				2: ascii = 8'h32;
				3: ascii = 8'h33;
				4: ascii = 8'h34;
				5: ascii = 8'h35;
				6: ascii = 8'h36;
				7: ascii = 8'h37;
				8: ascii = 8'h38;
				9: ascii = 8'h39;
				default: ascii = 8'h00;
		endcase
endmodule