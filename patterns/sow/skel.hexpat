#pragma description Shadow of War SKEL File
#pragma MIME sow/skel

import sow.types;

fn relative_to_string_section(u128 offset) {
    return addressof(header) + sizeof(header) + 4;
};

enum SectionID : u32 {
    BONE_SECTION    = 0xDCDCFF00,
    MODEL_SECTION   = 0xDCDCFF01,
    UNK2_SECTION    = 0xDCDCFF02,
    INDICES_SECTION = 0xDCDCFF03,
    CLOTH_SECTION   = 0xDCDCFF04,
    UNK5_SECTION    = 0xDCDCFF05,
    UNK9_SECTION    = 0xDCDCFF99,
};

struct AABB {
    Vector3f min [[comment("Minimum Alignment")]];
    Vector3f max [[comment("Maximum Alignment")]];
};

struct LOD {
    bool    unknownBool1; // Related to `Connection::unk` in "mesh.hexpat", true = 3 and false = 1
    bool    unknownBool2;
    float   lodThreshold  [[comment("Distance Threshold")]];
    u32     material      [[comment("Index of the Material")]];
    s32     unknownInt;
};

struct LODGroup {
    u32 lodCount                  [[comment("Number of LODs")]];
    LOD lods[lodCount]            [[comment("LODs")]];
};

struct Bone {
    char       *stringPtr[] : u32 [[pointer_base("relative_to_string_section"), inline, sealed]];
    bool        active;
    Vector3f    translation       [[comment("Position of the Bone in 3D Space")]];
    Quaternion  rotation          [[comment("Rotation of the Bone in 3D Space")]];
    u32         childCount        [[comment("Number of Child Bones")]];
} [[name(stringPtr)]];

struct Animation {
    char *stringPtr[] : u32 [[pointer_base("relative_to_string_section"), inline, sealed]];
    u32   boneCount;
    u32   padding1;
    u8    data[boneCount];
} [[name(stringPtr)]];

struct Model {
    char *stringPtr[] : u32 [[pointer_base("relative_to_string_section"), inline, sealed]];
} [[name(stringPtr)]];

struct Cloth {
    char *stringPtr[] : u32 [[pointer_base("relative_to_string_section"), inline, sealed]];
} [[name(stringPtr)]];

struct Header {
    char     magic[4]                  [[comment("File Signature")]]; // SKEL
    u32      version                   [[comment("File Version")]];
    u32      headerSize                [[comment("Size of the Header")]];
    u32      stringSectionSize         [[comment("Size of the String Section")]];
    u32      modelCount;
    u32      boneNameCount             [[comment("Number of Bone Names")]];
    u32      boneSectionSize           [[comment("Size of the Bone Section")]];
    s32      unk4; // Animation Count?
    u32      lodGroupCount             [[comment("Number of LOD Groups")]];
    u32      unk6; // FX Count?
    u32      boneCount                 [[comment("Number of Bones")]];
    s32      unk7;
    s32      unk8;
    s32      unk9;
    s32      unk10;
    s32      unk11; // ID?
    u32      unk12;
    float    unk13; // 400 or 1200, ID?
    AABB     boundingBox               [[comment("Axis-Aligned Bounding Box")]];
    LODGroup lodGroups[lodGroupCount]  [[comment("LOD Groups")]];
};

struct AnimationSection {
    u32 animationCount;
    Animation animations[animationCount];
};

struct BoneSection {
    SectionID sectionID;    
    u8 stringSection[header.stringSectionSize] [[comment("Section containing Strings"), highlight_hidden, sealed]];
    Bone bones[header.boneCount]               [[comment("Collection of Bones in the Skeleton")]];
    AnimationSection animationSection;
    u32 padding1;
};

struct ModelSection {
    SectionID sectionID;
    Model models[header.modelCount];
};

struct Unk2Section {
    SectionID sectionID;
    u32 unk2Count;
};

struct IndicesSection {
    SectionID sectionID;
    u8 boneIndices[header.boneCount];
};

struct ClothSection {
    SectionID sectionID;
    u32   clothCount;
    Cloth cloth[clothCount];
};

struct Sections {
    BoneSection    boneSection;
    ModelSection   modelSection;
    Unk2Section    unk2Section;
    IndicesSection indicesSection;
    ClothSection   clothSection;
};

Header   header   @ 0x00 [[comment("Header containing File Information")]];
Sections sections @ $;