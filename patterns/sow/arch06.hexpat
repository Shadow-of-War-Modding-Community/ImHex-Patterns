#pragma description Shadow of War ARCH06 File
#pragma MIME sow/arch06

import sow.types;
import std.core;

fn relative_to_stringtable(u128 offset) {
    return addressof(section.stringTable);
};

fn format_string_ptr(ref auto stringPtr) {
    return stringPtr.stringPtr;
};

struct StringPtr {
    String *stringPtr : u32 [[pointer_base("relative_to_stringtable"), inline, sealed]];
} [[format("format_string_ptr")]];

enum ResourceType : u32 {
    BUNDLE   = 1,
    UNKNOWN1 = 740,
    UNKNOWN2 = 760,
    UNKNOWN3 = 1109131264,
    UNKNOWN4 = 1236533248,
    UNKNOWN5 = 3477864448,
};

enum Index : s32 {
    END_DIRECTORY  = -1,
    MAIN_DIRECTORY =  1,
    SUB_DIRECTORY  =  2 ... 99
};

struct Bundle {
    u32  unk1;
    u32  unk2;
    u16  unk3;
    u32  unk4;
    char magic[4];
    u32  version;
};

struct Resource {
    ResourceType type;
    u32 offset;
    padding[12];
    if (offset > 0) 
        Bundle bundle @ offset;
};

struct Folder {
    StringPtr pathPtr;
    Index index;
    padding[8];
};

struct Header {
    char    magic[4]; // LTAR
    u32     version;
    u32     stringTableSize;
    u32     resourceCount1;
    u32     resourceCount2;
    u32     unk4;
    char    padding1[24];
};

struct Section {
    char stringTable[header.stringTableSize];
    Resource resources[header.resourceCount1];
    //Folder folders[header.resourceCount1];
};

Header header @ 0x0;
Section section @ $;