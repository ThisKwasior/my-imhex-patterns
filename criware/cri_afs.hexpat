#pragma author Kwasior/@ThisKwasior
#pragma description CRI-Middleware/CRIWARE file archive (Dreamcast/PS2/Xbox/GC/PC)
#pragma endian little
#pragma magic [41 46 53 00] @ 0x0
#pragma loop_limit 65537

/*
    Like AFS2 (AWB), file is in little endian.
    Sections are aligned to 2048 bytes by default.
*/

/*
    AFS file can have both null entries AND somehow 65534 files
    with last one being null entry.
    It can also have more files in the header than files in metadata.
    It can also not have the metadata section.
    Couldn't reproduce this fuckery with afslnk and AfsLink.
*/

import std.io;
import std.mem;

#define AFS_HEADER_SIZE             (8)
#define AFS_ENTRY_SIZE              (8)
#define AFS_METADATA_ENTRY_SIZE     (48)
#define AFS_BLOCK_SIZE_DEFAULT      (2048)
#define AFS_BLOCK_SIZE_CD           (AFS_BLOCK_SIZE_DEFAULT)
#define AFS_FIRST_OFFSET_BIG        (524288)
#define AFS_MAX_FILES               (65536)

/*
    STRUCTURES
*/
struct AFS_ENTRY
{
    u32 test = std::mem::read_unsigned($, 4);

    /* Null entry. Discard. */
    if(test == 0)
    {
        $ += AFS_ENTRY_SIZE;
        continue;
    }
    
    u32 offset;
    u32 size;
    //u8 data[size] @ offset;
};

struct METADATA_ENTRY
{
    u32 offset;
    u32 size;
};

struct AFS_ENTRY_METADATA
{
    char name[32];
    u16 year;
    u16 month;
    u16 day;
    u16 hour;
    u16 minute;
    u16 second;
    u32 file_size;      /* But not always */
};

struct AFS_HEADER
{
    u8 magic[4];        /* AFS\0 */
    u32 file_count;     /* But not always */
};

struct AFS_FILE
{
    AFS_HEADER header;
    
    u32 first_file_idx = afs_find_first_file_index();
    u32 file_count = afs_count_possible_files(first_file_idx);
    u32 metadata_index = afs_find_metadata_index(first_file_idx, file_count);
    
    if(metadata_index)
    {
        METADATA_ENTRY metadata_entry @ afs_id_to_entry_offset(metadata_index);
        
        if(metadata_entry.offset && metadata_entry.size)
        {
            file_count = file_count - 1;
            AFS_ENTRY_METADATA metadata[file_count] @ metadata_entry.offset;
        }
    }
    
    AFS_ENTRY entries[while($ != afs_id_to_entry_offset(metadata_index))] @ afs_id_to_entry_offset(first_file_idx);
};

/*
    FUNCTIONS
*/

/*
    First file does not need to have index 0.
*/
fn afs_find_first_file_index()
{
    for(u32 i = 0, i != AFS_MAX_FILES, i += 1)
    {
        u32 cur_offset_offset = AFS_HEADER_SIZE + (i*AFS_ENTRY_SIZE);
        u32 cur_offset @ cur_offset_offset;
        u32 cur_size @ cur_offset_offset+4;
        
        if(cur_offset != 0)
        {
            //std::print("[{}] Found entry {},{} at {}", i, cur_offset, cur_size, cur_offset_offset);
            return i;
        }
    }
    
    //std::print("Can't find the first file index. File is probably corrupted.");
    return -1;
};

/*
    
*/
fn afs_find_metadata_index(u32 first_file_id, u32 file_count)
{
    AFS_ENTRY first_entry @ afs_id_to_entry_offset(first_file_id);
    u32 feo = first_entry.offset-AFS_HEADER_SIZE;
    u32 max_index = ((feo-(feo%8))/8)-1;
    
    if(max_index > AFS_MAX_FILES)
    {
        max_index = AFS_MAX_FILES-1;
    }
    
    for(u32 i = max_index, i != first_file_id, i -= 1)
    {
        METADATA_ENTRY cur_entry @ afs_id_to_entry_offset(i);
        
        if(cur_entry.offset)
        {
            u32 meta_count = cur_entry.size/AFS_METADATA_ENTRY_SIZE;
            AFS_ENTRY_METADATA first_meta @ cur_entry.offset;

            if(meta_count == (file_count-1))
            {
                //std::print("Meta {} {} {}", i, first_meta.file_size, first_entry.size);
                return i;
            }
            else /* No metadata section */
            {
                return i+1;
            }
        }
    }
    
    /* No metadata section */
    return 1;
};

/*
    Will count files that aren't null from the first ID
    to its file offset or until AFS_MAX_FILES is reached.
*/
fn afs_count_possible_files(u32 first_file_id)
{
    u32 file_it = 0;
    AFS_ENTRY first_entry @ afs_id_to_entry_offset(first_file_id); 
    
    for(u32 i = first_file_id, i != AFS_MAX_FILES, i+=1)
    {
        u32 entry_offset = afs_id_to_entry_offset(i);
        
        if(entry_offset >= first_entry.offset)
        {
            //std::print("Reached the first file while iterating");
            break;
        }

        AFS_ENTRY cur_entry @ entry_offset;

        if(cur_entry.offset)
        {
            file_it += 1;
            //std::print("[{}][{}] Entry valid {},{}", i, file_it, cur_entry.offset, cur_entry.size);
        }
    }
    
    return file_it;
};

fn afs_id_to_entry_offset(u32 id)
{
    return AFS_HEADER_SIZE+(id*AFS_ENTRY_SIZE);
};


AFS_FILE afs @ 0x0;