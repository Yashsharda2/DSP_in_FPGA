module fft (

    input  signed [15:0] x_real [0:15],
    input  signed [15:0] x_img [0:15],

    output signed [15:0] X_real [0:15],
    output signed [15:0] X_img [0:15]

);

//  Twiddle factor
reg signed [15:0] W_real [0:7];
reg signed [15:0] W_img [0:7];

initial begin
    W_real[0] = 16'sd32767;  W_img[0] = 16'sd0;

    W_real[1] = 16'sd30274;  W_img[1] = -16'sd12540;
    W_real[2] = 16'sd23170;  W_img[2] = -16'sd23170;
    W_real[3] = 16'sd12540;  W_img[3] = -16'sd30274;

    W_real[4] = 16'sd0;      W_img[4] = -16'sd32768;
    W_real[5] = -16'sd12540; W_img[5] = -16'sd30274;
    W_real[6] = -16'sd23170; W_img[6] = -16'sd23170;
    W_real[7] = -16'sd30274; W_img[7] = -16'sd12540;
end


wire signed [15:0] s1_real [0:15];
wire signed [15:0] s1_img [0:15];

wire signed [15:0] s2_real [0:15];
wire signed [15:0] s2_img [0:15];

wire signed [15:0] s3_real [0:15];
wire signed [15:0] s3_img [0:15];

// Stages 

stage #(16, 0) stage0 (
    .in_real(x_real),
    .in_img(x_img),
    .w_real(W_real),
    .w_img(W_img),
    .out_real(s1_real),
    .out_img(s1_img)
);

// Stage 1
stage #(16, 1) stage1 (
    .in_real(s1_real),
    .in_img(s1_img),
    .w_real(W_real),
    .w_img(W_img),
    .out_real(s2_real),
    .out_img(s2_img)
);

stage #(16, 2) stage2 (
    .in_real(s2_real),
    .in_img(s2_img),
    .w_real(W_real),
    .w_img(W_img),
    .out_real(s3_real),
    .out_img(s3_img)
);

stage #(16, 3) stage3 (
    .in_real(s3_real),
    .in_img(s3_img),
    .w_real(W_real),
    .w_img(W_img),
    .out_real(X_real),
    .out_img(X_img)
);

endmodule