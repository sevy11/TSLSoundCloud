//
//  SoundCloudManager.h
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/16/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SoundCloud.h"
#import "SCUI.h"
#import "Track.h"
#import "Playlist.h"

@interface SoundCloudManager : NSObject

typedef void (^resultBlockWithTracks)(NSMutableArray *tracks, NSError *error);
typedef void (^resultBlockWithLists)(NSArray *playlist, NSError *error);

@property (strong, nonatomic) SCAccount *account;
@property (strong, nonatomic) Track *selectedTrack;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSArray *playlist;

+(SoundCloudManager*)sharedSettings;

-(void)accountAccess:(SCAccount*)account;
-(void)search:(SCAccount*)account track:(NSString*)track withBlock:(resultBlockWithTracks)trackArray;
-(void)getPlaylists:(SCAccount*)account withBlock:(resultBlockWithLists)lists;

-(void)parseUserData:(NSDictionary*)soundDict;
@end
