//
//  SoundCloud.h
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/16/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundCloud : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *fullName;

@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *userPageURL;
@property (strong, nonatomic) NSNumber *playlistCount;
@property (strong, nonatomic) NSNumber *trackCount;

@end
