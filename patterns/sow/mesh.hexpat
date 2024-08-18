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

enum ElementFormat1 : u8 {
    UNK0  =  0,
    UNK1  =  1,
    UNK2  =  2,
    P16   =  3, // Position 16 Bytes (float32)
    UNK4  =  4,
    UNK5  =  5,
    UNK6  =  6,
    UNK7  =  7,
    UNK8  =  8,
    UNK9  =  9,
    UNK10 = 10,
    UNK11 = 11,
    P8    = 12, // Position 8 Bytes (float16)
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
    s32 model     [[comment("Index of the model")]];
    s32 constMesh [[comment("Mesh referenced by \"meshMatIndices\" (Constant)")]];
    s32 mat       [[comment("Index of the material")]];
    s32 constUnk  [[comment("Unknown referenced by \"unkMatIndices\" (Constant)")]];
};

struct MeshInfo {
    u32 vertDataSize  [[comment("Size of the vertex data")]];
    u32 faceDataSize  [[comment("Size of the face data")]];
    u32 skinDataSize  [[comment("Size of the skin data")]];
    u32 subMeshCount  [[comment("Number of submeshes")]];
    u16 faceCount[16] [[comment("Number of faces")]];
};

struct SubMeshInfo {
    u32 dataOffset [[comment("Offset for the data")]];
    u32 vertOffset [[comment("Offset for the vertices")]];
    u32 vertCount  [[comment("Number of vertices")]];
    u32 faceOffset [[comment("Offset for the faces")]];
    u32 faceCount  [[comment("Number of faces")]];
    u32 skinOffset [[comment("Offset for the skins")]];
    u32 skinCount  [[comment("Number of skins")]];
    u32 unknown7;
    u32 unknown8;
    u32 layer      [[comment("Index of the layer")]];
};

struct LodThresholds {
    float meshLodThresholds[parent.parent.meshLodCount]     [[comment("Distance thresholds for mesh LODs")]];
    float shadowLodThresholds[parent.parent.shadowLodCount] [[comment("Distance thresholds for shadow LODs")]];
};

struct LodConnections {
    u32 meshLodConnections[parent.parent.meshLodCount]     [[comment("Connections between mesh LODs and distance thresholds")]];
    u32 shadowLodConnections[parent.parent.shadowLodCount] [[comment("Connections between shadow LODs and distance thresholds")]];
};

struct LodSection {
    u32 lodSectionID; // 0x8E3E068E
    u32 lodSettings[parent.lodSettingsCount] [[comment("Settings related to the LODs")]];
    LodThresholds  lodThresholds             [[comment("Distance thresholds for LODs")]];
    LodConnections lodConnections            [[comment("Connections between LODs and distance thresholds")]];
};

// Affects Model LODs Vertex Positions, Bone Weights, UVs, Normals, and Face Visibility
struct LayerFormat {
    u32 elementCount                            [[comment("Number of elements")]];
    ElementFormat1 elementFormat1[elementCount] [[comment("First format definition of the elements")]];
    ElementFormat2 elementFormat2[elementCount] [[comment("Second format definition of the elements")]];
    ElementFormat3 elementFormat3[elementCount] [[comment("Third format definition of the elements")]];
    ElementFormat4 elementFormat4[elementCount] [[comment("Fourth format definition of the elements")]];
};

struct LayerSection {
    u32 layerSectionID; // 0x37D749A6
    LayerFormat layerFormat[parent.layerCount]; // Affects Model LODs Vertex Positions, Bone Weights, UVs, Normals, and Face Visibility
};

struct Bone {
    BoneName   boneName    [[comment("Name of the bone")]];
    s16        boneParent  [[comment("Index of the parent bone")]];
    u16        boneChild   [[comment("Number of child bones")]];
    Vector3f   translation [[comment("Position of the bone in 3D space")]];
    Quaternion rotation    [[comment("Rotation of the bone in 3D space")]];
    float      scale       [[comment("Scaling of the bone in 3D space")]];
} [[name(boneName)]];

struct BoneSection {
    u32  boneSectionID; // 0x93D9A424
    Bone bones[parent.boneCount] [[comment("Collection of bones")]];
};

// 8 Bytes (float16)
struct Position8 {
    float16 x;
    float16 y;
    float16 z;
    float16 w; // Always 1.0
};

// 16 Bytes (float32)
struct Position16 {
    float x;
    float y;
    float z;
    float w; // Always 1.0
};

struct SkinWeight {
    u8 weight[4];
    u8 skinID[4];
};

struct Vertex {
    Position16 position; // Position should be determined by LayerFormat
    SkinWeight skinWeight;
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

struct Face {
    u16 vertIndex1;
    u16 vertIndex2;
    u16 vertIndex3;
};

struct VertDataSection {
    u8 vertData[meshDescSection.vertSectionSize[std::core::array_index()]];
};

struct FaceDataSection {
    u8 faceData[meshDescSection.faceSectionSize[std::core::array_index()]];
    
    //Face faces[meshInfoSection.subMeshInfo[std::core::array_index()].faceCount / 3];
};

struct SkinDataSection {
    u8 skinData[meshDescSection.skinSectionSize[std::core::array_index()]];
};

struct Header {
    char magic[4]            [[comment("File signature")]]; // MMSH
    u32  version             [[comment("File version")]];
    u32  meshDescSectionSize [[comment("Size of the description section")]];
    u32  meshInfoSectionSize [[comment("Size of the information section")]];
    u32  meshDataSectionSize [[comment("Size of the data section")]];
};

struct MeshDescSection {
    SectionID meshDescSectionID; // 0xEBAEC3FA
    u32 matIndexCount                     [[comment("Number of material indices")]];
    u32 dataSectionCount                  [[comment("Number of data sections")]];
    s32 unkMatIndices[matIndexCount]      [[comment("Unknown material indices")]];
    s32 meshMatIndices[matIndexCount]     [[comment("Mesh material indices")]];
    u32 vertSectionSize[dataSectionCount] [[comment("Size of the vertex data section")]];
    u32 faceSectionSize[dataSectionCount] [[comment("Size of the face data section")]];
    u32 skinSectionSize[dataSectionCount] [[comment("Size of the skin data section")]];
};

struct MeshInfoSection {
    SectionID meshInfoSectionID; // 0x1A1541BC
    u32   modelCount                                 [[comment("Number of models")]];
    u32   matAssignmentCount                         [[comment("Number of material assignments")]];
    u32   meshCount                                  [[comment("Number of meshes")]];
    u32   subMeshCount                               [[comment("Number of submeshes")]];
    u32   unknownULong1;
    u32   lodSettingsCount                           [[comment("Number of LOD settings")]];
    u32   meshLodCount                               [[comment("Number of mesh LODs")]];
    u32   shadowLodCount                             [[comment("Number of shadow LODs")]];
    u32   layerCount                                 [[comment("Number of layers")]];
    u32   ULongReadCount;
    float unknownFloat; // 400 or 1200, ID for unknown1?
    float unknown1[4];
    u32   boneCount                                  [[comment("Number of bones")]];
    u32   boneSectionSize                            [[comment("Size of the bone section")]];    
    u32   modelID[modelCount]                        [[comment("Hash of the model names")]];
    MatAssignment matAssignments[matAssignmentCount] [[comment("Material assignments")]];
    MeshInfo      meshInfo[meshCount]                [[comment("Mesh information")]];
    SubMeshInfo   subMeshInfo[subMeshCount]          [[comment("Submesh information")]];
    LodSection    lodSection;
    LayerSection  layerSection;
    BoneSection   boneSection;
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