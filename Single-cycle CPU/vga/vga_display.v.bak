module vga_display(
		output [23:0] vga_data,
		input clk,
		input valid,
		input [3:0] height,
		input [3:0] width,  //单个字符行列信息
		input [7:0] ascii
);

		wire [10:0] raddress;
		wire [10:0] temp;
		wire [11:0] rowdata;
		wire pixel;
		
		vga_font read(raddress,clk,rowdata);
		assign temp = ascii;
		assign raddress = temp << 4 + height;
		assign pixel = rowdata[width];
		assign vga_data = (pixel == 1)?24'hFFFFFF:24'h000000;
endmodule