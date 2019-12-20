module vga_display(
		output reg[23:0] vga_data,
		input clk,
		input valid,
		input [3:0] height,
		input [3:0] width,  //单个字符行列信息
		input [7:0] ascii
);

		wire [11:0] raddress;
		wire [11:0] temp;
		wire [11:0] rowdata;
		wire pixel;
		
		vga_font read(raddress,clk,rowdata);
		assign temp = {4'h0,ascii};
		assign raddress = temp*16+ height;
		assign pixel = rowdata[width];
		always @(*) 
		if(valid) begin
			if(pixel==1'b1)
				vga_data=24'hFFFFFF;
			else
				vga_data=24'h000000;
		end
endmodule