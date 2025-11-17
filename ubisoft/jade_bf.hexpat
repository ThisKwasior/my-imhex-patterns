import std.io;

#pragma array_limit                 0xFFFFFFFE
#pragma pattern_limit               0xFFFFFFFE

#define FAT_INVALID_INDEX           (0xFFFFFFFF)

#define BIG_HEADER_SIZE             44
#define FAT_HEADER_SIZE             24

u32 g_bf_version = 0;

struct BIG_HEADER 
{
    char magic[4];
    u32 version;
    u32 file_count;
    u32 dir_count;
    u32 max_key;
    u32 root_index;
    u32 first_file;
    u32 first_dir;
    u32 fat_entries;
    u32 fat_count;
    u32 key;
};

struct FAT_HEADER
{
    u32 file_count;
    u32 dir_count;
    u32 data_pos;
    u32 next_fat_pos;   /* minus sizeof(FAT_HEADER) */
    u32 first_index;
    u32 last_index;    
};

struct FAT_FILE_DESC
{
    u32 pos;
    u32 key;
    
    u32 data_size @ pos;
};

struct FAT_FILE_DESC_EDITOR
{
    u32 size_on_disk;
    u32 prev_index;
    u32 next_index;
    u32 parent_index;
    u32 time;
    char name[64];
    u32 p4_rev_client;
    
    if(g_bf_version == 42) /* naruto.bf | Naruto: Rise of a Ninja */
    {
        char p4_owner_name[36];
    }
};

struct FAT_DIR_DESC_EDITOR
{
    u32 first_file;
    u32 first_sub_dir;
    u32 prev_index;
    u32 next_index;
    u32 parent_index;
    char name[64];
};

struct FAT_FILE
{
    FAT_HEADER header;
    u32 idx_count = header.last_index - header.first_index;

    FAT_FILE_DESC files[idx_count+1] @ header.data_pos;
    FAT_FILE_DESC_EDITOR files_editor[idx_count+1] @ header.data_pos + sizeof(files);
    FAT_DIR_DESC_EDITOR dirs_editor[header.dir_count] @ header.data_pos + sizeof(files) + sizeof(files_editor);
    
    if(header.next_fat_pos != FAT_INVALID_INDEX)
    {
        FAT_FILE next_fat @ (header.next_fat_pos - FAT_HEADER_SIZE);
    }
};

struct BIG_FILE
{
    BIG_HEADER header;
    g_bf_version = header.version;
    FAT_FILE fat;
};

BIG_FILE big_file @ 0x0;