//
//  Homography.m
//  StitchMan
//
//  Created by wjy on 13-7-27.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "Homography.h"
#import "GaussianElimination.h"

@implementation Homography

+ (double *)findHomography2DWithX1:(double)x1 Y1:(double)y1 X11:(double)x11 Y11:(double)y11
                                X2:(double)x2 Y2:(double)y2 X22:(double)x22 Y22:(double)y22
                                X3:(double)x3 Y3:(double)y3 X33:(double)x33 Y33:(double)y33
                                X4:(double)x4 Y4:(double)y4 X44:(double)x44 Y44:(double)y44
{
    
    static double homography[9];
    double mat[72];
    
    mat[0]=-x1;mat[1]=-y1;mat[2]=-1;mat[3]=mat[4]=mat[5]=0;mat[6]=x1*x11;mat[7]=y1*x11;mat[8]=-x11;
    mat[9]=mat[10]=mat[11]=0;mat[12]=-x1;mat[13]=-y1;mat[14]=-1;mat[15]=x1*y11;mat[16]=y1*y11;mat[17]=-y11;
    mat[18]=-x2;mat[19]=-y2;mat[20]=-1;mat[21]=mat[22]=mat[23]=0;mat[24]=x2*x22;mat[25]=y2*x22;mat[26]=-x22;
    mat[27]=mat[28]=mat[29]=0;mat[30]=-x2;mat[31]=-y2;mat[32]=-1;mat[33]=x2*y22;mat[34]=y2*y22;mat[35]=-y22;
    mat[36]=-x3;mat[37]=-y3;mat[38]=-1;mat[39]=mat[40]=mat[41]=0;mat[42]=x3*x33;mat[43]=y3*x33;mat[44]=-x33;
    mat[45]=mat[46]=mat[47]=0;mat[48]=-x3;mat[49]=-y3;mat[50]=-1;mat[51]=x3*y33;mat[52]=y3*y33;mat[53]=-y33;
    mat[54]=-x4;mat[55]=-y4;mat[56]=-1;mat[57]=mat[58]=mat[59]=0;mat[60]=x4*x44;mat[61]=y4*x44;mat[62]=-x44;
    mat[63]=mat[64]=mat[65]=0;mat[66]=-x4;mat[67]=-y4;mat[68]=-1;mat[69]=x4*y44;mat[70]=y4*y44;mat[71]=-y44;
    
    [GaussianElimination solveWithVariate:8 Matrix:mat];
    
    homography[0]=mat[8];
    homography[1]=mat[17];
    homography[2]=mat[26];
    homography[3]=mat[35];
    homography[4]=mat[44];
    homography[5]=mat[53];
    homography[6]=mat[62];
    homography[7]=mat[71];
    homography[8]=1;
    
    /*
    static double homography[9];
    double mat[42];
    
    mat[0]=x1;mat[1]=y1;mat[2]=1;mat[3]=mat[4]=mat[5]=0;mat[6]=x11;
    mat[7]=mat[8]=mat[9]=0;mat[10]=x1;mat[11]=y1;mat[12]=1;mat[13]=y11;
    mat[14]=x2;mat[15]=y2;mat[16]=1;mat[17]=mat[18]=mat[19]=0;mat[20]=x22;
    mat[21]=mat[22]=mat[23]=0;mat[24]=x2;mat[25]=y2;mat[26]=1;mat[27]=y22;
    mat[28]=x3;mat[29]=y3;mat[30]=1;mat[31]=mat[32]=mat[33]=0;mat[34]=x33;
    mat[35]=mat[36]=mat[37]=0;mat[38]=x3;mat[39]=y3;mat[40]=1;mat[41]=y33;
    
    
    [GaussianElimination solveWithVariate:6 Matrix:mat];
    
    homography[0]=mat[6];
    homography[1]=mat[13];
    homography[2]=mat[20];
    homography[3]=mat[27];
    homography[4]=mat[34];
    homography[5]=mat[41];
    homography[6]=0;
    homography[7]=0;
    homography[8]=1;
    */
    
    return homography;
}

@end
