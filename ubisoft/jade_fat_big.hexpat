/*
    FAT files but not the same ones as in bf files.
    
    I'm basing this implementation on soundxe*.fat
    from Naruto rise of a ninja.
    
    Metadata file to *.big file with the same name. 
*/

import std.mem;

struct FAT_ENTRY
{
    u32 key;
    u32 file_offset;
    u32 file_size;
    u32 unk_4;
    u32 name_size;
    char name[name_size];
};

FAT_ENTRY entries[while(!std::mem::eof())] @ 0x0;