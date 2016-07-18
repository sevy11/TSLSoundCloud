//
//  SoundCloudManager.m
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/16/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "SoundCloudManager.h"
#import "Track.h"
#import "Playlist.h"

#define CLIENT_ID @"5d56ce12bf54a1a60632a180aeb8fa57"

@implementation SoundCloudManager

+ (id)sharedSettings
{
    static SoundCloudManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

-(void)accountAccess:(SCAccount*)account
{
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me.json"]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){

                 if (error)
                 {
                     NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                 }
                 else
                 {
                     NSDictionary *objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                     self.userId = objects[@"id"];
                 }
             }];
}

-(void)search:(SCAccount*)account track:(NSString*)track withBlock:(resultBlockWithTracks)trackArray;
{
    NSDictionary *artistSearch = @{@"q" : track};
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:@"https://api.soundcloud.com/tracks.json"]
             usingParameters:artistSearch
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){

                 if (error)
                 {
                     NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                     trackArray(nil, error);
                 }
                 else
                 {
                     NSArray *tracks = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                     NSMutableArray *localTracks = [NSMutableArray new];

                     for (NSDictionary *track in tracks)
                     {
                         trackArray([self parseTrack:track arrayToPass:localTracks], nil);
                     }
                 }
             }];
}

-(void)getPlaylists:(SCAccount*)account withBlock:(resultBlockWithLists)lists
{
    NSString *urlStr = [NSString stringWithFormat:@"https://api.soundcloud.com/me/playlists.json"];
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:urlStr]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){

                 if (error)
                 {
                     NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                 }
                 else
                 {
                     NSArray *playlists = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                     //NSDictionary *dict = playlists.firstObject;
                     lists(playlists, nil);
                     //self.playlist = playlists;
//                     NSMutableArray *localList = [NSMutableArray new];
//
//                     for (NSDictionary *list in playlists)
//                     {
//                         lists([self parseList:list arrayToPass:localList], nil);
//                         //self.playlist = [self parseList:list arrayToPass:localList];
//                     }
                 }
             }];
}

-(void)addSongToPlaylist:(SCAccount*)account withTrackId:(NSNumber*)track
{
    NSString *urlStr = [NSString stringWithFormat:@"https://api.soundcloud.com/me/playlists.json"];
    [SCRequest performMethod:SCRequestMethodPOST
                  onResource:[NSURL URLWithString:urlStr]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){

                 if (error)
                 {
                     NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                 }
                 else
                 {
                     NSLog(@"save track to playlist: %@", response);
                 }
             }];
}

-(NSMutableArray*)parseList:(NSDictionary*)listDict arrayToPass:(NSMutableArray*)localLists
{
    Playlist *list = [Playlist new];

    NSNumber *listId = listDict[@"id"];
    NSString *listTitle = listDict[@"title"];
    NSArray *tracks = listDict[@"tracks"];

    if (listId != nil)
    {
        list.listId = listId;
    }

    if (listTitle != nil)
    {
        list.title = listTitle;
    }
    else
    {
        list.title = @"Untitled";
    }

    if (tracks != nil)
    {
        list.tracks = tracks;
    }

    [localLists addObject:list];
    
    return localLists;
}


-(NSMutableArray*)parseTrack:(NSDictionary*)trackDict arrayToPass:(NSMutableArray*)localTracks
{
    NSDictionary *userDict = trackDict[@"user"];
    Track *track = [Track new];

    NSString *trackID = trackDict[@"id"];
    NSString *trackTitle = trackDict[@"title"];
    NSString *trackStream = trackDict[@"stream_url"];
    id trackArt = trackDict[@"artwork_url"];
    NSString *artistAvatar = userDict[@"avatar_url"];
    NSString *artistUser = userDict[@"username"];

    //track
    if (trackID != nil)
    {
        track.trackId = trackDict[@"id"];
    }

    if (trackTitle != nil)
    {
        track.title = trackDict[@"title"];
    }
    else
    {
        track.title = @"N/A";
    }

    if (trackStream != nil)
    {
        track.streamURL = trackDict[@"stream_url"];
    }

    NSString *displayNameType = @"";
    if (trackArt != [NSNull null])
    {
        displayNameType = (NSString *)trackArt;
        track.artworkURL = trackDict[@"artwork_url"];
    }
    else
    {
        track.artworkURL = nil;
    }

    //artist
    if (artistAvatar != nil)
    {
        track.avatarURL = userDict[@"avatar_url"];
    }

    if (artistUser != nil)
    {
        track.username = userDict[@"username"];
    }
    else
    {
        track.username = @"N/A";
    }

    [localTracks addObject:track];

    return localTracks;
}



-(void)parseUserData:(NSDictionary*)soundDict
{
    SoundCloud *sc = [SoundCloud new];

    sc.userId = soundDict[@"id"];
    sc.username = soundDict[@"username"];
    sc.fullName = soundDict[@"full_name"];
    sc.avatarURL = soundDict[@"avatar_url"];
    sc.city = soundDict[@"city"];
    sc.userPageURL = soundDict[@"permalink_url"];
    sc.playlistCount = soundDict[@"playlist_count"];
    sc.trackCount = soundDict[@"track_count"];
}
@end

