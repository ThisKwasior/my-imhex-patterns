/*
    Decompressed data from SRA
*/

enum GPUTEXTUREFORMAT : u8
{
    FMT_1_REVERSE = 0,
    FMT_1 = 1,
    FMT_8 = 2,
    FMT_1_5_5_5 = 3,
    FMT_5_6_5 = 4,
    FMT_6_5_5 = 5,
    FMT_8_8_8_8 = 6,
    FMT_2_10_10_10 = 7,
    FMT_8_A = 8,
    FMT_8_B = 9,
    FMT_8_8 = 10,
    FMT_Cr_Y1_Cb_Y0_REP = 11,
    FMT_Y1_Cr_Y0_Cb_REP = 12,
    FMT_16_16_EDRAM = 13, // EDRAM render target only
    FMT_8_8_8_8_A = 14,
    FMT_4_4_4_4 = 15,
    FMT_10_11_11 = 16,
    FMT_11_11_10 = 17,
    FMT_DXT1 = 18,
    FMT_DXT2_3 = 19,
    FMT_DXT4_5 = 20,
    FMT_16_16_16_16_EDRAM = 21, // EDRAM render target only
    FMT_24_8 = 22,
    FMT_24_8_FLOAT = 23,
    FMT_16 = 24,
    FMT_16_16 = 25,
    FMT_16_16_16_16 = 26,
    FMT_16_EXPAND = 27,
    FMT_16_16_EXPAND = 28,
    FMT_16_16_16_16_EXPAND = 29,
    FMT_16_FLOAT = 30,
    FMT_16_16_FLOAT = 31,
    FMT_16_16_16_16_FLOAT = 32,
    FMT_32 = 33,
    FMT_32_32 = 34,
    FMT_32_32_32_32 = 35,
    FMT_32_FLOAT = 36,
    FMT_32_32_FLOAT = 37,
    FMT_32_32_32_32_FLOAT = 38,
    FMT_32_AS_8 = 39,
    FMT_32_AS_8_8 = 40,
    FMT_16_MPEG = 41,
    FMT_16_16_MPEG = 42,
    FMT_8_INTERLACED = 43,
    FMT_32_AS_8_INTERLACED = 44,
    FMT_32_AS_8_8_INTERLACED = 45,
    FMT_16_INTERLACED = 46,
    FMT_16_MPEG_INTERLACED = 47,
    FMT_16_16_MPEG_INTERLACED = 48,
    FMT_DXN = 49,
    FMT_8_8_8_8_AS_16_16_16_16 = 50,
    FMT_DXT1_AS_16_16_16_16 = 51,
    FMT_DXT2_3_AS_16_16_16_16 = 52,
    FMT_DXT4_5_AS_16_16_16_16 = 53,
    FMT_2_10_10_10_AS_16_16_16_16 = 54,
    FMT_10_11_11_AS_16_16_16_16 = 55,
    FMT_11_11_10_AS_16_16_16_16 = 56,
    FMT_32_32_32_FLOAT = 57,
    FMT_DXT3A = 58,
    FMT_DXT5A = 59,
    FMT_CTX1 = 60,
    FMT_DXT3A_AS_1_1_1_1 = 61,
    FMT_8_8_8_8_GAMMA_EDRAM = 62, // EDRAM render target only
    FMT_2_10_10_10_FLOAT_EDRAM = 63, // EDRAM render target only
};

enum GPUENDIAN : u8
{
    ED_NONE = 0,
    ED_8IN16 = 1,
    ED_8IN32 = 2,
    ED_16IN32 = 3
};

enum GPUNUMFORMAT : u8
{
    FRACTION = 0,
    INTEGER = 1
};

bitfield D3DFORMAT
{
    GPUTEXTUREFORMAT texture_fmt : 6;
    GPUENDIAN endian : 2;
    tiled : 1;
    signx : 2;
    signy : 2;
    signz : 2;
    signw : 2;
    GPUNUMFORMAT numfmt : 1;
    swizzlex : 3;
    swizzley : 3;
    swizzlez : 3;
    swizzlew : 3;
};

struct XE_TEXTURE
{
    char magic[4];
    u32 texture_type;
    u32 width;
    u32 height;
    D3DFORMAT format;
    u32 mipmaps;
    u32 tail_level;
    u32 data_size;
};

XE_TEXTURE tex @ 0;