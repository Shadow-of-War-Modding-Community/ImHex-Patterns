#pragma description Shadow of War FXP File

import std.mem;

enum ClientFX : str {
    StandardGPUParticleSystem,
    DynaLight,
    Wind,
    Rumble,
    Sound,
    CameraShake,
    MaterialController,
    Model,
    ParticleSystem,
    Sprite,
    DecalLight,
};

struct LTFX_Header {
    char    LTFX_Magic[0x04];
    u32     LTFX_Version;
};

struct GADB_Header {
    char    GADB_Magic[0x04];
    u32     GADB_Version;
    u32     FXDB_Size;
    u32     FXDB_Entries;
    u32     unknown1;
    u32     unknown2;
    u32     unknown3;
    u32     FXDB_BlockCount;
    u32     unknown5;
    u32     unknown6;
    u32     unknown7;
    u16     unknown8;
};

struct FXDB_Section {
    char    type[];
    u8      space[];
    char    propertyStrings[];
    u8      propertyValues[];
};

struct ClientFX_StandardGPUParticleSystem {
    char    ClientFX_StandardGPUParticleSystem[0x22];
    u16     padding1;
    u32     unknown1;
    char    HighDetail[0x0A];
    u16     padding2;
    char    Translucent[0x0B];
    u8      unknown3[0x0D];
    char    FaceCamera[0x0A];
    u8      unknown4[0x02];
    char    BeginFrame[0x0A];
    u8      unknown5[0xD6];
    char    curse_smoke_glow[0x3A];
    u8      unknown6[0x4A];
    char    Follow[0x06];
    u8      unknown7[0x02];
    char    Smoke[0x05];
    u8      unknown8[0x73];
    char    Sphere[0x06];
    u8      unknown9[0x02];
    char    RandomStatic[0x0C];
    u8      unknown10[0x98];
    char    Standard[0x08];
    u8      unknown11[0x44];
    char    FlipURandom[0x0B];
    u8      nknown12[0x39];
    char    Quad[0x04];
    u8      unknown13[0x04];
};

struct ClientFX_DynaLight {
    char    ClientFX_DynaLight[0x12];
    u8      unknown1[0x56];
    char    Never[];
    u8      unknown2[2];
    char    Low[];
    char    Point[];
    u8      unknown3[102];
};

struct ClientFX_Wind {
    char    ClientFX_Wind[0x0D];
    u8      unknown1[7];
    char    Impact_L1[];
    u8      unknown2[78];
};

struct ClientFX_Rumble {
    char    ClientFX_Rumble[0x0F];
    u8      unknown1[23];
    char    HDLinear[];
    u8      unknown2[1];
    char    Presentation[];
    u8      unknown3[135];
    char    Player[];
    u8      unknown4[1];
};

struct ClientFX_Sound {
    char    ClientFX_Sound[0x0E];
    u8      unknown1[0x06];
    char    string1[0x16];
    u8      unknown2[0x06];
    char    string2[0x17];
    u8      unknown3[0x01];
};

struct ClientFX_CameraShake {
    char    ClientFX_CameraShake[0x14];
    u8      unknown1[0x2C];
    char    string1[0x05];
    u8      unknown2[0x17];
    char    string2[0x06];
    u8      unknown3[0x6E];
};

struct ClientFX_MaterialController {
    char    ClientFX_MaterialController[0x1B];
    u8      unknown1[0x19];
    char    string1[0x09];
    u8      unknown2[0x03];
    char    string2[0x0D];
    u8      unknown3[0x03];
    char    string3[0x0E];
    u8      unknown4[0x02];
    char    string4[0x0F];
    u8      unknown5[0x01];
    char    string5[0x10];
    u8      unknown6[0x04];
    char    string6[0x11];
    u8      unknown7[0x4F];
    char    string7[0x3E];
    u8      unknown8[0x06];
    char    string8[0x09];
    u8      unknown9[0x03];
    char    string9[0x0C];
    u8      unknown10[0x04];
    char    string10[0x09];
    u8      unknown11[0x67];
    char    string11[0x29];
    u8      unknown12[0x03];
};

struct ClientFX_Model {
    char    ClientFX_Model[0x0E];
    u8      unknown1[0x12A];
    char    string1[0x2A];
    u8      unknown2[0x02];
};

