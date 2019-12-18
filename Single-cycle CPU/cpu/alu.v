module alu(operanda, operandb, op, result, zero);
	input [31:0] operanda, operandb;
	input [3:0] op;
	output reg [31:0] result;
	output zero;
	
	initial
		result = 0;
	
	always@(operanda or operandb or op)
	begin
		casex(op)
			4'bx000: result = operanda + operandb;							//ADD
			4'bx100: result = operanda - operandb;							//SUB
			
			4'bx001: result = operanda & operandb;							//AND
			4'bx101: result = operanda | operandb;							//OR
			
			4'bx010: result = operanda ^ operandb;							//XOR
			4'bx110: result = {operandb[15:0], 16'h0};			//LUI
			
			4'b0011: result = operandb << operanda[4:0];					//SLL
			4'b0111: result = operandb >> operandb[4:0];					//SRL
			
			4'b1111: result = ($signed(operandb)) >>> operanda[4:0];	//SRA
			
			default: result = 32'hffffffff;					//ERROR
		endcase
	end
	
	assign zero = ~|result;
	
endmodule 