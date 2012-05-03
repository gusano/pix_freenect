
pix_freenect (0.04 still experimental...)
=========================================
pure data / Gem external to get Kinect camera streams (and audio - testing)

 - depends on libfreenect (v0.1 !!)

Output RGB, Depth and Audio Stream (linux only) simultaneously from multiple Kinect sensors
Tested with 2 Kinects, should work with more (on different usb controllers)


(C) 2011/2012 by Matthias Kronlachner


### Install

tested and compiled for Ubuntu 11.10 and MacOS 10.6.8 with Gem 0.93.3

use binaries from build folder or build yourself

 - get/install pd and Gem (0.93.2) including src [http://puredata.info](http://puredata.info)

 - get and install latest libfreenect from [https://github.com/OpenKinect/libfreenect](https://github.com/OpenKinect/libfreenect)
   (compile it with Audio support! see the tips at the end of this file)

#### Linux

 - inside pix_freenect folder (change PD_DIR and GEM_DIR to your local paths): `make PD_DIR=$HOME/dev/pure-data GEM_DIR=$HOME/dev/Gem`

 - alternatively you can edit `Makefile`, change the paths to Gem and pd sources and run `make`

 - have a look at the pix_freenect-help.pd file!

#### OSX

Make sure that libfreenect.0.0.1.dylib and libusb-1.0.0.dylib provided in build folder are in the same folder than pix_freenect.pd_darwin!

 - inside pix_freenect folder (change PD_DIR and GEM_DIR to your local paths): `make PD_DIR=$HOME/dev/pure-data GEM_DIR=$HOME/dev/Gem PD_APP_DIR=/Applications/Pd-extended.app/Contents/Resources`

 - alternatively you can edit `Makefile`, change the paths to Gem and pd sources and run `make`

 - have a look at the pix_freenect-help.pd file!

### Changelog

0.04
 - open specific kinect by serial number -> external lists all available kinect sensors with serial number on startup
    -> now you can be sure you use the right kinect if two or more plugged to the computer
 - output registered depth map --> rgb and depth are matching (depthmap gets a little bit smaller)
    -> includes the output of depthmap in [mm] distance as 16 bit value packed into r and g color channel
 - option to change resolution of rgb image to 1280x1024 -> slows down transfer!
 - various improvements to help file

0.03
 - output rgb and depth stream simultaneously
 - output 4 channel audio as list on linux (experimental)
 - libfreenect v0.1 -> not backward compatible!!
 - binary for osx -> thanks to hans-christoph steiner for makefiles
 - accelerator output
 - different depth output modes (raw for distance measurement)

0.02
 - compatibility to Gem 0.93

### Known bugs

 - streams do not start automatically, have to be triggered by led change, tilt change or |accel( message

### To do

 - implement audio resampling in helpfile
 - pack audio into separate external, maybe motor and led control as well
 - audio external with built in resampling

questions: `m.kronlachner@gmail.com`



### Tips to build libfreenect

 - `git clone git://github.com/OpenKinect/libfreenect.git`
 - `cd libfreenect`
 - `mkdir build && cd build`
 - on linux: `cmake -DBUILD_AUDIO=ON ..`
 - on osx: `cmake -DBUILD_AUDIO=ON -DCMAKE_OSX_ARCHITECTURE=i386;x86_64 ..`
 - if you don't have Glut, you have to disable building the examples: `cmake -DBUILD_AUDIO=ON -DBUILD_EXAMPLES=OFF ..`
 - `make`
 - `sudo make install`
