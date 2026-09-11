/*  xcuimg.d by Evan / https://github.com/xzripper

    Simple library for loading/decoding images and other things based on stb_image.h
    Use XCUImageDWrapper.d for a low-level implementation. */

module xcuimg.XCUImage;

import core.stdc.stdio : FILE, ftell, fseek, rewind, SEEK_END, SEEK_SET;

import std.string : toStringz, fromStringz;

import std.stdio : File;

import xcuimg.XCUImageDWrapper;

enum XCUIMG_VERSION = "1.2";

enum IMAGE_MIN_CHANNELS = 1, IMAGE_MAX_CHANNELS = 4;

enum XCU_OK = "XCU_OK", XCU_INTERNAL = "XCU_INTERNAL", XCU_EMPTY = -1;

int XCURGBIDX( int p_ImgWidth, int p_LX, int p_LY, int p_Channels ) @safe @nogc
{
    return (p_LY * p_ImgWidth + p_LX) * p_Channels;
}

void REWIND_FPTR( FILE* p_File )
{
    rewind( p_File );
}

bool FSTREAM_AT_END( FILE* p_File ) {
    long t_CurrPos = ftell( p_File );

    fseek( p_File, 0, SEEK_END );

    long t_LastPos = ftell( p_File );

    fseek( p_File, t_CurrPos, SEEK_SET );

    return t_CurrPos == t_LastPos;
}

struct XCUImage
{
private:
    string m_ImgPath, m_ImgLoadError = XCU_OK;

    int m_ImgWidth = XCU_EMPTY,
        m_ImgHeight = XCU_EMPTY,
        m_ImgChannels = XCU_EMPTY,
        m_ImgDesiredChannels = XCU_EMPTY;

    ubyte* m_ImgData = null;

    bool m_Released = false;

public:
    string GetImagePath() @safe @nogc { return m_ImgPath; }

    string GetImageLoadError() @safe @nogc { return m_ImgLoadError; }

    int GetImageWidth() @safe @nogc { return m_ImgWidth; }
    int GetImageHeight() @safe @nogc { return m_ImgHeight; }

    int GetImageChannels() @safe @nogc { return m_ImgChannels; }

    int GetImageDesiredChannels() @safe @nogc { return m_ImgDesiredChannels; }

    ubyte* GetImageData() @safe @nogc { return m_ImgData; }

    bool IsReleased() @safe @nogc { return m_Released; }

    int[][] GetImagePixelArray()
    {
        int[][] t_RGBA;

        foreach ( int t_ImgY; 0..m_ImgHeight )
        {
            foreach ( int t_ImgX; 0..m_ImgWidth )
            {
                int t_RGBIdx = XCURGBIDX( m_ImgWidth, t_ImgX, t_ImgY, m_ImgDesiredChannels );

                int[] t_RGBA1 = new int[m_ImgDesiredChannels];

                for ( int t_IterChannel = 0; t_IterChannel <= m_ImgDesiredChannels - 1; ++t_IterChannel )
                {
                    t_RGBA1[t_IterChannel] = m_ImgData[t_RGBIdx + t_IterChannel];
                }

                t_RGBA ~= t_RGBA1;
            }
        }

        return t_RGBA;
    }

    void Free()
    {
        assert( m_ImgData !is null && !m_Released, "Image is already freed" );

        xcu_image_free( m_ImgData );

        m_Released = true;
    }
}

struct XCUImageInfo
{
private:
    string m_ImgPath;

    bool m_InfoRetrieved;

    int m_ImgWidth = XCU_EMPTY,
        m_ImgHeight = XCU_EMPTY,
        m_ImgChannels = XCU_EMPTY;

public:
    string GetImagePath() @safe @nogc { return m_ImgPath; }

    bool IsRetrieved() @safe @nogc { return m_InfoRetrieved; }

    int GetImageWidth() @safe @nogc { return m_ImgWidth; }
    int GetImageHeight() @safe @nogc { return m_ImgHeight; }

    int GetImageChannels() @safe @nogc { return m_ImgChannels; }
}

private ubyte* _UBytePointer( void[] p_ImageByteBuffer ) @nogc
{
    return (cast(ubyte[]) p_ImageByteBuffer).ptr;
}

private string _TranslateError( char* p_STBIERR ) @nogc
{
    return cast(string) fromStringz( p_STBIERR );
}

XCUImage XCULoadImage( string p_FileName, int p_DesiredChannels )
{
    assert( 
        p_DesiredChannels >= IMAGE_MIN_CHANNELS && p_DesiredChannels <= IMAGE_MAX_CHANNELS, 
        "Invalid desired channels value");

    XCUImage t_LImage;

    t_LImage.m_ImgPath = p_FileName;

    t_LImage.m_ImgDesiredChannels = p_DesiredChannels;

    t_LImage.m_ImgData = xcu_load_image( cast(const char*) p_FileName, 
                        &t_LImage.m_ImgWidth, &t_LImage.m_ImgHeight,
                        &t_LImage.m_ImgChannels, p_DesiredChannels );

    if ( t_LImage.m_ImgData is null )
    {
        t_LImage.m_ImgLoadError = _TranslateError( xcu_get_error() );
    }

    return t_LImage;
}

