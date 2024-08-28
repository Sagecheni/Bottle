module Music (
    input wire CLK,        // 主时钟信号
    input wire CLK_1,      // 音频时钟信号
    input wire allFull,    // 全满信号
    output reg Music       // 输出警报信号
);

    reg [1:0] state;  // 用于控制交替输出的状态

    always @(posedge CLK) begin
        if (allFull) begin
            state <= state + 1;  // 每次时钟周期更新状态
            if (state == 2'b00 || state == 2'b10) begin
                Music <= CLK_1;  // 输出警报音频
            end else begin
                Music <= 1'b0;   // 输出无效音频
            end
        end else begin
            Music <= 1'b0;  // 当 allFull 无效时，保持 Music 为低电平
            state <= 2'b00;  // 重置状态
        end
    end

endmodule
