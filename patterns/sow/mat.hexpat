#pragma description Shadow of War MAT File
#pragma MIME sow/mat

import std.string;
import hex.core;
import std.fxpt;

enum Type : u32 {
    FLOAT3 =     2,
    FLOAT4 =     3,
    INT32  =     4,
    FLOAT  =     5,
    UINT32 =     6,
    STRING =     8,
    FLOAT2 =    11,
    PATH   = 65537,
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
    u16  propertyCount1;
    u16  propertyCount2;
    u32  shaderDataSize;
    u32  unknownSize;
    u16  shaderLength;
    char shader[shaderLength];
};

struct Property {
    Type type;
    u16  nameLength;
    char name[nameLength];
    u32  offset;

    match (type) {
        (Type::FLOAT2):
            if (std::string::starts_with(name, "k_v")) Vector2<float> vector @ sizeof(header) + offset;
            else Vector2<float> vector @ sizeof(header) + offset;
        (Type::FLOAT3): {
            if (std::string::starts_with(name, "k_v")) {
                if (std::string::ends_with(name, "SpecularTint")) SpecularTint specular @ sizeof(header) + offset;
                else Vector3<float> vector @ sizeof(header) + offset;
            }
            else if (std::string::starts_with(name, "k_c")) RGB<float> color @ sizeof(header) + offset [[name("color##xx")]];
            else Vector3<float> vector @ sizeof(header) + offset;
        }
        (Type::FLOAT4):
            if (std::string::starts_with(name, "k_v")) Vector4<float> vector @ sizeof(header) + offset;
            else Vector4<float> vector @ sizeof(header) + offset;
        (Type::INT32):
            if (std::string::starts_with(name, "k_n")) s32 number @ sizeof(header) + offset;
            else s32 int32 @ sizeof(header) + offset;
        (Type::FLOAT):
            if (std::string::starts_with(name, "k_f")) float floatingPoint @ sizeof(header) + offset [[name("float")]];
            else float floatingPoint @ sizeof(header) + offset [[name("float")]];
        (Type::UINT32):
            if (std::string::starts_with(name, "k_b")) bool boolean @ sizeof(header) + offset;
            else u32 uint32 @ sizeof(header) + offset;
        (Type::STRING):
            if (std::string::starts_with(name, "Surface")) String surface @ sizeof(header) + offset;
            else String string @ sizeof(header) + offset;
        (Type::PATH): {
            if (std::string::starts_with(name, "t")) String texture @ sizeof(header) + offset;
            else String path @ sizeof(header) + offset;
            hex::core::add_virtual_file(texture.data, this); // Check the "Virtual Filesystem" tab at the Console
        }
    }

} [[name(name)]];

Header   header @ 0x0;
Property properties[header.propertyCount1 + header.propertyCount2] @ sizeof(header) + header.propertyDataSize;