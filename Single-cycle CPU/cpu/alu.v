module alu(
a,b,aluc,r,z
);
input [31:0] a,b;
input [31:0] aluc;
output [31:0] r;
output z;
wire [31:0] d_and = a & b;
wire [31:0] d_or = a | b;
wire [31:0] d_xor = a ^ b;
wire [31:0] d_lui = {b[15:0],16'h0};
wire [31:0] d_and_or = aluc[2] ? d_or :d_and;
wire [31:0] d_xor_lui = aluc[2] ? d_lui: d_xor;
wire [31:0] d_as,d_sh;
assign d_as = aluc[2] ? a - b :a + b;
shift shifter(b,a[4:0],aluc[2],aluc[3],d_sh);
mux4x32 select(d_as,d_and_or,d_xor_lui,d_sh,aluc[1:0],r);
assign z = ~|r;
endmodule 