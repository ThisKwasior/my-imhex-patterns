#pragma endian big

struct LIT_ANIM_HEADER
{
    u32 metadata_offset;
    u32 metadata_size;
    u32 keyframes_offset;
    u32 keyframes_size;
    u32 string_table_offset;
    u32 string_table_size;
};

struct LIT_ANIM_METADATA
{
    u32 anim_count;
    u32 anim_offsets[anim_count];  /* array of uint32_t */
};

struct KEYFRAME
{
    float index;
    float value;
};

struct KEYFRAME_SET
{
    u8 type;
    u8 flag2;
    u8 interpolation;
    u8 flag4;
    u32 frames_length;
    u32 frames_start;
};

struct LIT_ANIM_ENTRY
{
    u32 name_offset;
    u32 type;
    float frame_rate;
    float start_frame;
    float end_frame;
    u32 keyframe_set_count;
    float unk_00;
    float unk_01;
    float unk_02;
    float unk_03;
    
    float color_red;        // 04
    float color_green;      // 05
    float color_blue;       // 06
    float unk_07;
    
    float unk_08;
    float unk_09;
    float unk_0A;
    float unk_0B;
    
    float unk_0C;
    float unk_0D;
    float unk_0E;
    float intensity;        // 0F
    
    float unk_10;
    float unk_11;
    float unk_12;
    float unk_13;
    
    float unk_14;
    float unk_15;
    float unk_16;
    float unk_17;
    
    float unk_18;
    float unk_19;
    float unk_1A;
    float unk_1B;
    
    KEYFRAME_SET sets[keyframe_set_count];
};

LIT_ANIM_HEADER header @ 0x18;
LIT_ANIM_METADATA meta @ header.metadata_offset + 0x18;
LIT_ANIM_ENTRY entry @ meta.anim_offsets[0] + 0x18;
KEYFRAME keyframes[header.keyframes_size/8] @ header.keyframes_offset + 0x18;