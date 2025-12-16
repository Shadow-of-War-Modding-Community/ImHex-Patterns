#pragma description Shadow of War FXO File
#pragma MIME sow/fxo

import type.types.c;
import std.mem;
import std.core;
import std.string;

using String = std::string::NullString;
using SizedString<T> = std::string::SizedString<T>;


//================================
// Utility functions and types
//================================

fn relative_to_parent(auto offset) {
    return addressof(parent.parent);
};

fn relative_to_parent_of_parent(auto offset) {
    return addressof(parent.parent.parent);
};

fn format_part(ref auto part) {
    return part.Header.Magic;
};

fn format_element(ref auto element) {
    return element.SemanticName;
};

fn format_pattern_scanner(ref auto scanner) {
    return typenameof(scanner.pattern);
};

fn format_pattern_scanner_entries(ref auto scanner) {
    return typenameof(scanner.pattern) + '[' + std::string::to_string(std::core::array_index()) + ']';
};

struct PatternScanner<auto MAGIC, T> {
    u32 test = std::mem::read_unsigned($, 4);
    if (test != u32(MAGIC)) {
        $ += 1;
        continue;
    }
    T pattern @ $ [[inline]];
    $ += sizeof(pattern);
};


//=====================================
// Types related to the DXBC format
//=====================================
namespace DXBC {

    enum SystemValueType : uint32_t {
        UNDEFINED                     = 0,
        POSITION                      = 1,
        CLIP_DISTANCE                 = 2,
        CULL_DISTANCE                 = 3,
        RENDER_TARGET_ARRAY_INDEX     = 4,
        VIEWPORT_ARRAY_INDEX          = 5,
        VERTEX_ID                     = 6,
        PRIMITIVE_ID                  = 7,
        INSTANCE_ID                   = 8,
        IS_FRONT_FACE                 = 9,
        SAMPLE_INDEX                  = 10,
        FINAL_QUAD_EDGE_TESSFACTOR    = 11,
        FINAL_QUAD_INSIDE_TESSFACTOR  = 12,
        FINAL_TRI_EDGE_TESSFACTOR     = 13,
        FINAL_TRI_INSIDE_TESSFACTOR   = 14,
        FINAL_LINE_DETAIL_TESSFACTOR  = 15,
        FINAL_LINE_DENSITY_TESSFACTOR = 16,
        BARYCENTRICS                  = 23,
        SHADINGRATE                   = 24,
        CULLPRIMITIVE                 = 25,
        TARGET                        = 64,
        DEPTH                         = 65,
        COVERAGE                      = 66,
        DEPTH_GREATER_EQUAL           = 67,
        DEPTH_LESS_EQUAL              = 68,
        STENCIL_REF                   = 69,
        INNER_COVERAGE                = 70,
    };

    enum ComponentType : uint32_t {
        Unknown = 0,
        UInt32  = 1,
        SInt32  = 2,
        Float32 = 3,
        UInt16  = 4,
        SInt16  = 5,
        Float16 = 6,
        UInt64  = 7,
        SInt64  = 8,
        Float64 = 9,
    };
    
    enum ShaderType : uint16_t {
        PIXEL_SHADER    = 0,
        VERTEX_SHADER   = 1,
        GEOMETRY_SHADER = 2,
        HULL_SHADER     = 3,
        DOMAIN_SHADER   = 4,
        COMPUTE_SHADER  = 5,
        RESERVED0       = 0xFFF0,
    };
    
    bitfield Version {
        Minor : 4;
        Major : 4;
    };
    
    struct SignatureElement {
        String*         SemanticName : uint32_t [[pointer_base("relative_to_parent_of_parent"), comment("Name of the semantic.")]];
        uint32_t        SemanticIndex           [[comment("Index of the semantic.")]];
        SystemValueType SystemValueType         [[comment("A predefined system value, or UNDEFINED if not applicable.")]];
        ComponentType   ComponentType           [[comment("Scalar type (e.g. uint, float, etc.).")]];
        uint32_t        Register                [[comment("Register index.")]];
        uint8_t         Mask                    [[comment("Mask to indicate which components of the register are used (combination of D3D10_COMPONENT_MASK values).")]];
        uint8_t         ReadWriteMask           [[comment("Mask to indicate whether a given component is never written (if this is an output signature) or always read (if this is an input signature). (combination of D3D_MASK_* values).")]];
        uint8_t         Stream                  [[comment("Stream index.")]];
        uint8_t         MinPrecision            [[comment("Minimum desired interpolation precision.")]];
    } [[format("format_element")]];
    
