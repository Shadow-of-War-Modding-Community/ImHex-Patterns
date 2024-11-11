#pragma description Shadow of War GAMEDB File
#pragma MIME sow/gamedb

struct Header {
    char magic[4]; // GADB
    u32  version;
    u32  stringTableSize;
    u32  recordCount;
    u32  unk2;
    u32  unk3;
    u32  unk4;
    u32  unk5;
    u32  unk6;
    u32  unk7;
    u32  stringTableOffset;
};

struct StringTable {
    u16  stringSize;
    char string[stringSize];
    char data[header.stringTableSize];
};

Header      header      @ 0x00;
StringTable stringTable @ header.stringTableOffset;