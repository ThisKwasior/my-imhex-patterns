#pragma endian little

struct AWB_HEADER
{
    u8 magic[4];
    u8 version;
    u8 offset_size;
    u8 id_size;
    u8 unk;
    u32 file_count;
    u16 alignment;
    u16 subkey;
};

struct AWB_ID
{
    if(parent.header.id_size == 2)
        u16 id;
    if(parent.header.id_size == 4)
        u32 id;
};

struct AWB_OFFSET
{
    if(parent.header.offset_size == 2)
        u16 offset;
    if(parent.header.offset_size == 4)
        u32 offset;
};

struct AWB_FILE
{
    AWB_HEADER header;
    AWB_ID ids[header.file_count];
    AWB_OFFSET offsets[header.file_count];
    u32 file_size;
};

AWB_FILE awb @ 0x0;