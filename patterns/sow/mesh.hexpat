#pragma description Shadow of War MESH File
#pragma MIME sow/mesh

#pragma pattern_limit 1000000

import sow.enums;
import sow.types;
import std.core;

enum SectionID : u32 {
    MESH_DESC_SECTION = 0xEBAEC3FA,
    MESH_INFO_SECTION = 0x1A1541BC,
    MESH_DATA_SECTION = 0x95DBDB69,
};

enum Buffer : u8 {
    BUFFER_0  =  0,
    BUFFER_1  =  1,
};

enum Type : u8 {
    TYPE0      =  0,
    VECTOR2F32 =  1,
    VECTOR3F32 =  2,
    VECTOR4F32 =  3,
    VECTOR4U8  =  4,
    TYPE5      =  5,
    TYPE6      =  6,
    TYPE7      =  7,
    TYPE8      =  8,
    VECTOR2I16 =  9,
    TYPE10     = 10,
    TYPE11     = 11,
    VECTOR4F16 = 12,
};

enum Attribute : u8 {
    POSITION    =  0,
    NORMAL      =  1,
    TANGENT     =  2,
    BITANGENT   =  3,
    TEXCOORD    =  4,
    COLOR       =  5,
    WEIGHT      =  6,
    VERTEXGROUP =  7,
    ATTRIBUTE8  =  8,
    ATTRIBUTE9  =  9,
    ATTRIBUTE10 = 10,
    ATTRIBUTE11 = 11,
    ATTRIBUTE12 = 12,
};

enum Channel : u8 {
    CHANNEL_0  =  0,
    CHANNEL_1  =  1,
};

struct Connection {
    s32 lodGroup  [[comment("Index of the LOD Group")]];
    s32 lod       [[comment("Index of the LOD in the LOD Group (Constant)")]];
    s32 material  [[comment("Index of the Material")]];
    s32 unk       [[comment("Unknown (Constant)")]];
};

struct LodInfo {
    u32 vertexDataSize      [[comment("Size of the Vertex Data")]];
    u32 faceDataSize        [[comment("Size of the Face Data")]];
    u32 VertexGroupDataSize [[comment("Size of the Vertex Group Data")]];
    u32 meshCount           [[comment("Number of Meshes")]];
    u16 faceCount[16]       [[comment("Number of Faces")]];
};

struct MeshInfo {
    u32 dataOffset         [[comment("Offset of the Data")]];
    u32 verticesOffset     [[comment("Offset of the Vertices")]];
    u32 verticesCount      [[comment("Number of Vertices")]];
    u32 faceIndicesOffset  [[comment("Offset of the Face Indices")]];
    u32 faceIndicesCount   [[comment("Number of Face Indices")]];
    u32 vertexGroupsOffset [[comment("Offset of the Vertex Groups")]];
    u32 vertexGroupsCount  [[comment("Number of Vertex Groups")]];
    u32 unknown7;
    u32 unknown8;
    u32 vertexBufferLayout [[comment("Index of the Vertex Buffer Layout")]];
};

struct LodThresholds {
    float meshLodThresholds[parent.parent.meshLodCount]     [[comment("Distance Thresholds for the Mesh LODs")]];
    float shadowLodThresholds[parent.parent.shadowLodCount] [[comment("Distance Thresholds for the Shadow LODs")]];
};

struct LodConnections {
    u32 meshLodConnections[parent.parent.meshLodCount]     [[comment("Connections between the Mesh LODs and the Distance Thresholds")]];
    u32 shadowLodConnections[parent.parent.shadowLodCount] [[comment("Connections between the Shadow LODs and the Distance Thresholds")]];
};

struct LodSection {
    u32 lodSectionID; // 0x8E3E068E
    u32 lodSettings[parent.lodSettingsCount] [[comment("Settings related to the LODs")]];
    LodThresholds  lodThresholds             [[comment("Distance Thresholds for the LODs")]];
    LodConnections lodConnections            [[comment("Connections between the LODs and the Distance Thresholds")]];
};

