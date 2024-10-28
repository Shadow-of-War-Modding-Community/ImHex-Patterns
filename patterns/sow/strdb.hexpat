#pragma description Shadow of War STRDB File
#pragma array_limit 100000
#pragma pattern_limit 900000

struct String16 {
    char16 string[];
} [[inline]];

struct HashMap {
    u32 hash;
    u32 stringOffset;
};

struct Header {
    char magic[4];
    u32  version;
    u32  hashMapOffset;
    u32  hashMapCount;
    char padding1[4];
    u32  stringTableSize;
    char padding2[4];
};

struct Section1 {
    HashMap  hashMap[header.hashMapCount];
    //char16 stringTable[header.stringTableSize];
    String16 strings[59969];
};

Header   header   @ 0x00;
Section1 section1 @ header.hashMapOffset;