module stage #(
parameter N = 16,
parameter STAGE = 0
)(

input signed [15:0] in_real [0:N-1],
input signed [15:0] in_img [0:N-1],

input signed [15:0] w_real[0:N/2-1],
input signed [15:0] w_img[0:N/2-1],

output signed [15:0] out_real [0:N-1],
output signed [15:0] out_img [0:N-1]
);

localparam integer HALF = (1 << STAGE);
localparam integer STEP = (1 << (STAGE + 1));
localparam integer STRIDE = N / STEP;

genvar k, i;

generate
    for (k = 0; k < N; k = k + STEP) begin : block
        for (i = 0; i < HALF; i = i + 1) begin : butterfly_loop
        
            butterfly bf(
                .a_real(in_real[k+i]),
                .a_img (in_img[k+i]),
                .b_real(in_real[k+i+HALF]),
                .b_img (in_img[k+i+HALF]),

                .X_real(out_real[k+i]),
                .X_img (out_img[k+i]),
                .Y_real(out_real[k+i+HALF]),
                .Y_img (out_img[k+i+HALF]),

                .w_real(w_real[i*STRIDE]),
                .w_img (w_img[i*STRIDE])
);
end
end
endgenerate
endmodule