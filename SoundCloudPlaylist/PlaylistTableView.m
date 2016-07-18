//
//  PlaylistTableView.m
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/17/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "PlaylistTableView.h"
#import "SoundCloudManager.h"
#import "Playlist.h"

@interface PlaylistTableView()

@property (strong, nonatomic) NSMutableArray *playlists;
@end

@implementation PlaylistTableView



-(void)viewDidLoad
{
    [super viewDidLoad];

    self.playlists = [NSMutableArray new];

    self.navigationItem.title = @"Playlists";

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[SoundCloudManager sharedSettings] getPlaylists:[SoundCloudManager sharedSettings].account withBlock:^(NSArray *playlist, NSError *error) {


        for (NSDictionary *dict in playlist)
        {
            Playlist *play = [Playlist new];
            play.title = dict[@"title"];
            play.tracks = dict[@"tracks"];
            play.listId = dict[@"id"];

            [self.playlists addObject:play];
        }

        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playlists.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaylistCell"];
    Playlist *list = [self.playlists objectAtIndex:indexPath.row];

    cell.textLabel.text = list.title;
//    cell.detailTextLabel.text = track.username;
   // cell.imageView.image = [UIImage imageWithData:[self imageCheck:track.avatarURL]];

    return cell;
}
@end
