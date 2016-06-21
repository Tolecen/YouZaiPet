/* 
 * HaoRan ImageFilter Classes v0.3
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

#if !defined(BilinearDistort_H)
#define BilinearDistort_H

#include "../Image.h"
#include "../GradientFilter.h"

namespace HaoRan_ImageFilter{

class BilinearDistort : public IImageFilter{
protected:
	Image clone;

public:
	BilinearDistort(){};

	virtual void calc_undistorted_coord (int x, int y, double& un_x, double& un_y) =0 ;
	
	
	bool IsInside (int width , int height, int x, int y) const {
		return (x>=0) && (x<width) && (y>=0) && (y<height);
	}

	/**
        Calculate bilinear interpolation \n
        0 <= x,y < 1, distance to crPixel[0,0] \n
        colors - in order [0,0], [1,0], [0,1], [1,1].
    */
    static int GetBilinear (double x, double y, vector<int> colors)
    {
		Color color(colors[0]);
        vector<int> px0(3);
		px0[0] = color.R;
		px0[1] = color.G;
		px0[2] = color.B;

		Color color1(colors[1]);
		vector<int> px1(3);
		px1[0] = color1.R;
		px1[1] = color1.G;
		px1[2] = color1.B;
		
		Color color2(colors[2]);
		vector<int> px2(3);
		px2[0] = color2.R;
		px2[1] = color2.G;
		px2[2] = color2.B;

		Color color3(colors[3]);
		vector<int> px3(3);
		px3[0] = color3.R;
		px3[1] = color3.G;
		px3[2] = color3.B;
		
 		vector<int> crRet(3);
        for (int i=0 ; i < 3 ; i++)
        {
            double m0 = px0[i] + x * (px1[i] - px0[i]);
            double m1 = px2[i] + x * (px3[i] - px2[i]);
            double my = m0 + y * (m1 - m0) ;
          	crRet[i] = SAFECOLOR(my) ;
        }
     
        return Color::rgb(crRet[0], crRet[1], crRet[2]) ;
    }
	
	virtual Image process(Image imageIn)
	{
		  clone = imageIn.clone();
		  int width = imageIn.getWidth();
		  int height = imageIn.getHeight(); 
		  for(int x = 0 ; x < width; x++){
			  for(int y = 0 ; y < height ; y++){
				    double   un_x, un_y ;
					calc_undistorted_coord (x, y, un_x, un_y) ;

                  int crNull = White;
					int cr  = crNull ;
					if ( (un_x > -1) && (un_x < width) && (un_y > -1) && (un_y < height) )
					{
						// only this range is valid
						int nSrcX = ((un_x < 0) ? -1 : (int)un_x);
						int nSrcY = ((un_y < 0) ? -1 : (int)un_y);
						int nSrcX_1 = nSrcX + 1;
						int nSrcY_1 = nSrcY + 1;

						vector<int> color(4);
						color[0] = IsInside(width, height, nSrcX, nSrcY) ? clone.getPixelColor(nSrcX,nSrcY) : crNull;
						color[1] = IsInside(width, height, nSrcX_1, nSrcY) ? clone.getPixelColor(nSrcX_1,nSrcY) : crNull;
						color[2] = IsInside(width, height, nSrcX, nSrcY_1) ? clone.getPixelColor(nSrcX,nSrcY_1) : crNull;
						color[3] = IsInside(width, height, nSrcX_1, nSrcY_1) ? clone.getPixelColor(nSrcX_1,nSrcY_1) : crNull;
						cr = GetBilinear(un_x-nSrcX, un_y-nSrcY, color);					
					}
					imageIn.setPixelColor(x, y, cr);		
			  }
		  }
#ifndef WIN32 //only for apple ios
		imageIn.copyPixelsFromBuffer();
#endif
		return imageIn;
	}
};

}// namespace HaoRan
#endif