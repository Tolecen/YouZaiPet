/* 
 * HaoRan ImageFilter Classes v0.2
 * Copyright (C) 2012 Zhenjun Dai
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation; either version 2.1 of the License, or (at your
 * option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation.
 */
#if !defined(LomoFilter_H)
#define LomoFilter_H

#include "IImageFilter.h"
#include "BrightContrastFilter.h"

namespace HaoRan_ImageFilter{

class LomoFilter : public IImageFilter{

private:
	BrightContrastFilter contrastFx;
    GradientMapFilter gradientMapFx;
    ImageBlender blender;
    VignetteFilter vignetteFx;
    NoiseFilter noiseFx;

public:

	LomoFilter(){
		contrastFx.BrightnessFactor = 0.05f;
        contrastFx.ContrastFactor = 0.5f;
         
        blender.Mixture = 0.5f;
        blender.Mode = ::Multiply;
        
        vignetteFx.Size = 0.6f;
	
		noiseFx.Intensity = 0.02f;
	};

	virtual Image process(Image imageIn)
	{
		Image tempImg = contrastFx.process(imageIn);
        tempImg = noiseFx.process(tempImg);
        imageIn = gradientMapFx.process(tempImg);
        imageIn = blender.Blend(imageIn, tempImg);
        imageIn = vignetteFx.process(imageIn);
#ifndef WIN32 //only for apple ios
		imageIn.copyPixelsFromBuffer();
#endif
	    return imageIn;
	}
};

}// namespace HaoRan
#endif