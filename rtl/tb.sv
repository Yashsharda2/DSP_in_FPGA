`timescale 1ns/1ps

module tb;

logic clk, rst;
always #5 clk = ~clk;

logic signed [15:0] sample_real, sample_img;
logic valid_in, done;

logic signed [15:0] fir_out_real, fir_out_img;
logic ready;

data u_data (
    .clk        (clk),
    .rst        (rst),
    .en         (1'b1),
    .sample_real(sample_real),
    .sample_img (sample_img),
    .valid      (valid_in),
    .done       (done)
);

fir u_fir (
    .clk         (clk),
    .rst         (rst),
    .x_real_in   (sample_real),
    .x_img_in    (sample_img),
    .valid       (valid_in),
    .fir_out_real(fir_out_real),
    .fir_out_img (fir_out_img),
    .ready       (ready)
);

integer f;
int cycle_count;

initial begin
    f = $fopen("fir_out.txt", "w");
    $fdisplay(f, "cycle,fir_real,fir_img");
end

// delay valid by 1 cycle to match FIR registered output
logic valid_d;
always @(posedge clk) begin
    if (rst) valid_d <= 0;
    else     valid_d <= valid_in;
end

always @(posedge clk) begin
    if (!rst && valid_d) begin
        $fdisplay(f, "%0d,%0d,%0d", cycle_count, fir_out_real, fir_out_img);
        $display("cycle=%0d | fir_real=%0d | fir_img=%0d", cycle_count, fir_out_real, fir_out_img);
    end
    cycle_count <= cycle_count + 1;
end

initial begin
    clk = 0; rst = 1; cycle_count = 0;
    repeat(4) @(posedge clk);
    rst = 0;

    wait(done);
    repeat(40) @(posedge clk);  // enough for FIR pipeline to flush

    $fclose(f);
    $display("Done. Output written to fir_out.txt");
    $finish;
end

initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
end

endmodule
