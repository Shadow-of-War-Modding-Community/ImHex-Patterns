#pragma description Shadow of War ARCH06 File
#pragma MIME sow/arch06

struct File {
    u32 nameOffset;
    u64 dataOffset;
    u64 dataSize;
    u64 uncompressedSize;
    u8  flag1; // Is compressed?
    u8  flag2; // Compression level?
    
    char name[] @ addressof(parent.stringTable[nameOffset]);
    char data[dataSize] @ dataOffset;
} [[name(name)]];

struct Folder {
    u32 nameOffset;
    s32 nextSubFolderIndex;
    s32 nextFolderIndex;
    u32 subFileCount;
    
    char name[] @ addressof(parent.stringTable[nameOffset]);
} [[name(name)]];

struct Header {
    char magic[4]; // LTAR
    u32  version;
    u32  stringTableSize;
    u32  folderCount;
    u32  fileCount;
    u32  unk4;
    u32  unk5;
    u32  unk6;
    char padding1[16];
};

struct Section {
    char   stringTable[header.stringTableSize];
    File   files[header.fileCount];
    Folder folders[header.folderCount];
};

Header  header  @ 0x0;
Section section @ $;