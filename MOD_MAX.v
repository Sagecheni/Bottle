module MOD_MAX (
    input wire CLK,           // 时钟信号
    input wire isWork,        // 工作状态信号，高电平表示正在工作
    input wire conti,         // 是否继续计数信号，高电平表示继续
    input wire allFull,       // 全满信号，高电平表示药瓶已满
    input wire EN_work,       // 工作模式信号
    input wire EN_set,        // 设置模式信号
    input wire set,           // 设置信号，高电平表示正在设置
    input wire [3:0] maxL,    // 药瓶容量的个位部分
    input wire [3:0] maxH,    // 药瓶容量的十位部分

    output reg [3:0] outL,    // 输出当前药片数量的个位部分
    output reg [3:0] outH     // 输出当前药片数量的十位部分
);

    reg [3:0] ones, tens;     // ones: 当前计数的个位部分, tens: 当前计数的十位部分

    always @(posedge CLK) begin
        if (EN_work && EN_set && !set) begin
            // 复位计数器
            ones <= 4'b0000;
            tens <= 4'b0000;
        end else if (isWork && !allFull) begin
            // 在工作状态下，且全满信号为低时进行计数
            if (!EN_work && !EN_set) begin
                if (ones == 4'b1001) begin
                    // 如果个位数达到9，个位数复位，十位数加1
                    ones <= 4'b0000;
                    tens <= tens + 1;
                end else if ((ones == maxL - 1 && tens == maxH) || (ones == 9 && maxL == 0 && tens == maxH - 1)) begin
                    // 达到最大值时，复位计数器
                    ones <= 4'b0000;
                    tens <= 4'b0000;
                end else begin
                    // 正常计数
                    ones <= ones + 1;
                end
            end
        end else if (conti) begin
            // 如果 conti 信号高电平，继续计数
            ones <= ones + 1;
        end
        // 将当前计数输出
        outL <= ones;
        outH <= tens;
    end
endmodule
