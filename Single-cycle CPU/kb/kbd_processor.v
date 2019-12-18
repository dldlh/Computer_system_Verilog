module kbd_processor(
		input clk,
		input ready,
		input [7:0] data,
		output reg nextdata_n,
		output [7:0] ascii
		);
		
		reg [7:0] receive;
		reg [7:0] scancode;
		wire [7:0] ascii_1;
		wire [7:0] ascii_2;
		reg breaksign=1'b0;
		reg shift=1'b0;
		
		always @(posedge clk) begin
				scancode<=8'h00;
				if(ready) begin				
						receive<=data;
						nextdata_n<=0;	
						if(receive==8'h12||receive==8'h59)
								shift<=1;
						if(breaksign) begin   
								scancode<=receive;
								if(receive==8'h12||receive==8'h59) begin
										shift<=0;
										scancode<=8'h00;
								end
								breaksign<=0;
						end	
						if(receive==8'hF0)	
							breaksign<=1;			
				end
				else begin
						receive<=receive;
						nextdata_n<=1;
				end		
		end
		
		code2a trans_1(scancode,clk,ascii_1); 
		code2a_shift trans_2(scancode,clk,ascii_2);
      assign ascii=(shift==1)?ascii_2:ascii_1;
		
endmodule 
	
	