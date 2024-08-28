module all_slice (
    input wire CLK,
    input wire isWork,
    input wire [3:0] bot_seq_L,   // 已装满药瓶数的个位
    input wire [3:0] bot_seq_H,   // 已装满药瓶数的十位
    input wire [3:0] bot_maxL,    // 药瓶总数的个位
    input wire [3:0] bot_maxH,    // 药瓶总数的十位
    output reg allFull            // 全满信号
);

    always @(posedge CLK) begin
        if (isWork) begin
            if (bot_seq_L == bot_maxL && bot_seq_H == bot_maxH) begin
                // 如果已装满药瓶数等于药瓶总数，输出全满信号
                allFull <= 1;
            end else begin
                // 否则全满信号无效
                allFull <= 0;
            end
        end else begin
            // 如果不是工作状态，保持全满信号无效
            allFull <= 0;
        end
    end

endmodule
