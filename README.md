<h1 align="center">xcuimg.d v1.2</h1>
<p align="center">XCUImage (Explicitus Image) is a simple library for loading/decoding images, with additional utilities based on <a href="https://github.com/nothings/stb/blob/master/stb_image.h">stb_image</a>.</p>

```d
import xcuimg.XCUImage : XCUImage, XCULoadImage;

void main() {
    XCUImage image = XCULoadImage("MyImage.jpg", 3);

    int[][] pixels = image.GetImagePixelArray();
}
```
<sub>Reading JPG image's pixel array.</sub>

Check out the specification for desired channels <a href="https://github.com/nothings/stb/blob/2c980bb59875b0d32144a71867fbdebb2f77cd20/stb_image.h#L167">here</a>.

<h3>Installation</h3>
Basic steps:

```
git clone https://github.com/xzripper/xcuimg.d
cd xcuimg.d
```

Pre-built object file:

```
wget -q https://github.com/xzripper/xcuimg.d/releases/download/v1.1/xcuimg.o -O xcuimg/cbg/xcuimg.o
```
<sub>Object file is the same since V1.1</sub>

Building manually:

```
wget -q https://github.com/nothings/stb/blob/master/stb_image.h?raw=true -O xcuimg/cbg/stb_image.h
gcc -c xcuimg/cbg/xcuimg.c -o xcuimg/cbg/xcuimg.o
```

After you finished building/downloading the object file, you can drag `xcuimg` directory into your project.

Run your code with:

```
dmd [FILE(S)] xcuimg/cbg/xcuimg.o -I. -i
```

<h3>Look up for functions and their implementations (+ constants)</h3>
<a href="https://github.com/xzripper/xcuimg.d/blob/main/xcuimg/XCUImage.d">XCUImage</a>, <a href="https://github.com/xzripper/xcuimg.d/blob/main/xcuimg/XCUImageDWrapper.d">XCUImageDWrapper</a>.
