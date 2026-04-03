module fir(
input logic clk,
input logic rst,

input logic signed [15:0] x_real_in,
input logic signed [15:0] x_img_in,
input logic valid,

output logic signed [15:0] fir_out_real,
output logic signed [15:0] fir_out_img,
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

    logic signed [35:0] sr_real [0:NTAPS-1];
    logic signed [35:0] sr_img [0:NTAPS-1];
    
    logic signed [31:0] mult_real [0:NTAPS-1];
    logic signed [31:0] mult_img  [0:NTAPS-1];

always_comb begin
for(int i=0; i<NTAPS; i++)begin
mult_real[i]=x_real_in*h[i];
mult_img[i]=x_img_in*h[i];
end
end


always_ff @(posedge clk) begin
if(rst)begin
for (int i = 0; i < NTAPS; i++) begin
sr_real[i] <= '0;
sr_img[i]  <= '0;
end
end else if(valid) begin
sr_real[0]<=mult_real[0];
sr_img[0]<=mult_img[0];
for(int i=1; i<NTAPS; i++) begin
sr_real[i]<=sr_real[i-1]+mult_real[i];
sr_img[i]<=sr_img[i-1]+mult_img[i];
end 
end
end
     
assign fir_out_real = (sr_real[NTAPS-1] + 36'sd16384) >>> 15;
assign fir_out_img  = (sr_img[NTAPS-1]  + 36'sd16384) >>> 15;
       
endmodule