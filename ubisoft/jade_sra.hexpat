enum FSRA_RES_TYPE : u32
{
    CLIP = 1
};

struct FSRA_HEADER
{
    char magic[4];
    u32 version;
    u32 unk_offset1;
    u32 unk_offset1_count;
    u32 unk_offset2;
    u32 unk_offset2_count;
};

struct FSRA_CLIP_NAME
{
    char name[72];
};

struct FSRA_CLIP
{
    char magic[4];
    u32 unk1;
    u32 cfx_size;
    u32 tex_count;
    FSRA_CLIP_NAME tex_names[tex_count];
    char cfx_data[cfx_size]; // zlib DEFLATE
};

struct UNK_SECTION_1
{
    u32 type;
    u32 key;
    u32 unk3;
    u32 data_offset;
    u32 data_size;
    u32 unk6;
    u32 unk7;

    if(type == FSRA_RES_TYPE::CLIP)
    {
        FSRA_CLIP clip @ data_offset;
    }
    else
    {
        // zlib DEFLATE
        char data[data_size] @ data_offset;
    }
};

struct UNK_SECTION_2
{
    u32 type;
    
    if(type == 0)
    {
        u32 unk2;
        u32 unk3;
        u32 unk4;
    }
    
    if(type == 1)
    {
        u32 unk2;
        u32 key;
        char name[128];
    }
};


struct SRA_FILE
{
    FSRA_HEADER header;
    UNK_SECTION_1 unk_section_1[header.unk_offset1_count] @ header.unk_offset1;
    UNK_SECTION_2 unk_section_2[header.unk_offset2_count] @ header.unk_offset2;
};

SRA_FILE sra @ 0;