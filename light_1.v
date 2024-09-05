//��������4λ�ź� light �� light2 ��ģ�顣���������ʹ���źź������źţ�����������źŵ�ֵ���ڲ�ͬ������±�����

module light_1 (
    input wire CLK,                    // ʱ���ź�
    input wire EN_work,                // ����״̬ʹ���ź�
    input wire EN_set,                 // ����״̬ʹ���ź�
    input wire SET,                    // �����ź�
    input wire allFull,                // ��״̬�ź�
    output reg [3:0] light             // 4λ�ƹ�������
);

always @(posedge CLK) begin
    if (EN_work == 1'b1 && EN_set == 1'b1) begin    //���������ģʽ��light��light2��Ϊ0
        light <= 4'b0000;
    end else if (EN_work == 1'b0 && EN_set == 1'b0 && SET == 1'b0) begin
        light <= 4'b0001;
    end else if (EN_work == 1'b0 && EN_set == 1'b0 && SET == 1'b1) begin
        light <= 4'b0010;
    end else if (EN_work == 1'b0 && EN_set == 1'b1) begin
        light <= 4'b0011;
    end else if (EN_work == 1'b1 && EN_set == 1'b0) begin
        if (SET == 1'b0) begin
            light <= 4'b0100;
        end else if (SET == 1'b1) begin
            light <= 4'b0101;
        end
    end
end

endmodule
