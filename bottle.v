module Bottle (
    input wire CLK_org,                   // ԭʼʱ�������ź�
    input wire CLK_Music,                 // ����ʱ�������ź�
    
    input wire isWork,                    // ����״̬�ź�
    input wire EN_work,                   // ����ʹ���ź�
    input wire EN_set,                    // ����ʹ���ź�
    input wire SET,                       // �����ź�
    input wire conti,                     // ���������ź�
    input wire PrintB,                    // ��ӡʹ���ź�
    input wire mode_EN,                   // ģʽʹ���ź�
    
    output wire light6_D, light6_C, light6_B, light6_A,  // ��6��ƹ�������
    output wire light5_D, light5_C, light5_B, light5_A,  // ��5��ƹ�������
    output wire light4_D, light4_C, light4_B, light4_A,  // ��4��ƹ�������
    output wire light3_D, light3_C, light3_B, light3_A,  // ��3��ƹ�������
    output wire light2_D, light2_C, light2_B, light2_A,  // ��2��ƹ�������
    output wire light1_a, light1_b, light1_c, light1_d, light1_e, light1_f, light1_g, // ��1��ƹ����������߶���ʾ����
    
    input wire set_low_D, set_low_C, set_low_B, set_low_A, // ���õ�λ��������
    input wire set_high_D, set_high_C, set_high_B, set_high_A, // ���ø�λ��������

	output wire Speaker
);

// �ڲ��ź�����
wire CLK;                         // ���ɵ�ʱ���ź�
wire maxA, maxB, botA, botB;      // ���ֵ�͵ײ�״̬�ź�

// ���������ź���ϳ�4λ�ź�
wire [3:0] Cinl = {set_low_D, set_low_C, set_low_B, set_low_A}; // ��λ��������ź�
wire [3:0] Cinh = {set_high_D, set_high_C, set_high_B, set_high_A}; // ��λ��������ź�

// �ڲ��ź����ڼ�����״̬
wire [3:0] Maxl, Maxh;            // ���ֵ�ĵ�λ�͸�λ
wire [3:0] bot_low, bot_high;     // ��ǰƿ�������ĵ�λ�͸�λ
wire [3:0] bot_max2, bot_max1;    // ���ƿ�������ĵ�λ�͸�λ
wire [3:0] bot_seq_L, bot_seq_H;  // ���кŵ�λ�͸�λ

wire allFull;                     // ȫ��ƿ�������ź�
wire [3:0] mode_light1, mode_light2; // ģʽ�ƹ���ʾ�ź�
wire [3:0] light6, light5, light4, light3, light2; // ����ƹ�����ź�


// ���ʵ����
make_fre u1 (.CLK(CLK_org), .CLK_out(CLK)); // Ƶ��������
Decoder_2to4 u2 (.inB(SET), .inA(SET), .outD(botA), .outC(botB), .outB(maxA), .outA(maxB)); // ������

set_MAX u3 (.CLK(CLK), .EN_work(EN_work), .EN_set(EN_set), .set(maxA & maxB), .setL(Cinl), .setH(Cinh), .maxL(bot_max1), .maxH(bot_max2)); // ���ֵ����
set_MAX u4 (.CLK(CLK), .EN_work(EN_work), .EN_set(EN_set), .set(botA & botB), .setL(Cinl), .setH(Cinh), .maxL(Maxl), .maxH(Maxh)); // ��һ�����ֵ����

MOD_MAX u5 (.CLK(CLK), .isWork(isWork), .conti(conti), .allFull(allFull), .EN_work(EN_work), .EN_set(EN_set), .set(SET), .maxL(Maxl), .maxH(Maxh), .outL(bot_low), .outH(bot_high)); // ����ǰ���������ֵ
full u6 (.CLK(CLK), .EN_work(EN_work), .EN_set(EN_set), .set(SET), .isWork(isWork), .maxL(Maxl), .maxH(Maxh), .nowL(bot_low), .nowH(bot_high), .seqL(bot_seq_L), .seqH(bot_seq_H)); // ���ƿ���Ƿ�����
all_slice u7 (.CLK(CLK), .isWork(isWork), .bot_seq_L(bot_seq_L), .bot_seq_H(bot_seq_H), .bot_maxL(bot_max1), .bot_maxH(bot_max2), .allFull(allFull)); // �������ƿ���Ƿ�����

light_1 u8 (.CLK(CLK), .EN_work(EN_work), .EN_set(EN_set), .SET(SET), .allFull(allFull), .light(mode_light1), .light2(mode_light2)); // �ƹ����
BCD_7 u9 (.EN(PrintB), .a(light1_a), .b(light1_b), .c(light1_c), .d(light1_d), .e(light1_e), .f(light1_f), .g(light1_g)); // �߶���ʾ����

page u11 (.CLK(CLK_org), .EN(mode_EN), .SET(SET), .EN_work(EN_work), .EN_set(EN_set), .print1(PrintB), .max2(Maxh), .max1(Maxl), .ten(bot_max2), .one(bot_max1), .mode1(mode_light1), .mode2(mode_light2), .seqH(bot_seq_H), .seqL(bot_seq_L), .now2(bot_high), .now1(bot_low), .out6(light6), .out5(light5), .out4(light4), .out3(light3), .out2(light2)); // ҳ����ʾ����

Music u12 (.CLK(CLK_org), .CLK_1(CLK_Music), .allFull(allFull), .Music(Speaker));

// ����ƹ��ź�ӳ��
assign light6_D = light6[3]; assign light6_C = light6[2]; assign light6_B = light6[1]; assign light6_A = light6[0];
assign light5_D = light5[3]; assign light5_C = light5[2]; assign light5_B = light5[1]; assign light5_A = light5[0];
assign light4_D = light4[3]; assign light4_C = light4[2]; assign light4_B = light4[1]; assign light4_A = light4[0];
assign light3_D = light3[3]; assign light3_C = light3[2]; assign light3_B = light3[1]; assign light3_A = light3[0];
assign light2_D = light2[3]; assign light2_C = light2[2]; assign light2_B = light2[1]; assign light2_A = light2[0];

endmodule
