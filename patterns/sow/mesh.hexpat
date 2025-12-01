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
    TYPE0  =  0,
    FLOAT2 =  1,
    FLOAT3 =  2,
    FLOAT4 =  3,
    UBYTE4 =  4,
    TYPE5  =  5,
    TYPE6  =  6,
    TYPE7  =  7,
    TYPE8  =  8,
    SHORT2 =  9,
    TYPE10 = 10,
    TYPE11 = 11,
    HALF4  = 12,
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
    u32 lodGroup  [[comment("Index of the LOD Group")]];
    s32 lod       [[comment("Index of the LOD in the LOD Group (Constant)")]];
    u32 material  [[comment("Index of the Material")]];
    u32 unk       [[comment("Unknown (Constant)")]];
};

struct LodInfo {
    u32 vertexDataSize      [[comment("Size of the Vertex Data")]];
    u32 faceDataSize        [[comment("Size of the Face Data")]];
    u32 VertexGroupDataSize [[comment("Size of the Vertex Group Data")]];
    u32 meshCount           [[comment("Number of Meshes")]];
    u16 faceCount[16]       [[comment("Number of Faces")]];
};

struct MeshInfo {
    u32   dataOffset         [[comment("Offset of the Data")]];
    u32   verticesOffset     [[comment("Offset of the Vertices")]];
    u32   verticesCount      [[comment("Number of Vertices")]];
    u32   faceIndicesOffset  [[comment("Offset of the Face Indices")]];
    u32   faceIndicesCount   [[comment("Number of Face Indices")]];
    u32   vertexGroupsOffset [[comment("Offset of the Vertex Groups")]];
    u32   vertexGroupsCount  [[comment("Number of Vertex Groups")]];
    float unknown7;
    float unknown8;
    u32   vertexBufferLayout [[comment("Index of the Vertex Buffer Layout")]];
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

struct Vector2<T> {
    T x [[comment("X-Component of the Vector")]];
    T y [[comment("Y-Component of the Vector")]];
} [[static]];

struct Vector3<T> {
    T x [[comment("X-Component of the Vector")]];
    T y [[comment("Y-Component of the Vector")]];
    T z [[comment("Z-Component of the Vector")]];
} [[static]];

struct Vector4<T> {
    T x [[comment("X-Component of the Vector")]];
    T y [[comment("Y-Component of the Vector")]];
    T z [[comment("Z-Component of the Vector")]];
    T w [[comment("W-Component of the Vector")]];
} [[static]];

struct RGBA<T> {
  T red   [[color("FF0000"), comment("Red-Channel of the Color")]];
  T green [[color("00FF00"), comment("Green-Channel of the Color")]];
  T blue  [[color("0000FF"), comment("Blue-Channel of the Color")]];
  T alpha [[color("FFFFFF"), comment("Alpha-Channel of the Color")]];
} [[static, hex::inline_visualize("color", std::fxpt::to_fixed(red, 8), std::fxpt::to_fixed(green, 8), std::fxpt::to_fixed(blue, 8), std::fxpt::to_fixed(alpha, 8))]];

struct VertexBuffer0 {
    match (meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].attributesLayout[0].buffer,
           meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].attributesLayout[0].type,
           meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].attributesLayout[0].attribute,
           meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].attributesLayout[0].channel) {
        (Buffer::BUFFER_0, Type::HALF4,  Attribute::POSITION,    Channel::CHANNEL_0): Vector4<float16> position        [[comment("Position of the Vertex in 3D space")]];
        (Buffer::BUFFER_0, Type::FLOAT4, Attribute::POSITION,    Channel::CHANNEL_0): Vector4<float>   position        [[comment("Position of the Vertex in 3D space")]];
        (Buffer::BUFFER_0, Type::UBYTE4, Attribute::WEIGHT,      Channel::CHANNEL_0): u8               weights[4]      [[comment("Weights associated with Vertex Groups")]];
        (Buffer::BUFFER_0, Type::UBYTE4, Attribute::VERTEXGROUP, Channel::CHANNEL_0): u8               vertexGroups[4] [[comment("Indices of Vertex Groups")]];
    }
};

