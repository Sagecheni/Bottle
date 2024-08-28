module tb_page;

    reg CLK;             // 测试时钟信号
    reg EN;              // 测试模式控制信号
    reg SET;             // 测试设置模式信号
    reg EN_work;         // 测试工作模式信号
    reg EN_set;          // 测试设置使能信号
    reg print1;          // 页显示控制信号
    reg [3:0] max2, max1, ten, one, mode1, mode2, seqH, seqL, now2, now1;  // 测试输入信号
    wire [3:0] out6, out5, out4, out3, out2;  // 测试输出信号

    // 实例化被测试模块
    page uut (
        .CLK(CLK),
        .EN(EN),
        .SET(SET),
        .EN_work(EN_work),
        .EN_set(EN_set),
        .print1(print1),
        .max2(max2),
        .max1(max1),
        .ten(ten),
        .one(one),
        .mode1(mode1),
        .mode2(mode2),
        .seqH(seqH),
        .seqL(seqL),
        .now2(now2),
        .now1(now1),
        .out6(out6),
        .out5(out5),
        .out4(out4),
        .out3(out3),
        .out2(out2)
    );

    // 时钟信号产生，每 5 个时间单位翻转一次
    always #5 CLK = ~CLK;

    initial begin
        // 初始化信号
        CLK = 0;
        EN = 0;
        SET = 0;
        EN_work = 0;
        EN_set = 0;
        print1 = 0;
        max2 = 4'd9;  // 预设的最大值十位
        max1 = 4'd5;  // 预设的最大值个位
        ten = 4'd2;   // 当前值的十位
        one = 4'd1;   // 当前值的个位
        mode1 = 4'd7; // 模式1的值
        mode2 = 4'd3; // 模式2的值
        seqH = 4'd4;  // 序列的高位
        seqL = 4'd6;  // 序列的低位
        now2 = 4'd8;  // 当前值的高位
        now1 = 4'd0;  // 当前值的低位

        // 使用 $monitor 实时监控信号变化
        $monitor("Time=%0t | CLK=%b | EN=%b | SET=%b | EN_work=%b | EN_set=%b | print1=%b | out6=%b | out5=%b | out4=%b | out3=%b | out2=%b",
                 $time, CLK, EN, SET, EN_work, EN_set, print1, out6, out5, out4, out3, out2);

        // 仿真步骤，依次改变不同控制信号的状态
        #20 EN = 1;  // 切换到模式2
        #20 print1 = 1;  // 切换到第2页显示
        #20 SET = 1;  // 进入设置模式
        #20 EN_work = 1; EN_set = 0;  // 启动工作模式，但保持设置未使能

        #100;
        $stop;  // 停止仿真
    end

endmodule
