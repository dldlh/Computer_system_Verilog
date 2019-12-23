module e_clock(
	input 							CLOCK_50,
	input 							clrn,
	input                      pause,  //暂停时可以设置时间
	input            [1:0]     sel,   //00：分钟低位 01：分钟高位
	                                  //10：小时低位 11：小时高位
	input            [3:0]     load,
	output			  [31:0]    ascii
);
	
	wire clk_1s;
	reg [3:0]out_q0=0;
	reg [3:0]out_q1=0;
	reg [3:0]out_q2=0;
	reg [3:0]out_q3=0;
	reg [3:0]out_q4=0;
	reg [3:0]out_q5=0;
		
	clkgen #(1) myclk_1s(CLOCK_50,1'b0,1'b1,clk_1s);  //生成1s时钟
	always @ (posedge clk_1s) begin
			if(pause) begin
					case(sel) 
							0: out_q2 <= load;   //0~9
							1: out_q3 <= load;   //0~5
							2: out_q4 <= load;  //0~9
							3: out_q5 <= load;  //0~2
					endcase
			end
			else begin
					if(clrn)
					 begin
						out_q0<=out_q0+1;	
						if(out_q0==9&&out_q1==5
							&&out_q2==9&&out_q3==5
							&&out_q4==3&&out_q5==2)	begin
								out_q0<=0;
								out_q1<=0;
								out_q2<=0;
								out_q3<=0;
								out_q4<=0;
								out_q5<=0;
						end
						else if(out_q0==9&&out_q1==5
							&&out_q2==9&&out_q3==5
							&&out_q4==9) begin
								out_q0<=0;
								out_q1<=0;
								out_q2<=0;
								out_q3<=0;
								out_q4<=0;
								out_q5<=out_q5+1;
						end
						else if(out_q0==9&&out_q1==5
							&&out_q2==9&&out_q3==5) begin
								out_q0<=0;
								out_q1<=0;
								out_q2<=0;
								out_q3<=0;
								out_q4<=out_q4+1;
						end
						else if(out_q0==9&&out_q1==5
							&&out_q2==9) begin
								out_q0<=0;
								out_q1<=0;
								out_q2<=0;
								out_q3<=out_q3+1;
						end
						else if(out_q0==9&&out_q1==5) begin
								out_q0<=0;
								out_q1<=0;
								out_q2<=out_q2+1;
						end
						else if(out_q0==9) begin
								out_q0<=0;
								out_q1<=out_q1+1;
						end
					end
					else
					 begin
						out_q0<=0;
						out_q1<=0;
						out_q2<=0;
						out_q3<=0;
						out_q4<=0;
						out_q5<=0;
					end				 
			end								 
	end
	num2ascii i0(out_q2,ascii[7:0]);						
	num2ascii i1(out_q3,ascii[15:8]);											
	num2ascii i2(out_q4,ascii[23:16]);
	num2ascii i3(out_q5,ascii[31:24]);
endmodule 