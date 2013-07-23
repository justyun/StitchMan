
#import "KeypointVector.h"

@implementation KeypointVector

- (id)initWithPyramid:(Pyramid *)pyramid
{
    if(self=[super init]){
        keypoints=[[NSMutableArray alloc] init];
        duplicateKeypoints=[[NSMutableArray alloc] init];
        
        count1=0;
        pyr=pyramid;
        [self locateKeypoints:pyr];
        printf("%d local maximum.\n",count1);
        printf("%d keypoints are detected.\n",[keypoints count]);
        [self calculateOrientations];
        printf("%d keypoints are detected. (modified result)\n",[keypoints count]);
        [self calculateDescriptors];
        
    }
    return self;
}

- (void)locateKeypoints:(Pyramid *)pyramid
{
    int octaveNum=[pyramid getOctaveNum];
    int intervalNum=[pyramid getIntervalNum];
    
    for(int i=0;i<octaveNum;i++){
        for(int j=1;j<intervalNum+1;j++){
            [self locateKeypointsAtOctave:i Interval:j Pyramid:pyramid];
            //printf("finish\n");
        }
    }
}

- (void)locateKeypointsAtOctave:(int)octave_num Interval:(int)interval_num
                        Pyramid:(Pyramid *)pyramid
{
    ImageMatrix *imtmp=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                             Interval:interval_num];
    int width=imtmp->imageWidth;
    int height=imtmp->imageHeight;
    
    for(int i=1;i<height-1;i++){
        for(int j=1;j<width-1;j++){
            if([self isExtremaAtX:j Y:i
                           Octave:octave_num Interval:interval_num Pyramid:pyramid]){
                
                //
                count1++;
                
                Keypoint *kp=[self adjustExtremaAtX:j Y:i
                                             Octave:octave_num Interval:interval_num
                                            Pyramid:pyramid];
                if(kp!=nil){
                    [keypoints addObject:kp];
                }
                
            }
        }
    }
}

- (BOOL)isExtremaAtX:(int)x Y:(int)y
              Octave:(int)octave_num Interval:(int)interval_num Pyramid:(Pyramid *)pyramid
{
    ImageMatrix *prev=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                            Interval:interval_num-1];
    ImageMatrix *im=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                          Interval:interval_num];
    ImageMatrix *next=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                            Interval:interval_num+1];
    
    int width=im->imageWidth;
    float value=im->pImage[y*width+x];
    float value1,value2,value3;
    
    if(value>=0){
        for(int i=y-1;i<=y+1;i++){
            for(int j=x-1;j<=x+1;j++){
                
                value1=prev->pImage[i*width+j];
                value2=im->pImage[i*width+j];
                value3=next->pImage[i*width+j];
                
                if(value<value1 || value<value2 || value<value3)
                    return FALSE;
            }
        }
    }
    else{
        for(int i=y-1;i<=y+1;i++){
            for(int j=x-1;j<=x+1;j++){
                
                value1=prev->pImage[i*width+j];
                value2=im->pImage[i*width+j];
                value3=next->pImage[i*width+j];
                
                if(value>value1 || value>value2 || value>value3)
                    return FALSE;
            }
        }
    }
    
    return TRUE;
}

