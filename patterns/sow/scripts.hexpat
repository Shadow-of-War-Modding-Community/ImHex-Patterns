struct Header{
    u32 magic;
    u32 version;
    u8 unknown;
    u32 scriptSize;
};

Header header @ 0x0;
char script[header.scriptSize] @ sizeof(header);