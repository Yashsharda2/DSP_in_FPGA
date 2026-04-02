module fir(
input logic clk,
input logic rst,

input logic signed [15:0] x_real_in,
input logic signed [15:0] x_img_in,
input logic valid,

output logic signed [15:0] fft_real[0:15],
output logic signed [15:0] fft_img[0:15],
output logic ready
);

localparam int NTAPS = 16;

    // coefficients
    logic signed [15:0] h [0:NTAPS-1];
    initial begin
        h[0]  = -16'sd42;   h[1]  = -16'sd177;
        h[2]  = -16'sd406;  h[3]  = -16'sd352;
        h[4]  =  16'sd669;  h[5]  =  16'sd2961;
        h[6]  =  16'sd5846; h[7]  =  16'sd7885;
        h[8]  =  16'sd7885; h[9]  =  16'sd5846;
        h[10] =  16'sd2961; h[11] =  16'sd669;
        h[12] = -16'sd352;  h[13] = -16'sd406;
        h[14] = -16'sd177;  h[15] = -16'sd42;
    end

    logic signed [15:0] sr_real [0:NTAPS-1];
    logic signed [15:0] sr_img [0:NTAPS-1];
    
    always_ff @(posedge clk) begin
    if(!rst)begin
    for (int i = 0; i < NTAPS; i++) begin
    sr_real[i] <= '0;
    sr_img[i]  <= '0;
    end
    end else if(valid) begin
    for(int i=NTAPS-1; i>0; i--) begin
    sr_real[i]<=sr_real[i-1];
    sr_img[i]<=sr_img[i-1];
    end 
    sr_real[0]<=x_real_in;
    sr_img[0]<=x_img_in;
    end
    end
    
    logic signed [35:0] acc_real, acc_img;
    
    always_comb begin
    acc_real = '0;
    acc_img = '0;
     for(int k=0; k<NTAPS; k++) begin
     acc_real+=sr_real[k]*h[k];
     acc_img+=sr_img[k]*h[k];
     end
     end
     
      logic signed [15:0] fir_out_real, fir_out_img;
      assign fir_out_real = (acc_real + 36'sd16384) >>> 15;
      assign fir_out_img  = (acc_img  + 36'sd16384) >>> 15;
      
       logic signed [15:0] f_real [0:NTAPS-1];
       logic signed [15:0] f_img  [0:NTAPS-1];
       logic [3:0]         frame_idx;
       logic               frame_ready;
       
       always_ff @(posedge clk) begin
       if(rst)begin
       frame_idx<='0;
       frame_ready<=1'b0;
       for (int i = 0; i < NTAPS; i++) begin
                f_real[i] <= '0;
                f_img[i]  <= '0;
            end
       end else begin
       frame_ready<=1'b0;
       if(valid) begin
       f_real[frame_idx]<=fir_out_real;
       f_img[frame_idx]<=fir_out_img;
       if(frame_idx==4'd15)begin
       frame_idx<='0;
       frame_ready<=1'b1;
       end else begin
       frame_idx <= frame_idx + 1'b1;
       end
       end
       end
       end
       
       always_ff @(posedge clk) begin
       if(rst) begin
       for (int i = 0; i < NTAPS; i++) begin
                fft_real[i] <= '0;
                fft_img[i]  <= '0;
       end 
       end else if(frame_ready) begin
       for (int i = 0; i < NTAPS; i++) begin
       fft_real[i]<=f_real[i];
       fft_img[i]<=f_img[i];
       end
       end
       end
       assign ready = frame_ready;
    
endmodule