- (Keypoint *)adjustExtremaAtX:(int)x Y:(int)y
Octave:(int)octave_num Interval:(int)interval_num Pyramid:(Pyramid *)pyramid
__attribute((ns_returns_retained))
{
    int i=0;
    double xc,yc,ic;
    double *dD;
    double *dD2;
    double det_D2;
    double inv_dD2[3][3];
    int intervalNum=[pyramid getIntervalNum];
    ImageMatrix *im=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num
                                                          Interval:interval_num];
    
    //interpolation
    while(i<INTERPOLATION_ITERATION)
    {
        //derivatives
        dD=[Derivative deriv3D:pyramid Octave:octave_num Interval:interval_num X:x Y:y];
        dD2=[Derivative hessian3D:pyramid Octave:octave_num Interval:interval_num X:x Y:y];
        
        //inverse of D2
        det_D2=dD2[0]*dD2[4]*dD2[8] + dD2[1]*dD2[5]*dD2[6] + dD2[3]*dD2[7]*dD2[2]
        - dD2[0]*dD2[5]*dD2[7] - dD2[1]*dD2[3]*dD2[8] - dD2[2]*dD2[4]*dD2[6];
        if(det_D2==0.0)
            return nil;
        
        inv_dD2[0][0]= (dD2[4]*dD2[8] - dD2[5]*dD2[7])/det_D2;
        inv_dD2[0][1]=-(dD2[1]*dD2[8] - dD2[2]*dD2[7])/det_D2;
        inv_dD2[0][2]= (dD2[1]*dD2[5] - dD2[2]*dD2[4])/det_D2;
        inv_dD2[1][0]= (dD2[5]*dD2[6] - dD2[3]*dD2[8])/det_D2;
        inv_dD2[1][1]=-(dD2[2]*dD2[6] - dD2[0]*dD2[8])/det_D2;
        inv_dD2[1][2]= (dD2[2]*dD2[3] - dD2[0]*dD2[5])/det_D2;
        inv_dD2[2][0]= (dD2[3]*dD2[7] - dD2[4]*dD2[6])/det_D2;
        inv_dD2[2][1]=-(dD2[0]*dD2[7] - dD2[1]*dD2[6])/det_D2;
        inv_dD2[2][2]= (dD2[0]*dD2[4] - dD2[1]*dD2[3])/det_D2;
        
        //multiply invD2 and D
        xc=-(inv_dD2[0][0]*dD[0] + inv_dD2[0][1]*dD[1] + inv_dD2[0][2]*dD[2]);
        yc=-(inv_dD2[1][0]*dD[0] + inv_dD2[1][1]*dD[1] + inv_dD2[1][2]*dD[2]);
        ic=-(inv_dD2[2][0]*dD[0] + inv_dD2[2][1]*dD[1] + inv_dD2[2][2]*dD[2]);
        
        if(fabs(xc)<0.5 && fabs(yc)<0.5 && fabs(ic)<0.5) break;
        
        x+=round(xc);
        y+=round(yc);
        interval_num+=round(ic);
        
        if(interval_num<1 || interval_num>intervalNum
           || x<1 || x>=im->imageWidth-1
           || y<1 || y>=im->imageHeight-1)
            return nil;
        
        i++;
    }
    
    if(i>=INTERPOLATION_ITERATION)
        return nil;
    
    //remove keypoints with low contrast
    im=[pyramid getDifferenceOfGaussianMatrixAtOctave:octave_num Interval:interval_num];
    double D=im->pImage[y*im->imageWidth+x] + 0.5*(dD[0]*xc+dD[1]*yc+dD[2]*ic);
    if(fabs(D)<CONTRAST_THRESHOLD/(double)intervalNum)
        return nil;
    
    //remove edge responses
    double tr=dD2[0]+dD2[4];
    double det=dD2[0]*dD2[4]-dD2[1]*dD2[3];
    if(det<=0)
        return nil;
    if(tr*tr/det >= (R+1.0)*(R+1.0)/R)
        return nil;
    
    //return keypoint
    Keypoint *newKeypoint=[[Keypoint alloc]
                           initWithX:(int)(((double)x+xc)*(double)(1<<octave_num))
                           Y:(int)(((double)y+yc)*(double)(1<<octave_num))
                           X_OCT:x
                           Y_OCT:y
                           Octave:octave_num
                           Interval:interval_num];
    
    return newKeypoint;
}


- (void)calculateOrientations
{
    int length=[keypoints count];
    Keypoint *kp;
    for(int i=0;i<length;i++){
        kp=[keypoints objectAtIndex:i];
        [self calculateOrientationAtKeypoint:kp Pyramid:pyr];
    }
    
    int length2=[duplicateKeypoints count];
    for(int i=0;i<length2;i++){
        kp=[duplicateKeypoints objectAtIndex:i];
        [keypoints addObject:kp];
    }
    duplicateKeypoints=nil;
}



