module vga_top(
	input 							CLOCK_50,
	input 							clrn,
	input				  [7:0]     ascii,
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,
	output			  [4:0]     row,
	output			  [6:0]     col
);

	wire [23:0] vga_data;
	wire [3:0] height;
	wire [3:0] width;

	clkgen #(25000000) my_vgaclk(CLOCK_50,~clrn,1'b1,VGA_CLK);	
	assign VGA_SYNC_N=0;
	
vga_ctrl v1(
			.pclk(VGA_CLK),
			.reset(~clrn), 
			.vga_data(vga_data), 
			.row(row),  
			.col(col),  
			.height(height),  
			.width(width),
			.hsync(VGA_HS),
			.vsync(VGA_VS),
			.valid(VGA_BLANK_N), 
			.vga_r(VGA_R), 
			.vga_g(VGA_G),
			.vga_b(VGA_B)
);	
	
vga_display v2(
			.vga_data(vga_data), 
			.clk(CLOCK_50),
			.valid(VGA_BLANK_N),
			.height(height),  
			.width(width),
			.ascii(ascii)
);

endmodule 