struct VertexBuffer1 {
    match (meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].attributesLayout[0].buffer,
           meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].attributesLayout[0].type,
           meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].attributesLayout[0].attribute,
           meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].attributesLayout[0].channel) {
        (Buffer::BUFFER_1, Type::SHORT2, Attribute::TEXCOORD,  Channel::CHANNEL_0): Vector2<s16>   texCoord_0 [[comment("Texture Coordinates")]];
        (Buffer::BUFFER_1, Type::FLOAT2, Attribute::TEXCOORD,  Channel::CHANNEL_0): Vector2<float> texCoord_0 [[comment("Texture Coordinates")]];
        (Buffer::BUFFER_1, Type::SHORT2, Attribute::TEXCOORD,  Channel::CHANNEL_1): Vector2<s16>   texCoord_1 [[comment("Texture Coordinates")]];
        (Buffer::BUFFER_1, Type::FLOAT2, Attribute::TEXCOORD,  Channel::CHANNEL_1): Vector2<float> texCoord_1 [[comment("Texture Coordinates")]];
        (Buffer::BUFFER_1, Type::FLOAT3, Attribute::NORMAL,    Channel::CHANNEL_0): Vector3<float> normal     [[comment("Normal of the Vertex")]];
        (Buffer::BUFFER_1, Type::FLOAT3, Attribute::TANGENT,   Channel::CHANNEL_0): Vector3<float> tangent    [[comment("Tangent of the Vertex")]];
        (Buffer::BUFFER_1, Type::FLOAT3, Attribute::BITANGENT, Channel::CHANNEL_0): Vector3<float> bitangent  [[comment("Normal of the Vertex")]];
        (Buffer::BUFFER_1, Type::UBYTE4, Attribute::COLOR,     Channel::CHANNEL_0): RGBA<u8>       color      [[comment("Color of the Vertex")]];
    }
};

struct Vertex {
    
    match (meshInfoSection.bufferLayoutSection.vertexBufferLayout[0].attributesLayout[0].buffer) {
        (Buffer::BUFFER_0): VertexBuffer0 vertexBuffer0[0];
        (Buffer::BUFFER_1): VertexBuffer1 vertexBuffer1[0];
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

struct VertexGroup {
    u8 boneIndex;
};

struct Mesh {
    Vertex      vertices;
    Face        faces;
    VertexGroup vertexGroups;
};

struct LOD {
    Mesh meshes;
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
    u32 vertexGroupDataSectionSize[dataSectionCount] [[comment("Size of the Vertex Group Data Section")]];
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
    u32   vertexAttributeCount                          [[comment("Number of Vertex Attributes")]];
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

struct VertexData {
    char vertexData[meshDescSection.vertexDataSectionSize[std::core::array_index()]];
};

struct FaceData {
    char faceData[meshDescSection.faceDataSectionSize[std::core::array_index()]];
};

struct VertexGroupData {
    char vertexGroupData[meshDescSection.vertexGroupDataSectionSize[std::core::array_index()]];
};

struct MeshDataSection {    
    SectionID meshDataSectionID; // 0x95DBDB69
    VertexData vertexData[meshDescSection.dataSectionCount];
    FaceData faceData[meshDescSection.dataSectionCount];
    VertexGroupData vertexGroupData[meshDescSection.dataSectionCount];
    //Mesh meshes[meshInfoSection.subMeshCount];
    //VertexArray vertexArray;
};

Header header @ 0x00                                                                                         [[comment("Header containing File Information")]];
MeshDescSection meshDescSection @ (sizeof(header))                                                           [[comment("Section containing Mesh Descriptions")]];
MeshInfoSection meshInfoSection @ (sizeof(header) + header.meshDescSectionSize)                              [[comment("Section containing Mesh Information")]];
MeshDataSection meshDataSection @ (sizeof(header) + header.meshDescSectionSize + header.meshInfoSectionSize) [[comment("Section containing Mesh Data")]];