- (void)calculateOrientationAtKeypoint:(Keypoint *)kp Pyramid:(Pyramid *)pyramid
{
    ImageMatrix *im=[pyramid getGaussianMatrixAtOctave:kp->octave_num Interval:kp->interval_num];
    int width=im->imageWidth;
    int height=im->imageHeight;
    int x=kp->x_oct;
    int y=kp->y_oct;
    int x1,y1;
    double scale=[self getScaleAtOctave:kp->octave_num Interval:kp->interval_num];
    double scale_oct=[self getOctaveScaleAtInterval:kp->interval_num];
    double sigma=1.5*scale_oct;
    int radius=(int)(3.0*1.5*scale_oct);
    double magnitude,theta;
    double histogram[36];
    
    for(int i=0;i<36;i++)
        histogram[i]=0.0;
    
    for(int i=-radius;i<radius;i++){
        for(int j=-radius;j<radius;j++){
            x1=x+j;
            y1=y+i;
            if(x1>0 && x1<width-1 && y1>0 && y1<height-1){
                double dx=im->pImage[y1*width+x1+1]-im->pImage[y1*width+x1-1];
                double dy=im->pImage[(y1+1)*width+x1]-im->pImage[(y1-1)*width+x1];
                magnitude=sqrt(dx*dx+dy*dy);
                theta=atan2(-dy,dx);
                
                int index=(int)(36*(theta+PI)/PI/2.0);
                if(index<0) index=0;
                else if(index>35) index=35;
                
                double mid=(i*i+j*j)/(2*sigma*sigma);
                double gaussian=(1.0/(2*PI*sigma*sigma))* pow(EULER,-mid);
                
                histogram[index]=histogram[index]+gaussian*magnitude;
            }
        }
    }
    
    double max=0.0;
    int max_index=0;
    for(int i=0;i<36;i++)
        if(histogram[i]>max){
            max=histogram[i];
            max_index=i;
        }
    kp->theta=2.0*PI*max_index/36.0-PI;
    
    for(int i=0;i<36;i++)
        if(i!=max_index && histogram[i]>0.8*max){
            Keypoint *newkp=[[Keypoint alloc] initWithKeypoint:kp];
            newkp->theta=2.0*PI*i/36.0-PI;
            [duplicateKeypoints addObject:newkp];
        }
}

- (void)calculateDescriptors
{
    int length=[keypoints count];
    for(int i=0;i<length;i++){
        
        //test
        if(i==40){
            int ggg=0;
        }
        
        Keypoint *kp=[keypoints objectAtIndex:i];
        [self calculateDescriptorAtKeypoint:kp Pyramid:pyr];
    }
}

