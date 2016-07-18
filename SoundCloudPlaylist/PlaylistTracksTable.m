//
//  PlaylistTracksTable.m
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/18/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "PlaylistTracksTable.h"
#import "Track.h"

@interface PlaylistTracksTable()

@property (strong, nonatomic) NSMutableArray *tracks;
@end

@implementation PlaylistTracksTable


-(void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Tracks";

    self.tracks = [NSMutableArray new];

    NSLog(@"listsT's: %@", self.listTracks);

    for (NSDictionary *dict in self.listTracks)
    {
        Track *track = [Track new];

        id trackArt = dict[@"artwork_url"];
        NSString *trackTitle = dict[@"title"];
        NSNumber *trackId = dict[@"id"];

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

        [self.tracks addObject:track];
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];


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

    if (track.artworkURL)
    {
        NSURL *url = [NSURL URLWithString:track.artworkURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.imageView.image = [UIImage imageWithData:data];
    }

    return cell;
}
@end
