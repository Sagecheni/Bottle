//控制两个4位信号 light 和 light2 的模块。根据输入的使能信号和设置信号，这两个输出信号的值会在不同的情况下被更新

module light_1 (
    input wire CLK,                    // 时钟信号
    input wire EN_work,                // 工作状态使能信号
    input wire EN_set,                 // 设置状态使能信号
    input wire SET,                    // 设置信号
    input wire allFull,                // 满状态信号
    output reg [3:0] light,            // 4位灯光控制输出
    output reg [3:0] light2            // 4位灯光控制输出
);

always @(posedge CLK) begin
    if (EN_work == 1'b1 && EN_set == 1'b1) begin
        light <= 4'b0000;
        light2 <= 4'b0001;
    end else if (EN_work == 1'b0 && EN_set == 1'b0 && SET == 1'b0) begin
        light <= 4'b0001;
        light2 <= 4'b0100;
    end else if (EN_work == 1'b0 && EN_set == 1'b0 && SET == 1'b1) begin
        light <= 4'b0010;
        light2 <= 4'b0100;
    end else if (EN_work == 1'b0 && EN_set == 1'b1) begin
        light <= 4'b0011;
        light2 <= 4'b1000;
    end else if (EN_work == 1'b1 && EN_set == 1'b0) begin
        light2 <= 4'b0010;
        if (SET == 1'b0) begin
            light <= 4'b0100;
        end else if (SET == 1'b1) begin
            light <= 4'b0101;
        end
    end

    if (allFull == 1'b1) begin
        light2 <= 4'b0001;
    end
end

endmodule
