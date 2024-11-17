#pragma description Shadow of War STRDB File
#pragma MIME sow/strdb

#pragma array_limit 100000
#pragma pattern_limit 900000

struct String16 {
    char16 string[];
} [[inline]];

struct StringIndex {
    u32 hash;
    u32 offset;
} [[static]];

struct Header {
    char magic[4];
    u32  version;
    u32  stringIndicesOffset;
    u32  stringIndicesCount;
    char padding1[4];
    u32  stringTableSize;
    char padding2[4];
};

struct Section1 {
    StringIndex  stringIndices[header.stringIndicesCount];
    //char16 stringTable[header.stringTableSize];
    String16 strings[59969];
};

Header   header   @ 0x00;
Section1 section1 @ header.stringIndicesOffset;