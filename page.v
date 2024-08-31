module page (
    input wire CLK,            // ʱ���ź�
    input wire EN,             // ��ʾģʽ�����źţ�EN = 0 ʱ�������ʾģʽ��EN = 1 ʱ��ͨ����ʾģʽ
    input wire SET,            // ����ģʽ�źţ����ڿ�����ʾ����������ģʽ�µ���˸
    input wire EN_work,        // ����ģʽʹ���ź�
    input wire EN_set,         // ����ģʽʹ���ź�
    input wire print1,         // ҳ��ʾ�����źţ�print1 = 0 ʱ��ʾ��1ҳ��print1 = 1 ʱ��ʾ��2ҳ
    input wire [3:0] max2,     // ����ƿ��������С�ĸ�λ
    input wire [3:0] max1,     // ����ƿ��������С�ĵ�λ
    input wire [3:0] ten,      // ƿ����Ŀ���ֵ��λ
    input wire [3:0] one,      // ƿ����Ŀ���ֵ��λ
    input wire [3:0] mode1,    // ģʽ1�µ���ʾֵ
    input wire [3:0] mode2,    // ģʽ2�µ���ʾֵ
    input wire [3:0] seqH,     // װ����ƿ����Ŀ�ĸ�λ
    input wire [3:0] seqL,     // װ����ƿ����Ŀ�ĸ�λ
    input wire [3:0] now2,     // ��ǰƿ���е�ҩƬ��Ŀ�ĸ�λ
    input wire [3:0] now1,     // ��ǰƿ���е�ҩƬ��Ŀ�ĵ�λ
    output reg [3:0] out6,     // �����/��ͨ�Ƶ����6
    output reg [3:0] out5,     // �����/��ͨ�Ƶ����5
    output reg [3:0] out4,     // �����/��ͨ�Ƶ����4
    output reg [3:0] out3,     // �����/��ͨ�Ƶ����3
    output reg [3:0] out2      // �����/��ͨ�Ƶ����2
);

    // �����ڲ��Ĵ����������ݴ����ֵ
    reg [3:0] Y6, Y5, Y4, Y3, Y2;

    // ����ʱ���źŵ������أ�������ʾ����
    always @(CLK) begin
        // ���� EN �ź�ѡ�������ģʽ/��ͨ��ģʽ
        if (EN == 1'b0) begin
            Y6 <= mode1;  // �����ģʽ
        end else begin
            Y6 <= mode2;  // ��ͨ��ģʽ
        end

        // ���� print1 �ź�ѡ����ʾ��1ҳ���ǵ�2ҳ
        if (print1 == 1'b0) begin
            // ��1ҳ��ʾ�߼�
            if (EN_work == 1'b1 && EN_set == 1'b0 && CLK == 1'b0) begin
                // ������ģʽ�µ���˸����
                if (SET == 1'b0) begin  //����ҩƿ����
                    Y5 <= ten;Y4 <= one;Y3 <= 4'b1111;Y2 <= 4'b1111;
                end else begin
                    Y5 <= 4'b1111;Y4 <= 4'b1111;Y3 <= max2;Y2 <= max1;
                end
            end else begin
            // ������ʾ״̬
            Y5 <= ten;
            Y4 <= one;
            Y3 <= max2;
            Y2 <= max1;
            end
        end else if (print1 == 1'b1) begin
        // ��2ҳ��ʾ�߼�
        Y5 <= seqH;
        Y4 <= seqL;
        Y3 <= now2;
        Y2 <= now1;
        end
    end
    // ��������ļĴ���ֵ���������˿�
    always @* begin
        out6 <= Y6;
        out5 <= Y5;
        out4 <= Y4;
        out3 <= Y3;
        out2 <= Y2;
    end

endmodule
