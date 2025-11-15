#pragma endian big

/*
    WIP
    
    https://github.com/kohos/CriTools/blob/master/src/hca.js#L180

    CRC-16/UMTS
*/

struct HCA_SECTION_FMT
{
    u8 channel_count;
    u24 sample_rate;
    u32 block_count;
    u16 mute_header;
    u16 mute_footer;
};

struct HCA_SECTION_COMP
{
    u16 block_size;
    u8 r[8];
    u8 reserved[2];
};

struct HCA_SECTION_DEC
{
    u8 count1;
    u8 count2;
    u8 reserved[2];
    u8 enable_count2;
};

struct HCA_SECTION_VBR
{
    u16 vbr[2];
};

struct HCA_SECTION_ATH
{
    u32 type;
};

struct HCA_SECTION_LOOP
{
    u32 start;
    u32 end;
    u16 count;
    u16 reserved;
};

struct HCA_SECTION_CIPH
{
    u16 type; /* 0, 1 and 56 */
};

struct HCA_SECTION_RVA
{
    float volume;
};

struct HCA_SECTION_COMM
{
    u8 length;
    char comment[length];
};

struct HCA_SECTION
{
    char name[4];
    
    
    if(name == "fmt\0")             HCA_SECTION_FMT fmt;
    if(name == "\xe6\xed\xf4\0")    HCA_SECTION_FMT fmt;
    if(name == "comp")              HCA_SECTION_COMP comp;
    if(name == "\xe3\xef\xed\xf0")  HCA_SECTION_COMP comp;
    if(name == "dec\0")             HCA_SECTION_DEC dec;
    if(name == "vbr\0")             HCA_SECTION_VBR vbr;
    if(name == "ath\0")             HCA_SECTION_ATH ath;
    if(name == "loop")              HCA_SECTION_LOOP loop;
    if(name == "ciph")              HCA_SECTION_CIPH ciph;
    if(name == "\xe3\xe9\xf0\xe8")  HCA_SECTION_CIPH ciph;
    if(name == "rva\0")             HCA_SECTION_RVA rva;
    if(name == "comm")              HCA_SECTION_COMM comm;
};

struct HCA_FILE
{
    u8 magic[4];
    u16 version;
    u16 data_offset;

    HCA_SECTION sections[9];
};

HCA_FILE hca @ 0x0;