XCUImage XCULoadImageFromMemory( void[] p_ImageByteBuffer, int p_DesiredChannels )
{
    assert( 
        p_DesiredChannels >= IMAGE_MIN_CHANNELS && p_DesiredChannels <= IMAGE_MAX_CHANNELS, 
        "Invalid desired channels value");

    XCUImage t_LImage;

    t_LImage.m_ImgPath = XCU_INTERNAL;

    t_LImage.m_ImgDesiredChannels = p_DesiredChannels;

    t_LImage.m_ImgData = xcu_load_image_from_memory(
                    _UBytePointer( p_ImageByteBuffer ), cast(int) p_ImageByteBuffer.length,
                    &t_LImage.m_ImgWidth, &t_LImage.m_ImgHeight,
                    &t_LImage.m_ImgChannels, p_DesiredChannels );

    if ( t_LImage.m_ImgData is null )
    {
        t_LImage.m_ImgLoadError = _TranslateError( xcu_get_error() );
    }

    return t_LImage;
}

XCUImage XCULoadImageFromFile( FILE* p_File, int p_DesiredChannels )
{
    assert( 
        p_DesiredChannels >= IMAGE_MIN_CHANNELS && p_DesiredChannels <= IMAGE_MAX_CHANNELS, 
        "Invalid desired channels value");

    XCUImage t_LImage;

    t_LImage.m_ImgPath = XCU_INTERNAL;

    t_LImage.m_ImgDesiredChannels = p_DesiredChannels;

    if ( FSTREAM_AT_END( p_File ) )
    {
        REWIND_FPTR( p_File );
    }

    t_LImage.m_ImgData = xcu_load_image_from_file( p_File,
                        &t_LImage.m_ImgWidth, &t_LImage.m_ImgHeight,
                        &t_LImage.m_ImgChannels, p_DesiredChannels );

    if ( t_LImage.m_ImgData is null )
    {
        t_LImage.m_ImgLoadError = _TranslateError( xcu_get_error() );
    }

    return t_LImage;
}

XCUImageInfo XCURetrieveImageInfo( string p_FileName )
{
    XCUImageInfo t_ImgInfo;

    t_ImgInfo.m_ImgPath = p_FileName;

    t_ImgInfo.m_InfoRetrieved = xcu_image_info( cast(const char*) p_FileName,
                                &t_ImgInfo.m_ImgWidth, &t_ImgInfo.m_ImgHeight,
                                &t_ImgInfo.m_ImgChannels ) == 1 ? true : false;

    return t_ImgInfo;
}

XCUImageInfo XCURetrieveImageInfoFromMemory( void[] p_ImageByteBuffer )
{
    XCUImageInfo t_ImgInfo;

    t_ImgInfo.m_ImgPath = XCU_INTERNAL;

    t_ImgInfo.m_InfoRetrieved = xcu_image_info_from_memory(
                _UBytePointer( p_ImageByteBuffer ), cast(int) p_ImageByteBuffer.length,
                &t_ImgInfo.m_ImgWidth, &t_ImgInfo.m_ImgHeight,
                &t_ImgInfo.m_ImgChannels ) == 1 ? true : false;

    return t_ImgInfo;
}

XCUImageInfo XCURetrieveImageInfoFromFile( FILE* p_File )
{
    XCUImageInfo t_ImgInfo;

    t_ImgInfo.m_ImgPath = XCU_INTERNAL;

    if ( FSTREAM_AT_END( p_File ) )
    {
        REWIND_FPTR( p_File );
    }

    t_ImgInfo.m_InfoRetrieved = xcu_image_info_from_file( p_File,
                                &t_ImgInfo.m_ImgWidth, &t_ImgInfo.m_ImgHeight,
                                &t_ImgInfo.m_ImgChannels ) == 1 ? true : false;

    return t_ImgInfo;
}

bool XCUImageIsHDR( string p_FileName )
{
    return xcu_image_is_hdr( cast(const char*) p_FileName ) == 1 ? true : false;
}

bool XCUMemoryImageIsHDR( void[] p_ImageByteBuffer )
{
    return xcu_image_is_hdr_from_memory(
        _UBytePointer( p_ImageByteBuffer ),
        cast(int) p_ImageByteBuffer.length ) == 1 ? true : false;
}

bool XCUFileImageIsHDR( FILE* p_File )
{
    if ( FSTREAM_AT_END( p_File ) )
    {
        REWIND_FPTR( p_File );
    }

    return xcu_image_is_hdr_from_file( p_File ) == 1 ? true : false;
}

void XCUSetFlipVerticallyOnLoad( bool p_FlipVertically )
{
    xcu_set_flip_vertically_on_load( p_FlipVertically ? 1 : 0 );
}

void XCUSetUnpremultiplyOnLoad( bool p_Unpremultiply )
{
    xcu_set_unpremultiply_on_load( p_Unpremultiply ? 1 : 0 );
}

void XCUiPhoneConvertPNGToRGB( bool p_Convert )
{
    xcu_convert_iphone_png_to_rgb( p_Convert ? 1 : 0 );
}
