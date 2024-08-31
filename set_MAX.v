
//����������
module set_MAX (
    input wire CLK,         // ʱ���ź�
    input wire EN_work,     // ����ʹ���ź�
    input wire EN_set,      // ����ʹ���ź�
    input wire set,         // �����ź�
    input wire [3:0] setL,  // ���õĸ�λ
    input wire [3:0] setH,  // ���õ�ʮλ
    output reg [3:0] maxL,  
    output reg [3:0] maxH
);

    always @(posedge CLK) begin
        if (EN_work && !EN_set && set) begin
            maxL <= (setL > 4'b1001) ? 4'b1001 : setL;
            maxH <= (setH > 4'b1001) ? 4'b1001 : setH;
        end
    end

endmodule
