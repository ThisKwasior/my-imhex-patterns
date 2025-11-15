#pragma endian big

#include <std/string.pat>

/* Column data types */
#define UTF_COLUMN_TYPE_UINT8           0x0
#define UTF_COLUMN_TYPE_SINT8           0x1
#define UTF_COLUMN_TYPE_UINT16          0x2
#define UTF_COLUMN_TYPE_SINT16          0x3
#define UTF_COLUMN_TYPE_UINT32          0x4
#define UTF_COLUMN_TYPE_SINT32          0x5
#define UTF_COLUMN_TYPE_UINT64          0x6
#define UTF_COLUMN_TYPE_SINT64          0x7
#define UTF_COLUMN_TYPE_FLOAT           0x8
#define UTF_COLUMN_TYPE_DOUBLE          0x9
#define UTF_COLUMN_TYPE_STRING          0xa
#define UTF_COLUMN_TYPE_VLDATA          0xb
#define UTF_COLUMN_TYPE_UINT128         0xc    /* for GUIDs */
#define UTF_COLUMN_TYPE_UNDEFINED       0xf

enum UTF_TYPE : u8
{
    UINT8 = UTF_COLUMN_TYPE_UINT8,
    SINT8 = UTF_COLUMN_TYPE_SINT8,
    UINT16 = UTF_COLUMN_TYPE_UINT16,
    SINT16 = UTF_COLUMN_TYPE_SINT16,
    UINT32 = UTF_COLUMN_TYPE_UINT32,
    SINT32 = UTF_COLUMN_TYPE_SINT32,
    UINT64 = UTF_COLUMN_TYPE_UINT64,
    SINT64 = UTF_COLUMN_TYPE_SINT64,
    FLOAT = UTF_COLUMN_TYPE_FLOAT,
    DOUBLE = UTF_COLUMN_TYPE_DOUBLE,
    STRING = UTF_COLUMN_TYPE_STRING,
    VLDATA = UTF_COLUMN_TYPE_VLDATA,
    UINT128 = UTF_COLUMN_TYPE_UINT128,
    UNDEFINED = UTF_COLUMN_TYPE_UNDEFINED,
};

struct UTF_HEADER
{
    char id[4];
    u32 table_size;
};

bitfield UTF_SCHEMA_DESC
{
    padding : 1;        /* shouldn't exist */
    row: 1;             /* data is found relative to row start */
    default : 1;        /* data is found relative to schema start (const value for all rows) */
    name : 1;           /* column has name (may be empty) */
    UTF_TYPE type: 4;   /* data type for default */
};

struct UTF_SCHEMA_ENTRY
{
    UTF_SCHEMA_DESC desc;
    
    if(desc.name)
    {
        u32 name_offset;
        char name[] @ parent.string_table_offset+8+name_offset;
    }
    
    if(desc.default)
    {
        if(desc.type == UTF_COLUMN_TYPE_UINT8) u8 data;
        if(desc.type == UTF_COLUMN_TYPE_SINT8) s8 data;
        if(desc.type == UTF_COLUMN_TYPE_UINT16) u16 data;
        if(desc.type == UTF_COLUMN_TYPE_SINT16) s16 data;
        if(desc.type == UTF_COLUMN_TYPE_UINT32) u32 data;
        if(desc.type == UTF_COLUMN_TYPE_SINT32) s32 data;
        if(desc.type == UTF_COLUMN_TYPE_UINT64) u64 data;
        if(desc.type == UTF_COLUMN_TYPE_SINT64) s64 data;
        if(desc.type == UTF_COLUMN_TYPE_FLOAT) float data;
        if(desc.type == UTF_COLUMN_TYPE_DOUBLE) double data;
        if(desc.type == UTF_COLUMN_TYPE_UINT128) u128 data;
        
        if(desc.type == UTF_COLUMN_TYPE_STRING)
        {
            u32 str_offset;
            //char string[] @ parent.parent.string_table_offset+8+str_offset;
        }
        
        if(desc.type == UTF_COLUMN_TYPE_VLDATA) 
        {
            u32 data_offset;
            u32 data_size;
        }
    }
    
    if(desc.row)
    {
        if(desc.type == UTF_COLUMN_TYPE_UINT8) {u8 data @ parent.rows_offset+gsi; gsi+=1;}
        if(desc.type == UTF_COLUMN_TYPE_SINT8) {s8 data @ parent.rows_offset+gsi; gsi+=1;}
        if(desc.type == UTF_COLUMN_TYPE_UINT16) {u16 data @ parent.rows_offset+gsi; gsi+=2;}
        if(desc.type == UTF_COLUMN_TYPE_SINT16) {s16 data @ parent.rows_offset+gsi; gsi+=2;}
        if(desc.type == UTF_COLUMN_TYPE_UINT32) {u32 data @ parent.rows_offset+gsi; gsi+=4;}
        if(desc.type == UTF_COLUMN_TYPE_SINT32) {s32 data @ parent.rows_offset+gsi; gsi+=4;}
        if(desc.type == UTF_COLUMN_TYPE_UINT64) {u64 data @ parent.rows_offset+gsi; gsi+=8;}
        if(desc.type == UTF_COLUMN_TYPE_SINT64) {s64 data @ parent.rows_offset+gsi; gsi+=8;}
        if(desc.type == UTF_COLUMN_TYPE_FLOAT) {float data @ parent.rows_offset+gsi; gsi+=4;}
        if(desc.type == UTF_COLUMN_TYPE_DOUBLE) {double data @ parent.rows_offset+gsi; gsi+=8;}
        if(desc.type == UTF_COLUMN_TYPE_UINT128) {u128 data @ parent.rows_offset+gsi; gsi+=16;}
        
        if(desc.type == UTF_COLUMN_TYPE_STRING)
        {
            u32 str_offset  @ parent.rows_offset+gsi;
            gsi+=4;
            char string[] @ parent.string_table_offset+8+str_offset;
        }
        
        if(desc.type == UTF_COLUMN_TYPE_VLDATA) 
        {
            u32 data_offset  @ parent.rows_offset+gsi;
            u32 data_size  @ parent.rows_offset+gsi+4;
            gsi+=8;
            u8 data[data_size] @ 8+parent.data_offset+data_offset;
        }
    }
};

struct UTF_ROW
{
    char row[parent.rows_width];
    
};

struct UTF_TABLE
{
    u16 version;
    u16 rows_offset;
    u32 string_table_offset;
    u32 data_offset;
    u32 name_offset;    /* In string table */
    u16 columns_count;
    u16 rows_width;
    u32 rows_count;
    
    char table_name[] @ string_table_offset+8+name_offset;
    
    UTF_SCHEMA_ENTRY schema[columns_count];
    UTF_ROW rows[rows_count] @ parent.m_pos+8+rows_offset;
    //char string_table[data_offset - string_table_offset] @ 8+string_table_offset;
    //char data_table[parent.header.table_size - data_offset] @ 8+data_offset;
};

u32 gsi = 8;

struct UTF_FILE
{
    u32 m_pos = $;
    UTF_HEADER header;
    UTF_TABLE table;
};

UTF_FILE utf @ 0x0;