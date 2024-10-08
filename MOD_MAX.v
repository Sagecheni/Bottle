module MOD_MAX (
    input wire CLK,           // 时钟信号
    input wire isWork,        // 工作状态信号，高电平表示正在工作
    input wire conti,         // 是否继续计数
    input wire EN_work,       // 工作模式信号
    input wire EN_set,        // 设置模式信号
    input wire set,           // 工作状态下，连续计数/间隔计数
    input wire [3:0] maxL,    // 药瓶容量的个位部分
    input wire [3:0] maxH,    // 药瓶容量的十位部分
    input wire [3:0] nowL,    // 当前药片数量的个位ni
    input wire [3:0] nowH,    // 当前药片数量的十位
    input wire [3:0] bot_maxL,    // 药瓶总数的个位部分
    input wire [3:0] bot_maxH,    // 药瓶总数的十位部分

    output reg [3:0] outL,    // 输出当前药片数量的个位部分
    output reg [3:0] outH,    // 输出当前药片数量的十位部分
    output reg [3:0] seqL,    // 输出当前已装满药瓶数量的个位部分
    output reg [3:0] seqH,    // 输出当前已装满药瓶数量的十位部分
    output reg allFull        // 全满信号
);

    reg [3:0] ones, tens;     // ones: 当前药片计数的个位部分, tens: 当前药片计数的十位部分
    reg [3:0] start_seq_L, start_seq_H; // 药瓶装满的计数
    reg stop;                 // 停止计数标志
    reg conti_last;           // 上一个时钟周期的 conti 信号

    initial begin
        ones = 4'b0000;
        tens = 4'b0000;
        start_seq_L = 4'b0000;
        start_seq_H = 4'b0000;
        allFull = 0;
        stop = 0;
        conti_last = 0;
    end

    always @(posedge CLK) begin
        // 检测 conti 信号的上升沿
        if (conti && !conti_last) begin
            stop <= 0; // 允许计数继续
            allFull <= 0; // 取消警报
        end
        conti_last <= conti; // 更新上一个时钟周期的 conti 信号

        if (EN_work && EN_set) begin
            // 复位计数器
            ones <= 4'b0000;
            tens <= 4'b0000;
            start_seq_L <= 4'b0000;
            start_seq_H <= 4'b0000;
            allFull <= 0;
            stop <= 0;
        end else if (isWork && !stop ) begin
            if (start_seq_L == bot_maxL  && start_seq_H == bot_maxH && ones == 0 && tens == 0) begin
                // 如果已经装满所有瓶子，触发全满信号并停止
                allFull <= 1'b1;
                stop <= 1'b1;
            end else if (ones == maxL - 1 && tens == maxH) begin
                // 正常增加瓶子计数
                ones <= 4'b0000;
                tens <= 4'b0000;
                if (start_seq_L == 4'b1001) begin
                    start_seq_L <= 4'b0000;
                    start_seq_H <= start_seq_H + 1;
                end else begin
                    start_seq_L <= start_seq_L + 1;
                end
                
                // 如果 set 信号为高，且计数满一瓶后停止并触发警报（间隔计数）
                if (set) begin
                    stop <= 1'b1;
                    allFull <= 1'b1;
                end
            end else if (!EN_work && !EN_set) begin
                // 如果个位数达到9，个位数复位，十位数加1
                if (ones == 4'b1001) begin
                    ones <= 4'b0000;
                    tens <= tens + 1;
                end else begin
                    // 正常药片计数
                    ones <= ones + 1;
                end
            end
        end else if (!isWork) begin
            // 如果停止工作，复位全满信号和停止标志
            allFull <= 1'b0;
            stop <= 0;
        end

        // 将当前计数输出
        outL <= ones;
        outH <= tens;

        // 将药瓶装满计数输出
        seqL <= start_seq_L;
        seqH <= start_seq_H;
    end

endmodule
