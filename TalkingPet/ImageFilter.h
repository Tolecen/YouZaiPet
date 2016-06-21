//
//  ImageFilter.h
//  TalkingPet
//
//  Created by wangxr on 14/10/22.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//


#include <vector>


#include <algorithm>
//#include "Image.h"
//v0.1
#include "InvertFilter.h"
#include "AutoLevelFilter.h"
#include "RadialDistortionFilter.h"
#include "BannerFilter.h"
#include "BigBrotherFilter.h"
#include "BlackWhiteFilter.h"
#include "ColorQuantizeFilter.h"
#include "ConvolutionFilter.h"
#include "BrickFilter.h"
#include "BlockPrintFilter.h"
#include "EdgeFilter.h"
#include "FeatherFilter.h"
#include "GaussianBlurFilter.h"
#include "GradientFilter.h"
#include "HistogramEqualFilter.h"
#include "LightFilter.h"
#include "MistFilter.h"
#include "MonitorFilter.h"
#include "MosaicFilter.h"
#include "NeonFilter.h"
#include "NightVisionFilter.h"
#include "NoiseFilter.h"
#include "OilPaintFilter.h"
#include "OldPhotoFilter.h"
#include "PixelateFilter.h"
#include "RainBowFilter.h"
#include "RectMatrixFilter.h"
#include "ReflectionFilter.h"
#include "ReliefFilter.h"
#include "SaturationModifyFilter.h"
#include "SepiaFilter.h"
#include "SmashColorFilter.h"
#include "ThresholdFilter.h"
#include "TintFilter.h"
#include "VignetteFilter.h"
#include "VintageFilter.h"
#include "WaterWaveFilter.h"
#include "XRadiationFilter.h"

//v0.2
#include "LomoFilter.h"
#include "PaintBorderFilter.h"
#include "SceneFilter.h"
#include "ComicFilter.h"
#include "FilmFilter.h"
#include "FocusFilter.h"
#include "CleanGlassFilter.h"

//v3
#include "ZoomBlurFilter.h"
#include "ThreeDGridFilter.h"
#include "ColorToneFilter.h"
#include "SoftGlowFilter.h"
#include "TileReflectionFilter.h"
#include "BlindFilter.h"
#include "RaiseFrameFilter.h"
#include "ShiftFilter.h"
#include "WaveFilter.h"
#include "BulgeFilter.h"
#include "TwistFilter.h"
#include "RippleFilter.h"
#include "IllusionFilter.h"
#include "SupernovaFilter.h"
#include "LensFlareFilter.h"
#include "PosterizeFilter.h"
#include "SharpFilter.h"
#include "VideoFilter.h"
#include "FillPatternFilter.h"
#include "MirrorFilter.h"
#include "YCBCrLinearFilter.h"
#include "TexturerFilter.h"
#include "CloudsTexture.h"
#include "LabyrinthTexture.h"
#include "MarbleTexture.h"
#include "TextileTexture.h"
#include "WoodTexture.h"
#include "HslModifyFilter.h"
using namespace HaoRan_ImageFilter;


vector<IImageFilter*> LoadFilterVector(){
    vector<IImageFilter*> vectorFilter;
    vectorFilter.push_back(new BlackWhiteFilter());/*1,0*/
    vectorFilter.push_back(new BrightContrastFilter());/*8,1*/
    vectorFilter.push_back(new SaturationModifyFilter());/*9,2*/
    vectorFilter.push_back(new LightFilter());/*17,4*/
//    vectorFilter.push_back(new ReflectionFilter(false));/*22,6*/
    vectorFilter.push_back(new VignetteFilter());/*30,8*/
    vectorFilter.push_back(new RainBowFilter());/*33,10*/
    vectorFilter.push_back(new SceneFilter(5.0f, Gradient::Scene1()));/*40,13*/
    vectorFilter.push_back(new SceneFilter(5.0f, Gradient::Scene3()));/*42,15*/
//    vectorFilter.push_back(new PaintBorderFilter(0x00FF00));//green/*46,17*/
//    vectorFilter.push_back(new PaintBorderFilter(0x0000FF));//blue/*47,18*/
//    vectorFilter.push_back(new PaintBorderFilter(0xFFFF00));//yellow/*48,19*/
    vectorFilter.push_back(new SupernovaFilter(0xFFFF00,80,100));/*66,25*/
    vectorFilter.push_back(new GammaFilter(50));/*69,26*/
    vectorFilter.push_back(new VideoFilter(VideoFilter::VIDEO_3X3));/*73,27*/
    vectorFilter.push_back(new MirrorFilter(true));/*77,29*/
//    vectorFilter.push_back(new YCBCrLinearFilter(new YCBCrLinearFilter::Range(-0.276f, 0.163f), new YCBCrLinearFilter::Range(-0.202f, 0.5f)));/*80,31*/
    vectorFilter.push_back(new HslModifyFilter(200));/*92,34*/
    vectorFilter.push_back(new HslModifyFilter(250));/*93,35*/
    return vectorFilter;
}