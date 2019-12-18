module kbd_top(
	input 							CLOCK_50,
	input 							clrn,
	input 							PS2_CLK,
	input 		          		PS2_DAT,
	output			  [7:0]     ascii
);

	wire ready, nextdata_n, overflow, shift;
	wire [7:0] data;
	
	
	
ps2_keyboard u1(
			.clk(CLOCK_50),
			.clrn(clrn),
			.ps2_clk(PS2_CLK),
			.ps2_data(PS2_DAT),
			.data(data),
			.ready(ready),
			.nextdata_n(nextdata_n),
			.overflow(overflow)
);

kbd_processor u2(
			.clk(CLOCK_50),
		   .ready(ready),
		   .data(data),
			.nextdata_n(nextdata_n),
		   .ascii(ascii)
);

endmodule 