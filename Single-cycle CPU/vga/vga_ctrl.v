module vga_ctrl(
		input pclk, //25MHz 时钟
		input reset, // 置位
		input [23:0] vga_data, // 上层模块提供的VGA 颜色数据

		output reg [4:0] row,  //显存位置,0~29
		output reg [6:0] col,  // 0~69
		output reg [3:0] height,  //单个字符行列信息,0~15
		output reg [3:0] width,   // 0~8

		output hsync, // 行同步和列同步信号
		output vsync,
		output valid, // 消隐信号
		output [7:0] vga_r, // 红绿蓝颜色信号
		output [7:0] vga_g,
		output [7:0] vga_b
		);

		//640x480 分辨率下的VGA 参数设置
		parameter h_frontporch = 96;
		parameter h_active = 144;
		parameter h_backporch = 784;
		parameter h_total = 800;

		parameter v_frontporch = 2;
		parameter v_active = 35;
		parameter v_backporch = 515;
		parameter v_total = 525;

		// 像素计数值
		reg [9:0] x_cnt;
		reg [9:0] y_cnt;
		wire h_valid;
		wire v_valid;

		always @(posedge reset or posedge pclk) // 行像素计数 
		begin
				if (reset == 1'b1) begin
					x_cnt <= 1;
					col <= 0;
					width <= 0;
				end
				else  begin
						if (x_cnt == h_total) begin   //扫描行满
								x_cnt <= 1;
								col <= 0;
								width <= 0;
						end
						else begin
								x_cnt <= x_cnt + 10'd1;
								if(h_valid) begin
										if(width == 4'd8) begin 
												col <= col + 1;    //下一个字符
												width <= 0;
										end
										else  
												width <= width + 1;
								end
						end
				end
		end		
			 
		 
		always @(posedge pclk) // 列像素计数
		begin
				if (reset == 1'b1) begin
						y_cnt <= 1;
						row <= 0;
						height <= 0;
				end
				else  begin
						if (y_cnt == v_total & x_cnt == h_total) begin  
								y_cnt <= 1;
								row <= 0;
								height <= 0;
						end
						else if (x_cnt == h_total) begin   
								y_cnt <= y_cnt + 1;			
								if(v_valid) begin
										if(height == 4'd15) begin
												row <= row + 1;
												height <= 0;
										end
										else  
												height <= height + 1;
								end
						end
				end
		end
			
		
		 // 生成同步信号
		 assign hsync = (x_cnt > h_frontporch);
		 assign vsync = (y_cnt > v_frontporch);
		 // 生成消隐信号
		 assign h_valid = (x_cnt > h_active) & (x_cnt <= h_backporch);
		 assign v_valid = (y_cnt > v_active) & (y_cnt <= v_backporch);
		 assign valid = h_valid & v_valid;
		 // 设置输出的颜色值
		 assign vga_r = vga_data[23:16];
		 assign vga_g = vga_data[15:8];
		 assign vga_b = vga_data[7:0];
endmodule