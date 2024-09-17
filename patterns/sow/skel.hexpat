#pragma description Shadow of War SKEL File
#pragma MIME sow/skel

import sow.types;

enum SectionID : u32 {
    BONE_SECTION      = 0xDCDCFF00,
    MODEL_SECTION     = 0xDCDCFF01,
    ANIMATION_SECTION = 0xDCDCFF02,
    INDICES_SECTION   = 0xDCDCFF03,
    CLOTH_SECTION     = 0xDCDCFF04,
    UNK5_SECTION      = 0xDCDCFF05,
    UNK9_SECTION      = 0xDCDCFF99,
};

enum Magic : str {
    BONE_SECTION      = "\x00\xFF\xDC\xDC",
    MODEL_SECTION     = "\x01\xFF\xDC\xDC",
    ANIMATION_SECTION = "\x02\xFF\xDC\xDC",
    INDICES_SECTION   = "\x03\xFF\xDC\xDC",
    CLOTH_SECTION     = "\x04\xFF\xDC\xDC",
    UNK5_SECTION      = "\x05\xFF\xDC\xDC",
    UNK9_SECTION      = "\x99\xFF\xDC\xDC",
};

enum AnimationType : u32 {
    CHARACTER_ANIMATION = 0,
    CINEMATIC_ANIMATION = 1,
};

fn relative_to_string_table(u128 offset) {
    return addressof(header) + sizeof(header) + 4;
};

fn format_string_ptr(ref auto stringPtr) {
    return stringPtr.stringPtr;
};

struct StringPtr {
    String *stringPtr : u32 [[pointer_base("relative_to_string_table"), inline, sealed]];
} [[format("format_string_ptr")]];

struct AABB {
    Vector3f min [[comment("Minimum Alignment")]];
    Vector3f max [[comment("Maximum Alignment")]];
};

struct LOD {
    bool  unknownBool1; // Related to `Connection::unk` in "mesh.hexpat", true = 3 and false = 1
    bool  unknownBool2;
    float lodThreshold  [[comment("Distance Threshold")]];
    u32   materialIndex [[comment("Index of the Material")]];
    s32   unknownInt;
};

struct LODGroup {
    u32 lodCount       [[comment("Number of LODs")]];
    LOD lods[lodCount] [[comment("LODs")]];
};

struct Bone {
    StringPtr  boneNamePtr;
    bool       active;
    Vector3f   translation    [[comment("Position of the Bone in 3D Space")]];
    Quaternion rotation       [[comment("Rotation of the Bone in 3D Space")]];
    u32        childCount     [[comment("Number of Child Bones")]];
} [[name(boneNamePtr)]];

struct Controller {
    StringPtr controllerNamePtr;
    u32       boneCount;
    u32       controlCount;
    u8        controls[boneCount];
} [[name(controllerNamePtr)]];

struct Socket {
    u32       boneIndex;
    StringPtr socketNamePtr;
    padding[32];
} [[name(socketNamePtr)]];

struct Rig {
    u32        controllerCount;
    Controller controllers[controllerCount];
    u32        socketCount;
    if (socketCount > 0) {
        Socket sockets[socketCount];
    }
};

struct Header {
    char     magic[4]                  [[comment("File Signature")]]; // SKEL
    u32      version                   [[comment("File Version")]];
    u32      headerSize                [[comment("Size of the Header")]];
    u32      stringTableSize           [[comment("Size of the String Table")]];
    u32      modelStringsCount;
    u32      boneNameCount             [[comment("Number of Bone Names")]];
    u32      boneSectionSize           [[comment("Size of the Bone Section")]];
    s32      animationCount;
    u32      lodGroupCount             [[comment("Number of LOD Groups")]];
    u32      socketCount;
    u32      boneCount                 [[comment("Number of Bones")]];
    s32      unk7;
    s32      unk8;
    s32      unk9;
    s32      unk10;
    u32      checksum                  [[format("format_hex")]];
    u32      unk12;
    float    unk13; // 400 or 1200, ID?
    AABB     boundingBox               [[comment("Axis-Aligned Bounding Box")]];
    LODGroup lodGroups[lodGroupCount]  [[comment("LOD Groups")]];
};

struct BoneSection {
    SectionID sectionID;
    char stringTable[header.stringTableSize] [[comment("Table of Strings"), highlight_hidden]];
    Bone bones[header.boneCount]             [[comment("Collection of Bones in the Skeleton")]];
    Rig  rig;
    std::print("{}", sectionID);
} [[inline]];

struct ModelSection {
    SectionID sectionID;
    StringPtr AnimationPathPtrs[header.animationCount];
    StringPtr LODGroupNamePtrs[header.lodGroupCount];
    std::print("{}", sectionID);
} [[inline]];

struct AnimationSection {
    SectionID sectionID;
    AnimationType animationTypes[header.animationCount];
    std::print("{}", sectionID);
} [[inline]];

struct IndicesSection {
    SectionID sectionID;
    u8 boneIndices[header.boneCount];
    std::print("{}", sectionID);
} [[inline]];

struct ClothSection {
    SectionID sectionID;
    u32 clothCount;
    StringPtr clothPtrs[clothCount];
    u32 checksum [[format("format_hex")]];
    std::print("{}", sectionID);
} [[inline]];

struct Unk5Section {
    SectionID sectionID;
    u32 unk5Count;
    u32 checksum [[format("format_hex")]];
    std::print("{}", sectionID);
} [[inline]];

struct Unk9Section {
    SectionID sectionID;
    char checksum[4];
    u32  unk1;
    std::print("{}", sectionID);
} [[inline]];

struct Sections {
    std::mem::MagicSearch<Magic::BONE_SECTION,      BoneSection>      boneSection;
    std::mem::MagicSearch<Magic::MODEL_SECTION,     ModelSection>     modelSection;
    std::mem::MagicSearch<Magic::ANIMATION_SECTION, AnimationSection> animationSection;
    std::mem::MagicSearch<Magic::INDICES_SECTION,   IndicesSection>   indicesSection;
    std::mem::MagicSearch<Magic::CLOTH_SECTION,     ClothSection>     clothSection;
    std::mem::MagicSearch<Magic::UNK5_SECTION,      Unk5Section>      unk5Section;
    std::mem::MagicSearch<Magic::UNK9_SECTION,      Unk9Section>      unk9Section;
};

Header   header   @ 0x00 [[comment("Header containing File Information")]];
Sections sections @ $;