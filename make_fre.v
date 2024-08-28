module make_fre (
    input wire CLK,
    output wire CLK_out
);

    reg bin_Y;

    initial begin
        bin_Y = 1'b0;  // 初始化 bin_Y
    end

    always @(posedge CLK) begin
        bin_Y <= ~bin_Y;  // 在每个时钟上升沿，翻转 bin_Y 信号
    end

    assign CLK_out = bin_Y;  // 输出为分频后的时钟信号

endmodule
