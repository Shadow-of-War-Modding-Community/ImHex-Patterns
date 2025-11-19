#pragma description Shadow of War VEGTILE File
#pragma MIME sow/vegtile

import type.float16;
using float16 = u16 [[format("type::impl::format_float16")]];

struct Vec3f {
    float x, y, z;
};

struct Tile {
    Vec3f start, end;  
};

struct Vegetation {
    float16 x, y, z;
    u8 size;
    s8 constant;
    u32 hash; // Probably a hash as every value is unique
    u8 defaultPushDown; 
    u8 unk5;
    u8 unk6;
    u8 unk7;
};

struct VegetationGroup {
    u16 nameLength;
    char name[nameLength];
    u32 vegCount;
    Vegetation vegetations[vegCount];
};

struct Header{
    u32 magic;
    u32 version;
    Tile tile;
    u32 vegGroupCount;
};

Header header @ 0x0;
VegetationGroup vegGroup[header.vegGroupCount] @ $;