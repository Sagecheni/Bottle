module MOD_MAX (
    input wire CLK,           // 时钟信号
    input wire isWork,        // 工作状态信号，高电平表示正在工作
    input wire conti,         // 是否继续计数信号，高电平表示继续
    input wire allFull,       // 全满信号，高电平表示药瓶已满
    input wire EN_work,       // 工作使能信号，高电平表示使能
    input wire EN_set,        // 设置使能信号，高电平表示使能
    input wire set,           // 设置信号，高电平表示正在设置
    input wire [3:0] maxL,    // 药瓶容量的个位部分
    input wire [3:0] maxH,    // 药瓶容量的十位部分

    output reg [3:0] outL,    // 输出当前药片数量的个位部分
    output reg [3:0] outH     // 输出当前药片数量的十位部分
);

    reg [3:0] ones, tens;     // ones: 当前计数的个位部分, tens: 当前计数的十位部分
    reg stop;                 // stop: 停止计数信号，高电平表示停止计数

    always @(posedge CLK) begin
        // 当 EN_work 和 EN_set 高电平且 set 低电平时复位计数器
        if (EN_work && EN_set && !set) begin
            ones <= 4'b0000;
            tens <= 4'b0000;
            stop <= 0;
        end else if (isWork) begin
            // 在工作状态下，当 EN_work 和 EN_set 都低电平时进行计数
            if (!EN_work && !EN_set) begin
                // 如果药瓶未满且未停止计数，继续计数
                if (!allFull && !stop) begin
                    // 如果当前计数达到最大值，复位计数器并根据 set 信号停止计数
                    if (ones == maxL && tens == maxH) begin
                        ones <= 4'b0000;
                        tens <= 4'b0000;
                        stop <= set ? 1 : 0;
                    end else if (ones == 4'b1001) begin
                        // 如果个位数达到9，个位数复位，十位数加1
                        ones <= 4'b0000;
                        tens <= tens + 1;
                    end else begin
                        // 否则，个位数加1
                        ones <= ones + 1;
                    end
                end else if (conti) begin
                    // 如果 conti 信号高电平，继续计数
                    stop <= 0;
                end
            end
        end
        // 将当前计数输出
        outL <= ones;
        outH <= tens;
    end
endmodule
