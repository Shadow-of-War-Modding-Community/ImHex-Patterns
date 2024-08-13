#pragma description Shadow of War SCRIPTS File
#pragma MIME sow/scripts

struct Header {
    char magic[4];
    u32  version;
    u8   stringCount;
    u32  scriptSize;
};

struct Script {
    char code[header.scriptSize];
};

Header header @ 0x0;
Script script @ sizeof(header);