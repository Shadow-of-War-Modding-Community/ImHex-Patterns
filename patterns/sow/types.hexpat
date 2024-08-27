#pragma description Shadow of War TYPES File
#pragma once

import type.float16;
import type.color;

using float16 = u16 [[format("type::impl::format_float16")]];
using RGBA8 = type::RGBA8;

struct Vector2f {
    float x;
    float y;
};

struct Vector3f {
    float x;
    float y;
    float z;
};

struct Vector4f {
    float x;
    float y;
    float z;
    float W;
};

struct Vector4u8 {
    u8 x;
    u8 y;
    u8 z;
    u8 W;
};

struct Vector2u16 {
    u16 x;
    u16 y;
};

struct Vector4f16 {
    float16 x;
    float16 y;
    float16 z;
    float16 W;
};

struct Quaternion {
    float x;
    float y;
    float z;
    float w;
};