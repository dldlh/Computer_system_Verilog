module exp09(clk,clk_ls,hsync,vsync,vga_sync_n,valid,vga_r,vga_g,vga_b,ascii,block_addr,vgasource);
	input clk;
	input vgasource;//0:屏保；1:系统
	
	input [7:0] ascii;
	output clk_ls,hsync,vsync,vga_sync_n,valid;
	output [7:0] vga_r,vga_g,vga_b;
	assign vga_sync_n = 0;
	reg [23:0] data = 0;
	//wire [23:0]wiredata = data;
	wire [23:0] scdata;

	output reg [11:0] block_addr = 0;
	reg [11:0] addr;
	//reg wren = 0;
	wire [9:0] h_addr,v_addr;
	wire [7:0] vga_ret = ascii[7:0];
	wire [8:0] font_ret;
	wire [7:0] waste;
	reg [23:0] datares;
	clkgen #25000000 c(clk,1'b0,1'b1,clk_ls);
	//wire datares =wiredata  & {24{vgasource}} | scdata  & {24{~vgasource}};
	vga_ctrl v(.pclk(clk_ls),.reset(1'b0),.vga_data(datares),.h_addr(h_addr),.v_addr(v_addr),.hsync(hsync),.vsync(vsync),.valid(valid),.vga_r(vga_r),.vga_g(vga_g),.vga_b(vga_b));
	top_flyinglogo screen(.pclk(clk_ls), .rst(1'b0), .valid(valid), .h_cnt(h_addr), .v_cnt(v_addr), .vga_data(scdata));
	rom_font my_rom_font(.address(addr),.clock(clk_ls),.q(font_ret));

	always @(clk_ls) begin
		if(vgasource==1)begin
			datares <= data;
		end	
		else begin
			datares <= scdata;
		end
	end

	always @ (clk_ls)
	begin
			block_addr <= ((v_addr  / 16 ) << 7)+ ((h_addr - 4) / 9);
			addr <= (vga_ret << 4) + (v_addr % 16);
			if(font_ret[h_addr%9] == 1'b1) data <= 24'hffffff;
			else data <= 24'h000000;
	end
endmodule


