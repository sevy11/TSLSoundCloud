//
//  UIImage+SC.h
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/17/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SC)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
