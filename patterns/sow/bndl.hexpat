#pragma description Shadow of War BNDL File
#pragma MIME sow/bndl

import std.core;

struct Resource {
    u32 resourceSize @ addressof(header.resourceSize[std::core::array_index()]);
    u32 resourceOffset;
    char resourcePath[] @ sizeof(header) + resourceOffset;
} [[name(resourcePath)]];

struct Header {
    char magic[4];
    u32 version;
    u32 bundleTypeOffset;
    u32 resourcePtrOffset;
    u32 resourceCount;
    u32 resourceSize[resourceCount] [[hidden]];
};

struct ResourceSection {
    char bundleType[] @ addressof(this) + header.bundleTypeOffset;
    Resource resources[header.resourceCount] @ addressof(this) + header.resourcePtrOffset;
};

Header header @ 0x00;
ResourceSection resourceSection @ $;