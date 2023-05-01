module MarioROM_right (
    input logic [7:0] Address,
    output logic [23:0] CharacterRGB
);

    // Replace the following data with the 16x16 character's RGB values
    logic [23:0] ROM_Data [255:0] = '{
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'h00, 8'h00, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'h80, 8'h47, 8'h16},
{8'h80, 8'h47, 8'h16},
{8'h80, 8'h47, 8'h16},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'h00, 8'h00, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFC, 8'hA9, 8'h5D},
{8'h80, 8'h47, 8'h16},
{8'hFC, 8'hA9, 8'h5D},
{8'h80, 8'h47, 8'h16},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hA5, 8'h49, 8'h1F},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFD, 8'hAB, 8'h5E},
{8'h01, 8'h01, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFE, 8'hAB, 8'h5F},
{8'h80, 8'h47, 8'h16},
{8'hFF, 8'hAD, 8'h60},
{8'h80, 8'h47, 8'h16},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'h00, 8'h00, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'h80, 8'h47, 8'h16},
{8'h80, 8'h47, 8'h16},
{8'hFF, 8'hAD, 8'h60},
{8'h80, 8'h47, 8'h16},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'h80, 8'h47, 8'h16},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFE, 8'h07, 8'h03},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'h3F, 8'h51, 8'hB5},
{8'hFB, 8'h01, 8'h02},
{8'hFB, 8'h01, 8'h02},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFE, 8'h07, 8'h03},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'h00, 8'h00},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'hEB, 8'h3A},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'hEB, 8'h3A},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'h00, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'h3E, 8'h50, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3E, 8'h50, 8'hB5},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hAD, 8'h60},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hCD, 8'h72},
{8'hFF, 8'hCD, 8'h72},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h49, 8'h5F, 8'hD4},
{8'h49, 8'h5F, 8'hD4},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'hCD, 8'h72},
{8'hFF, 8'hCD, 8'h72},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'h3F, 8'h51, 8'hB4},
{8'h3F, 8'h51, 8'hB4},
{8'h3F, 8'h51, 8'hB5},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'h3F, 8'h51, 8'hB5},
{8'h3F, 8'h51, 8'hB4},
{8'h3F, 8'h51, 8'hB4},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00},
{8'hFF, 8'hD7, 8'h00}
};

    assign CharacterRGB = ROM_Data[Address];

endmodule
