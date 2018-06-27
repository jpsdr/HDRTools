Some general information first.

The recording process is the following :
SDR :
[Camera sensor] -> Linear R,G,B -> OETF -> Non linear R',G',B' -> Color Matrix -> Y',C'r,C'b
Y',C'r,C'b -> Inv Color Matrix -> Non linear R',G',B' -> EOTF -> Linear R,G,B
HDR :
[Camera sensor] -> Linear R,G,B -> OOTF (PQ/HLG) -> OETF (PQ/HLG) -> Non linear R',G',B' -> Color Matrix -> Y',C'r,C'b
Y',C'r,C'b -> Inv Color Matrix -> Non linear R',G',B' -> EOTF (PQ/HLG) -> Inv OOTF (PQ/HLG) -> Linear R,G,B

We can thought that at the level of Linear R,G,B, we have directly the "original" light information.
Unfortunately not. The R,G,B provided by the Camera sensor are linked to chromaticity parameters
(things like white color T°, etc...). So, the more appropriate color space closest to the "original"
light information seems the XYZ color space.

Functions inside this plugin :


**************************************
**      ConvertYUVtoLinearRGB       **
**************************************

ConvertYUVtoLinearRGB(int Color,int OutputMode,bool HLGMode,bool OOTF,bool EOTF,bool fullrange,bool mpeg2c,
     int threads,bool logicalCores,bool MaxPhysCore,bool SetAffinity,bool sleep,int prefetch)

Accepted input : Planar YUV 8 to 16 bits.

   Color -
      Set the color mode of the data.
         0 : BT2100
         1 : BT2020
         2 : BT709
         3 : BT601_525
         4 : BT601_625

       Default: 2 (int)

   OutputMode -
      Set the output data mode.
         0 : No change : Input 8 Bits -> Output : RGB32, Input > 8 Bits -> Output : RGB64
	 1 : The ouput will be RGB64
	 2 : The ouput will be RGBPS (Planar RGB float)

       Default: 0 (int)

   HDRMode -
      Has effect only if Color=0.
         0 : PQ mode.
         1 : HLG normalized 10000 cd/m² mode.
         2 : HLG not normalized.

       Default: 0 (int)

   HLGLw -
      Set the white level in cd/m² for HLG mastering.
      Has effect only if HDRMode is set to 1 or 2.

       Default: 1000.0 (float)

   HLGLb -
      Set the black level in cd/m² for HLG mastering.
      Has effect only if HDRMode is set to 1 or 2.

       Default: 0.05 (float)

   OOTF -
      Has effect only if Color=0. If set to false, the inv OOTF step will be skipped
      during the linear convertion.

       Default: true (bool)

   EOTF -
      If set to false, the EOTF step will be skipped during the linear convertion.

       Default: true (bool)

   fullrange -
      If set to true, the YUV input data will be considered full range value.

       Default: false (bool)

   mpeg2c -
      Has effect only if input is YV12. If set to false, chroma placement will be
      considered mpeg-1, otherwise mpeg-2.
      Not implemented yet.

       Default: true (bool)

   threads -
      Controls how many threads will be used for processing. If set to 0, threads will
      be set equal to the number of detected logical or physical cores,according logicalCores parameter.

      Default:  0  (int)

   logicalCores -
      If threads is set to 0, it will specify if the number of threads will be the number
      of logical CPU (true) or the number of physical cores (false). If your processor doesn't
      have hyper-threading or threads<>0, this parameter has no effect.

      Default: true (bool)

   MaxPhysCore -
      If true, the threads repartition will use the maximum of physical cores possible. If your
      processor doesn't have hyper-threading or the SetAffinity parameter is set to false,
      this parameter has no effect.

      Default: true (bool)

   SetAffinity -
      If this parameter is set to true, the pool of threads will set each thread to a specific core,
      according MaxPhysCore parameter. If set to false, it's leaved to the OS.
      If prefecth>number of physical cores, it's automaticaly set to false.

      Default: false (bool)

  sleep -
      If this parameter is set to true, once the filter has finished one frame, the threads of the
      threadpool will be suspended (instead of still running but waiting an event), and resume when
      the next frame will be processed. If set to false, the threads of the threadpool are always
      running and waiting for a start event even between frames.

      Default: false (bool)

  prefetch -
      This parameter will allow to create more than one threadpool, to avoid mutual resources acces
      if "prefetch" is used in the avs script.
      0 : Will set automaticaly to the prefetch value use in the script. Well... that's what i wanted
          to do, but for now it's not possible for me to get this information when i need it, so, for
          now, 0 will result in 1. For now, if you're using "prefetch" in your script, put the same
          value on this parameter.

      Default: 0

