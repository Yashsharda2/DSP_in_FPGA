module window(
input logic signed [15:0] in_real_window[0:15],
input logic signed [15:0] in_img_window[0:15],
output logic signed [15:0] window_real[0:15], 
output logic signed [15:0] window_img [0:15]
);

reg signed [15:0] w [0:15];

initial begin
    w[0] = 16'sd2621;
    w[1] = 16'sd3925;
    w[2] = 16'sd7609;
    w[3] = 16'sd13037;
    w[4] = 16'sd19270;
    w[5] = 16'sd25231;
    w[6] = 16'sd29889;
    w[7] = 16'sd32439;
    w[8] = 16'sd32439;
    w[9] = 16'sd29889;
    w[10] = 16'sd25231;
    w[11] = 16'sd19270;
    w[12] = 16'sd13037;
    w[13] = 16'sd7609;
    w[14] = 16'sd3925;
    w[15] = 16'sd2621;
end

logic signed [31:0] mult_real [0:15];
logic signed [31:0] mult_img  [0:15];


always_comb begin
for (int i=0; i<16; i++) begin
 mult_img[i] = in_img_window[i]*w[i];
 mult_real[i] = in_real_window[i]*w[i];

  window_real[i] = (mult_real[i] + 32'sd16384) >>> 15;
  window_img[i]  = (mult_img[i]  + 32'sd16384) >>> 15;
end
end

endmodule