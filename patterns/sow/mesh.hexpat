#pragma description Shadow of War MESH File
#pragma MIME sow/mesh

#pragma pattern_limit 1000000

import sow.enums;
import sow.types;
import std.core;
import type.float16;
import type.color;

using float16 = u16 [[format("type::impl::format_float16")]];
using RGBA8 = type::RGBA8;

enum SectionID : u32 {
    MESH_DESC_SECTION = 0xEBAEC3FA,
    MESH_INFO_SECTION = 0x1A1541BC,
    MESH_DATA_SECTION = 0x95DBDB69,
};

enum BufferIndex : u8 {
    BUFFER_0  =  0,
    BUFFER_1  =  1,
};

enum Type : u8 {
    UNK0       =  0,
    UNK1       =  1,
    VECTOR3F32 =  2,
    VECTOR4F32 =  3,
    UINT8      =  4,
    UNK5       =  5,
    UNK6       =  6,
    UNK7       =  7,
    UNK8       =  8,
    UINT16     =  9,
    UNK10      = 10,
    UNK11      = 11,
    VECTOR4F16 = 12,
};

enum Element : u8 {
    POSITION    =  0,
    NORMAL      =  1,
    TANGENT     =  2,
    BITANGENT   =  3,
    TEXCOORD    =  4,
    COLOR       =  5,
    WEIGHT      =  6,
    VERTEXGROUP =  7,
    UNK8        =  8,
    UNK9        =  9,
    UNK10       = 10,
    UNK11       = 11,
    UNK12       = 12,
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
    u32 layerIndex         [[comment("Index of the layer")]];
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

struct ElementLayout {
    u8        bufferIndex;
    Type      type;
    Element   element;
    u8        channel;
};

struct VertexBufferLayout {
    u32 elementCount;
    ElementLayout elementsLayout[elementCount];
};

struct BufferLayoutSection {
    u32 bufferLayoutSectionID; // 0x37D749A6
    VertexBufferLayout vertexBufferLayout[parent.bufferLayoutCount] [[comment("Format definitions for the Elements")]]; // Affects Model LODs Vertex Positions, Bone Weights, UVs, Normals, and Face Visibility
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

// 8 Bytes (float16)
struct Position16 {
    float16 x [[comment("X-Coordinate of the Position")]];
    float16 y [[comment("Y-Coordinate of the Position")]];
    float16 z [[comment("Z-Coordinate of the Position")]];
    float16 w [[comment("W-Component, often used in Homogeneous Coordinates")]]; // Always 1.0
};

// 16 Bytes (float32)
struct Position32 {
    float x [[comment("X-Coordinate of the Position")]];
    float y [[comment("Y-Coordinate of the Position")]];
    float z [[comment("Z-Coordinate of the Position")]];
    float w [[comment("W-Component, often used in Homogeneous Coordinates")]]; // Always 1.0
};

struct Weights {
    u8 weight[4]           [[comment("Weight associated with the Vertex Group")]];
    u8 vertexGroupIndex[4] [[comment("Vertex Group associated with the Weight")]];
};

struct Vertex {
    match (meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].elementsLayout[0].type, meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].elementsLayout[0].element) {
        (Type::VECTOR4F16, Element::POSITION): float16 x, y, z, w;
        (Type::VECTOR4F32, Element::POSITION): float x, y, z, w;
        (Type::UINT8, Element::WEIGHT): u8 weight[4];
        (Type::UINT8, Element::VERTEXGROUP): u8 vertexGroupIndex[4];
    }
    //Position32 position [[comment("Position of the Vertex in 3D space")]]; // Position should be determined by LayerFormat
    //Weights weights     [[comment("Bone Weights for the Vertex")]];
};

struct UV16Channel_1 {
    u16 u [[comment("U-Coordinate (Horizontal Texture Coordinate)")]];
    u16 v [[comment("V-Coordinate (Vertical Texture Coordinate)")]];
};

struct UV16Channel_2 {
    float16 u [[comment("U-Coordinate (Horizontal Texture Coordinate)")]];
    float16 v [[comment("V-Coordinate (Vertical Texture Coordinate)")]];
};

union TextureCoordinate16 {
    UV16Channel_1 uvChannel_1 [[comment("First UV Channel containing Texture Coordinates")]];
    UV16Channel_2 uvChannel_2 [[comment("Second UV Channel containing Texture Coordinates")]];
};

struct UV32Channel_1 {
    u32 u [[comment("U-Coordinate (Horizontal Texture Coordinate)")]];
    u32 v [[comment("V-Coordinate (Vertical Texture Coordinate)")]];
};

struct UV32Channel_2 {
    float u [[comment("U-Coordinate (Horizontal Texture Coordinate)")]];
    float v [[comment("V-Coordinate (Vertical Texture Coordinate)")]];
};

union TextureCoordinate32 {
    UV32Channel_1 uvChannel_1 [[comment("First UV Channel containing Texture Coordinates")]];
    UV32Channel_2 uvChannel_2 [[comment("Second UV Channel containing Texture Coordinates")]];
};

struct Normal {
    float x [[comment("X-Component of the Normal")]];
    float y [[comment("Y-Component of the Normal")]];
    float z [[comment("Z-Component of the Normal")]];
};

struct Tangent {
    float x [[comment("X-Component of the Tangent")]];
    float y [[comment("Y-Component of the Tangent")]];
    float z [[comment("Z-Component of the Tangent")]];
};

struct Bitangent {
    float x [[comment("X-Component of the Bitangent")]];
    float y [[comment("Y-Component of the Bitangent")]];
    float z [[comment("Z-Component of the Bitangent")]];
};

