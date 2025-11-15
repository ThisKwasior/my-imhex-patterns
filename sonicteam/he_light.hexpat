#pragma endian big

struct MIRAGE_HEADER
{
    u32 file_size;
    u32 version;
    u32 data_size;
    u32 data_offset;
    u32 offset_table_offset;
    u32 name_offset;
};

struct MIRAGE_OFFSET_TABLE
{
    u32 count;
    u32 offsets[count];
};

struct HE_LIGHT
{
    u32 type;

    if(type == 0)
    {
        float position_x;
        float position_y; /* Up */
        float position_z;
        float color_red;
        float color_green;
        float color_blue;
    }
    
    if(type == 1)
    {
        float unk_01;
        float unk_02;
        float unk_03;
        float color_red;
        float color_green;
        float color_blue;
        float unk_07;
        float unk_08;
        float unk_09;
        float unk_0A;
        float unk_0B;
        float unk_0C;
        float unk_0D;
        float unk_0E;
        float unk_0F;
        float unk_10;
    }
    
    if(type == 2)
    {
        float unk_12;
        float unk_13;
        float unk_14;
        float unk_15;
        float unk_16;
        float unk_17;
        float unk_18;
        float unk_1;
        float unk_2;
        float unk_3;
        float unk_4;
        float unk_5;
        float unk_6;
        float unk_7;
        float unk_8;
        float unk_9;
        float unk_10;
    }
};

MIRAGE_HEADER mirage @ 0x0;
HE_LIGHT light @ mirage.data_offset;
MIRAGE_OFFSET_TABLE offset_table @ mirage.offset_table_offset;