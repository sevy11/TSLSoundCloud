//
//  Playlist.h
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/17/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *listId;
@property (strong, nonatomic) NSArray *tracks;


@end
