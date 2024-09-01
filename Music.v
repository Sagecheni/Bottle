module Music (
    input wire CLK,        // ��ʱ���ź� (1 Hz)
    input wire CLK_1,      // ��Ƶʱ���ź� (100 kHz)
    input wire allFull,    // ȫ���ź�
    output reg Music       // ��������ź�
);

    reg [7:0] counter;      // 8λ������������������Ƶ�ź�
    reg enable_audio;       // ������Ƶ��ͣ�ı�־


    // ʹ�� 1 Hz �� CLK �źſ�����Ƶ����ͣ
    always @(posedge CLK) begin
        if (allFull) begin
            enable_audio <= ~enable_audio;  // ÿ�뷭תһ�Σ�������ͣ
        end else begin
            enable_audio <= 0;  // ��� allFull Ϊ�ͣ��ر���Ƶ
        end
    end

    // ʹ�ýϸ�Ƶ�ʵ� CLK_1 ������Ƶ�ź�
    always @(posedge CLK_1) begin
        if (allFull && enable_audio) begin
            counter <= counter + 1;
            if (counter >= 152) begin  // 100 kHz / 152 �� 657.89 Hz
                counter <= 0;
                Music <= ~Music;  // ��ת�������������
            end
        end else begin
            Music <= 0;
        end
    end

endmodule
