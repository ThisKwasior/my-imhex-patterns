#pragma author Kwasior/@ThisKwasior
#pragma description Hedgehog Engine *-anim related structures
#pragma endian big

struct MIRAGE_HEADER
{
    u32 file_size;
    u32 version;
    u32 data_size;
    u32 data_offset;
    u32 offset_table_offset;
    u32 file_start_offset;
};

struct MIRAGE_INFO
{
    u32 metadata_offset;
    u32 metadata_size;
    u32 keyframes_offset;
    u32 keyframes_size;
    u32 string_table_offset;
    u32 string_table_size;
    
    if(metadata_offset == 32) /* pt-anim */
    {
        u32 texture_table_offset;
        u32 texture_table_size;
    }
};

struct MIRAGE_KEYFRAME
{
    float index;
    float value;
};

struct MIRAGE_KEYFRAME_SET
{
    u8 type;
    u8 flag2;
    u8 interpolation;
    u8 flag4;
    u32 length;
    u32 start;
};

struct OFFSET_TABLE
{
    u32 count;
    u32 offsets[count];
};

MIRAGE_HEADER header @ 0x0;
MIRAGE_INFO info @ header.data_offset;
OFFSET_TABLE offsets @ header.offset_table_offset;