//ȫ������
module all_slice (
    input wire CLK,
    input wire isWork,
    input wire [3:0] bot_seq_L,   // ��װ��ҩƿ���ĸ�λ
    input wire [3:0] bot_seq_H,   // ��װ��ҩƿ����ʮλ
    input wire [3:0] bot_maxL,    // ҩƿ�����ĸ�λ
    input wire [3:0] bot_maxH,    // ҩƿ������ʮλ
    output reg allFull            // ȫ���ź�
);

    always @(posedge CLK) begin
        if (isWork) begin
            if (bot_seq_L == bot_maxL && bot_seq_H == bot_maxH) begin
                // �����װ��ҩƿ������ҩƿ���������ȫ���ź�
                allFull <= 1;
            end else begin
                // ����ȫ���ź���Ч
                allFull <= 0;
            end
        end else begin
            // ������ǹ���״̬������ȫ���ź���Ч
            allFull <= 0;
        end
    end

endmodule
