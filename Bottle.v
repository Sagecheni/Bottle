module Bottle (
    input wire CLK_org,                   // 时钟信号
    input wire CLK_Music,                 // 音乐时钟信号
    
    input wire isWork,                    // 
    input wire EN_work,                   // 
    input wire EN_set,                    // 
    input wire SET,                       // 
    input wire conti,                     // 间隔计数开关
    input wire PrintB,                    // 
    input wire mode_EN,                   // 
    
    output wire light6_D, light6_C, light6_B, light6_A,  // 
    output wire light5_D, light5_C, light5_B, light5_A,  // 
    output wire light4_D, light4_C, light4_B, light4_A,  // 
    output wire light3_D, light3_C, light3_B, light3_A,  // 
    output wire light2_D, light2_C, light2_B, light2_A,  // 
    output wire light1_a, light1_b, light1_c, light1_d, light1_e, light1_f, light1_g, // 
    
    input wire set_low_D, set_low_C, set_low_B, set_low_A, // 
    input wire set_high_D, set_high_C, set_high_B, set_high_A, // 

	output wire Speaker
);


wire CLK;                         // 
wire [3:0] Cinl = {set_low_D, set_low_C, set_low_B, set_low_A}; // 
wire [3:0] Cinh = {set_high_D, set_high_C, set_high_B, set_high_A}; // 

// 
wire [3:0] Maxl, Maxh;            // 单个瓶子容量大小
wire [3:0] bot_low, bot_high;     // 当前瓶子中的药片数目
wire [3:0] bot_max2, bot_max1;    // 瓶子数目大小
wire [3:0] bot_seq_L, bot_seq_H;  // 当前已经装满的瓶子数目

wire allFull;                     // 全满信号
wire [3:0] mode_light1, mode_light2; // 
wire [3:0] light6, light5, light4, light3, light2; 


set_MAX u1 (.CLK(CLK_org), .EN_work(EN_work), .EN_set(EN_set), .set(SET && !PrintB), .setL(Cinl), .setH(Cinh), .maxL(bot_max1), .maxH(bot_max2)); // 设置瓶子数目
set_MAX u2 (.CLK(CLK_org), .EN_work(EN_work), .EN_set(EN_set), .set(!SET && !PrintB), .setL(Cinl), .setH(Cinh), .maxL(Maxl), .maxH(Maxh)); // 设置单个瓶子的容量

MOD_MAX u3 (.CLK(CLK_org), .isWork(isWork), .conti(conti), .EN_work(EN_work), .EN_set(EN_set), .set(SET), .maxL(Maxl), .maxH(Maxh),.nowL(bot_low), .nowH(bot_high),.bot_maxL(bot_max1), .bot_maxH(bot_max2), .outL(bot_low), .outH(bot_high),.seqL(bot_seq_L), .seqH(bot_seq_H),.allFull(allFull)); // 
light_1 u4 (.CLK(CLK_org), .EN_work(EN_work), .EN_set(EN_set), .SET(SET), .allFull(allFull), .light(mode_light1), .light2(mode_light2)); // 
BCD_7 u5 (.EN(PrintB), .a(light1_a), .b(light1_b), .c(light1_c), .d(light1_d), .e(light1_e), .f(light1_f), .g(light1_g)); // 
page u6 (.CLK(CLK_org), .EN(mode_EN), .SET(SET), .EN_work(EN_work), .EN_set(EN_set), .print1(PrintB), .max2(Maxh), .max1(Maxl), .ten(bot_max2), .one(bot_max1), .mode1(mode_light1), .mode2(mode_light2), .seqH(bot_seq_H), .seqL(bot_seq_L), .now2(bot_high), .now1(bot_low), .out6(light6), .out5(light5), .out4(light4), .out3(light3), .out2(light2)); // 
Music u7 (.CLK(CLK_org), .CLK_1(CLK_Music), .allFull(allFull), .Music(Speaker));

// 
assign light6_D = light6[3]; assign light6_C = light6[2]; assign light6_B = light6[1]; assign light6_A = light6[0];
assign light5_D = light5[3]; assign light5_C = light5[2]; assign light5_B = light5[1]; assign light5_A = light5[0];
assign light4_D = light4[3]; assign light4_C = light4[2]; assign light4_B = light4[1]; assign light4_A = light4[0];
assign light3_D = light3[3]; assign light3_C = light3[2]; assign light3_B = light3[1]; assign light3_A = light3[0];
assign light2_D = light2[3]; assign light2_C = light2[2]; assign light2_B = light2[1]; assign light2_A = light2[0];

endmodule
