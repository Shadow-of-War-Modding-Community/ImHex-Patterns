#pragma description Shadow of War MESH File
#pragma MIME sow/mesh

#pragma pattern_limit 1000000

import type.float16;
import std.core;

using float16 = u16 [[format("type::impl::format_float16")]];

enum SectionID : u32 {
    MESH_DESC_SECTION = 0xEBAEC3FA,
    MESH_INFO_SECTION = 0x1A1541BC,
    MESH_DATA_SECTION = 0x95DBDB69,
};

enum UVFormat : u32 {
    UVArray52 = 0x00000000,
    UVArray56 = 0x00000001,
    UVArray48 = 0x00000002,
    UVArray44 = 0x00000003,
};

struct MatAssignment {
    s32 modelLod;   // Affects Model LODs?
    s32 meshIndex;  // Referenced by meshMatIndices
    s32 meshLod;    // Affects Mesh LODs and Shadow LODs
    s32 unkIndex;   // Referenced by unkMatIndices
};

struct MeshInfo {
    u32 vertSecSize;
    u32 faceSecSize;
    u32 boneSecSize;
    u32 subMeshCount;
    
    u16 faceCount[16];
};

struct SubMeshInfo {
    u32 offset;
    u32 vertStart;
    u32 vertCount;
    u32 faceStart;
    u32 faceCount;
    u32 boneStart;
    u32 boneCount;
    u32 unknown7;
    u32 unknown8;
    UVFormat UVFormat;
};

// Affects UVs, Bones, Materials/Normals
struct ModelLodSettings {
    u32 unknownCount;
    u8 unknownByte1[unknownCount];
    u8 unknownByte2[unknownCount];
    u8 unknownByte3[unknownCount];
    u8 unknownByte4[unknownCount];
};

struct Bone {
    u32 boneID;
    u16 boneIndex;
    u16 boneChild;
    float a11, a12, a13, a14;
    float a21, a22, a23, a24;
};

struct VertArray16 {
    float16 x;
    float16 y;
    float16 z;
    u16 checkVert; // 15360
    u8 weight1;
    u8 weight2;
    u8 weight3;
    u8 weight4;
    u8 bone1;
    u8 bone2;
    u8 bone3;
    u8 bone4;
    
    if (checkVert != 15360)
        std::error("Wrong array size");
};

struct VertArray24 {
    float x;
    float y;
    float z;
    float checkVert; // 1.0
    u8 weight1;
    u8 weight2;
    u8 weight3;
    u8 weight4;
    u8 bone1;
    u8 bone2;
    u8 bone3;
    u8 bone4;
    
    if (checkVert != 1.0)
        std::error("Wrong array size");
};

union UV00 {
    u16 u;
    u16 v;
};

union UV01 {
    u16 uv1;
    float uv2;
};

union UV10 {
    float uv1;
    u16 uv2;
};

union UV11 {
    float u;
    float v;
};

struct UVArray44 {
    UV01;
    padding[36];
    u32 checkUV;
    
    if (checkUV != 0xFFFFFFFF)
        std::error("Wrong array size");
};

struct UVArray48 {
    UV01;
    padding[40];
    u32 checkUV;
    
    if (checkUV != 0xFFFFFFFF)
        std::error("Wrong array size");
};

struct UVArray52 {
    UV01;
    padding[44];
    u32 checkUV;
    
    if (checkUV != 0xFFFFFFFF)
        std::error("Wrong array size");
};

struct UVArray56 {
    UV01;
    padding[48];
    u32 checkUV;
    
    if (checkUV != 0xFFFFFFFF)
        std::error("Wrong array size");
};

struct UVArray58 {
    UV01;
    padding[50];
    u32 checkUV;
    
    if (checkUV != 0xFFFFFFFF)
        std::error("Wrong array size");
};

struct FaceArray {
    u16 vertIndex1;
    u16 vertIndex2;
    u16 vertIndex3;
};

struct VertDataSection {
    u8 vertData[meshDescSection.vertSectionSize[std::core::array_index()]];
    
