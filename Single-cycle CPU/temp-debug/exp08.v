
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module exp08(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// LED //////////
	output	[7:0]ascii,
	output reg enable = 1'b1,
	//output reg CapsLock = 0,
	/*
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,
*/
	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2
	
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
	wire clrn;
	wire [7:0] code; 
	reg [7:0] cnt = 0;
	reg nextdata = 0;
	reg flag = 1;
	reg CapsLock = 0;
	wire ready,overflow;
	reg [7:0] code_reg;
	assign clrn = SW[0];
	ps2_keyboard p(.clk(CLOCK_50),.clrn(clrn),.ps2_clk(PS2_CLK),.ps2_data(PS2_DAT),.data(code),.ready(ready),.nextdata_n(nextdata),.overflow(overflow));
	ram r(.in(code_reg),.out(ascii),.CapsLock(CapsLock));
	reg [6:0] count = 0;
	/*
	reg clk_ls = 0;
	
	always @ (posedge CLOCK_50)
	begin
		if(count == 50)
		begin
			count <= 0;
			clk_ls <= ~clk_ls;
		end
		else
			count <= count + 1;
	end
	*/
	always @ (posedge CLOCK_50)
	begin
		if(ready && nextdata == 1'b1) 
		begin
			nextdata <= 0;
			code_reg <= code;
			if(code == 8'hf0)
			begin
				cnt <= cnt + 1;
				flag <= 1;  
			end
			else
			begin
				if(flag) 
				begin
					enable <= 0;
					flag <= 0;
					if(code == 8'h58) CapsLock = ~CapsLock;
				end
				else
				begin
					enable <= 1;
				end	
			end
		end
		else nextdata <= 1;
	end

//=======================================================
//  Structural coding
//=======================================================



endmodule
