module Decoder_2to4 (
    input wire inB,
    input wire inA,
    output reg outD,
    output reg outC,
    output reg outB,
    output reg outA
);

    always @(*) begin
        case ({inB, inA})
            2'b00: {outD, outC, outB, outA} <= 4'b1110;
            2'b01: {outD, outC, outB, outA} <= 4'b1101;
            2'b10: {outD, outC, outB, outA} <= 4'b1011;
            2'b11: {outD, outC, outB, outA} <= 4'b0111;
            default: {outD, outC, outB, outA} <= 4'b1111;
        endcase
    end

endmodule
