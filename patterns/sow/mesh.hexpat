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

enum BoneName : u32 {
    Null                    = 2293934055,
    pNull                   = 3098352119,
    Pelvis                  = 2861856577,
    Torso_Base              = 1297833140,
    Torso                   = 851855475,
    Upper_Torso             = 3946131511,
    Spine4_joint            = 2062824752,
    Neck                    = 2280412807,
    Head                    = 1918468904,
    L_Shoulder              = 864875954,
    L_Armu                  = 1485615219,
    L_Arml                  = 1485615210,
    L_Hand                  = 2609352201,
    L_Thumb1                = 1344538152,
    L_Thumb2                = 1344538153,
    L_Thumb3                = 1344538154,
    L_Index1                = 2310456012,
    L_Index2                = 2310456013,
    L_Index3                = 2310456014,
    L_Middle1               = 2536197245,
    L_Middle2               = 2536197246,
    L_Middle3               = 2536197247,
    L_Ring1                 = 2209318066,
    L_Ring2                 = 2209318067,
    L_Ring3                 = 2209318068,
    L_Pinky1                = 1465773483,
    L_Pinky2                = 1465773484,
    L_Pinky3                = 1465773485,
    L_Wrist                 = 2194093645,
    L_WeaponOffset          = 3856893505,
    L_Weapon                = 267331182,
    L_Forearm               = 2437334694,
    L_Bicep                 = 1395607981,
    L_ArmuX                 = 3775753453,
    L_ShoulderX             = 252051990,
    L_ShoulderPad           = 1809879177,
    L_SPadX                 = 3655141214,
    L_SPadOverride          = 3262987526,
    R_Shoulder              = 1741693372,
    R_Armu                  = 2219670845,
    R_Arml                  = 2219670836,
    R_Hand                  = 3343407827,
    R_Thumb1                = 3338714514,
    R_Thumb2                = 3338714515,
    R_Thumb3                = 3338714516,
    R_Index1                = 9665078,
    R_Index2                = 9665079,
    R_Index3                = 9665080,
    R_Middle1               = 1233238531,
    R_Middle2               = 1233238532,
    R_Middle3               = 1233238533,
    R_Ring1                 = 2496572888,
    R_Ring2                 = 2496572889,
    R_Ring3                 = 2496572890,
    R_Pinky1                = 3459949845,
    R_Pinky2                = 3459949846,
    R_Pinky3                = 3459949847,
    R_Wrist                 = 2481348467,
    R_WeaponOffset          = 1882700171,
    R_Weapon                = 2261507544,
    R_Forearm               = 1134375980,
    R_Bicep                 = 1682862803,
    R_ArmuX                 = 4063008275,
    R_ShoulderX             = 2888374780,
    R_ShoulderPad           = 405674191,
    R_SPadX                 = 3942396036,
    R_SPadOverride          = 1288794192,
    Scabbard_Joined         = 2881813277,
    dagger_sheath_back      = 621773628,
    dagger_sheath_back_NB1  = 4084043262,
    Memento_0               = 27350910,
    Memento_1               = 27350911,
    Memento_2               = 27350912,
    Memento_3               = 27350913,
    Dagger_Sheath           = 2955995281,
    scabbard_back           = 670505491,
    scabbard_back_NB        = 672867151,
    L_Legu                  = 1422362969,
    L_Legl                  = 1422362960,
    L_Foot                  = 1068873872,
    L_Toe                   = 3270432200,
    L_Thigh                 = 2066366852,
    Ls_loinCloth_F_01       = 2281032108,
    Ls_loinCloth_F_02       = 2281032109,
    Ls_loinCloth_B_01       = 3471393168,
    Ls_loinCloth_B_02       = 3471393169,
    R_Legu                  = 2156418595,
    R_Legl                  = 2156418586,
    R_Foot                  = 1802929498,
    R_Toe                   = 887734414,
    R_Thigh                 = 2353621674,
    Rs_loinCloth_B_01       = 2120514710,
    Rs_loinCloth_B_02       = 2120514711,
    Rs_loinCloth_F_01       = 930153650,
    Rs_loinCloth_F_02       = 930153651,
    L_loinCloth_F_01        = 1572053519,
    L_loinCloth_F_02        = 1572053520,
    L_loinCloth_F_03        = 1572053521,
    L_loinCloth_F_04        = 1572053522,
    L_loinCloth_B_01        = 2762414579,
    L_loinCloth_B_02        = 2762414580,
    L_loinCloth_B_03        = 2762414581,
    L_loinCloth_B_04        = 2762414582,
    R_loinCloth_F_01        = 2654840825,
    R_loinCloth_F_02        = 2654840826,
    R_loinCloth_F_03        = 2654840827,
    R_loinCloth_F_04        = 2654840828,
    R_loinCloth_B_01        = 3845201885,
    R_loinCloth_B_02        = 3845201886,
    R_loinCloth_B_03        = 3845201887,
    R_loinCloth_B_04        = 3845201888,
    Belt_1                  = 4010709185,
    Belt_2                  = 4010709186,
    Belt_3                  = 4010709187,
    aimer                   = 3020092226,
    attach                  = 1261444213,
    attachModel             = 2661824188,
    IK_LHand                = 3169140735,
    IK_RHand                = 786442949,
    IK_LFoot                = 1628662406,
    IK_RFoot                = 3540931916,
    centerofmass            = 722797352,
    Combat_Aimer            = 44923816,
    ClothCollider           = 1149942854,
    World_Ground            = 1706522707,
    Camera                  = 42530773,
    Aim_Camera              = 1510913398,
    FaceCam                 = 1669885178,
    cam01                   = 1743290448,
    cam02                   = 1743290449,
    cam01Aim                = 2908956061,
    cam02Aim                = 3685107620,
};

