module vga_ctrl_2(
	input pclk,
	input reset,
	input [23:0] vga_data,
	output [9:0] h_addr,
	output [9:0] v_addr,
	output hsync,
	output vsync,
	output valid,
	output [7:0] vga_r,
	output [7:0] vga_g,
	output [7:0] vga_b
	);
	
	parameter h_frontporch=96;
	parameter h_active=144;
	parameter h_backporch=784;
	parameter h_total=800;
	
	parameter v_frontporch=2;
	parameter v_active=35;
	parameter v_backporch=515;
	parameter v_total=525;
	
	reg [9:0] x_cnt;
	reg [9:0] y_cnt;
	wire h_valid;
	wire v_valid;
	
	always @ (posedge reset or posedge pclk)
		if(reset)
			x_cnt<=1;
		else
		begin
			if(x_cnt==h_total)
				x_cnt<=1;
			else
				x_cnt<=x_cnt+10'd1;
		end
		
	always @(posedge pclk)
		if(reset==1'b0)
			y_cnt<=1;
		else
		begin
			if(y_cnt==v_total & x_cnt==h_total)
				y_cnt<=1;
			else if(x_cnt==h_total)
				y_cnt<=y_cnt+10'd1;
		end
		
	assign hsync=(x_cnt>h_frontporch);
	assign vsync=(y_cnt>v_frontporch);
	
	assign h_valid=(x_cnt>h_active)&(x_cnt<=h_backporch);
	assign v_valid=(y_cnt>v_active)&(y_cnt<=v_backporch);
	assign valid=h_valid & v_valid;
	
	assign h_addr=h_valid?(x_cnt-10'd145):{10{1'b0}};
	assign v_addr=v_valid?(y_cnt-10'd36):{10{1'b0}};
	
	assign vga_r[7:0]=vga_data[23:16];
	assign vga_g[7:0]=vga_data[15:8];
	assign vga_b[7:0]=vga_data[7:0];

	
endmodule
