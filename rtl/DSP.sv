module DSP (
input logic clk,
input logic rst,


output logic signed [15:0] FFT_real [0:15],
output logic signed [15:0] FFT_img  [0:15],
output logic done
);

logic        [31:0] magnitude_sq [0:15];


//  data -> fir
logic signed [15:0] sam_real;
logic signed [15:0] sam_img;
logic valid;

//  fir -> frame
logic signed [15:0] fir_out_real;
logic signed [15:0] fir_out_img;
logic fir_ready;

//  frame -> window
logic signed [15:0] in_real_window[0:15];
logic signed [15:0] in_img_window[0:15];
logic frame_ready;

// window -> fft            
logic signed [15:0] window_real [0:15];
logic signed [15:0] window_img  [0:15];

data u_data (
    .clk        (clk),
    .rst        (rst),
    .en         (1'b1),
    .sample_real(sam_real),
    .sample_img (sam_img),
    .valid      (valid),
    .done       (done)
);

fir u_fir (
    .clk(clk),
    .rst(rst),
    .x_real_in(sam_real),
    .x_img_in(sam_img),
    .valid(valid),
    .fir_out_real(fir_out_real),
    .fir_out_img(fir_out_img),
    .ready(fir_ready)
);

frame u_frame (
    .clk(clk),
    .rst(rst),
    .data_real_in(fir_out_real),
    .data_img_in(fir_out_img),
    .valid_in(fir_ready),
    .frame_real(in_real_window),
    .frame_img(in_img_window),
    .frame_ready(frame_ready)
);
window u_window (                     
    .in_real_window(in_real_window),
    .in_img_window(in_img_window),
    .window_real(window_real),
    .window_img(window_img)
);

fft u_fft (
    .x_real(window_real),             
    .x_img(window_img),
    .X_real(FFT_real),
    .X_img(FFT_img)
);

magnitude u_mag(
    .X_real_in(FFT_real),
    .X_img_in(FFT_img),
    .mag_sq(magnitude_sq)
);

endmodule