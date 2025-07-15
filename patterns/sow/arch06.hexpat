#pragma description Shadow of War ARCH06 File
#pragma MIME sow/arch06

#pragma pattern_limit 999999

import type.guid;

fn align_chunk_size(u64 chunkSize) {
    return (chunkSize + 3) & ~3; // Align to 4-byte boundary
};

fn get_padding_size(u64 chunkSize) {
    return align_chunk_size(chunkSize) - chunkSize;
};

struct CompressedChunkHeader {
    u32 chunkSize;
    u32 uncompressedSize;
};

struct CompressedChunk {
    CompressedChunkHeader header;
    u8 data[header.chunkSize];
    u8 padding1[get_padding_size(header.chunkSize)];
};

struct File {
    u32  nameOffset;
    u64  dataOffset;
    u64  dataSize;
    u64  uncompressedSize;
    bool compression      [[comment("Determines if the archive is compressed or not.")]];
    u8   compressionLevel [[comment("Determines the compression level if compression is used. There are 9 levels of compression.")]];
    
    char  name[] @ addressof(parent.stringTable[nameOffset]);
    
    if (compression)
        CompressedChunk chunks[while($ - dataOffset < dataSize)] @ dataOffset;
    else
        u8 data[dataSize] @ dataOffset;
        
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
    u32  retail   [[comment("Determines if the archive is shipped with the game.")]];
    u32  download [[comment("Determines if the archive should be considered for automatic content download with some games.")]];
    u32  crc      [[comment("Determines if the archive contains a CRC value for the entire archive.")]];
    type::GUID guid;
};

struct Section {
    char   stringTable[header.stringTableSize];
    File   files[header.fileCount];
    Folder folders[header.folderCount];
};

Header  header  @ 0x0;
Section section @ $;