    struct Header {
        char     Magic[4]     [[comment("Four character code (magic number) with the value \"DXBC\" to denote the file format.")]]; // "DXBC"
        uint8_t  FileHash[16] [[comment("A 128-bit hash computed with a proprietary algorithm and encoded in the binary by a bytecode validator.")]];
        uint16_t MajorVersion [[comment("Major version number of the file format.")]];
        uint16_t MinorVersion [[comment("Minor version number of the file format.")]];
        uint32_t FileSize     [[comment("Total size of the file, including this header.")]];
        uint32_t PartCount    [[comment("Number of parts contained in this file.")]];
    } [[inline]];

    // Stores the input signature for Shader Model 5 and earlier
    struct ISGN {
        uint32_t         ElementCount;
        uint32_t         Unknown;
        SignatureElement Elements[ElementCount];
        padding[parent.parent.Header.Size - sizeof(this)];
    };
    
    // Stores the output signature for Shader Model 5 and earlier
    struct OSGN {
        uint32_t         ElementCount;
        uint32_t         Unknown;
        SignatureElement Elements[ElementCount];
        padding[parent.parent.Header.Size - sizeof(this)];
    };
    
    // Stores the compiled DXBC bytecode
    struct SHEX {
        Version    Version;
        uint8_t    Unused;
        ShaderType ShaderType;
        uint32_t   SizeInDWORD;
        uint8_t    Instructions[parent.parent.Header.Size - sizeof(this)];
    };
    
    namespace Part {
    
        struct Header {
            char     Magic[4];
            uint32_t Size;
        };
        
        struct Data {
            match (parent.Header.Magic) {
                ("ISGN"): ISGN    Data [[inline]];
                ("OSGN"): OSGN    Data [[inline]];
                ("SHEX"): SHEX    Data [[inline]];
                (_):      uint8_t Data[parent.Header.Size];
            }
            padding[parent.Header.Size - sizeof(this)];
        };
    
    } // namespace Part
    
    struct Part {
        Part::Header Header [[inline]];
        Part::Data   Data   [[inline]];
    } [[format("format_part")]];

} // namespace DXBC


// DirectX Container that stores compuiled shaders targeting the DirectX runtime
struct DXBC {
    DXBC::Header Header;
    uint32_t     Offsets[Header.PartCount];
    DXBC::Part   Parts[Header.PartCount];
};


//=====================================
// Types related to the SRHR format
//=====================================
namespace SRHR {

    namespace DX11 {
    
        struct Header {
            char     Magic[4]; // "DX11"
            uint32_t Version;
            uint32_t ShaderID;
            uint16_t ShaderCount;
            uint8_t  ShaderFlags[12];
            uint8_t  Unknown[29];
        };
    
    } // namespace DX11

    struct HeaderOffset {
        char     Magic[4];
        uint32_t Offset;
        
        if (Magic == "DX11")
            break;
    };

    struct Header {
        char         Magic[4]; // "SRHR"
        uint32_t     Version;
        uint32_t     HeaderCount;
        HeaderOffset HeaderOffsets[HeaderCount];
        DX11::Header DX11Header;
        
        if (DX11Header.Magic != "DX11" && DX11Header.Version != 2)
            return;
    };


    SRHR::Header                 Header @ $;
    // Relying on a PatternScanner to locate the DXContainers until I know how to parse the rest of the file
    PatternScanner<"DXBC", DXBC> DXContainers[while(!std::mem::eof())] @ $ [[format_entries("format_pattern_scanner_entries")]];

} // namespace SRHR


//=====================================
// WIP types for the constant buffers
//=====================================

struct CBuffer_Header {
    SizedString<uint16_t> Name;
    uint32_t Hash;
    uint16_t Flags;
    uint8_t  VariableCount;
    uint8_t  Unknown;
    uint8_t  Size;
};

struct CBuffer {
    CBuffer_Header Header;
    uint8_t        Data[Header.Size];
};

struct RDEF {
    SizedString<uint16_t> CompileArguments;
    uint8_t CBufferCount;
    CBuffer CBuffers[CBufferCount];
};


// talion_armor.fxo
//RDEF rdef_at_0x18F @ 0x18F;
//RDEF rdef_at_0x1ED6 @ 0x1ED6;

// occlusionquery.fxo
//RDEF rdef_at_0xA7 @ 0xA7;

// customparticle_clearindirectbuffer.fxo
//RDEF rdef_at_0x4B @ 0x4B;