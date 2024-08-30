module control (
    input wire CLK,
    input wire allFull,       // 全满信号
    input wire startWork,     // 开始工作的信号
    output reg isWork         // 工作状态信号，高电平表示正在工作
);

    always @(posedge CLK) begin
        if (allFull) begin
            // 如果全满信号为高，停止工作
            isWork <= 0;
        end else if (startWork) begin
            // 如果开始工作的信号为高，启动工作
            isWork <= 1;
        end
    end

endmodule
