/*
    I assume sdb means Shader Data Base
    
    Based on xeshader.bin/xeshader.sdb from Naruto: Rise of a Ninja
*/

#pragma endian big

struct SDB_HEADER
{
    char magic[4];
    u32 version;
    u32 shader_count;
    u32 fat_entries;
    u32 shader_offset;
    u32 fat_offset;
};

struct SDB_SHADER_ENTRY
{
    if(parent.header.magic == "3BDS") /* Retail naruto roan and broken bond */
    {
        char file_name[64];
        u32 key;
        u32 data_size;
        u32 unk3;
        u32 index;
        char data[data_size];
    }
    
    if(parent.header.magic == "2BDS") /* From naruto aug16 prototype */
    {
        char file_name[64];
        u32 key;
        u32 data_size;
        u32 unk3;
        u32 unk4;
        u32 unk5;
        u32 unk6;
        char data[data_size];
    }
};

struct SDB_SHADER_FILE
{
    if(parent.header.version == 262145) /* Something something The Broken Bond demo */
    {
        u32 unk1;
        u32 unk2;
        u32 unk3;
        u32 unk4;
        u32 unk5;
        u32 unk6;
        u32 unk7;
        u32 unk8;
        u32 data_offset;
        u32 data_size;
        u32 unk9;
    }
    else
    {
        u32 type;
        u64 unk1;
        u32 unk2;
        u32 unk3;
        u32 unk4;
        u32 data_offset;
        u32 data_size;
    }
    
    char data[data_size] @ data_offset;
};

struct SDB_FILE
{
    SDB_HEADER header;
    SDB_SHADER_ENTRY entries[header.shader_count] @ header.shader_offset;
    SDB_SHADER_FILE files[header.fat_entries] @ header.fat_offset;
};

SDB_FILE sdb @ 0;