The logicalCores, MaxPhysCore, SetAffinity and sleep are parameters to specify how the pool of thread
will be created and handled, allowing if necessary each people to tune according his configuration.


**************************************
**      ConvertLinearRGBtoYUV       **
**************************************

ConvertLinearRGBtoYUV(int Color,int OutputMode,bool HLGMode,bool OOTF,bool OETF,bool fullrange,bool mpeg2c,
     bool fasmode,int threads,bool logicalCores,bool MaxPhysCore,bool SetAffinity,bool sleep,int prefetch)

Accepted input : RGB32, RGB64 and Planar float RGB.

   Color -
      Set the color mode of the data.
         0 : BT2100
         1 : BT2020
         2 : BT709
         3 : BT601_525
         4 : BT601_625

       Default: 2 (int)

   OutputMode -
      Set the output data mode. IF input is 8 bits output is 8 bits, 16 bits otherwise.
         0 : YV24
	 1 : YV16
	 2 : YV12
       Default: 0 (int)

   OOTF -
      Has effect only if Color=0. If set to false, the OOTF step will be skipped
      during the de-linear convertion.

       Default: true (bool)

   OETF -
      If set to false, the EOTF step will be skipped during the de-linear convertion.

       Default: true (bool)

   fullrange -
      If set to true, the YUV output data will be set full range.

       Default: false (bool)

   mpeg2c -
      Has effect only if output is YV12. If set to false, chroma convertion will be mpeg-1, otherwise mpeg-2.
      Not implemented yet.

       Default: true (bool)

   fastmode -
      Has effect only if input is float. If set to true, the de-linear convertion will be done using
      a lookup table of 20 bits input (mantisse size of float is 24 bits). Otherwise, the function will
      be calculated each time, this will create a huge slowdown.

       Default: true (bool)

The others parameters are identical to ConvertYUVtoLinearRGB.


**************************************
**         ConvertYUVtoXYZ          **
**************************************

ConvertYUVtoXYZ(int Color,int OutputMode,bool HLGMode,bool OOTF,bool EOTF,bool fullrange,bool mpeg2c,
     float Rx,float Ry,float Gx,float Gy,float Bx,float By,float Wx,float Wy,
     int threads,bool logicalCores,bool MaxPhysCore,bool SetAffinity,bool sleep,int prefetch)

Accepted input : Planar YUV 8 to 16 bits.
The output will be tagged RGB even if data is XYZ.

   Rx,Ry,Gx,Gy,Bx,By,Wx,Wy -
      These parameters allow to configure the chromaticity coordinates Red point, Green point, Blue point
      and White point. If not set, the values defined in the BT.xxxx of the Color parameter are used.

       Default: According Color parameter (float)

The others parameters are identical to ConvertYUVtoLinearRGB.


**************************************
**         ConvertXYZtoYUV          **
**************************************

ConvertXYZtoYUV(int Color,int OutputMode,bool HLGMode,bool OOTF,bool OETF,bool fullrange,bool mpeg2c,
     bool fasmode,float Rx,float Ry,float Gx,float Gy,float Bx,float By,float Wx,float Wy,
     int pColor,float pRx,float pRy,float pGx,float pGy,float pBx,float pBy,float pWx,float pWy,
     int threads,bool logicalCores,bool MaxPhysCore,bool SetAffinity,bool sleep,int prefetch)

Accepted input : RGB32, RGB64 and Planar float RGB.

   pColor -
      Color mode used in YUV/RGBtoXYZ.
         0 : BT2100
         1 : BT2020
         2 : BT709
         3 : BT601_525
         4 : BT601_625

       Default: 2 if Color=0, 0 otherwise.


   pRx,pRy,pGx,pGy,pBx,pBy,pWx,pWy -
      Chromaticity datas used in previous YUV/RGBtoXYZ.

       Default: According pColor parameter (float)


The others parameters are identical to ConvertLinearRGBtoYUV.


**************************************
**         ConvertRGBtoXYZ          **
**************************************

ConvertRGBtoXYZ(int Color,int OutputMode,bool HLGMode,bool OOTF,bool EOTF,fastmode,
     float Rx,float Ry,float Gx,float Gy,float Bx,float By,float Wx,float Wy,
     int threads,bool logicalCores,bool MaxPhysCore,bool SetAffinity,bool sleep,int prefetch)

