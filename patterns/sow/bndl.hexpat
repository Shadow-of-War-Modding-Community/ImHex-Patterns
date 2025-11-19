#pragma description Shadow of War BNDL File
#pragma MIME sow/bndl

import std.core;
import hex.core;

struct Resource {
    u32  size @ addressof(header.resourceSize[std::core::array_index()]) [[comment("Size of this Resource")]];
    u32  offset [[comment("Offset to the Path for this Resource")]];
    char path[] @ addressof(parent) + offset [[comment("Path for this Resource")]];
    hex::core::add_virtual_file(path, this); // Check the "Virtual Filesystem" tab at the Console
} [[name(path), comment("Resource in this Bundle")]];

struct Header {
    char magic[4]         [[comment("File Signature")]];
    u32  version          [[comment("File Version")]];
    u32  bundleTypeOffset [[comment("Offset to the Bundle Type")]];
    u32  resourcesOffset  [[comment("Offset to the Resources")]];
    u32  resourceCount    [[comment("Number of Resources")]];
    u32  resourceSize[resourceCount] [[hidden]];
};

struct ResourceSection {
    char bundleType[] @ addressof(this) + header.bundleTypeOffset [[comment("Type of Bundle")]];
    Resource resources[header.resourceCount] @ addressof(this) + header.resourcesOffset [[comment("Resources in this Bundle")]];
};

Header header @ 0x00                [[comment("Header containing File Information")]];
ResourceSection resourceSection @ $ [[comment("Section containing Resource Data")]];