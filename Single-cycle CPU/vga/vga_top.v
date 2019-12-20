module vga_top(
	input 						CLOCK_50,
	input 						clrn,
	input			 [31:0]     data,
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,
	output			 [9:0]      inquire_addr,
	output reg [7:0] ascii
);
	wire [4:0] row;
	wire [6:0] col;
	wire [23:0] vga_data;
	wire [3:0] height;
	wire [3:0] width;
	wire [11:0] addr;
	wire [11:0] temp;
	//reg [7:0] ascii; 
	
	clkgen #(25000000) my_vgaclk(CLOCK_50,~clrn,1'b1,VGA_CLK);	

	
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
			//.clk(VGA_CLK),
			.valid(VGA_BLANK_N),
			.height(height),  
			.width(width),
			.ascii(ascii)
);

always @(*) begin
	case(addr[1:0])
		2'd0: ascii = data[7:0];
		2'd1: ascii = data[15:8];
		2'd2: ascii = data[23:16];
		2'd3: ascii = data[31:24];
		default:ascii = data[7:0];
	endcase
end

assign VGA_SYNC_N=0;
assign temp = {{7'b0},row};
//assign addr = temp << 7 + col;
assign addr = temp * 70 + col;
assign inquire_addr = addr[11:2];
endmodule 