<h1 align="center">xcuimg.d</h1>
<p align="center">XCUImage (Explicitus Image) is a simple library for loading/decoding images and additional utilities based on <a href="https://github.com/nothings/stb/blob/master/stb_image.h">stb_image</a>.</p>

<h3>Installation</h3>
Basic steps:

```
git clone https://github.com/xzripper/xcuimg.d
cd xcuimg.d
```

Pre-built object file:

```
wget -q https://github.com/xzripper/xcuimg.d/releases/download/v1.0/xcuimg.o -O xcuimg/cbg/xcuimg.o
```

Manual build:

```
wget -q https://github.com/nothings/stb/blob/master/stb_image.h?raw=true -O xcuimg/cbg/stb_image.h
gcc -c xcuimg/cbg/xcuimg.c -o xcuimg/cbg/xcuimg.o
```

After you downloaded/built the object file you can drag `xcuimg` directory into your project.

Run your code with:

```
dmd [FILE(S)] xcuimg/cbg/xcuimg.o -I. -i
```

<h3>Cheatsheet</h3>
<a href="https://github.com/xzripper/xcuimg.d/blob/main/xcuimg/XCUImage.d">XCUImage</a>, <a href="https://github.com/xzripper/xcuimg.d/blob/main/xcuimg/XCUImageDWrapper.d">XCUImageDWrapper</a>.