struct VertexAttributes44 {
    TextureCoordinate16 textureCoordinate [[comment("UV Mapping Coordinates for Textures")]];
    Normal    normal                      [[comment("Normal Vector at the Vertex (For Lighting Calculations)")]];
    Tangent   tangent                     [[comment("Tangent Vector at the Vertex (Used for Normal Mapping)")]];
    Bitangent bitangent                   [[comment("Bitangent Vector at the Vertex (Orthogonal to the Normal and Tangent)")]];
    RGBA8     color                       [[comment("Color of the Vertex")]];
};

struct VertexAttributes48 {
    TextureCoordinate32 textureCoordinate [[comment("UV Mapping Coordinates for Textures")]];
    Normal    normal                      [[comment("Normal Vector at the Vertex (For Lighting Calculations)")]];
    Tangent   tangent                     [[comment("Tangent Vector at the Vertex (Used for Normal Mapping)")]];
    Bitangent bitangent                   [[comment("Bitangent Vector at the Vertex (Orthogonal to the Normal and Tangent)")]];
    RGBA8     color                       [[comment("Color of the Vertex")]];
};

struct VertexAttributes52 {
    TextureCoordinate32 textureCoordinate [[comment("UV Mapping Coordinates for Textures")]];
    padding[4];
    Normal    normal                      [[comment("Normal Vector at the Vertex (For Lighting Calculations)")]];
    Tangent   tangent                     [[comment("Tangent Vector at the Vertex (Used for Normal Mapping)")]];
    Bitangent bitangent                   [[comment("Bitangent Vector at the Vertex (Orthogonal to the Normal and Tangent)")]];
    RGBA8     color                       [[comment("Color of the Vertex")]];
};

struct VertexAttributes56 {
    TextureCoordinate32 textureCoordinate [[comment("UV Mapping Coordinates for Textures")]];
    padding[4];
    padding[4];
    Normal    normal                      [[comment("Normal Vector at the Vertex (For Lighting Calculations)")]];
    Tangent   tangent                     [[comment("Tangent Vector at the Vertex (Used for Normal Mapping)")]];
    Bitangent bitangent                   [[comment("Bitangent Vector at the Vertex (Orthogonal to the Normal and Tangent)")]];
    RGBA8     color                       [[comment("Color of the Vertex")]];
};

struct VertexArray {
    Vertex vertices[meshInfoSection.meshInfo[std::core::array_index()].verticesCount] [[comment("Vertices in the Mesh")]];
    
    //match (meshInfoSection.subMeshInfo[std::core::array_index()].layer) {
    //    (0): VertexAttributes52 vertexAttributes[meshInfoSection.meshInfo[std::core::array_index()].verticesCount] [[comment("Attributes for the Vertex")]];
    //    (1): VertexAttributes56 vertexAttributes[meshInfoSection.meshInfo[std::core::array_index()].verticesCount] [[comment("Attributes for the Vertex")]];
    //    (2): VertexAttributes48 vertexAttributes[meshInfoSection.meshInfo[std::core::array_index()].verticesCount] [[comment("Attributes for the Vertex")]];
    //    (3): VertexAttributes44 vertexAttributes[meshInfoSection.meshInfo[std::core::array_index()].verticesCount] [[comment("Attributes for the Vertex")]];
    //    (4): VertexAttributes52 vertexAttributes[meshInfoSection.meshInfo[std::core::array_index()].verticesCount] [[comment("Attributes for the Vertex")]];
    //    (5): VertexAttributes48 vertexAttributes[meshInfoSection.meshInfo[std::core::array_index()].verticesCount] [[comment("Attributes for the Vertex")]];
    //}
};

struct Face {
    u16 index1 [[comment("Index of the first Vertex in this Face")]];
    u16 index2 [[comment("Index of the second Vertex in this Face")]];;
    u16 index3 [[comment("Index of the third Vertex in this Face")]];;
};

struct Mesh {
    //VertexArray vertexArray @ meshInfoSection.subMeshInfo[std::core::array_index()].vertOffset * sizeof(this);
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
    u32   lodGroupCount                       [[comment("Number of LOD Groups")]];
    u32   connectionCount                     [[comment("Number of Connections")]];
    u32   lodCount                            [[comment("Number of LODs")]];
    u32   meshCount                           [[comment("Number of Meshes")]];
    u32   unknownULong1;
    u32   lodSettingsCount                    [[comment("Number of LOD settings")]];
    u32   meshLodCount                        [[comment("Number of Mesh LODs")]];
    u32   shadowLodCount                      [[comment("Number of Shadow LODs")]];
    u32   bufferLayoutCount                   [[comment("Number of Layers")]];
    u32   ULongReadCount;
    float unknownFloat; // 400 or 1200, ID for unknown1?
    float unknown1[4];
    u32   boneCount                           [[comment("Number of Bones in the Skeleton")]];
    u32   boneSectionSize                     [[comment("Size of the Bone Section")]];    
    u32   lodGroupIDs[lodGroupCount]          [[comment("Hashes of the Names for the LOD Groups")]];
    Connection   connections[connectionCount] [[comment("Connections between the LOD Groups, LODs, Meshes and Materials")]];
    LodInfo      lodInfo[lodCount]            [[comment("Information about how the Data for the LODs are stored")]];
    MeshInfo     meshInfo[meshCount]          [[comment("Information about how the Data for the Meshes are stored")]];
    LodSection   lodSection                   [[comment("Section containing Data for the LODs")]];
    BufferLayoutSection bufferLayoutSection   [[comment("Section containing Data for the Layers")]];
    BoneSection  boneSection                  [[comment("Section containing Data for the Bones")]];
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