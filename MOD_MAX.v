module MOD_MAX (
    input wire CLK,           // ʱ���ź�
    input wire isWork,        // ����״̬�źţ��ߵ�ƽ��ʾ���ڹ���
    input wire conti,         // �Ƿ���������źţ��ߵ�ƽ��ʾ����
    input wire allFull,       // ȫ���źţ��ߵ�ƽ��ʾҩƿ����
    input wire EN_work,       // ����ģʽ�ź�
    input wire EN_set,        // ����ģʽ�ź�
    input wire set,           // �����źţ��ߵ�ƽ��ʾ��������
    input wire [3:0] maxL,    // ҩƿ�����ĸ�λ����
    input wire [3:0] maxH,    // ҩƿ������ʮλ����

    output reg [3:0] outL,    // �����ǰҩƬ�����ĸ�λ����
    output reg [3:0] outH     // �����ǰҩƬ������ʮλ����
);

    reg [3:0] ones, tens;     // ones: ��ǰ�����ĸ�λ����, tens: ��ǰ������ʮλ����

    always @(posedge CLK) begin
        if (EN_work && EN_set && !set) begin
            // ��λ������
            ones <= 4'b0000;
            tens <= 4'b0000;
        end else if (isWork && !allFull) begin
            // �ڹ���״̬�£���ȫ���ź�Ϊ��ʱ���м���
            if (!EN_work && !EN_set) begin
                if (ones == 4'b1001) begin
                    // �����λ���ﵽ9����λ����λ��ʮλ����1
                    ones <= 4'b0000;
                    tens <= tens + 1;
                end else if ((ones == maxL - 1 && tens == maxH) || (ones == 9 && maxL == 0 && tens == maxH - 1)) begin
                    // �ﵽ���ֵʱ����λ������
                    ones <= 4'b0000;
                    tens <= 4'b0000;
                end else begin
                    // ��������
                    ones <= ones + 1;
                end
            end
        end else if (conti) begin
            // ��� conti �źŸߵ�ƽ����������
            ones <= ones + 1;
        end
        // ����ǰ�������
        outL <= ones;
        outH <= tens;
    end
endmodule
