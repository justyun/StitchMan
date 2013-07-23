//
//  ViewController.m
//  StitchMan
//
//  Created by wjy on 13-7-1.
//  Copyright (c) 2013年 wjy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//@synthesize imageView;
int count=0;
int hasMergedImage=0;

- (id)init
{
    self=[super init];
    //imageView=[[UIImageView alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openImage
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(IBAction)stitchWithoutOverlap{
    if(count!=0){
        mergedImage = [Stitcher mergeTheImage:image[0] withImage:image[1]];
        self.imageView.image = mergedImage;
        count = 1;
        image[0] = mergedImage;
        hasMergedImage = 1;
    }
}

-(IBAction)saveToCameraRoll{
    if (hasMergedImage==1) {
        UIImageWriteToSavedPhotosAlbum(mergedImage, nil, nil, nil);
    }
}

-(IBAction)cancel{
    count = 0;
    mergedImage = nil;
    self.imageView.image = nil;


}

-(IBAction)sift{
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image[count]=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image=image[count];
    //ImageMatrix *imageMatrix=[ImageConverter UIImage2ImageMatrixY:image];
    //[imageMatrix print];
    //Pyramid *test=[[Pyramid alloc] initWithImageMatrix:imageMatrix];
    
    ImageMatrix *im=[ImageConverter UIImage2ImageMatrixY:image[count]];
    SIFT *sift=[[SIFT alloc] initWithImageMatrix:im];
    self.imageView.image=[ImageConverter Luminance2UIImage:im withMark:[sift output]];
    
   // sift->keypointVector
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Image size: %.0f x %.0f",image[count].size.width,image[count].size.height);
    count++;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"No Image is picked up.");
}

@end
