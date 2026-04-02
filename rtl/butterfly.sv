module butterfly(
//Q1.15 format
input signed [15:0] a_real,     
input signed [15:0] a_img,
input signed [15:0] b_real,
input signed [15:0] b_img,

input signed [15:0] w_real,
input signed [15:0] w_img,

output signed [15:0] X_real,
output signed [15:0] X_img,
output signed [15:0] Y_real,
output signed [15:0] Y_img
);

wire signed [16:0] sum_real;
wire signed [16:0] sum_img;

wire signed [16:0] diff_real_w;
wire signed [16:0] diff_img_w;

wire signed [16:0] diff_real;
wire signed [16:0] diff_img;


assign sum_real = a_real + b_real;
assign sum_img  = a_img  + b_img;
assign diff_real_w = a_real - b_real;
assign diff_img_w  = a_img  - b_img;

assign diff_real = diff_real_w >>> 1;
assign diff_img  = diff_img_w  >>> 1;
assign X_real = sum_real >>> 1;
assign X_img  = sum_img  >>> 1;

// truncate diff back to 16-bit for multiplier
wire signed [15:0] diff_real_s;
wire signed [15:0] diff_img_s;

assign diff_real_s = diff_real[15:0];
assign diff_img_s  = diff_img[15:0];

wire signed [31:0] mult_real;
wire signed [31:0] mult_img;


assign mult_real = (diff_real_s * w_real) - (diff_img_s * w_img);
assign mult_img  = (diff_real_s * w_img) + (diff_img_s * w_real);
assign Y_real = (mult_real + 32'sd16384) >>> 15;
assign Y_img  = (mult_img  + 32'sd16384) >>> 15;

endmodule