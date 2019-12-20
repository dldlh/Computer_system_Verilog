module exp09(clk,clk_ls,hsync,vsync,vga_sync_n,valid,vga_r,vga_g,vga_b,ascii,block_addr);
	input clk;
	input [31:0] ascii;
	output clk_ls,hsync,vsync,vga_sync_n,valid;
	output [7:0] vga_r,vga_g,vga_b;
	assign vga_sync_n = 0;
	reg [23:0] data = 0;
	//output [9:0]inaddr = block_addr[11:2];
	output reg [11:0] block_addr = 0;
	reg [11:0] addr;
	//reg wren = 0;
	wire [9:0] h_addr,v_addr;
	reg [7:0] vga_ret;
	wire [8:0] font_ret;
	wire [7:0] waste;
	clkgen #25000000 c(clk,1'b0,1'b1,clk_ls);
	vga_ctrl v(.pclk(clk_ls),.reset(1'b0),.vga_data(data),.h_addr(h_addr),.v_addr(v_addr),.hsync(hsync),.vsync(vsync),.valid(valid),.vga_r(vga_r),.vga_g(vga_g),.vga_b(vga_b));
	//ram_vga my_ram_vga(.address(block_addr),.clock(clk_ls),.data(ascii),.wren(wren),.q(vga_ret));
	//ram2_vga my_ram2_vga(block_addr,index,clk_ls,1'b0,ascii,1'b0,1'b1,vga_ret,waste);
	//ram3 my_ram3(block_addr,index,clk_ls,clk_10,1'b0,ascii,1'b0,1'b1,vga_ret,waste);
	//ram480 my_ram3(block_addr,index,clk_ls,clk_10,1'b0,ascii,1'b0,1'b1,vga_ret,waste);
	rom_font my_rom_font(.address(addr),.clock(clk_ls),.q(font_ret));
	
	always @ (clk_ls)begin
		case(block_addr[1:0])
			2'b00: vga_ret <= ascii[31:24];
			//2'b01: vga_ret <= ascii[23:16];
			//2'b10: vga_ret <= ascii[15:8];
			//2'b11: vga_ret <= ascii[7:0];
			default: vga_ret <= ascii[7:0];
		endcase
	end
	
	always @ (clk_ls)
	begin
			block_addr <= (v_addr / 16)* 70 + ((h_addr - 4) / 9);
			addr <= (vga_ret << 4) + (v_addr % 16);
			if(font_ret[h_addr%9] == 1'b1) data <= 24'hffffff;
			else data <= 24'h000000;
	end
endmodule

