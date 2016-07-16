//
//  SoundCloudManager.h
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/16/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundCloud.h"
#import "SCUI.h"
#import <AFNetworking.h>

@interface SoundCloudManager : NSObject

+(SoundCloudManager*)sharedSettings;

-(void)accountAccess:(SCAccount*)account;
-(void)parseSCUserData:(NSDictionary*)soundDict;

@end
