#pragma description Shadow of War SKEL File
#pragma MIME sow/skel

import sow.types;

enum SectionID : u32 {
    BONE_SECTION    = 0xDCDCFF00,
    MODEL_SECTION   = 0xDCDCFF01,
    UNK2_SECTION    = 0xDCDCFF02,
    INDICES_SECTION = 0xDCDCFF03,
    CLOTH_SECTION   = 0xDCDCFF04,
    UNK5_SECTION    = 0xDCDCFF05,
    UNK9_SECTION    = 0xDCDCFF99,
};

struct BoundingBox {
    Vector3f min;
    Vector3f max;
};

struct UnknownMeshDataBlock {
    bool    unknownBool1;
    bool    unknownBool2;
    float   lodThreshold;
    u32     mat;
    s32     unknownInt;
};

struct UnknownMeshData {
    u32 materialAssignmentCount;
    UnknownMeshDataBlock unknownMeshDataBlock[materialAssignmentCount] [[inline]];
};

struct Bone {
    u32         boneNameOffset;
    bool        boneActive;
    Vector3f    translation;
    Quaternion  rotation;
    u32         childCount;
    
    char boneName[] @ sizeof(header) + boneNameOffset + 4;
} [[name(boneName)]];

struct Header {
    char    magic[4]; // SKEL
    u32     version;
    char    unk1[4]; // ID?
    u32     boneNameSecSize;
    u32     unk2;
    u32     boneCount1;
    char    unk3[4]; // ID?
    s32     unk4; // Animation count?
    u32     modelCount;
    u32     unk6; // FX count?
    u32     boneCount2;
    s32     unk7;
    s32     unk8;
    s32     unk9;
    s32     unk10;
    s32     unk11; // ID?
    u32     unk12;
    float   unk13; // SectionID?
    BoundingBox boundingBox;
    
    UnknownMeshData unknownMeshData[modelCount];
};

struct BoneSection {
    SectionID sectionID;    
    Bone bones[header.boneCount1] @ addressof(this) + 4 + header.boneNameSecSize;
};

Header header @ 0x00;
BoneSection boneSection @ sizeof(header);