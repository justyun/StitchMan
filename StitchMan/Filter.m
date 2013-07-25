//
//  Convolution.m
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "Filter.h"

@implementation Filter

- (void)dealloc
{
	//NSLog(@"dealloc called");
}

+ (ImageMatrix *)convWithGaussian:(ImageMatrix *)target
sigma:(float)sigma filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
	return [Filter conv:target filter:[Filter getGaussianFilter:sigma
															   filterSize:filterSize]];
}

+ (ImageMatrix *)convWithGaussianFast:(ImageMatrix *)target
sigma:(float)sigma filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
    ImageMatrix *hg=[self getHorizontalGaussianFilter:sigma filterSize:filterSize];
    ImageMatrix *vg=[self getVerticalGaussianFilter:sigma filterSize:filterSize];
    
	return [Filter conv:target horizontalFilter:hg verticalFilter:vg];
}

+ (ImageMatrix *)conv:(ImageMatrix *)target filter:(ImageMatrix *)filter
__attribute((ns_returns_retained))
{
	int targetHeight=target->imageHeight;
	int targetWidth=target->imageWidth;
	int filterHeight=filter->imageHeight;
	int filterWidth=filter->imageWidth;
	
    ImageMatrix *result=[[ImageMatrix alloc] initWithHeight:targetHeight Width:targetWidth];
    float *pFilterImage=filter->pImage;
    float *pTargetImage=target->pImage;
    float *pResultImage=result->pImage;
	
    //if the target is too small, return the target without convolution.
    //if(targetHeight<filterHeight || targetWidth<filterWidth)
    //    return target;
    for(int i=0;i<targetHeight;i++){
        for(int j=0;j<targetWidth;j++){
            //opeation on each pixel
            int targetBaseWidth=j-filterWidth/2;
            int targetBaseHeight=i-filterHeight/2;
            float sum=0;
            
            for(int m=0;m<filterHeight;m++){
                for(int n=0;n<filterWidth;n++){
                    float targetValue;
                    float filterValue;
                    int targetIndexHeight=targetBaseHeight+m;
                    int targetIndexWidth=targetBaseWidth+n;
                    
                    if(targetIndexHeight<0)
                        targetIndexHeight=0;
                    else if(targetIndexHeight>=targetHeight)
                        targetIndexHeight=targetHeight-1;
                    if(targetIndexWidth<0)
                        targetIndexWidth=0;
                    else if(targetIndexWidth>=targetWidth)
                        targetIndexWidth=targetWidth-1;
                    
					filterValue
                    =pFilterImage[m*filter->imageWidth+n];
                    targetValue
                    =pTargetImage[targetIndexHeight*target->imageWidth+targetIndexWidth];
                    
                    sum=sum+filterValue*targetValue;
                }
            }
            pResultImage[i*targetWidth+j]=sum;
        }
    }
    
    return result;
}

+ (ImageMatrix *)conv:(ImageMatrix *)target
     horizontalFilter:(ImageMatrix *)horizontalFilter verticalFilter:(ImageMatrix *)verticalFilter
