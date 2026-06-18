#pragma description Shadow of War GAMEDB File
#pragma MIME sow/gamedb

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
    float x;
    float y;
} [[format("format_vector2")]];

fn format_vector2(ref auto vector2) {
    return std::format("({}, {})", vector2.x, vector2.y);
};

struct Vector3 {
    float x;
    float y;
    float z;
} [[format("format_vector3")]];

fn format_vector3(ref auto vector3) {
    return std::format("({}, {}, {})", vector3.x, vector3.y, vector3.z);
};

struct Vector4 {
    float x;
    float y;
    float z;
    float w;
} [[format("format_vector4")]];

fn format_vector4(ref auto vector4) {
    return std::format("({}, {}, {}, {})", vector4.x, vector4.y, vector4.z, vector4.w);
};

bitfield RecordLink {
    RecordIndex   : 20;
    CategoryIndex : 12;
};


// File Structures

struct Header {
    char     Magic[4];
    uint32_t Version;
    uint32_t ValueTableSize;
    uint32_t CategoryCount;
    uint32_t RecordCount;
    uint32_t StructureCount;
    uint32_t ValueCount;
    uint32_t AttributeCount;
    uint32_t UnknownSize;
    uint32_t Unknown;
    uint32_t HeaderSize;
} [[static, format("format_header")]];

fn format_header(ref auto header) {
    return std::format("{} {}", header.Magic, header.Version);
};

enum AttributeType : uint8_t {
    Invalid    =  0,
    Bool       =  1,
    Float      =  2,
    Int32      =  3,
    String     =  4,
    Enum       =  5,
    WString    =  6,
    Vector2    =  7,
    Vector3    =  8,
    Vector4    =  9,
    RecordLink = 10,
    Struct     = 11,
};

enum AttributeUsage : uint8_t {
    Default   = 0,
    File      = 1,
    Effect    = 2,
    Animation = 3,
};

bitfield AttributeFlags {
    AttributeType  Type  : 6;
    AttributeUsage Usage : 2;
} [[static]];

struct Attribute {
    uint32_t       Hash1;
    uint32_t       Hash2;
    uint8_t        Index1;
    uint8_t        Index2;
    AttributeFlags Flags;
    uint16_t       ValueCount;
    uint16_t       ValueIndex;
} [[static]];

struct AttributeValue {
    Attribute Attribute @ addressof(Attributes[parent.AttributeIndex]) [[inline]];
    if (Attribute.ValueCount) {
        match (Attribute.Flags.Type) {
            (AttributeType::Bool):       bool       Values[Attribute.ValueCount] @ addressof(parent.Values[Attribute.ValueIndex]);
            (AttributeType::Float):      float      Values[Attribute.ValueCount] @ addressof(parent.Values[Attribute.ValueIndex]);
            (AttributeType::Int32):      int32_t    Values[Attribute.ValueCount] @ addressof(parent.Values[Attribute.ValueIndex]);
            (AttributeType::String):     String     Values[Attribute.ValueCount] @ addressof(ValueTable) + parent.Values[Attribute.ValueIndex];
            (AttributeType::WString):    String     Values[Attribute.ValueCount] @ addressof(ValueTable) + parent.Values[Attribute.ValueIndex];
            (AttributeType::Enum):       String     Values[Attribute.ValueCount] @ addressof(ValueTable) + parent.Values[Attribute.ValueIndex];
            (AttributeType::Vector2):    Vector2    Values[Attribute.ValueCount] @ addressof(ValueTable) + parent.Values[Attribute.ValueIndex];
            (AttributeType::Vector3):    Vector3    Values[Attribute.ValueCount] @ addressof(ValueTable) + parent.Values[Attribute.ValueIndex];
            (AttributeType::Vector4):    Vector4    Values[Attribute.ValueCount] @ addressof(ValueTable) + parent.Values[Attribute.ValueIndex];
            (AttributeType::RecordLink): RecordLink Values[Attribute.ValueCount] @ addressof(parent.Values[Attribute.ValueIndex]);
        }
    }
};

struct Structure {
    uint16_t       ValueCount;
    uint8_t        AttributeCount;
    uint32_t       AttributeIndex;
    uint8_t        Unknown;
    uint32_t       Values[ValueCount];
    AttributeValue Attributes[AttributeCount];
};

struct Record {
    Pointer<String> Name;
    uint16_t        ValueCount;
    uint8_t         AttributeCount;
    uint32_t        AttributeIndex;
    uint8_t         Unknown;
    uint32_t        Values[ValueCount];
    AttributeValue  Attributes[AttributeCount];
} [[format("format_record")]];

fn format_record(ref auto record) {
    return record.Name;
};

struct Category {
    Pointer<String> Name;
    Pointer<String> Schema;
    Pointer<String> Category;
    uint32_t        StructureCount;
    uint32_t        RecordCount;
    uint32_t        Hash;
    Structure       Structures[StructureCount];
    Record          Records[RecordCount];
} [[format("format_category")]];

fn format_category(ref auto category) {
    return category.Name;
};

struct Database {
    Pointer<String> Name;
    uint32_t        CategoryCount;
    Category        Categories[50];
} [[format("format_database")]];

fn format_database(ref auto database) {
    return database.Name;
};

Header      Header @ 0x00;
SizedString FilePath @ $;
char        ValueTable[Header.ValueTableSize] @ $;
Attribute   Attributes[Header.AttributeCount] @ $;
Database    Database @ $;