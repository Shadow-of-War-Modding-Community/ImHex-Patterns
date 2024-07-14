#pragma description Shadow of War MAT File
#pragma MIME sow/mat

import std.string;

enum Type : u32 {
    Vector2f = 0x0000000B,
    Vector3f = 0x00000002,
    Vector4f = 0x00000003,
    Number = 0x00000004,
    Float = 0x00000005,
    Boolean = 0x00000006,
    String = 0x00000008,
    Texture = 0x00010001,
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
        (Type::Vector2f): Vector2f @ sizeof(header) + offset;
        (Type::Vector3f):
            if (!std::string::starts_with(name, "k_c")) Vector3f @ sizeof(header) + offset;
            else if (std::string::starts_with(name, "k_c")) Color @ sizeof(header) + offset;
        (Type::Vector4f): Vector4f @ sizeof(header) + offset;
        (Type::Number): Number @ sizeof(header) + offset;
        (Type::Float): Float @ sizeof(header) + offset;
        (Type::Boolean): Boolean @ sizeof(header) + offset;
        (Type::String): String @ sizeof(header) + offset;
        (Type::Texture): String @ sizeof(header) + offset;
    }

} [[name(name)]];

Header header @ 0x0;
Property properties[header.propertyCount1 + header.propertyCount2] @ sizeof(header) + header.propertyDataSize;