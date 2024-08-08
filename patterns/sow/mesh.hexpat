#pragma description Shadow of War MESH File
#pragma MIME sow/mesh

#pragma pattern_limit 1000000

import sow.enums;
import sow.types;
import type.float16;
import std.core;

using float16 = u16 [[format("type::impl::format_float16")]];

enum SectionID : u32 {
    MESH_DESC_SECTION = 0xEBAEC3FA,
    MESH_INFO_SECTION = 0x1A1541BC,
    MESH_DATA_SECTION = 0x95DBDB69,
};

enum Layer : u32 {
    LAYER_0 = 0, // Vertex16 = 48 Bytes? | Vertex24 = 52 Bytes?
    LAYER_1 = 1, // Vertex16 = 44 Bytes? | Vertex24 = 56 Bytes?
    LAYER_2 = 2, //                      | Vertex24 = 48 Bytes?
    LAYER_3 = 3, //                      | Vertex24 = 44 Bytes?
    LAYER_4 = 4, //                      | Vertex24 = 52 Bytes?
    LAYER_5 = 5, //                      | Vertex24 = 48 Bytes?
};

enum ElementFormat1 : u8 {
    UNK0  =  0,
    UNK1  =  1,
    UNK2  =  2,
    P4    =  3, // Position 4 Bytes (float32)
    UNK4  =  4,
    UNK5  =  5,
    UNK6  =  6,
    UNK7  =  7,
    UNK8  =  8,
    UNK9  =  9,
    UNK10 = 10,
    UNK11 = 11,
    P2    = 12, // Position 2 Bytes (float16)
};

enum ElementFormat2 : u8 {
    UNK0  =  0,
    UNK1  =  1,
    UNK2  =  2,
    UNK3  =  3,
    UNK4  =  4,
    UNK5  =  5,
    UNK6  =  6,
    UNK7  =  7,
    UNK8  =  8,
    UNK9  =  9,
    UNK10 = 10,
    UNK11 = 11,
    UNK12 = 12,
};

enum ElementFormat3 : u8 {
    UNK0  =  0,
    UNK1  =  1,
    UNK2  =  2,
    UNK3  =  3,
    UNK4  =  4,
    UNK5  =  5,
    UNK6  =  6,
    UNK7  =  7,
    UNK8  =  8,
    UNK9  =  9,
    UNK10 = 10,
    UNK11 = 11,
    UNK12 = 12,
};

enum ElementFormat4 : u8 {
    UNK0  =  0,
    UNK1  =  1,
    UNK2  =  2,
    UNK3  =  3,
    UNK4  =  4,
    UNK5  =  5,
    UNK6  =  6,
    UNK7  =  7,
    UNK8  =  8,
    UNK9  =  9,
    UNK10 = 10,
    UNK11 = 11,
    UNK12 = 12,
};

struct MatAssignment {
    s32 model;
    s32 mesh;   // Constant referenced by meshMatIndices
    s32 mat;
    s32 unk;    // Constant referenced by unkMatIndices
};

struct MeshInfo {
    u32 vertDataSize;
    u32 faceDataSize;
    u32 skinDataSize;
    u32 subMeshCount;
    
    u16 faceCount[16];
};

struct SubMeshInfo {
    u32 offset;
    u32 vertStart;
    u32 vertCount;
    u32 faceStart;
    u32 faceCount;
    u32 skinStart;
    u32 skinCount;
    u32 unknown7;
    u32 unknown8;
    u32 layer;
};

// Affects Model LODs Vertex Positions, Bone Weights, UVs, Normals, and Face Visibility
struct LayerFormat {
    u32 elementCount;
    ElementFormat1 elementFormat1[elementCount];
    ElementFormat2 elementFormat2[elementCount];
    ElementFormat3 elementFormat3[elementCount];
    ElementFormat4 elementFormat4[elementCount];
};

struct Bone {
    BoneName    boneName;
    s16         boneIndex;
    u16         boneChild;
    Vector3f    translation;
    Quaternion  rotation;
    float       scale;
} [[name(boneName)]];

// 16 Bytes
struct Vertex16 {
    float16 x;
    float16 y;
    float16 z;
    float16 w; // Always 1.0
    u8 weight1;
    u8 weight2;
    u8 weight3;
    u8 weight4;
    s8 skinID1;
    s8 skinID2;
    s8 skinID3;
    s8 skinID4;
    
    if (w != 1.0)
        std::error("Wrong size");
};

// 24 Bytes
struct Vertex24 {
    float x;
    float y;
    float z;
    float w; // Always 1.0
    u8 weight1;
    u8 weight2;
    u8 weight3;
    u8 weight4;
    s8 skinID1;
    s8 skinID2;
    s8 skinID3;
    s8 skinID4;
    
    if (w != 1.0)
        std::error("Wrong size");
};

union UV00 {
    u16 u;
    u16 v;
};

union UV01 {
    u16   uv1;
    float uv2;
};

union UV10 {
    float uv1;
    u16   uv2;
};