__attribute((ns_returns_retained))
{
	int targetHeight=target->imageHeight;
	int targetWidth=target->imageWidth;
	int filterHeight=verticalFilter->imageHeight;
	int filterWidth=horizontalFilter->imageWidth;
    
    float targetValue;
    float filterValue;
    int targetIndexHeight;
    int targetIndexWidth;
	
    //printf("height = %d\n",targetHeight);
    //printf("width = %d\n",targetWidth);
    //printf("filter size = %d\n",filterHeight);
    
    //ImageMatrix *tmp=[[ImageMatrix alloc] initWithHeight:targetHeight Width:targetWidth];
    float *pHorizontalFilterImage=horizontalFilter->pImage;
    float *pVerticalFilterImage=verticalFilter->pImage;
    float *pTargetImage=target->pImage;
    float *tmp=malloc(sizeof(float)*targetHeight*targetWidth);
    ImageMatrix *result=[[ImageMatrix alloc] initWithHeight:targetHeight Width:targetWidth];
    float *pResultImage=result->pImage;
    
    for(int i=0;i<targetHeight;i++){
        for(int j=0;j<targetWidth;j++){
            //opeation on each pixel
            int targetBaseWidth=j-filterWidth/2;
            float sum=0;
            for(int m=0;m<filterWidth;m++){
                    targetIndexWidth=targetBaseWidth+m;
                    
                    if(targetIndexWidth<0)
                        targetIndexWidth=0;
                    else if(targetIndexWidth>=targetWidth)
                        targetIndexWidth=targetWidth-1;
                    
					filterValue
					=pHorizontalFilterImage[m];
                    targetValue
                    =pTargetImage[i*targetWidth+targetIndexWidth];
                    
                    sum=sum+filterValue*targetValue;
            }
            //[tmp setValueAtHeight:i Width:j Value:sum];
            tmp[i*targetWidth+j]=sum;
        }
    }
    
    for(int i=0;i<targetHeight;i++){
        for(int j=0;j<targetWidth;j++){
            //opeation on each pixel
            int targetBaseHeight=i-filterHeight/2;
            float sum=0;
            for(int m=0;m<filterHeight;m++){
                targetIndexHeight=targetBaseHeight+m;
                
                if(targetIndexHeight<0)
                    targetIndexHeight=0;
                else if(targetIndexHeight>=targetHeight)
                    targetIndexHeight=targetHeight-1;
                
                filterValue
                =pVerticalFilterImage[m];
                targetValue
                =tmp[targetIndexHeight*targetWidth+j];
                
                sum=sum+filterValue*targetValue;
            }
            pResultImage[i*targetWidth+j]=sum;
        }
    }
    
    free(tmp);
    tmp=NULL;
    
    return result;
}

+ (ImageMatrix *)getGaussianFilter:(float) sigma
filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
    int x,y;
    int size = sizeof(float)* filterSize *filterSize;
    int halfSize=filterSize/2;
	float value;
	float sum=0;
    float *filter = malloc(size);
	
    for (x=0; x<filterSize; x++) {
        for (y=0; y<filterSize; y++) {
            float mid = (pow((x - halfSize),2) + pow((y - halfSize),2))/(2*sigma*sigma);
			value=(1.0 / (2 * PI * sigma * sigma))* pow(EULER,-mid);
            filter[x * filterSize + y] = value;
			sum=sum+value;
        }
    }
	
	for (x=0; x<filterSize; x++)
        for (y=0; y<filterSize; y++)
            filter[x * filterSize + y] = filter[x * filterSize + y]/sum;
	
	ImageMatrix *filterMatrix=[[ImageMatrix alloc] initWithArray:filter
                                                          Height:filterSize Width:filterSize];
	
	//tmp
	//[filterMatrix print];
    free(filter);
	
    return filterMatrix;
}

+ (ImageMatrix *)getHorizontalGaussianFilter:(float) sigma
filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
    int x;
    int halfSize=filterSize/2;
	float value;
	float sum=0;
    float filter[100];
	
    for (x=0; x<filterSize; x++) {
            float mid = pow((x - halfSize),2)/(2*sigma*sigma);
			value=sqrt(1.0 / (2 * PI * sigma * sigma))* pow(EULER,-mid);
            filter[x] = value;
			sum=sum+value;
    }
	
	for (x=0; x<filterSize; x++)
            filter[x] = filter[x]/sum;
	
	ImageMatrix *filterMatrix=[[ImageMatrix alloc] initWithArray:filter
                                                          Height:1 Width:filterSize];
	
	//tmp
	//[filterMatrix print];
	
    return filterMatrix;
}

+ (ImageMatrix *)getVerticalGaussianFilter:(float) sigma
filterSize:(int)filterSize
__attribute((ns_returns_retained))
{
    int x;
    int halfSize=filterSize/2;
	float value;
	float sum=0;
    float filter[100];
	
    for (x=0; x<filterSize; x++) {
        float mid = pow((x - halfSize),2)/(2*sigma*sigma);
        value=sqrt(1.0 / (2 * PI * sigma * sigma))* pow(EULER,-mid);
        filter[x] = value;
        sum=sum+value;
    }
	
	for (x=0; x<filterSize; x++)
        filter[x] = filter[x]/sum;
    
	ImageMatrix *filterMatrix=[[ImageMatrix alloc] initWithArray:filter
                                                          Height:filterSize Width:1];
	
	//tmp
	//[filterMatrix print];
	
    return filterMatrix;
}

@end
