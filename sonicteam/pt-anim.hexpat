#pragma endian big

#include <mirage>

struct PT_ANIM_METADATA
{
    u32 material_name_offset;
    u32 texture_name_offset;
    u32 anim_count;
    u32 anim_offsets[anim_count];
};

struct PT_ANIM_ENTRY
{
    
};

struct PT_ANIM_FILE
{
    MIRAGE_HEADER header;
    MIRAGE_INFO info;
    PT_ANIM_METADATA metadata @ (header.data_offset + info.metadata_offset);
};

PT_ANIM_FILE pt_anim @ 0x0;