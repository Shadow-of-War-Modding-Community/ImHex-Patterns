#pragma description Shadow of War ARCH06 File

struct Header {
    char    magic[4]; // LTAR
    u32     version;
    u32     unk1;
    u32     unk2;
    u32     unk3;
    u32     unk4;
    u8      padding1[25];
};

Header header @ 0x0;