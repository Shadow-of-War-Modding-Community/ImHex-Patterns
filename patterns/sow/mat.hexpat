#pragma description Shadow of War MAT File
#pragma MIME sow/mat

import std.string;

enum Type : u32 {
    VECTOR3F32 =     2,
    VECTOR4F32 =     3,
    NUMBER     =     4,
    FLOAT      =     5,
    BOOLEAN    =     6,
    STRING     =     8,
    VECTOR2F32 =    11,
    TEXTURE    = 65537,
};

struct Vector2f {
    float X;
    float Y;
} [[inline]];

struct Vector3f {
    float X;
    float Y;
    float Z;
} [[inline]];

struct Vector4f {
    float X;
    float Y;
    float Z;
    float W;
} [[inline]];

struct Number {
    u32 Number;
} [[inline]];

struct Float {
    float Float;
} [[inline]];

struct Boolean {
    bool Bool;
} [[inline]];

struct Color {
    float Red   [[color("FF0000")]];
    float Green [[color("00FF00")]];
    float Blue  [[color("0000FF")]];
} [[inline]];

struct String {
    char String[];
} [[inline]];

struct Texture {
    char String[];
} [[inline]];

struct Header {
    char magic[4]; // "LTMI"
    u32 version;
    u32 shaderID;
    u32 propertyDataSize;
    u16 propertyCount1;
    u16 propertyCount2;
    u32 shaderDataSize;
    u32 unknownSize;
    u16 strlen;
    char shader[strlen];
};

struct Property {
    Type type;
    u16 strlen;
    char name[strlen];
    u32 offset;

    match (type) {
        (Type::VECTOR2F32): Vector2f @ sizeof(header) + offset;
        (Type::VECTOR3F32):
            if (!std::string::starts_with(name, "k_c")) Vector3f @ sizeof(header) + offset;
            else if (std::string::starts_with(name, "k_c")) Color @ sizeof(header) + offset;
        (Type::VECTOR4F32): Vector4f @ sizeof(header) + offset;
        (Type::NUMBER): Number @ sizeof(header) + offset;
        (Type::FLOAT): Float @ sizeof(header) + offset;
        (Type::BOOLEAN): Boolean @ sizeof(header) + offset;
        (Type::STRING): String @ sizeof(header) + offset;
        (Type::TEXTURE): String @ sizeof(header) + offset;
    }

} [[name(name)]];

Header header @ 0x0;
Property properties[header.propertyCount1 + header.propertyCount2] @ sizeof(header) + header.propertyDataSize;