struct AttributeLayout {
    Buffer    buffer    [[comment("Index of the Buffer")]];
    Type      type      [[comment("Index of the Tyoe")]];
    Attribute attribute [[comment("Index of the Attribute")]];
    Channel   channel   [[comment("Index of the Channel")]];
};

struct VertexBufferLayout {
    u32 attributeCount                               [[comment("Number of Attributes")]];
    AttributeLayout attributesLayout[attributeCount] [[comment("Layout of the Attributes")]];
};

struct VertexBufferLayoutSection {
    u32 vertexBufferLayoutSectionID; // 0x37D749A6
    VertexBufferLayout vertexBufferLayout[parent.vertexBufferLayoutCount] [[comment("Layout of the Vertex Buffers")]];
};

struct Bone {
    BoneName   name        [[comment("Name of the Bone")]];
    s16        parentIndex [[comment("Index of the Parent Bone")]];
    u16        childCount  [[comment("Number of Child Bones")]];
    Vector3f   translation [[comment("Position of the Bone in 3D space")]];
    Quaternion rotation    [[comment("Rotation of the Bone in 3D space")]];
    float      scale       [[comment("Scaling of the Bone in 3D space")]];
} [[name(name)]];

struct BoneSection {
    u32  boneSectionID; // 0x93D9A424
    Bone bones[parent.boneCount] [[comment("Collection of Bones in the Skeleton")]];
};

struct Position<T> {
    T x [[comment("X-Coordinate of the Position")]];
    T y [[comment("Y-Coordinate of the Position")]];
    T z [[comment("Z-Coordinate of the Position")]];
    T w [[comment("W-Component, often used in Homogeneous Coordinates")]]; // Always 1.0
};

struct Weights<T> {
    T weight[4] [[comment("Weight associated with a Vertex Group")]];
};

struct VertexGroups<T> {
    T vertexGroup[4] [[comment("Vertex Group associated with a Weight")]];
};

struct TextureCoordinate<T> {
    T u [[comment("U-Coordinate (Horizontal Texture Coordinate)")]];
    T v [[comment("V-Coordinate (Vertical Texture Coordinate)")]];
};

struct Normal<T> {
    T x [[comment("X-Component of the Normal")]];
    T y [[comment("Y-Component of the Normal")]];
    T z [[comment("Z-Component of the Normal")]];
};

struct Tangent<T> {
    T x [[comment("X-Component of the Tangent")]];
    T y [[comment("Y-Component of the Tangent")]];
    T z [[comment("Z-Component of the Tangent")]];
};

struct Bitangent<T> {
    T x [[comment("X-Component of the Bitangent")]];
    T y [[comment("Y-Component of the Bitangent")]];
    T z [[comment("Z-Component of the Bitangent")]];
};

struct Color<T> {
    T r [[comment("Red-Channel of the Color")]];
    T g [[comment("Blue-Channel of the Color")]];
    T b [[comment("Green-Channel of the Color")]];
    T a [[comment("Alpha-Channel of the Color")]];
};

struct Vertex {
    match (meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].elementsLayout[0].type, meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].elementsLayout[0].element) {
        (Type::VECTOR4F16, Attribute::POSITION):    Position<float16> position     [[comment("Position of the Vertex in 3D space")]];
        (Type::VECTOR4F32, Attribute::POSITION):    Position<float>   position     [[comment("Position of the Vertex in 3D space")]];
        (Type::VECTOR4U8,  Attribute::WEIGHT):      Weights<u8>       weights      [[comment("Weights associated with Vertex Groups")]];
        (Type::VECTOR4U8,  Attribute::VERTEXGROUP): VertexGroups<u8>  vertexGroups [[comment("Indices of Vertex Groups")]];
        (Type::VECTOR4U8,  Attribute::COLOR):       Color<u8>         color        [[comment("Color of the Vertex")]];
    }
};

struct VertexArray {
    Vertex vertices[meshInfoSection.meshInfo[std::core::array_index()].verticesCount] [[comment("Vertices in the Mesh")]];
};

