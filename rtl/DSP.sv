module DSP (
input logic clk,
input logic rst,
input logic signed [15:0] sam_real,
input logic signed [15:0] sam_img,
input logic valid,

output logic signed [15:0] FFT_real [0:15],
output logic signed [15:0] FFT_img  [0:15]

);

logic signed [15:0] fir_to_fft_real [0:15];
    logic signed [15:0] fir_to_fft_img  [0:15];
    logic fft_frame_ready;

fir u (
        .clk(clk),
        .rst(rst),
        .x_real_in(sam_real),
        .x_img_in(sam_img),
        .valid(valid),
        .fft_real(fir_to_fft_real),
        .fft_img(fir_to_fft_img),
        .ready(fft_frame_ready)
    );

    fft u_fft (
        .x_real  (fir_to_fft_real),
        .x_img   (fir_to_fft_img),
        .X_real  (FFT_real),
        .X_img   (FFT_img)
    );

endmodule