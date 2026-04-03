module magnitude(
input logic signed [15:0] X_real_in[0:15],
input logic signed [15:0] X_img_in[0:15],

output logic [31:0] mag_sq [0:15]
);

always_comb begin
for(int i=0; i<16; i++)begin
 mag_sq[i] = X_real_in[i]*X_real_in[i] + X_img_in[i]*X_img_in[i];
 end
 end
 endmodule