    //try {VertArray16 VertArray16[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {VertArray24 VertArray24[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    
    //try {UVArray44 UVArray44[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {UVArray48 UVArray48[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {UVArray52 UVArray52[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {UVArray56 UVArray56[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
    //try {UVArray58 UVArray58[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];}
        
    //match (meshInfoSection.subMeshInfo[std::core::array_index()].UVFormat) {
    //    (UVFormat::UVArray52): UVArray52 UVArray52[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];
    //    (UVFormat::UVArray56): UVArray56 UVArray56[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];
    //    (UVFormat::UVArray48): UVArray48 UVArray48[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];
    //    (UVFormat::UVArray44): UVArray44 UVArray44[meshInfoSection.subMeshInfo[std::core::array_index()].vertCount];
    //}
};

struct FaceDataSection {
    u8 faceData[meshDescSection.faceSectionSize[std::core::array_index()]];
    
    //FaceArray faceArray[meshInfoSection.subMeshInfo[std::core::array_index()].faceCount / 3];
};

struct BoneDataSection {
    u8 boneData[meshDescSection.boneSectionSize[std::core::array_index()]];
    
    //u8 boneArray[meshInfoSection.subMeshInfo[std::core::array_index()].boneCount];
};

struct Header {
    char magic[4]; // MMSH
    u32 version;
    
    u32 meshDescSectionSize;
    u32 meshInfoSectionSize;
    u32 meshDataSectionSize;
};

struct MeshDescSection {
    SectionID; // 0xEBAEC3FA
    
    u32 matIndexCount;
    u32 sectionDataCount;
    
    s32 unkMatIndices[matIndexCount];
    s32 meshMatIndices[matIndexCount];
    
    u32 vertSectionSize[sectionDataCount];
    u32 faceSectionSize[sectionDataCount];
    u32 boneSectionSize[sectionDataCount];
};

struct MeshInfoSection {
    SectionID; // 0x1A1541BC
    
    u32 matCount; // Unique Mesh count?
    u32 matAssignmentCount;
    u32 meshCount;
    u32 subMeshCount;
    
    u32 unknownULong1;
    
    u32 lodSettingsCount;
    u32 meshLodCount;
    u32 shadowLodCount;
    
    u32 modelLodCount;
    u32 ULongReadCount;
    
    float unknownFloat; // 400 or 1200, ID for unknown1?
    
    float unknown1[4];
    
    u32 boneCount;
    u32 boneSectionSize;
    
    u32 matID[matCount]; // Unique Mesh ID?
    
    MatAssignment matAssignments[matAssignmentCount]; // Affects Material Connections
    MeshInfo meshInfo[meshCount];
    SubMeshInfo subMeshInfo[subMeshCount];
    
    u32 lodSectionID; // 0x8E3E068E
    u32 lodSettings[lodSettingsCount]; // Settings related to the LODs
    float lodThresholds[meshLodCount + shadowLodCount]; // Distance Thresholds for rendering different LODs
    u32 lodConnections[meshLodCount + shadowLodCount]; // Determines which LODs to render at the corresponding Distance Thresholds

    u32 modelLodSectionID; // 0x37D749A6
    ModelLodSettings modelLodSettings[modelLodCount]; // Affects Model LODs Vertex Positions, UVs, and Visibility
    
    u32 boneSectionID; // 0x93D9A424
    Bone bones[boneCount];
};

struct MeshDataSection {
    SectionID; // 0x95DBDB69
    
    VertDataSection vertDataSection[meshDescSection.sectionDataCount];
    FaceDataSection faceDataSection[meshDescSection.sectionDataCount];
    BoneDataSection boneDataSection[meshDescSection.sectionDataCount];
};

Header header @ 0x00;
MeshDescSection meshDescSection @ (sizeof(header));
MeshInfoSection meshInfoSection @ (sizeof(header) + header.meshDescSectionSize);
MeshDataSection meshDataSection @ (sizeof(header) + header.meshDescSectionSize + header.meshInfoSectionSize);