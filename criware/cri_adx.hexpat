#pragma endian big
#pragma pattern_limit 99999999
#pragma array_limit 999999

/*
    https://github.com/Thealexbarney/VGAudio/blob/master/docs/010-editor-templates/adx.bt
*/

bitfield ADX_CHANNEL_BYTE_SAMPLE
{
    s1 : 4;
    s2 : 4;
};

bitfield ADX_FRAME_CHANNEL
{
    filter_num : 3;
    scale : 13;
    
    ADX_CHANNEL_BYTE_SAMPLE samples[parent.parent.header.frame_size-2];
};

struct ADX_FRAME_CHANNEL_FAST
{
    u16 filter_scale;
    u8 samples[parent.parent.header.frame_size-2];
};

struct ADX_FRAME
{
    ADX_FRAME_CHANNEL channel[parent.header.channel_count];
};

struct ADX_HISTORY
{
    s16 hist1;
    s16 hist2;
};

struct ADX_LOOP
{
    s16 loop_num;
    s16 loop_type;
    s32 loop_start_sample;
    s32 loop_start_byte;
    s32 loop_end_sample;
    s32 loop_end_byte;
};

struct ADX_HEADER
{
    u8 magic[2];
    u16 header_size;
    u8 encoding_type;
    u8 frame_size;
    u8 bit_depth;
    u8 channel_count;
    s32 sample_rate;
    s32 sample_count;
    s16 highpass_freq;
    u8 version;
    u8 revision;
    
    if(version == 4)
    {
        s32 pad;
        if(channel_count < 2) ADX_HISTORY hist[2];
        else ADX_HISTORY hist[channel_count];
    }
    
    s16 alignment_samples;
    s16 loop_count;
    ADX_LOOP loop[loop_count];
    
    char copyright[6] @ header_size-2;
};

struct ADX_FOOTER
{
    u8 magic[2];
    s16 padding_length;
    u8 pad[padding_length];
};

struct ADX_FILE
{
    ADX_HEADER header;
    
    s32 samples_per_frame = (header.frame_size-2)*2;
    s32 frame_count = header.sample_count/samples_per_frame;
    if(header.sample_count%samples_per_frame) frame_count = frame_count+1;
    ADX_FRAME frames[frame_count] @ header.header_size+4;
    
    ADX_FOOTER footer @ header.header_size+4+sizeof(frames);
};

ADX_FILE adx @ 0x0;