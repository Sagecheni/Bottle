module bottle (
    input wire CLK_org,                   // 原始时钟输入信号
    input wire CLK_Music,                 // 音乐时钟输入信号
    
    input wire isWork,                    // 工作状态信号
    input wire EN_work,                   // 工作使能信号
    input wire EN_set,                    // 设置使能信号
    input wire SET,                       // 设置信号
    input wire conti,                     // 连续操作信号
    input wire PrintB,                    // 打印使能信号
    input wire mode_EN,                   // 模式使能信号
    
    output wire light6_D, light6_C, light6_B, light6_A,  // 第6组灯光控制输出
    output wire light5_D, light5_C, light5_B, light5_A,  // 第5组灯光控制输出
    output wire light4_D, light4_C, light4_B, light4_A,  // 第4组灯光控制输出
    output wire light3_D, light3_C, light3_B, light3_A,  // 第3组灯光控制输出
    output wire light2_D, light2_C, light2_B, light2_A,  // 第2组灯光控制输出
    output wire light1_a, light1_b, light1_c, light1_d, light1_e, light1_f, light1_g, // 第1组灯光控制输出（七段显示器）
    
    input wire set_low_D, set_low_C, set_low_B, set_low_A, // 设置低位数据输入
    input wire set_high_D, set_high_C, set_high_B, set_high_A, // 设置高位数据输入
    
    output wire Speaker                      // 扬声器输出信号
);

// 内部信号声明
wire CLK;                         // 生成的时钟信号
wire maxA, maxB, botA, botB;      // 最大值和底部状态信号

// 设置输入信号组合成4位信号
wire [3:0] Cinl = {set_low_D, set_low_C, set_low_B, set_low_A}; // 低位输入组合信号
wire [3:0] Cinh = {set_high_D, set_high_C, set_high_B, set_high_A}; // 高位输入组合信号

// 内部信号用于计数和状态
wire [3:0] Maxl, Maxh;            // 最大值的低位和高位
wire [3:0] bot_low, bot_high;     // 当前瓶子数量的低位和高位
wire [3:0] bot_max2, bot_max1;    // 最大瓶子数量的低位和高位
wire [3:0] bot_seq_L, bot_seq_H;  // 序列号低位和高位

wire allFull;                     // 全部瓶子已满信号
wire [3:0] mode_light1, mode_light2; // 模式灯光显示信号
wire [3:0] light6, light5, light4, light3, light2; // 各组灯光控制信号

// 音乐生成时钟信号
wire CLK_2, CLK_3, CLK_4, CLK_5, CLK_6, CLK_7, CLK_8, Mi; // 不同频率的时钟信号

// 组件实例化
make_fre u1 (.CLK(CLK_org), .CLK_out(CLK)); // 频率生成器
Decoder_2to4 u2 (.inB(SET), .inA(SET), .outD(botA), .outC(botB), .outB(maxA), .outA(maxB)); // 解码器

set_MAX u3 (.CLK(CLK), .EN_work(EN_work), .EN_set(EN_set), .set(maxA & maxB), .setL(Cinl), .setH(Cinh), .maxL(bot_max1), .maxH(bot_max2)); // 最大值设置
set_MAX u4 (.CLK(CLK), .EN_work(EN_work), .EN_set(EN_set), .set(botA & botB), .setL(Cinl), .setH(Cinh), .maxL(Maxl), .maxH(Maxh)); // 另一组最大值设置

MOD_MAX u5 (.CLK(CLK), .isWork(isWork), .conti(conti), .allFull(allFull), .EN_work(EN_work), .EN_set(EN_set), .set(SET), .maxL(Maxl), .maxH(Maxh), .outL(bot_low), .outH(bot_high)); // 管理当前数量与最大值
full u6 (.CLK(CLK), .EN_work(EN_work), .EN_set(EN_set), .set(SET), .isWork(isWork), .maxL(Maxl), .maxH(Maxh), .nowL(bot_low), .nowH(bot_high), .seqL(bot_seq_L), .seqH(bot_seq_H)); // 检查瓶子是否已满
all_slice u7 (.CLK(CLK), .isWork(isWork), .bot_seq_L(bot_seq_L), .bot_seq_H(bot_seq_H), .bot_maxL(bot_max1), .bot_maxH(bot_max2), .allFull(allFull)); // 检查所有瓶子是否已满

light_1 u8 (.CLK(CLK), .EN_work(EN_work), .EN_set(EN_set), .SET(SET), .allFull(allFull), .light(mode_light1), .light2(mode_light2)); // 灯光控制
BCD_7 u9 (.EN(PrintB), .a(light1_a), .b(light1_b), .c(light1_c), .d(light1_d), .e(light1_e), .f(light1_f), .g(light1_g)); // 七段显示控制

page u11 (.CLK(CLK_org), .EN(mode_EN), .SET(SET), .EN_work(EN_work), .EN_set(EN_set), .print1(PrintB), .max2(Maxh), .max1(Maxl), .ten(bot_max2), .one(bot_max1), .mode1(mode_light1), .mode2(mode_light2), .seqH(bot_seq_H), .seqL(bot_seq_L), .now2(bot_high), .now1(bot_low), .out6(light6), .out5(light5), .out4(light4), .out3(light3), .out2(light2)); // 页面显示控制

// 生成多个频率的时钟信号，用于音乐生成
make_fre u12 (.CLK(CLK_Music), .CLK_out(CLK_2));
make_fre u13 (.CLK(CLK_2), .CLK_out(CLK_3));
make_fre u14 (.CLK(CLK_3), .CLK_out(CLK_4));
make_fre u15 (.CLK(CLK_4), .CLK_out(CLK_5));
make_fre u16 (.CLK(CLK_5), .CLK_out(CLK_6));
make_fre u17 (.CLK(CLK_6), .CLK_out(CLK_7));
make_fre u19 (.CLK(CLK_7), .CLK_out(CLK_8));
make_fre u20 (.CLK(CLK_8), .CLK_out(Mi));

Music u30 (.CLK(CLK_org), .CLK_1(Mi), .allFull(allFull), .Music(Speaker)); // 音乐生成

// 输出灯光信号映射
assign light6_D = light6[3]; assign light6_C = light6[2]; assign light6_B = light6[1]; assign light6_A = light6[0];
assign light5_D = light5[3]; assign light5_C = light5[2]; assign light5_B = light5[1]; assign light5_A = light5[0];
assign light4_D = light4[3]; assign light4_C = light4[2]; assign light4_B = light4[1]; assign light4_A = light4[0];
assign light3_D = light3[3]; assign light3_C = light3[2]; assign light3_B = light3[1]; assign light3_A = light3[0];
assign light2_D = light2[3]; assign light2_C = light2[2]; assign light2_B = light2[1]; assign light2_A = light2[0];

endmodule
