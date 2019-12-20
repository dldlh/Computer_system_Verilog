module vga_top_2(

	input 						clkin,

	input 						clrn,

	input			 [31:0]     data,

	output		          		vga_blank_n,

	output		     [7:0]		vga_b,

	output		          		pclk,

	output		     [7:0]		vga_g,

	output		          		hsync,

	output		     [7:0]		vga_r,

	output		          		vga_sync_n,

	output		          		vsync,

	output			 [9:0]      inquire_addr

);

	reg [23:0] vga_data;
	wire [9:0] h_addr;
	wire [9:0] v_addr;

	reg [11:0] x_index=12'b0;
	reg [11:0] y_index=12'b0;
	reg [11:0] index=12'b0;
	reg [11:0] ram_index=12'b0;
	reg [11:0] rom_index=12'b0;

	wire [11:0] info;

	reg [7:0] ascii; 

	
	clkgen_2 #(25000000) my_clk(clkin,clrn,1'b1,pclk);	

	vga_ctrl_2 my_vga(pclk,clrn,vga_data,h_addr,v_addr,HSYNC,VSYNC,VGA_BLANK_N,VGA_R,VGA_G,VGA_B);



assign inquire_addr = ram_index[11:2];

vga_font read(rom_index,clkin,info);

always @ (h_addr or v_addr)
	begin
		if(h_addr<630)//如果在字符显示区内
		begin
		  y_index=h_addr/9; //计算显存中y坐标
		  x_index=v_addr>>4; //计算显存中x坐标（尽量用移位）
		  //计算RAM的下标x*128+y
		  ram_index=(x_index<<7)+y_index;
		  //inquire_addr=ram_index[11:2];
		  case(ram_index[1:0])
				0: ascii = data[7:0];
				1: ascii = data[15:8];
				2: ascii = data[23:16];
				3: ascii = data[31:24];
		  endcase
		  //info=rom[(ram[ram_index]<<4)+v_addr-(x_index<<4)];
		  //取出当前坐标ASCII码
		  rom_index=(ascii<<4)+v_addr-(x_index<<4); //后半部分等价于vaddr%16

		  index=h_addr-(y_index<<3)-y_index;//haddr-y*9，等价于haddr%9
		  //rom_font rom(rom_index,clkin,info); info为取出的12bit数
		  vga_data<={24{info[index]}};//为1则输出白色，为0则输出黑色

		end
		else
		begin 
		vga_data<=24'h000000;//不在显示区内则输出黑色
		end
	end
	
endmodule
