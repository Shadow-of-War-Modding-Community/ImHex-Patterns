#pragma description Shadow of War ARCHIVEPATCHLOOSEFILES File
#pragma MIME sow/archivepatchloosefiles

import hex.core;

struct File {
    u32  hash;
    u32  offset;
    char path[] @ addressof(parent.stringTable[offset]);
    hex::core::add_virtual_file(path, this); // Check the "Virtual Filesystem" tab at the Console
} [[name(path)]];

struct Header {
    u32 version;
    u32 stringTableSize;
};

struct FileSection {
    char stringTable[header.stringTableSize];
    u32  fileCount;
    File files[fileCount];
};

Header      header      @ 0x00;
FileSection fileSection @ $;