Accepted input : RGB32, RGB64 and Planar float RGB.
The output will be tagged RGB even if data is XYZ.

The parameters are identical to ConvertYUVtoXYZ.


**************************************
**         ConvertXYZtoRGB          **
**************************************

ConvertXYZtoRGB(int Color,int OutputMode,bool HLGMode,bool OOTF,bool OETF,bool fasmode,
     float Rx,float Ry,float Gx,float Gy,float Bx,float By,float Wx,float Wy,
     int pColor,float pRx,float pRy,float pGx,float pGy,float pBx,float pBy,float pWx,float pWy,
     int threads,bool logicalCores,bool MaxPhysCore,bool SetAffinity,bool sleep,int prefetch)

Accepted input : RGB32, RGB64 and Planar float RGB.

   OutputMode -
      Set the output data mode.
         0 : No change
	 1 : Input 8 to 16 bits : no change, Input Planar float RGB -> Outpout RGB64.
       Default: 0 (int)


The others parameters are identical to ConvertXYZtoYUV.


**************************************
**       ConvertXYZ_HDRtoSDR        **
**************************************

ConvertXYZ_HDRtoSDR(int MinMastering, int MaxMastering,
     int threads,bool logicalCores,bool MaxPhysCore,bool SetAffinity,bool sleep,int prefetch,
     float Coeff_X, float Coeff_X, float Coeff_X)
     
Accepted input : RGB64 and Planar float RGB.

For now, it's just a linear scalling, just for testing. Formula is just Out_X=Coeff_X*In_X (etc...).

   MinMastering -
      Min mastering level found in the SEI mastering parameters of HDR streams.
      Not used.

       Default: 0 (int)

   MaxMastering -
      Max mastering level found in the SEI mastering parameters of HDR streams.
      Not used.

       Default: 1000 (int)

   Coeff_X -
      Linear scalar value used on X plane.
      
       Default: 100.0 (float)

   Coeff_Y -
      Linear scalar value used on Y plane.
      
       Default: Coeff_X (float)

   Coeff_Z -
      Linear scalar value used on Z plane.
      
       Default: Coeff_X (float)

The others parameters are identical to  ConvertYUVtoLinearRGB.


**************************************
**       ConvertXYZ_SDRtoHDR        **
**************************************

ConvertXYZ_SDRtoHDR(float Coeff_X, float Coeff_X, float Coeff_X,
     int threads,bool logicalCores,bool MaxPhysCore,bool SetAffinity,bool sleep,int prefetch)
     
Accepted input : RGB64 and Planar float RGB.

Produce linear scalling. Formula is just Out_X=In_X/Coeff_X (etc...).

   Coeff_X -
      Linear scalar value used on X plane.
      
       Default: 100.0 (float)

   Coeff_Y -
      Linear scalar value used on Y plane.
      
       Default: Coeff_X (float)

   Coeff_Z -
      Linear scalar value used on Z plane.
      
       Default: Coeff_X (float)

The others parameters are identical to  ConvertYUVtoLinearRGB.


*************************************************************

Note about Chromaticity parameters
==================================
On HDR stream, SEI mastering parameters provide the chromaticity parameters used.
Even if BT2100 has default value, i think it will produce optimal result in RGB/YUV
to XYZ convertion if SEI mastering parameters are used instead of default BT2100 values.
All the BTxxxx use D65 white point, if the SEI parameters are allready set to it, no use to
specify them.
These parameters can be get using mediainfo on the HDR stream.
Another way to get them, it's if you're using DGIndexNV, on HEVC HDR stream.
In that case, you'll have in the DGI file this line (for exemple) :

MASTERING 13250 34500 7500 3000 34000 16000 15635 16450 40000000 50

The values are the following :

MASTERING GreenX GreenY BlueX BlueY RedX RedY WhiteX WhiteY MaxMasteringLevel MinMasteringLevel

The GreenX GreenY BlueX BlueY RedX RedY WhiteX WhiteY are by 0.00002 steps.
The MaxMasteringLevel MinMasteringLevel are by 0.0001 steps.

In our exemple, it will result :
Gx : 0.265
Gy : 0.690
Bx : 0.150
By : 0.060
Rx : 0.680
Ry : 0.320
Wx : 0.3127
Wy : 0.3290
Max : 4000
Min : 0.05

Remark :
15635 16450 are the standard D65 white point value, no need in these case to put them.
