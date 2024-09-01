module Music (
    input wire CLK,        // 主时钟信号 (1 Hz)
    input wire CLK_1,      // 音频时钟信号 (100 kHz)
    input wire allFull,    // 全满信号
    output reg Music       // 输出警报信号
);

    reg [7:0] counter;      // 8位计数器，用于生成音频信号
    reg enable_audio;       // 控制音频启停的标志


    // 使用 1 Hz 的 CLK 信号控制音频的启停
    always @(posedge CLK) begin
        if (allFull) begin
            enable_audio <= ~enable_audio;  // 每秒翻转一次，控制启停
        end else begin
            enable_audio <= 0;  // 如果 allFull 为低，关闭音频
        end
    end

    // 使用较高频率的 CLK_1 生成音频信号
    always @(posedge CLK_1) begin
        if (allFull && enable_audio) begin
            counter <= counter + 1;
            if (counter >= 152) begin  // 100 kHz / 152 ≈ 657.89 Hz
                counter <= 0;
                Music <= ~Music;  // 翻转输出，产生方波
            end
        end else begin
            Music <= 0;
        end
    end

endmodule
