//
//  Track.h
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/17/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject
//track
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *trackId;
@property (strong, nonatomic) NSString *uri;
@property (strong, nonatomic) NSString *streamURL;
@property (strong, nonatomic) NSString *artworkURL;
//user
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *avatarURL;

@end
