#pragma description Shadow of War STRDB File
#pragma MIME sow/strdb

#pragma pattern_limit 1000000
#pragma array_limit 1000000

fn format_string(ref auto string) {
    return string.data;
};

fn format_stringindex(ref auto stringIndex) {
    return stringIndex.string;
};

struct String16 {
    char16 data[];
} [[sealed, format("format_string"), transform("format_string")]];

struct StringIndex {
    u32 hash;
    u32 offset;
    
    String16 string @ header.stringIndicesOffset + header.stringIndicesCount * sizeof(this) + offset * sizeof(char16) [[name("(string)")]];
} [[format("format_stringindex")]];

struct Header {
    char magic[4];
    u32  version;
    u32  stringIndicesOffset;
    u32  stringIndicesCount;
    char padding1[4];
    u32  stringTableSize;
    char padding2[4];
};

struct Section {
    StringIndex stringIndices[header.stringIndicesCount];
    char16      stringTable[header.stringTableSize];
};

Header   header  @ 0x00;
Section  section @ header.stringIndicesOffset;