- (void)calculateDescriptorAtKeypoint:(Keypoint *)kp Pyramid:(Pyramid *)pyramid
{
    ImageMatrix *im=[pyramid getDifferenceOfGaussianMatrixAtOctave:kp->octave_num
                                                          Interval:kp->interval_num];
    
    double kp_theta=kp->theta;
    double magnitude,theta;
    int x=kp->x_oct;
    int y=kp->y_oct;
    int x1,y1;
    int i,j,k;
    int i_rot,j_rot;
    double index_x_f,index_y_f,index_theta_f;
    int index_x,index_y,index_theta;
    int index_x_new,index_y_new,index_theta_new;
    int width=im->imageWidth;
    int height=im->imageHeight;
    double w;
    double scale=[self getScaleAtOctave:kp->octave_num Interval:kp->interval_num];
    double scale_oct=[self getOctaveScaleAtInterval:kp->interval_num];
    int radius=round(3*scale_oct*sqrt(2)*(4+1)/2);
    
    //clear descriptor
    for(i=0;i<4;i++)
        for(j=0;j<4;j++)
            for(k=0;k<8;k++)
                kp->descriptor[i][j][k]=0;
    
    //calculate descriptor
    for(i=-radius;i<radius;i++){
        for(j=-radius;j<radius;j++){
            x1=x+j;
            y1=y+i;
            if(x1>0 && x1<width-1 && y1>0 && y1<height-1){
                //calculate coordinate in theta
                j_rot=j*cos(kp_theta) - i*sin(kp_theta);
                i_rot=j*sin(kp_theta) + i*cos(kp_theta);
                
                index_x_f=j_rot/(3*scale_oct)+2-0.5;
                index_y_f=i_rot/(3*scale_oct)+2-0.5;
                index_x=floor(index_x_f);
                index_y=floor(index_y_f);
                
                //if the point is in the 5x5 area, jump in.
                if(index_x_f>-1.0 && index_x_f<4.0 && index_y_f>-1.0 && index_y_f<4.0){
                    //calculate magnitude and orientation
                    double dx=im->pImage[y1*width+x1+1]-im->pImage[y1*width+x1-1];
                    double dy=im->pImage[(y1+1)*width+x1]-im->pImage[(y1-1)*width+x1];
                    magnitude=sqrt(dx*dx+dy*dy);
                    theta=atan2(-dy,dx)+PI;
                    
                    index_theta_f=theta/(2.0*PI/8);
                    if(index_theta_f>=8.0) index_theta_f=0.0;
                    index_theta=floor(index_theta_f);
                    
                    //calculate magnitude with gaussian
                    w=magnitude*exp(-(i_rot*i_rot+j_rot*j_rot)/(2.0*0.5*0.5*4*4));
                    
                    //interpolation
                    for(int ii=0;ii<=1;ii++){
                        index_y_new=index_y+ii;
                        if(index_y_new>=0 && index_y_new<4){
                            for(int jj=0;jj<=1;jj++){
                                index_x_new=index_x+jj;
                                if(index_x_new>=0 && index_x_new<4){
                                    for(int kk=0;kk<=1;kk++){
                                        index_theta_new=index_theta+kk;
                                        if(index_theta_new>=8)
                                            index_theta_new=0;
                                        
                                        //calculate coefficients
                                        double co1,co2,co3;
                                        
                                        if(ii==0)
                                            co1=1.0-(index_y_f-index_y);
                                        else
                                            co1=index_y_f-index_y;
                                        if(jj==0)
                                            co2=1.0-(index_x_f-index_x);
                                        else
                                            co2=index_x_f-index_x;
                                        if(kk==0)
                                            co3=1.0-(index_theta_f-index_theta);
                                        else
                                            co3=index_theta_f-index_theta;
                                        
                                        kp->descriptor[index_y_new][index_x_new][index_theta_new]
                                        +=w*co1*co2*co3;
                                    }
                                }
                            }
                        }
                    }
                    //interpolation ends
                }
            }
        }
    }
    
    //normalize descriptor
    [self normalizeDescriptor:kp];
}

- (void)normalizeDescriptor:(Keypoint *)kp
{
    double sum=0;
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
            for(int k=0;k<8;k++)
                sum+=kp->descriptor[i][j][k];
    
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
            for(int k=0;k<8;k++)
                kp->descriptor[i][j][k]/=sum;
}



- (Keypoint *)getKeypointAtIndex:(int)index __attribute((ns_returns_retained))
{
    return [keypoints objectAtIndex:index];
}

- (int)getLength
{
    return [keypoints count];
}

- (double)getScaleAtOctave:(int)octave_num Interval:(int)interval_num;
{
    return pyr->sigma[0]*pow(2.0,octave_num+(double)interval_num/(double)pyr->intervalNum);
}

- (double)getOctaveScaleAtInterval:(int)interval_num
{
    return pyr->sigma[0]*pow(2.0,(double)interval_num/(double)pyr->intervalNum);
}



- (void)output
{
    FILE *fp=fopen("/Users/heqiyun/Desktop/keypoints.txt", "w");
    
    int length=[keypoints count];
    for(int l=0;l<length;l++){
        Keypoint *kp=[keypoints objectAtIndex:l];
        fprintf(fp,"Keypoint: %d\n",l+1);
        fprintf(fp,"Position: %d %d\n",kp->y,kp->x);
        for(int i=0;i<4;i++)
            for(int j=0;j<4;j++)
                for(int k=0;k<8;k++)
                    fprintf(fp,"%f ",kp->descriptor[i][j][k]);
        fprintf(fp,"\n");
    }
    
    fclose(fp);
}

@end