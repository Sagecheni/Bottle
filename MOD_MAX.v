module MOD_MAX (
    input wire CLK,           // ʱ���ź�
    input wire isWork,        // ����״̬�źţ��ߵ�ƽ��ʾ���ڹ���
    input wire conti,         // �Ƿ���������źţ��ߵ�ƽ��ʾ����
    input wire EN_work,       // ����ģʽ�ź�
    input wire EN_set,        // ����ģʽ�ź�
    input wire set,           // �����źţ��ߵ�ƽ��ʾ��������
    input wire [3:0] maxL,    // ҩƿ�����ĸ�λ����
    input wire [3:0] maxH,    // ҩƿ������ʮλ����
    input wire [3:0] nowL,    // ��ǰҩƬ�����ĸ�λ
    input wire [3:0] nowH,    // ��ǰҩƬ������ʮλ
    input wire [3:0] bot_maxL,    // ҩƿ�����ĸ�λ����
    input wire [3:0] bot_maxH,    // ҩƿ������ʮλ����

    output reg [3:0] outL,    // �����ǰҩƬ�����ĸ�λ����
    output reg [3:0] outH,    // �����ǰҩƬ������ʮλ����
    output reg [3:0] seqL,    // �����ǰ��װ��ҩƿ�����ĸ�λ����
    output reg [3:0] seqH,    // �����ǰ��װ��ҩƿ������ʮλ����
    output reg allFull        // ȫ���ź�
);

    reg [3:0] ones, tens;     // ones: ��ǰҩƬ�����ĸ�λ����, tens: ��ǰҩƬ������ʮλ����
    reg [3:0] start_seq_L, start_seq_H; // ҩƿװ���ļ���

    initial begin
        ones = 4'b0000;
        tens = 4'b0000;
        start_seq_L = 4'b0000;
        start_seq_H = 4'b0000;
        allFull = 0;
    end

    always @(posedge CLK) begin
        if (EN_work && EN_set && !set) begin
            // ��λ������
            ones <= 4'b0000;
            tens <= 4'b0000;
            start_seq_L <= 4'b0000;
            start_seq_H <= 4'b0000;
            allFull <= 0;
        end else if (isWork && !allFull) begin
            if (start_seq_L == bot_maxL  && start_seq_H == bot_maxH && ones==0 && tens==0) begin
                // ����Ѿ�װ������ƿ�ӣ�����ȫ���ź�
                allFull <= 1'b1;
            end else if (ones == maxL - 1 && tens == maxH) begin
                    // ��������ƿ�Ӽ���
                    ones <= 4'b0000;
                    tens <= 4'b0000;
                    if (start_seq_L == 4'b1001) begin
                        start_seq_L <= 4'b0000;
                        start_seq_H <= start_seq_H + 1;
                    end else begin
                        start_seq_L <= start_seq_L + 1;
                    end
            end else if (!EN_work && !EN_set) begin
                // �����λ���ﵽ9����λ����λ��ʮλ����1
                if (ones == 4'b1001) begin
                    ones <= 4'b0000;
                    tens <= tens + 1;
                end else begin
                    // ����ҩƬ����
                    ones <= ones + 1;
                end
            end
        end else if (!isWork) begin
            // ���ֹͣ��������λȫ���ź�
            allFull <= 1'b0;
        end else if (conti) begin
            // ��� conti �źŸߵ�ƽ����δ��ƿ����������
            ones <= ones + 1;
        end

        // ����ǰ�������
        outL <= ones;
        outH <= tens;

        // ��ҩƿװ���������
        seqL <= start_seq_L;
        seqH <= start_seq_H;
    end

endmodule
