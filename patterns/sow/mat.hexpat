#pragma description Shadow of War MAT File
#pragma MIME sow/mat

import std.string;
import hex.core;
import std.fxpt;

const u32 MAX_PROPERTY_COUNT = 128;

enum DataType : u16 {
    PATH   =  1,
    FLOAT3 =  2,
    FLOAT4 =  3,
    INT32  =  4,
    FLOAT  =  5,
    UINT32 =  6,
    STRING =  8,
    FLOAT2 = 11,
};

enum PropertyType : u8 {
    CONSTANT = 0,
    TEXTURE  = 1,
};

enum Usage : u8 {
    DEFAULT = 0,
};

struct Vector2<T> {
    T x;
    T y;
};

struct Vector3<T> {
    T x;
    T y;
    T z;
};

struct Vector4<T> {
    T x;
    T y;
    T z;
    T w;
};

struct SpecularTint {
    float metalness;
    float specularScale;
    float roughness;
};

struct String {
    char data[while(std::mem::read_unsigned($, sizeof(char)) != 0x00)];
    char null_terminator;
} [[sealed, format("std::string::impl::format_string"), transform("std::string::impl::format_string")]];

struct RGB<T> {
  T red   [[color("FF0000")]];
  T green [[color("00FF00")]];
  T blue  [[color("0000FF")]];
} [[static, hex::inline_visualize("color", std::fxpt::to_fixed(red, 8), std::fxpt::to_fixed(green, 8), std::fxpt::to_fixed(blue, 8), 1)]];

struct Header {
    char magic[4]; // "LTMI"
    u32  version;
    u32  shaderID;
    u32  propertyDataSize;
    u16  propertyCount1; // Dynamic sized properties (strings)
    u16  propertyCount2; // Static sized properties
    u32  shaderDataSize;
    u32  unknown;
    u16  shaderLength;
    char shader[shaderLength];
};

struct Property {
    DataType dataType;
    PropertyType propertyType;
    Usage usage;
    u16  nameLength;
    char name[nameLength];
    u32  offset;

    match (dataType) {
        (DataType::FLOAT2):
            if (std::string::starts_with(name, "k_v")) Vector2<float> vector @ addressof(propertyData[offset]);
            else Vector2<float> vector @ addressof(propertyData[offset]);
        (DataType::FLOAT3): {
            if (std::string::starts_with(name, "k_v")) {
                if (std::string::ends_with(name, "SpecularTint")) SpecularTint specular @ addressof(propertyData[offset]);
                else Vector3<float> vector @ addressof(propertyData[offset]);
            }
            else if (std::string::starts_with(name, "k_c")) RGB<float> color @ addressof(propertyData[offset]) [[name("color##xx")]];
            else Vector3<float> vector @ addressof(propertyData[offset]);
        }
        (DataType::FLOAT4):
            if (std::string::starts_with(name, "k_v")) Vector4<float> vector @ addressof(propertyData[offset]);
            else Vector4<float> vector @ addressof(propertyData[offset]);
        (DataType::INT32):
            if (std::string::starts_with(name, "k_n")) s32 number @ addressof(propertyData[offset]);
            else s32 int32 @ addressof(propertyData[offset]);
        (DataType::FLOAT):
            if (std::string::starts_with(name, "k_f")) float floatingPoint @ addressof(propertyData[offset]) [[name("float")]];
            else float floatingPoint @ addressof(propertyData[offset]) [[name("float")]];
        (DataType::UINT32):
            if (std::string::starts_with(name, "k_b")) bool boolean @ addressof(propertyData[offset]);
            else u32 uint32 @ addressof(propertyData[offset]);
        (DataType::STRING):
            if (std::string::starts_with(name, "Surface")) String surface @ addressof(propertyData[offset]);
            else String string @ addressof(propertyData[offset]);
        (DataType::PATH): {
            if (std::string::starts_with(name, "t")) String texture @ addressof(propertyData[offset]);
            else String path @ addressof(propertyData[offset]);
            hex::core::add_virtual_file(texture.data, this); // Check the "Virtual Filesystem" tab at the Console
        }
    }

} [[name(name)]];

Header   header @ 0x0;
const u32 propertyCount = header.propertyCount1 + header.propertyCount2;
if (propertyCount > MAX_PROPERTY_COUNT)
    return;

char     propertyData[header.propertyDataSize] @ $;
Property properties[header.propertyCount1 + header.propertyCount2] @ $;