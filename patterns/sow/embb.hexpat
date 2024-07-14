#pragma description Shadow of War EMBB File
#pragma MIME sow/embb

import std.core;

struct ResourceFile {
    u32 filePathOffset @ addressof(parent.filePathArrayOffset[std::core::array_index()]);
    char filePath[] @ addressof(parent) + filePathOffset;
    u32 fileSize;
    u8 fileData[fileSize];
} [[name(filePath)]];

struct Header {
    char magic[4];
    u32 version;
    u32 filePathArraySize;
    u32 resourceFileCount;
};

struct ResourceSection {
    char filePathArray[header.filePathArraySize] [[hidden]];
    u32 filePathArrayOffset[header.resourceFileCount] [[hidden]];
    ResourceFile resourcesFiles[header.resourceFileCount];
};

Header header @ 0x00;
ResourceSection resourceSection @ $;