#pragma description Shadow of War GAMEDB File
#pragma MIME sow/gamedb

#pragma pattern_limit 5000000
#pragma array_limit 5000000


// Functions

fn relative_to_stringtable(u128 offset) {
    return addressof(stringTable.data);
};


// Types

struct String {
    char string[];
} [[inline]];

struct StringPtr {
    String *stringPtr : u32 [[pointer_base("relative_to_stringtable")]];
} [[inline]];


// Data Structures

struct Header {
    char magic[4]; // GADB
    u32  version;
    u32  stringTableSize;
    u32  recordCount;
    u32  unk2;
    u32  unk3;
    u32  unk4;
    u32  unknownBlockCount;
    u32  unk6;
    u32  unk7;
    u32  stringTableOffset;
};

struct StringTable {
    u16  stringSize;
    char string[stringSize];
    char data[header.stringTableSize];
};

struct UnknownBlock {
    u32     unknown1;
    u32     unknown2;
    u8      unknown3;
    u8      unknown4;
    u8      unknown5;
    u16     unknown6;
    u16     unknown7;
} [[static]];

struct UnknownChunk1 {
    UnknownBlock unknownBlocks[header.unknownBlockCount];
};

struct UnknownBlock2 {
    s32 unknown1;
    u16 unknown2;
    u16 unknown3;
    padding[4];
    StringPtr stringPtr;
    u32 *hash :u32 [[pointer_base("relative_to_stringtable")]];
};

struct UnknownChunk2 {
    padding[4];
    u32 recordCount;
    StringPtr stringPtrs[5];
    UnknownBlock2 unknownBlocks2[12];
};

struct UnknownSection {
    UnknownChunk1 unknownChunk1;
    UnknownChunk2 unknownChunk2;
    //char unknownChunk2[2848] @ 0xE4B9C4;
    char unknownChunk3[1404] @ 0xE4C4E4;
    char unknownChunk4[7408] @ 0xE4CA60;
    char unknownChunk5[1268] @ 0xE4E750;
    char unknownChunk6[15304] @ 0xE4EC44;
    char unknownChunk7[3986] @ 0xE5280C;
    char unknownChunk8[1352] @ 0xE5379E;
    char unknownChunk9[10766] @ 0xE53CE6;
    char unknownChunk10[3612] @ 0xE566F4;
};

Header header @ 0x00;
StringTable stringTable @ header.stringTableOffset;
UnknownSection unknownSection @ $;