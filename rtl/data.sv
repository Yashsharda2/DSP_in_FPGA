module data (
    input  logic clk,
    input  logic rst,
    input  logic en,              
    output logic signed [15:0] sample_real,
    output logic signed [15:0] sample_img,
    output logic valid,
    output logic done            
);

logic signed [15:0] data_real [0:15];
logic signed [15:0] data_img  [0:15];

initial begin
    data_real[0]  =  16'sd32767;
    data_real[1]  =  16'sd30274;
    data_real[2]  =  16'sd23170;
    data_real[3]  =  16'sd12540;
    data_real[4]  =  16'sd0;
    data_real[5]  = -16'sd12540;
    data_real[6]  = -16'sd23170;
    data_real[7]  = -16'sd30274;
    data_real[8]  = -16'sd32768;
    data_real[9]  = -16'sd30274;
    data_real[10] = -16'sd23170;
    data_real[11] = -16'sd12540;
    data_real[12] =  16'sd0;
    data_real[13] =  16'sd12540;
    data_real[14] =  16'sd23170;
    data_real[15] =  16'sd30274;

    for (int i = 0; i < 16; i++)
        data_img[i] = 16'sd0;
end

logic [3:0] idx;


always_ff @(posedge clk) begin
    if (rst) begin
        idx         <= '0;
        valid       <= 1'b0;
        done        <= 1'b0;
        sample_real <= '0;
        sample_img  <= '0;
    end else begin
        valid <= 1'b0;
        if (en && !done) begin
            sample_real <= data_real[idx]; 
            sample_img  <= data_img[idx];
            valid       <= 1'b1;
            if (idx == 4'd15) begin
                done <= 1'b1;
                idx  <= '0;
            end else begin
                idx <= idx + 1;
            end
        end
    end
end

endmodule