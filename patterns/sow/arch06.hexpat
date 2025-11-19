#pragma description Shadow of War ARCH06 File
#pragma MIME sow/arch06

#pragma pattern_limit 999999

import type.guid;
import std.string;

using String = std::string::NullString;

fn relative_to_stringtable(u128 offset) {
    return addressof(header) + sizeof(header);
};

fn align_chunk_size(u64 chunkSize) {
    return (chunkSize + 3) & ~3; // Align to 4-byte boundary
};

fn get_padding_size(u64 chunkSize) {
    return align_chunk_size(chunkSize) - chunkSize;
};

struct CompressedChunkHeader {
    u32 compressedSize   [[comment("Size of the data when compressed.")]];
    u32 uncompressedSize [[comment("Size of the data when uncompressed.")]];
};

struct CompressedChunk {
    CompressedChunkHeader header                           [[comment("Header containing information about this chunk.")]];
    char data[header.compressedSize]                       [[comment("Data contained in this chunk.")]];
    char padding1[get_padding_size(header.compressedSize)] [[comment("Padding to align the chunk to a 4-byte boundary.")]];
};

struct File {
    String* name : u32       [[comment("Pointer to the name of this file relative to the string table."), pointer_base("relative_to_stringtable")]];
    u64     dataOffset       [[comment("Offset to the data stored for this file.")]];
    u64     compressedSize   [[comment("Size of the file when compressed.")]];
    u64     uncompressedSize [[comment("Size of the file when uncompressed.")]];
    
    if (header.version <= 3) // Version 3 used in Shadow of Mordor and FEAR
    {
        u32 compressionLevel [[comment("Determines the compression level if compression is used. There are 9 levels of compression.")]];
    }
    else if (header.version >= 4) // Version 4 used in Shadow of War
    {
        bool isCompressed     [[comment("Determines if the archive is compressed or not.")]];
        u8   compressionLevel [[comment("Determines the compression level if compression is used. There are 9 levels of compression.")]];
    }
    
    if (compressedSize == uncompressedSize)
        char data[uncompressedSize] @ dataOffset [[comment("Uncompressed data for this file.")]];
    else
        CompressedChunk chunks[while($ - dataOffset < compressedSize)] @ dataOffset [[comment("Compressed chunks of this file.")]];
        
} [[name(name)]];

// Uses a Left-Child Right-Sibling binary tree structure
struct Folder {
    String* name : u32              [[comment("Pointer to the name of this folder relative to the string table."), pointer_base("relative_to_stringtable")]];
    s32     leftChildFolderIndex    [[comment("Index of the left child folder used to access the first child folder.")]];
    s32     rightSiblingFolderIndex [[comment("Index of the right sibling folder used to access the next sibling folder.")]];
    u32     fileCount               [[comment("Number of files contained in this folder.")]];
} [[name(name)]];

struct Header {
    char magic[4]        [[comment("File signature.")]]; // LTAR
    u32  version         [[comment("File version.")]];
    u32  stringTableSize [[comment("Size of the string table.")]];
    u32  folderCount     [[comment("Number of folders in the archive.")]];
    u32  fileCount       [[comment("Number of files in the archive.")]];
    u32  isRetail        [[comment("Determines if the archive is shipped with the game.")]];
    u32  isDownloadable  [[comment("Determines if the archive should be considered for automatic content download for certain games.")]];
    u32  hasCRC          [[comment("Determines if the archive contains a CRC value for the entire archive.")]];
    type::GUID guid      [[comment("Globally Unique ID that identifies the archive. Can be empty.")]];
};

struct Section {
    char   stringTable[header.stringTableSize] [[comment("String table that contains the names of the files and folders in the archive.")]];
    File   files[header.fileCount]             [[comment("Files contained in the archive.")]];
    Folder folders[header.folderCount]         [[comment("Folders contained in the archive.")]];
};

Header  header  @ 0x0 [[comment("Header containing file information.")]];
Section section @ $   [[comment("Section containing file data.")]];