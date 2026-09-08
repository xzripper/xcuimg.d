/*  xcuimg.d by Evan / https://github.com/xzripper

    Simple library for loading/decoding images and other things based on stb_image.h
    Use XCUImage.d for a high-level implementation. */

module xcuimg.XCUImageDWrapper;

import core.stdc.stdio : FILE;

extern(C) {
    ubyte* xcu_load_image(const char* filename, int* width, int* height, int* channels, int desired_channels);
    ubyte* xcu_load_image_from_memory(const ubyte* buffer, int len, int* x, int* y, int* channels_in_file, int desired_channels);
    ubyte* xcu_load_image_from_file(FILE* file, int* x, int* y, int* channels_in_file, int desired_channels);

    int xcu_image_info(const char* filename, int* x, int* y, int* channels);
    int xcu_image_info_from_memory(const ubyte* buffer, int len, int* x, int* y, int* channels);
    int xcu_image_info_from_file(FILE* file, int* x, int* y, int* channels);

    int xcu_image_is_hdr(const char* filename);
    int xcu_image_is_hdr_from_memory(const ubyte* buffer, int len);
    int xcu_image_is_hdr_from_file(FILE* file);

    void xcu_image_free(void* image);

    void xcu_set_flip_vertically_on_load(int flag);

    char* xcu_get_error();

    void xcu_set_unpremultiply_on_load(int flag);

    void xcu_convert_iphone_png_to_rgb(int flag);
}
