#pragma description Shadow of War EMBB File
#pragma MIME sow/embb

import std.core;
import hex.core;

struct Resource {
    u32  pathOffset @ addressof(parent.stringTableOffsets[std::core::array_index()]) [[comment("Offset to the Path for this Resource")]];
    char path[] @ addressof(parent) + pathOffset [[comment("Path for this Resource")]];
    u32  size [[comment("Size of this Resource")]];
    u8   data[size] [[comment("Data of this Resource")]];
    hex::core::add_virtual_file(path, data); // Check the "Virtual Filesystem" tab at the Console
} [[name(path), comment("Resource in this Bundle")]];

struct Header {
    char magic[4]        [[comment("File Signature")]];
    u32  version         [[comment("File Version")]];
    u32  stringTableSize [[comment("Size of the String Table")]];
    u32  resourceCount   [[comment("Number of Resources in this Bundle")]];
} [[static]];

struct ResourceSection {
    char stringTable[header.stringTableSize]      [[hidden]];
    u32  stringTableOffsets[header.resourceCount] [[hidden]];
    Resource resources[header.resourceCount]      [[comment("Resources in this Bundle")]];
};

Header header @ 0x00                [[comment("Header containing File Information")]];
ResourceSection resourceSection @ $ [[comment("Section containing Resource Data")]];