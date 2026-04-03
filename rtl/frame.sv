module frame #(
    parameter N = 16,
    parameter WIDTH = 16
)(
    input  logic clk,
    input  logic rst,

    input  logic signed [WIDTH-1:0] data_real_in,
    input  logic signed [WIDTH-1:0] data_img_in,
    input  logic valid_in,

    output logic signed [WIDTH-1:0] frame_real [0:N-1],
    output logic signed [WIDTH-1:0] frame_img  [0:N-1],
    output logic frame_ready
);

logic [$clog2(N)-1:0] frame_idx;

always_ff @(posedge clk) begin
    if (rst) begin
        frame_idx   <= '0;
        frame_ready <= 1'b0;

        for (int i = 0; i < N; i++) begin
            frame_real[i] <= '0;
            frame_img[i]  <= '0;
        end
    end 
    else begin
        frame_ready <= 1'b0;

        if (valid_in) begin
            frame_real[frame_idx] <= data_real_in;
            frame_img[frame_idx]  <= data_img_in;

            if (frame_idx == N-1) begin
                frame_idx   <= '0;
                frame_ready <= 1'b1;
            end 
            else begin
                frame_idx <= frame_idx + 1'b1;
            end
        end
    end
end

endmodule