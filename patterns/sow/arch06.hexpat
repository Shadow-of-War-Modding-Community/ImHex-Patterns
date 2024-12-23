#pragma description Shadow of War ARCH06 File
#pragma MIME sow/arch06

import sow.types;

fn relative_to_string_table(u128 offset) {
    return addressof(header) + sizeof(header) - 1;
};

fn format_string_ptr(ref auto stringPtr) {
    return stringPtr.stringPtr;
};

struct StringPtr {
    String *stringPtr : u32 [[pointer_base("relative_to_string_table"), inline, sealed]];
} [[format("format_string_ptr")]];

enum ResourceType : u32 {
    BUNDLE = 1,
};

enum Index : s32 {
    END_DIRECTORY  = -1,
    MAIN_DIRECTORY =  1,
    SUB_DIRECTORY  =  2 ... 99
};

struct Resource {
    ResourceType type;
    u32 offset;
    padding[12];
};

struct Folder {
    StringPtr pathPtr;
    Index index;
    padding[8];
};

struct Header {
    char    magic[4]; // LTAR
    u32     version;
    u32     sectionOffset; // Relative to eof(Header)
    u32     resourceCount1;
    u32     resourceCount2;
    u32     unk4;
    char    padding1[25];
};

struct Section {
    Resource resources[header.resourceCount1]; // Relative to addressof(Header)
    Folder folders[header.resourceCount1];
};

Header header @ 0x0;
Section section @ sizeof(header) + header.sectionOffset - 1;