module BCD_7 (
    input wire EN, //翻页控制端
    output reg a,  //最上方横向数码管，按顺时针顺序旋转，g为中间横向数码管
    output reg b,
    output reg c,
    output reg d,
    output reg e,
    output reg f,
    output reg g
);

    reg [6:0] num;

    always @(*) begin
        if (!EN) begin
            num = 7'b0110000; // 显示数字1
        end else begin
            num = 7'b1101101; // 显示数字2
        end
        {a, b, c, d, e, f, g} = num;
    end

endmodule
