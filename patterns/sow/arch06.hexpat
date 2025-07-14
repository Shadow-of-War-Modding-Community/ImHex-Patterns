#pragma description Shadow of War ARCH06 File
#pragma MIME sow/arch06

fn align_chunk_size(u64 chunkSize) {
    return (chunkSize + 3) & ~3; // Align to 4-byte boundary
};

fn get_padding_size(u64 chunkSize) {
    return align_chunk_size(chunkSize) - chunkSize;
};

struct ChunkHeader {
    u32 chunkSize;
    u32 uncompressedSize;
};

struct Chunk {
    ChunkHeader header;
    u8 data[header.chunkSize];
    u8 padding1[get_padding_size(header.chunkSize)];
};

struct File {
    u32 nameOffset;
    u64 dataOffset;
    u64 dataSize;
    u64 uncompressedSize;
    u8  flag1; // Is compressed?
    u8  flag2; // Compression level?
    
    char  name[] @ addressof(parent.stringTable[nameOffset]);
    Chunk chunks[while($ - dataOffset < dataSize)] @ dataOffset;
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
    u32  unk4; // Always 1?
    u32  unk5; // Reserved?
    u32  unk6; // Reserved?
    char padding1[16];
};

struct Section {
    char   stringTable[header.stringTableSize];
    File   files[header.fileCount];
    Folder folders[header.folderCount];
};

Header  header  @ 0x0;
Section section @ $;