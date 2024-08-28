module page (
    input wire CLK,            // 时钟信号
    input wire EN,             // 显示模式控制信号：EN = 0 时显示模式1，EN = 1 时显示模式2
    input wire SET,            // 设置模式信号，用于控制显示内容在设置模式下的闪烁
    input wire EN_work,        // 工作模式使能信号
    input wire EN_set,         // 设置模式使能信号
    input wire print1,         // 页显示控制信号：print1 = 0 时显示第1页，print1 = 1 时显示第2页
    input wire [3:0] max2,     // 输入的最大值（十位）
    input wire [3:0] max1,     // 输入的最大值（个位）
    input wire [3:0] ten,      // 当前值的十位
    input wire [3:0] one,      // 当前值的个位
    input wire [3:0] mode1,    // 模式1下的显示值
    input wire [3:0] mode2,    // 模式2下的显示值
    input wire [3:0] seqH,     // 序列高位值
    input wire [3:0] seqL,     // 序列低位值
    input wire [3:0] now2,     // 当前值的高位
    input wire [3:0] now1,     // 当前值的低位
    output reg [3:0] out6,     // 数码管/交通灯的输出6
    output reg [3:0] out5,     // 数码管/交通灯的输出5
    output reg [3:0] out4,     // 数码管/交通灯的输出4
    output reg [3:0] out3,     // 数码管/交通灯的输出3
    output reg [3:0] out2      // 数码管/交通灯的输出2
);

    // 定义内部寄存器，用于暂存输出值
    reg [3:0] Y6, Y5, Y4, Y3, Y2;

    // 基于时钟信号的上升沿，更新显示内容
    always @(posedge CLK) begin
        // 根据 EN 信号选择模式1或模式2
        if (EN == 1'b0) begin
            Y6 <= mode1;  // 模式1下的显示值
        end else begin
            Y6 <= mode2;  // 模式2下的显示值
        end

        // 根据 print1 信号选择显示第1页还是第2页
        if (print1 == 1'b0) begin
            // 第1页显示逻辑
            if (EN_work == 1'b1 && EN_set == 1'b0 && CLK == 1'b0) begin
                // 在设置模式下的闪烁控制
                if (SET == 1'b0) begin
                    Y5 <= max2;  // 显示最大值的十位
                    Y4 <= max1;  // 显示最大值的个位
                    Y3 <= 4'b1111;  // 数码管空白（不显示）
                    Y2 <= 4'b1111;  // 数码管空白（不显示）
                end else begin
                    Y5 <= 4'b1111;  // 数码管空白（不显示）
                    Y4 <= 4'b1111;  // 数码管空白（不显示）
                    Y3 <= max2;  // 显示最大值的十位
                    Y2 <= max1;  // 显示最大值的个位
                end
            end else begin
                // 正常显示状态
                Y5 <= max2;  // 显示最大值的十位
                Y4 <= max1;  // 显示最大值的个位
                Y3 <= ten;   // 显示当前值的十位
                Y2 <= one;   // 显示当前值的个位
            end
        end else if (print1 == 1'b1) begin
            // 第2页显示逻辑
            Y5 <= seqH;  // 显示序列的高位
            Y4 <= seqL;  // 显示序列的低位
            Y3 <= now2;  // 显示当前值的高位
            Y2 <= now1;  // 显示当前值的低位
        end
    end

    // 将计算出的寄存器值输出到输出端口
    always @* begin
        out6 = Y6;
        out5 = Y5;
        out4 = Y4;
        out3 = Y3;
        out2 = Y2;
    end

endmodule
