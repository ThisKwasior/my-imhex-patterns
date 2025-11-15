import type.magic;

#define BIG_HEADER_SIZE             44
#define FAT_HEADER_SIZE             24
#define FAT_FILE_DESC_SIZE          8
#define FAT_FILE_DESC_EDITOR_SIZE   124
#define FAT_DIR_DESC_EDITOR_SIZE    84

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
    u32 next_fat_pos;
    u32 first_index;
    u32 last_index;
};

struct FAT_FILE_DESC
{
    u32 pos;
    u32 key;
    
    u32 data_size @ pos;
    //u8 data[data_size] @ pos+4;
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
    char p4_owner_name[32];
    u32 pad;
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

struct FAT_DATA
{
    u32 fatcnt = big_header.fat_count;
    u32 fatent = big_header.fat_entries;
    u32 start_offset = BIG_HEADER_SIZE + FAT_HEADER_SIZE*fatcnt;
    u32 files_offset = start_offset;
    u32 files_editor_offset = files_offset + FAT_FILE_DESC_SIZE*fatent;
    u32 dirs_editor_offset = files_editor_offset + FAT_FILE_DESC_EDITOR_SIZE*fatent;
    
    FAT_FILE_DESC file[big_header.file_count] @ files_offset;
    FAT_FILE_DESC_EDITOR file_editor[big_header.file_count] @ files_editor_offset;
    FAT_DIR_DESC_EDITOR dir_editor[big_header.dir_count] @ dirs_editor_offset;
};

BIG_HEADER big_header @ 0x0;
FAT_HEADER fat_header @ 0x2C; // [big_header.fat_count], but never seen BF with multiple FATs

FAT_DATA fat_data @ fat_header.data_pos;