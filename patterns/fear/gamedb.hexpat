#pragma description FEAR GAMEDB File
#pragma MIME fear/gamedb

#pragma pattern_limit 50000000
#pragma array_limit 50000000


// Imports

import type.types.c;
import std.io;


// Functions

fn relative_to_valuetable(u128 offset) {
    return addressof(ValueTable);
};


// Types

struct String {
    char data[];
} [[format("format_string")]];

struct WString {
    wchar_t data[];
} [[format("format_string")]];

struct SizedString {
    uint16_t size;
    char     data[size];
} [[format("format_string")]];

fn format_string(ref auto string) {
    return string.data;
};

struct Pointer<T> {
    T* offset : uint32_t [[pointer_base("relative_to_valuetable")]];
} [[format("format_pointer")]];

fn format_pointer(ref auto pointer) {
    return pointer.offset;
};

struct Vector2 {
    float x [[color("FF0000")]];
    float y [[color("00FF00")]];
} [[format("format_vector2")]];

fn format_vector2(ref auto vector2) {
    return std::format("({}, {})", vector2.x, vector2.y);
};

struct Vector3 {
    float x [[color("FF0000")]];
    float y [[color("00FF00")]];
    float z [[color("0000FF")]];
} [[format("format_vector3")]];

fn format_vector3(ref auto vector3) {
    return std::format("({}, {}, {})", vector3.x, vector3.y, vector3.z);
};

struct Vector4 {
    float x [[color("FF0000")]];
    float y [[color("00FF00")]];
    float z [[color("0000FF")]];
    float w [[color("FFFFFF")]];
} [[format("format_vector4")]];

fn format_vector4(ref auto vector4) {
    return std::format("({}, {}, {}, {})", vector4.x, vector4.y, vector4.z, vector4.w);
};


// File Structures

struct Header {
    char     Magic[4]; // GADB
    uint32_t Version;
    uint32_t ValueTableSize;
    uint32_t CategoryCount;
    uint32_t RecordCount;
    uint32_t AttributeCount;
    uint32_t ValueCount;
    
} [[static, format("format_header")]];

fn format_header(ref auto header) {
    return std::format("{} {}", header.Magic, header.Version);
};

enum AttributeType : uint32_t {
    Invalid    =  0,
    Bool       =  1,
    Float      =  2,
    Int32      =  3,
    String     =  4,
    WString    =  5,
    Vector2    =  6,
    Vector3    =  7,
    Vector4    =  8,
    RecordLink =  9,
    Struct     = 10,
};

enum AttributeUsage : uint32_t {
    Default   = 0,
    File      = 1,
    Effect    = 2,
    Animation = 3,
};

struct RecordLink {
    uint16_t RecordIndex;
    uint16_t CategoryIndex;
} [[static]];

struct Attribute {
    Pointer<String> Name;
    AttributeType   Type;
    AttributeUsage  Usage;
    uint32_t        ValueCount;
    match (Type) {
        (AttributeType::Bool):       uint32_t         Values[ValueCount];
        (AttributeType::Float):      float            Values[ValueCount];
        (AttributeType::Int32):      int32_t          Values[ValueCount];
        (AttributeType::String):     Pointer<String>  Values[ValueCount];
        (AttributeType::WString):    Pointer<WString> Values[ValueCount];
        (AttributeType::Vector2):    Pointer<Vector2> Values[ValueCount];
        (AttributeType::Vector3):    Pointer<Vector3> Values[ValueCount];
        (AttributeType::Vector4):    Pointer<Vector4> Values[ValueCount];
        (AttributeType::RecordLink): RecordLink       Values[ValueCount];
        (AttributeType::Struct):     uint32_t         Values[ValueCount];
    }
} [[static, format("format_entry")]];

struct Record {
    Pointer<String> Name;
    uint32_t        AttributeCount;
    Attribute       Attributes[AttributeCount];
} [[format("format_entry")]];

struct Category {
    Pointer<String> Name;
    uint32_t        RecordCount;
    Record          Records[RecordCount];
} [[format("format_entry")]];

struct Database {
    uint32_t CategoryCount;
    Category Categories[CategoryCount];
};

fn format_entry(ref auto entry) {
    return entry.Name;
};

Header   Header @ 0x00;
char     ValueTable[Header.ValueTableSize] @ $;
Database Database @ $;
