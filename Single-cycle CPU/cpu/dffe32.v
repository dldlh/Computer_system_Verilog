module dffe32(d, clk, clrn, e, q);
	input [31:0] d;
	input clk, clrn, e;
	output reg [31:0] q;
	
	initial
		q = 0;
	always@(negedge clrn or posedge clk)
	begin
		if(clrn == 0)
			q <= 0;
		else if(e)
			q <= d;
	end
	
endmodule 