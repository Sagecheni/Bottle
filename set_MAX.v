module set_MAX (
    input wire CLK,
    input wire EN_work,
    input wire EN_set,
    input wire set,
    input wire [3:0] setL,
    input wire [3:0] setH,
    output reg [3:0] maxL,
    output reg [3:0] maxH
);

    always @(posedge CLK) begin
        if (EN_work && !EN_set && !set) begin
            maxL <= (setL > 4'b1001) ? 4'b1001 : setL;
            maxH <= (setH > 4'b1001) ? 4'b1001 : setH;
        end
    end

endmodule
