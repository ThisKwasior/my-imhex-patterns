#pragma description Platinum Games DAT Archive
#pragma endian little

import std.io;
import std.hash;

fn calc_bucket_size(u32 prehash_shift)
{
    return 1<<(31-prehash_shift);
};

struct DAT_HEADER
{
    char magic[4];
    u32 file_count;
    u32 positions_offset;
    u32 extensions_offset;
    u32 names_offset;
    u32 sizes_offset;
    u32 hashtable_offset;
    u32 unk_1c;
};

struct DAT_EXTENSION
{
    char ext[4];
};

struct DAT_HASHTABLE
{
    u32 prehash_shift;
    u32 bucket_offset;
    u32 hashes_offset;
    u32 indices_offset;
    u16 bucket[calc_bucket_size(prehash_shift)];
    u32 hashes[header.file_count];
    u16 positions[header.file_count];
};

DAT_HEADER header @ 0x0;
u32 positions[header.file_count] @ header.positions_offset;
DAT_EXTENSION extensions[header.file_count] @ header.extensions_offset;
u32 name_size @ header.names_offset;
u32 sizes[header.file_count] @ header.sizes_offset;
DAT_HASHTABLE hashtable @ header.hashtable_offset;