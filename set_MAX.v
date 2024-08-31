
//参数控制器
module set_MAX (
    input wire CLK,         // 时钟信号
    input wire EN_work,     // 工作使能信号
    input wire EN_set,      // 设置使能信号
    input wire set,         // 设置信号
    input wire [3:0] setL,  // 设置的个位
    input wire [3:0] setH,  // 设置的十位
    output reg [3:0] maxL,  
    output reg [3:0] maxH
);

    always @(posedge CLK) begin
        if (EN_work && !EN_set && set) begin
            maxL <= (setL > 4'b1001) ? 4'b1001 : setL;
            maxH <= (setH > 4'b1001) ? 4'b1001 : setH;
        end
    end

endmodule
