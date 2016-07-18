//
//  UIImage+SC.m
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/17/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "UIImage+SC.h"

@implementation UIImage (SC)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
