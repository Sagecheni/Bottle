module Bottle (
    input wire CLK_org,                   // ԭʼʱ���ź� 1Hz
    input wire CLK_Music,                 // ����ʱ���ź� 100kHz

    input wire isWork,                    // �����ܿ���
    input wire EN_work,                   // ����ģʽʹ���ź�
    input wire EN_set,                    // ����ģʽʹ���ź�
    input wire SET,                       // ����ģʽѡ���źţ�����ƿ��������ƿ��������
    input wire conti,                     // ����������أ��ߵ�ƽ��ʾ�������
    input wire PrintB,                    // ��ӡģʽʹ���źţ�����ѡ���������ʾ����
    input wire mode_EN,                   // ģʽʹ���źţ�����ѡ��ƹ���ʾģʽ

    output wire light6_D, light6_C, light6_B, light6_A,  // �ƹ����������6λ�����
    output wire light5_D, light5_C, light5_B, light5_A,  // �ƹ����������5λ�����
    output wire light4_D, light4_C, light4_B, light4_A,  // �ƹ����������4λ�����
    output wire light3_D, light3_C, light3_B, light3_A,  // �ƹ����������3λ�����
    output wire light2_D, light2_C, light2_B, light2_A,  // �ƹ����������2λ�����
    output wire light1_a, light1_b, light1_c, light1_d, light1_e, light1_f, light1_g, // ����ܵƹ���������Ƶ��������

    input wire set_low_D, set_low_C, set_low_B, set_low_A, // ���õ�λ������λ�����������ź�
    input wire set_high_D, set_high_C, set_high_B, set_high_A, // ���ø�λ����ʮλ�����������ź�

    output wire Speaker                      // ����������ź�
);

// �ڲ��źŶ���
wire CLK;                         // ��Ƶ���ʱ���źţ�����ģ���ڲ�ʱ��
wire [3:0] Cinl = {set_low_D, set_low_C, set_low_B, set_low_A}; // ��ǰ���õĵ�λ������
wire [3:0] Cinh = {set_high_D, set_high_C, set_high_B, set_high_A}; // ��ǰ���õĸ�λ������

wire [3:0] Maxl, Maxh;            // ���õĵ���ƿ������
wire [3:0] bot_low, bot_high;     // ��ǰƿ���е�ҩƬ����
wire [3:0] bot_max2, bot_max1;    // ���õ�ƿ������
wire [3:0] bot_seq_L, bot_seq_H;  // ��ǰ��װ����ƿ������

wire allFull;                     // ȫ���źţ�������ƿ�Ӷ�װ��ʱ�ø�
wire [3:0] mode_light1, mode_light2; // ģʽѡ��ƹ����
wire [3:0] light6, light5, light4, light3, light2; // ������ܵĵƹ����

// ģ��ʵ����
// ����ƿ������
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

// ���õ���ƿ�ӵ�����
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

// ������ƿ�ӹ����߼�
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

// ���Ƶƹ���ʾģʽ
light_1 u4 (
    .CLK(CLK_org), 
    .EN_work(EN_work), 
    .EN_set(EN_set), 
    .SET(SET), 
    .allFull(allFull), 
    .light(mode_light1)
);

// �������ʾ����
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

// ��ʾҳ��Ŀ���
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

// ���ֲ���ģ�飬��ƿ��ȫ��ʱ������������
Music u7 (
    .CLK(CLK_org), 
    .CLK_1(CLK_Music), 
    .allFull(allFull), 
    .Music(Speaker)
);

// �������
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
