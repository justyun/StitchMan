//
//  ViewController.h
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageMatrix.h"
#import "ImageConverter.h"
#import "Pyramid.h"
#import "Stitcher.h"
#import "SIFT.h"

@interface ViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    int count;
    int hasMergedImage;

    //UIImage *image;
    UIImage *image[5];
    //UIImageView *imageView;
    UIImage *mergedImage;

}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

-(IBAction)openImage;

-(IBAction)stitchWithoutOverlap;

-(IBAction)saveToCameraRoll;

-(IBAction)cancel;

-(IBAction)sift;

-(void) freeImage;

@end
