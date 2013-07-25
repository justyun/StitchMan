//
//  Derivative.m
//  StitchMan
//
//  Created by wjy on 13-7-8.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "Derivative.h"

@implementation Derivative

+ (double *)deriv3D:(Pyramid *)pyramid Octave:(int)octave_num Interval:(int)interval_num
                       X:(int)x Y:(int)y
{
    ImageMatrix *mat=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                           Interval:interval_num];
    ImageMatrix *next=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                           Interval:interval_num+1];
    ImageMatrix *prev=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                           Interval:interval_num-1];
    
    static double deriv[3];
    double dx,dy,ds;
    int width=mat->imageWidth;
    
    deriv[0]=dx=(mat->pImage[y*width+x+1] - mat->pImage[y*width+x-1])/2.0;
    deriv[1]=dy=(mat->pImage[(y+1)*width+x] - mat->pImage[(y-1)*width+x])/2.0;
    deriv[2]=ds=(next->pImage[y*width+x] - prev->pImage[y*width+x])/2.0;
    
    return deriv;
}

+ (double *)hessian3D:(Pyramid *)pyramid Octave:(int)octave_num Interval:(int)interval_num
                   X:(int)x Y:(int)y
{
    ImageMatrix *mat=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                           Interval:interval_num];
    ImageMatrix *next=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                            Interval:interval_num+1];
    ImageMatrix *prev=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                            Interval:interval_num-1];
    
    static double hessian[9];
    double v,dxx,dyy,dss,dxy,dxs,dys;
    int width=mat->imageWidth;
    
	v = mat->pImage[y*width+x];
	dxx = mat->pImage[y*width+x+1] + mat->pImage[y*width+x-1] - 2*v;
	dyy = mat->pImage[(y+1)*width+x] + mat->pImage[(y-1)*width+x] - 2*v;
	dss = next->pImage[y*width+x] + prev->pImage[y*width+x] - 2*v;
	dxy = (mat->pImage[(y+1)*width+x+1] - mat->pImage[(y+1)*width+x-1]
           - mat->pImage[(y-1)*width+x+1] + mat->pImage[(y-1)*width+x-1]) / 4.0;
	dxs = (next->pImage[y*width+x+1] - next->pImage[y*width+x-1]
           - prev->pImage[y*width+x+1] + prev->pImage[y*width+x-1]) / 4.0;
	dys = (next->pImage[(y+1)*width+x] - next->pImage[(y-1)*width+x]
           - prev->pImage[(y+1)*width+x] + prev->pImage[(y-1)*width+x]) / 4.0;
    
    hessian[0]=dxx;
    hessian[1]=dxy;
    hessian[2]=dxs;
    hessian[3]=dxy;
    hessian[4]=dyy;
    hessian[5]=dys;
    hessian[6]=dxs;
    hessian[7]=dys;
    hessian[8]=dss;
    
	return hessian;
}

@end
