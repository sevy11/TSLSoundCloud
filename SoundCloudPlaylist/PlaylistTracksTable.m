//
//  PlaylistTracksTable.m
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/18/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "PlaylistTracksTable.h"
#import "Track.h"
#import "SoundCloudManager.h"

@interface PlaylistTracksTable()

@property (strong, nonatomic) NSMutableArray *tracks;
@end

@implementation PlaylistTracksTable


-(void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Tracks";

    UIBarButtonItem *editButton = [UIBarButtonItem new];
    [editButton setTitle:@"Edit"];
    [editButton setTarget:self];
    [editButton setAction:@selector(btnClicked:)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];

    self.tracks = [NSMutableArray new];

    for (NSDictionary *dict in self.listTracks)
    {
        Track *track = [Track new];

        id trackArt = dict[@"artwork_url"];
        NSString *trackTitle = dict[@"title"];
        NSNumber *trackId = dict[@"id"];
        NSDictionary *userDict = dict[@"user"];
        NSString *username = userDict[@"username"];

        NSString *displayNameType = @"";
        if (trackArt != [NSNull null])
        {
            displayNameType = (NSString *)trackArt;
            track.artworkURL = trackArt;
        }
        else
        {
            track.artworkURL = nil;
        }

        track.title = trackTitle;
        track.trackId = trackId;
        track.username = username;

        [self.tracks addObject:track];
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void) btnClicked:(id)sender
{
    NSLog(@"edit list with POST calls to SC to add/delete tracks from tracks array");
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tracks.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TracksCell"];
    Track *track = [self.tracks objectAtIndex:indexPath.row];

    cell.textLabel.text = track.title;
    cell.detailTextLabel.text = track.username;

    if (track.artworkURL)
    {
        NSURL *url = [NSURL URLWithString:track.artworkURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.imageView.image = [UIImage imageWithData:data];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SoundCloudManager sharedSettings].selectedTrack = [self.tracks objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:@"TrackDetails" sender:self];
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"edit tracks here");
}
@end
