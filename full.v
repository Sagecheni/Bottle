module full (
    input wire CLK,
    input wire EN_work,         // 模式控制
    input wire EN_set,
    input wire set,             //设置选择端
    input wire isWork,          //总开关
    input wire [3:0] maxL,
    input wire [3:0] maxH,
    input wire [3:0] nowL,
    input wire [3:0] nowH,
    output reg [3:0] seqL,
    output reg [3:0] seqH
);

    reg [3:0] start_seq_L, start_seq_H;

    always @(posedge CLK) begin
        if (EN_work && EN_set && set) begin
            // 清零模式：将药片数清零
            start_seq_L <= 4'b0000;
            start_seq_H <= 4'b0000;
        end else if (!EN_work && isWork && !EN_set) begin
            // 正常工作模式下，比较当前药片数与药瓶容量
            if (nowL == maxL - 2 && nowH == maxH || maxL == 0 && nowL == 8 && nowH == maxH - 1 || maxL == 1 && nowL == 9 && nowH == maxH -1) begin
                // 如果当前药片数等于容量，表示药瓶已装满
                if (start_seq_L == 4'b1001) begin
                    start_seq_L <= 4'b0000;
                    start_seq_H <= start_seq_H + 1;
                end else begin
                    start_seq_L <= start_seq_L + 1;
                end
            end
        end
        // 将计数器输出到seqL和seqH
        seqL <= start_seq_L;
        seqH <= start_seq_H;
    end

endmodule