struct Face {
    u16 index1 [[comment("Index of the first Vertex in this Face")]];
    u16 index2 [[comment("Index of the second Vertex in this Face")]];
    u16 index3 [[comment("Index of the third Vertex in this Face")]];
};

struct Header {
    char magic[4]            [[comment("File Signature")]]; // MMSH
    u32  version             [[comment("File Version")]];
    u32  meshDescSectionSize [[comment("Size of the Description Section")]];
    u32  meshInfoSectionSize [[comment("Size of the Information Section")]];
    u32  meshDataSectionSize [[comment("Size of the Data Section")]];
};

struct MeshDescSection {
    SectionID meshDescSectionID; // 0xEBAEC3FA
    u32 materialIndicesCount                         [[comment("Number of Material Indices")]];
    u32 dataSectionCount                             [[comment("Number of Data Sections")]];
    s32 unknownIndices[materialIndicesCount]         [[comment("Unknown Indices")]];
    s32 materialIndices[materialIndicesCount]        [[comment("Material Indices")]];
    u32 vertexDataSectionSize[dataSectionCount]      [[comment("Size of the Vertex Data Section")]];
    u32 faceDataSectionSize[dataSectionCount]        [[comment("Size of the Face Data Section")]];
    u32 VertexGroupDataSectionSize[dataSectionCount] [[comment("Size of the Vertex Group Data Section")]];
};

struct MeshInfoSection {
    SectionID meshInfoSectionID; // 0x1A1541BC
    u32   lodGroupCount                                 [[comment("Number of LOD Groups")]];
    u32   connectionCount                               [[comment("Number of Connections")]];
    u32   lodCount                                      [[comment("Number of LODs")]];
    u32   meshCount                                     [[comment("Number of Meshes")]];
    u32   unknownULong1;
    u32   lodSettingsCount                              [[comment("Number of LOD settings")]];
    u32   meshLodCount                                  [[comment("Number of Mesh LODs")]];
    u32   shadowLodCount                                [[comment("Number of Shadow LODs")]];
    u32   vertexBufferLayoutCount                       [[comment("Number of Vertex Buffer Layouts")]];
    u32   ULongReadCount;
    float unknownFloat; // 400 or 1200, ID for unknown1?
    float unknown1[4];
    u32   boneCount                                     [[comment("Number of Bones in the Skeleton")]];
    u32   boneSectionSize                               [[comment("Size of the Bone Section")]];    
    u32   lodGroupIDs[lodGroupCount]                    [[comment("Hashes of the Names for the LOD Groups")]];
    Connection   connections[connectionCount]           [[comment("Connections between the LOD Groups, LODs, Meshes and Materials")]];
    LodInfo      lodInfo[lodCount]                      [[comment("Information about where the Data of the LODs are stored")]];
    MeshInfo     meshInfo[meshCount]                    [[comment("Information about where the Data of the Meshes are stored")]];
    LodSection   lodSection                             [[comment("Section containing Data for the LODs")]];
    VertexBufferLayoutSection vertexBufferLayoutSection [[comment("Section containing Data for the Vertex Buffer Layout")]];
    BoneSection  boneSection                            [[comment("Section containing Data for the Bones")]];
};

struct MeshDataSection {
    SectionID meshDataSectionID; // 0x95DBDB69
    //Mesh meshes[meshInfoSection.subMeshCount];
    //VertexArray vertexArray;
};

Header header @ 0x00                                                                                         [[comment("Header containing File Information")]];
MeshDescSection meshDescSection @ (sizeof(header))                                                           [[comment("Section containing Mesh Descriptions")]];
MeshInfoSection meshInfoSection @ (sizeof(header) + header.meshDescSectionSize)                              [[comment("Section containing Mesh Information")]];
MeshDataSection meshDataSection @ (sizeof(header) + header.meshDescSectionSize + header.meshInfoSectionSize) [[comment("Section containing Mesh Data")]];