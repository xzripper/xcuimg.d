#define STB_IMAGE_IMPLEMENTATION

#include "stb_image.h"

unsigned char* xcu_load_image(const char *filename, int* x, int* y, int* channels, int desired_channels) { return stbi_load(filename, x, y, channels, desired_channels); }
unsigned char* xcu_load_image_from_memory(const stbi_uc *buffer, int len, int *x, int *y, int *channels_in_file, int desired_channels) { return stbi_load_from_memory(buffer, len, x, y, channels_in_file, desired_channels); }
unsigned char* xcu_load_image_from_file(FILE *file, int *x, int *y, int *channels_in_file, int desired_channels) { return stbi_load_from_file(file, x, y, channels_in_file, desired_channels); }

int xcu_image_info(const char *filename, int *x, int *y, int *channels) { return stbi_info(filename, x, y, channels); }
int xcu_image_info_from_memory(const stbi_uc *buffer, int len, int *x, int *y, int *channels) { return stbi_info_from_memory(buffer, len, x, y, channels); }
int xcu_image_info_from_file(FILE *file, int *x, int *y, int *channels) { return stbi_info_from_file(file, x, y, channels); }

int xcu_image_is_hdr(const char *filename) { return stbi_is_hdr(filename); }
int xcu_image_is_hdr_from_memory(const stbi_uc *buffer, int len) { return stbi_is_hdr_from_memory(buffer, len); }
int xcu_image_is_hdr_from_file(FILE *file) { return stbi_is_hdr_from_file(file); }

void xcu_image_free(void *image) { stbi_image_free(image); }

void xcu_set_flip_vertically_on_load(int flag) { stbi_set_flip_vertically_on_load(flag); }

const char* xcu_get_error(void) { return stbi_failure_reason(); }

void xcu_set_unpremultiply_on_load(int flag) { stbi_set_unpremultiply_on_load(flag); }

void xcu_convert_iphone_png_to_rgb(int flag) { stbi_convert_iphone_png_to_rgb(flag); }