union UV11 {
    float u;
    float v;
};

// 44 Bytes
struct LayerElements44 {
    UV01;
    padding[36];
    u32 checkSize;
    
    if (checkSize != 0xFFFFFFFF)
        std::error("Wrong size");
};

// 48 Bytes
struct LayerElements48 {
    UV01;
    padding[40];
    u32 checkSize;
    
    if (checkSize != 0xFFFFFFFF)
        std::error("Wrong size");
};

// 52 Bytes
struct LayerElements52 {
    UV01;
    padding[44];
    u32 checkSize;
    
    if (checkSize != 0xFFFFFFFF)
        std::error("Wrong size");
};

// 56 Bytes
struct LayerElements56 {
    UV01;
    padding[48];
    u32 checkSize;
    
    if (checkSize != 0xFFFFFFFF)
        std::error("Wrong size");
};

// 58 Bytes
struct LayerElements58 {
    UV01;
    padding[50];
    u32 checkSize;
    
    if (checkSize != 0xFFFFFFFF)
        std::error("Wrong size");
};

struct Face {
    u16 vertIndex1;
    u16 vertIndex2;
    u16 vertIndex3;
};

struct VertDataSection {
    u8 vertData[meshDescSection.vertSectionSize[std::core::array_index()]];
    
    //try {Vertex16 Vertices16[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {Vertex24 Vertices24[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    
    //try {LayerElements44 layerElements44[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {LayerElements48 layerElements48[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {LayerElements52 layerElements52[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {LayerElements56 layerElements56[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {LayerElements58 layerElements58[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
        
    //match (meshInfoSection.subMeshInfo[std::core::array_index()].layer) {
    //    (0): LayerElements52 layerElements52[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];
    //    (1): LayerElements56 layerElements56[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];
    //    (2): LayerElements48 layerElements48[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];
    //    (3): LayerElements44 layerElements44[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];
    //}
};

struct FaceDataSection {
    u8 faceData[meshDescSection.faceSectionSize[std::core::array_index()]];
    
    //Face faces[meshInfoSection.subMeshInfo[std::core::array_index()].faceCount / 3];
};

struct SkinDataSection {
    u8 skinData[meshDescSection.skinSectionSize[std::core::array_index()]];
};

struct Header {
    char magic[4]; // MMSH
    u32  version;

    u32 meshDescSectionSize;
    u32 meshInfoSectionSize;
    u32 meshDataSectionSize;
};

struct MeshDescSection {
    SectionID meshDescSectionID; // 0xEBAEC3FA
    
    u32 matIndexCount;
    u32 dataSectionCount;
    
    s32 unkMatIndices[matIndexCount];
    s32 meshMatIndices[matIndexCount];
    
    u32 vertSectionSize[dataSectionCount];
    u32 faceSectionSize[dataSectionCount];
    u32 skinSectionSize[dataSectionCount];
};

struct MeshInfoSection {
    SectionID meshInfoSectionID; // 0x1A1541BC
    
    u32 modelCount;
    u32 matAssignmentCount;
    u32 meshCount;
    u32 subMeshCount;
    
    u32 unknownULong1;
    
    u32 lodSettingsCount;
    u32 meshLodCount;
    u32 shadowLodCount;
    
    u32 layerCount;
    u32 ULongReadCount;
    
    float unknownFloat; // 400 or 1200, ID for unknown1?
    float unknown1[4];
    
    u32 boneCount;
    u32 boneSectionSize;
    
    u32 modelID[modelCount];
    
    MatAssignment matAssignments[matAssignmentCount];
    MeshInfo      meshInfo[meshCount];
    SubMeshInfo   subMeshInfo[subMeshCount];
    
    u32   lodSectionID; // 0x8E3E068E
    u32   lodSettings[lodSettingsCount]; // Settings related to the LODs
    float lodThresholds[meshLodCount + shadowLodCount]; // Distance Thresholds for rendering different LODs
    u32   lodConnections[meshLodCount + shadowLodCount]; // Determines which LODs to render at the corresponding Distance Thresholds
    
    u32 layerFormatSectionID; // 0x37D749A6
    LayerFormat layerFormat[layerCount]; // Affects Model LODs Vertex Positions, Bone Weights, UVs, Normals, and Face Visibility
    
    u32  boneSectionID; // 0x93D9A424
    Bone bones[boneCount];
};

struct MeshDataSection {
    SectionID meshDataSectionID; // 0x95DBDB69
    
    VertDataSection vertDataSection[meshDescSection.dataSectionCount];
    FaceDataSection faceDataSection[meshDescSection.dataSectionCount];
    SkinDataSection skinDataSection[meshDescSection.dataSectionCount];
};

Header header @ 0x00;
MeshDescSection meshDescSection @ (sizeof(header));
MeshInfoSection meshInfoSection @ (sizeof(header) + header.meshDescSectionSize);
MeshDataSection meshDataSection @ (sizeof(header) + header.meshDescSectionSize + header.meshInfoSectionSize);