enum UVFormat : u32 {
    UVArray52A = 0x00000000, // Vertex16 = 48 Bytes | Vertex24 = 52 Bytes
    UVArray56A = 0x00000001, // Vertex16 = 44 Bytes | Vertex24 = 56 Bytes
    UVArray48A = 0x00000002, //                     | Vertex24 = 48 Bytes
    UVArray44A = 0x00000003, //                     | Vertex24 = 44 Bytes
    UVArray52B = 0x00000004, //                     | Vertex24 = 52 Bytes
    UVArray48B = 0x00000005, //                     | Vertex24 = 48 Bytes
};

struct MatAssignment {
    s32 model;
    s32 mesh;   // Constant referenced by meshMatIndices
    s32 mat;
    s32 unk;    // Constant referenced by unkMatIndices
};

struct MeshInfo {
    u32 vertSecSize;
    u32 faceSecSize;
    u32 skinSecSize;
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
    UVFormat UVFormat;
};

// Affects Model LODs Vertex Positions, Bone Weights, UVs, Normals, and Face Visibility
struct ModelLodSettings {
    u32 unknownCount;
    u8  unknownByte1[unknownCount];
    u8  unknownByte2[unknownCount];
    u8  unknownByte3[unknownCount];
    u8  unknownByte4[unknownCount];
};

struct Bone {
    BoneName boneName;
    s16 boneIndex;
    u16 boneChild;
    float a11, a12, a13, a14;
    float a21, a22, a23, a24;
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

struct UVArray44 {
    UV01;
    padding[36];
    u32 checkSize;
    
    if (checkSize != 0xFFFFFFFF)
        std::error("Wrong size");
};

struct UVArray48 {
    UV01;
    padding[40];
    u32 checkSize;
    
    if (checkSize != 0xFFFFFFFF)
        std::error("Wrong size");
};

struct UVArray52 {
    UV01;
    padding[44];
    u32 checkSize;
    
    if (checkSize != 0xFFFFFFFF)
        std::error("Wrong size");
};

struct UVArray56 {
    UV01;
    padding[48];
    u32 checkSize;
    
    if (checkSize != 0xFFFFFFFF)
        std::error("Wrong size");
};

struct UVArray58 {
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
    
    u32 modelLodCount;
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
    
    u32 modelLodSectionID; // 0x37D749A6
    ModelLodSettings modelLodSettings[modelLodCount]; // Affects Model LODs Vertex Positions, Bone Weights, UVs, Normals, and Face Visibility
    
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