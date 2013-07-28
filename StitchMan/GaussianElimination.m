//
//  GaussianElimination.m
//  StitchMan
//
//  Created by wjy on 13-7-27.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "GaussianElimination.h"

@implementation GaussianElimination

+ (BOOL)solveWithVariate:(int)num Matrix:(double *)mat
{
    int i,j,k,max;
    double x;
    double tmp;
    
    
    //output
    [self output:num Matrix:mat];
    
    //convert to triangle type
    for(i=0;i<num-1;i++){
        
        //find maximum
        max=i;
        for(k=i;k<num;k++)
            if(fabs(mat[k*(num+1)+i])>fabs(mat[max*(num+1)+i]))
                max=k;
        //swap
        for(k=i;k<num+1;k++){
            tmp=mat[i*(num+1)+k];
            mat[i*(num+1)+k]=mat[max*(num+1)+k];
            mat[max*(num+1)+k]=tmp;
        }
        
        for(k=i;k<num-1;k++){
            //caculate coefficient
            x=-mat[(k+1)*(num+1)+i]/mat[i*(num+1)+i];
            
            //subtract the (j)th row and x times (i)th row
            for(j=i;j<num+1;j++){
                mat[(k+1)*(num+1)+j]=mat[(k+1)*(num+1)+j]+mat[i*(num+1)+j]*x;
            }
        }
        
        //output
        [self output:num Matrix:mat];
        
    }
    
    //check the last row
    if(mat[(num-1)*(num+1)+num-1]==0.0)
        return FALSE;
    
    //convert to diagonal type
    for(i=num-2;i>=0;i--){
        for(k=i;k>=0;k--){
            //caculate coefficient
            x=-mat[k*(num+1)+i+1]/mat[(i+1)*(num+1)+i+1];
            
            //subtract the (j)th row and x times (i)th row
            for(j=i;j<num+1;j++){
                mat[k*(num+1)+j]=mat[k*(num+1)+j]+mat[(i+1)*(num+1)+j]*x;
            }
        }
    }
    
    //normalize
    for(i=0;i<num;i++){
        mat[i*(num+1)+num]=mat[i*(num+1)+num]/mat[i*(num+1)+i];
        mat[i*(num+1)+i]=1;
    }
    
    
    //output
    [self output:num Matrix:mat];
    
    return TRUE;
}

+ (void)output:(int)num Matrix:(double *)mat
{
    for(int i=0;i<num;i++){
        for(int j=0;j<num+1;j++){
            printf("%f ",mat[i*(num+1)+j]);
        }
        printf("\n");
    }
    printf("\n");
}

@end