struct ClientFX_ParticleSystem {
    char    ClientFX_ParticleSystem[0x17];
    u8      unknown1[0x05];
    char    string1[0x06];
    u8      unknown2[0x16];
    char    string2[0x05];
    u8      unknown3[0x2B];
    char    string3[0x06];
    u8      unknown4[0x01];
    char    string4[0x05];
    u8      unknown5[0x01];
    char    string5[0x05];
    u8      unknown6[0x2A];
    char    string6[0x2D];
    u8      unknown7[0x4B];
    char    string7[0x08];
    u8      unknown8[0x4C];
    char    string8[0x0A];
    u8      unknown9[0x7E];
};

struct ClientFX_Sprite {
    char    ClientFX_Sprite[0x0F];
    u8      unknown1[0x05];
    char    string1[0x04];
    u8      unknown2[0x04];
    char    string2[0x23];
    u8      unknown3[0xAD];
};

struct ClientFX_DecalLight {
    char    ClientFX_DecalLight[0x13];
    u8      unknown1[0x9D];
    char    string1[0x37];
    u8      unknown2[0x49];
};

struct FXDB_Data {
    char    FXDB_Magic[0x04];
    u32     padding1;
    char    FxGlobalProps[0x0D];
    u8      padding2[7];
    char    fxpFilePath[];
    ClientFX_StandardGPUParticleSystem @ 0x0000007A;
    ClientFX_DynaLight @ 0x000003FA;
    ClientFX_Wind @ 0x000004DA;
    ClientFX_Rumble @ 0x00000546;
    ClientFX_Sound @ 0x00000612;
    ClientFX_CameraShake @ 0x0000065A;
    ClientFX_MaterialController @ 0x0000072A;
    ClientFX_Model @ 0x0000090A;
    ClientFX_ParticleSystem @ 0x00000A6E;
    ClientFX_Sprite @ 0x00000C66;
    ClientFX_DecalLight @ 0x00000D52;
};

struct FXDB_Block {
    u32     unknown1;
    u32     unknown2;
    u8      unknown3;
    u8      unknown4;
    u8      unknown5;
    u16     unknown6;
    u16     unknown7;
};

struct FXDB_Block2 {
    u8      unknown1[0x18];
    u32     unknown2;
    u16     unknown3;
    u8      unknown4;
    u32     unknown5;
    u8      unknown6;
    u32     unknown7;
    u32     unknown8[19];
};

struct FXDB_Buffer {
    FXDB_Block FxGlobalProps[0x05];
    FXDB_Block StandardGPUParticleSystem[0x51];
    FXDB_Block DynaLight[0x26];
    FXDB_Block Wind[0x15];
    FXDB_Block Rumble[0x17];
    FXDB_Block Sound[0x12];
    FXDB_Block CameraShake[0x1F];
    FXDB_Block MaterialController[0x65];
    FXDB_Block Model[0x3A];
    FXDB_Block ParticleSystem[0x47];
    FXDB_Block Sprite[0x26];
    FXDB_Block DecalLight[0x1D];
    u64     unknown1;
    FXDB_Block2;
};

enum ClientFX_Block : u32 {
    block2 = 0x00000002, // 16 bytes
    block3 = 0x00000003, // 24 bytes
    block4 = 0x00000004, // 32 bytes
    block5 = 0x00000005, // 40 bytes
    block6 = 0x00000006, // 48 bytes
    block7 = 0x00000007, // 56 bytes
    block8 = 0x00000008, // 64 bytes
    block9 = 0x00000009, // 72 bytes
};

struct ClientFX_Block2 {
    ClientFX_Block[1];
    u32 data[]
};

struct ClientFX_Data {
    ClientFX_Block block;
    
    if (ClientFX_Block::block2) {
        u32 data[while(std::mem::read_unsigned($, 1) != block)];
    }
    else if (ClientFX_Block::block3) {
        u8 data[24];
    }
    else if (ClientFX_Block::block4) {
        u8 data[32];
    }
};

LTFX_Header LTFX_Header @ 0x00;
GADB_Header GADB_Header @ 0x08;
FXDB_Data FXDB_Data @ 0x36;
FXDB_Buffer FXDB_Buffer @ (0x36 + GADB_Header.FXDB_Size);
ClientFX_Data ClientFX_Data @ 0xDE;