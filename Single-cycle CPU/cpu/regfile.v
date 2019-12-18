module regfile(rna, rnb, d, wn, we, clk, clrn, qa, qb);
	input [4:0] rna, rnb, wn;
	input [31:0] d;					//写入的数据
	input we, clk, clrn;				//写使能 时钟 清零
	output [31:0] qa, qb;
	reg [31:0] register [1:31];
	
	//输入信号
	always@(posedge clk or negedge clrn)
	begin
		if(clrn == 0)
		begin
			integer i;
			for(i = 1; i < 32; i = i + 1)
				register[i] <= 0;
		end
		else if( (wn != 0) && we)
			register[wn] <= d;
	end
	
	//输出信号
	assign qa = (rna == 0) ? 0 : register[rna];
	assign qb = (rnb == 0) ? 0 : register[rnb];
	
endmodule 