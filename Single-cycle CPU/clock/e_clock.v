module e_clock(
	input 							CLOCK_50,
	input 							clrn,
	input                      pause,  //暂停时可以设置时间
	input            [1:0]     sel,   //00：分钟低位 01：分钟高位
	                                  //10：小时低位 11：小时高位
	input            [3:0]     load,
	output			  [31:0]     ascii
);
	wire clk_1s;
	reg [3:0] min_l = 0;
	reg [3:0] min_h = 0;
	reg [3:0] hour_l = 0;
	reg [3:0] hour_h = 0;
	clkgen #(1) myclk_1s(CLOCK_50,~clrn,1'b1,clk_1s);
	integer count_sec = 0;
	always @ (posedge clk_1s) begin
			if(pause) begin
					case(sel) 
							0: min_l <= load;
							1: min_h <= load;
							2: hour_l <= load;
							3: hour_h <= load;
					endcase
			end
			else begin	
					count_sec <= count_sec + 1;
					if(count_sec == 59) begin
							count_sec <= 0;
							min_l <= min_l + 1;
							if(min_l == 9) begin
									min_l <= 0;
									min_h <= min_h + 1;
									if(min_h == 5) begin
											min_h <= 0;
											hour_l <= hour_l + 1;
											if(hour_l == 9) begin
													hour_l <= 0;
													hour_h <= hour_h + 1;
											end
											else if(hour_l == 3&&hour_h==2) begin
													hour_l <= 0;
													hour_h <= 0;
											end
									end
							end
					end
			end
	end
						
	num2ascii i0(min_l,ascii[7:0]);						
	num2ascii i1(min_h,ascii[15:8]);											
	num2ascii i2(hour_l,ascii[23:16]);
	num2ascii i3(hour_h,ascii[31:24]);
endmodule 