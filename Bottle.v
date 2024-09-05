module Bottle (
    input wire CLK_org,                   // 原始时钟信号 1Hz
    input wire CLK_Music,                 // 音乐时钟信号 100kHz

    input wire isWork,                    // 工作总开关
    input wire EN_work,                   // 工作模式使能信号
    input wire EN_set,                    // 设置模式使能信号
    input wire SET,                       // 设置模式选择信号（设置瓶子容量或瓶子数量）
    input wire conti,                     // 间隔计数开关，高电平表示间隔计数
    input wire PrintB,                    // 打印模式使能信号，用于选择数码管显示内容
    input wire mode_EN,                   // 模式使能信号，用于选择灯光显示模式

    output wire light6_D, light6_C, light6_B, light6_A,  // 灯光输出，控制6位数码管
    output wire light5_D, light5_C, light5_B, light5_A,  // 灯光输出，控制5位数码管
    output wire light4_D, light4_C, light4_B, light4_A,  // 灯光输出，控制4位数码管
    output wire light3_D, light3_C, light3_B, light3_A,  // 灯光输出，控制3位数码管
    output wire light2_D, light2_C, light2_B, light2_A,  // 灯光输出，控制2位数码管
    output wire light1_a, light1_b, light1_c, light1_d, light1_e, light1_f, light1_g, // 数码管灯光输出，控制单个数码管

    input wire set_low_D, set_low_C, set_low_B, set_low_A, // 设置低位数（个位数）的输入信号
    input wire set_high_D, set_high_C, set_high_B, set_high_A, // 设置高位数（十位数）的输入信号

    output wire Speaker                      // 扬声器输出信号
);

// 内部信号定义
wire CLK;                         // 分频后的时钟信号，用于模块内部时钟
wire [3:0] Cinl = {set_low_D, set_low_C, set_low_B, set_low_A}; // 当前设置的低位数输入
wire [3:0] Cinh = {set_high_D, set_high_C, set_high_B, set_high_A}; // 当前设置的高位数输入

wire [3:0] Maxl, Maxh;            // 设置的单个瓶子容量
wire [3:0] bot_low, bot_high;     // 当前瓶子中的药片数量
wire [3:0] bot_max2, bot_max1;    // 设置的瓶子数量
wire [3:0] bot_seq_L, bot_seq_H;  // 当前已装满的瓶子数量

wire allFull;                     // 全满信号，当所有瓶子都装满时置高
wire [3:0] mode_light1, mode_light2; // 模式选择灯光输出
wire [3:0] light6, light5, light4, light3, light2; // 各数码管的灯光输出

// 模块实例化
// 设置瓶子数量
set_MAX u1 (
    .CLK(CLK_org), 
    .EN_work(EN_work), 
    .EN_set(EN_set), 
    .set(SET && !PrintB), 
    .setL(Cinl), 
    .setH(Cinh), 
    .maxL(bot_max1), 
    .maxH(bot_max2)
); 

// 设置单个瓶子的容量
set_MAX u2 (
    .CLK(CLK_org), 
    .EN_work(EN_work), 
    .EN_set(EN_set), 
    .set(!SET && !PrintB), 
    .setL(Cinl), 
    .setH(Cinh), 
    .maxL(Maxl), 
    .maxH(Maxh)
);

// 计数和瓶子管理逻辑
MOD_MAX u3 (
    .CLK(CLK_org), 
    .isWork(isWork), 
    .conti(conti), 
    .EN_work(EN_work), 
    .EN_set(EN_set), 
    .set(SET), 
    .maxL(Maxl), 
    .maxH(Maxh),
    .nowL(bot_low), 
    .nowH(bot_high),
    .bot_maxL(bot_max1), 
    .bot_maxH(bot_max2), 
    .outL(bot_low), 
    .outH(bot_high),
    .seqL(bot_seq_L), 
    .seqH(bot_seq_H),
    .allFull(allFull)
);

// 控制灯光显示模式
light_1 u4 (
    .CLK(CLK_org), 
    .EN_work(EN_work), 
    .EN_set(EN_set), 
    .SET(SET), 
    .allFull(allFull), 
    .light(mode_light1)
);

// 数码管显示控制
BCD_7 u5 (
    .EN(PrintB), 
    .a(light1_a), 
    .b(light1_b), 
    .c(light1_c), 
    .d(light1_d), 
    .e(light1_e), 
    .f(light1_f), 
    .g(light1_g)
); 

// 显示页面的控制
page u6 (
    .CLK(CLK_org), 
    .SET(SET), 
    .EN_work(EN_work), 
    .EN_set(EN_set), 
    .print1(PrintB), 
    .max2(Maxh), 
    .max1(Maxl), 
    .ten(bot_max2), 
    .one(bot_max1), 
    .mode1(mode_light1), 
    .seqH(bot_seq_H), 
    .seqL(bot_seq_L), 
    .now2(bot_high), 
    .now1(bot_low), 
    .out6(light6), 
    .out5(light5), 
    .out4(light4), 
    .out3(light3), 
    .out2(light2)
); 

// 音乐播放模块，当瓶子全满时发出声音警报
Music u7 (
    .CLK(CLK_org), 
    .CLK_1(CLK_Music), 
    .allFull(allFull), 
    .Music(Speaker)
);

// 输出分配
assign light6_D = light6[3]; 
assign light6_C = light6[2]; 
assign light6_B = light6[1]; 
assign light6_A = light6[0];
assign light5_D = light5[3]; 
assign light5_C = light5[2]; 
assign light5_B = light5[1]; 
assign light5_A = light5[0];
assign light4_D = light4[3]; 
assign light4_C = light4[2]; 
assign light4_B = light4[1]; 
assign light4_A = light4[0];
assign light3_D = light3[3]; 
assign light3_C = light3[2]; 
assign light3_B = light3[1]; 
assign light3_A = light3[0];
assign light2_D = light2[3]; 
assign light2_C = light2[2]; 
assign light2_B = light2[1]; 
assign light2_A = light2[0];

endmodule
