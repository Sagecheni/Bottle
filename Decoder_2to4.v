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
            2'b00: {outD, outC, outB, outA} <= 4'b0011;
            2'b11: {outD, outC, outB, outA} <= 4'b1100;
            default: {outD, outC, outB, outA} <= 4'b1111;
        endcase
    end

endmodule
