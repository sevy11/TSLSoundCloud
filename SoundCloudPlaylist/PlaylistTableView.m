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
#import "PlaylistTracksTable.h"

@interface PlaylistTableView()

@property (strong, nonatomic) NSMutableArray *playlists;
@property (strong, nonatomic) NSArray *trackArray;

@end

@implementation PlaylistTableView



-(void)viewDidLoad
{
    [super viewDidLoad];

    self.playlists = [NSMutableArray new];
    self.trackArray = [NSArray new];

    self.navigationItem.title = @"Playlists";

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[SoundCloudManager sharedSettings] getPlaylists:[SoundCloudManager sharedSettings].account withBlock:^(NSArray *playlist, NSError *error) {

        //move parsing to SCManager
        for (NSDictionary *dict in playlist)
        {
            Playlist *play = [Playlist new];
            play.title = dict[@"title"];
            play.tracks = dict[@"tracks"];
            play.listId = dict[@"id"];
            play.listArt = dict[@"artwork_url"];

            NSString *displayNameType = @"";
            if (play.listArt != [NSNull null])
            {
                displayNameType = (NSString *)play.listArt;
                play.listArt = dict[@"artwork_url"];
            }
            else
            {
                play.listArt = nil;
            }


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

    //always checking for object in the image field
    cell.textLabel.text = list.title;

    NSURL *url = [NSURL URLWithString:list.listArt];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.imageView.image = [UIImage imageWithData:data];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self addActionSheetForList];








    Playlist *list = [self.playlists objectAtIndex:indexPath.row];
    self.trackArray = list.tracks;

    //empty array when user comes back around to prevent dupes
    [self.playlists removeAllObjects];
    [self performSegueWithIdentifier:@"PlaylistTracks" sender:self];
}

-(void)addActionSheetForList
{

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Playlist" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];

    NSString *trackToAdd = [NSString stringWithFormat:@"Add Track:%@",[SoundCloudManager sharedSettings].selectedTrack.title
];
    [actionSheet addAction:[UIAlertAction actionWithTitle:trackToAdd style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        //POST action here

    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Playlist Details" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self performSegueWithIdentifier:@"PlaylistTracks" sender:self];
    }]];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlaylistTracks"])
    {
        PlaylistTracksTable *ptt = segue.destinationViewController;
        ptt.listTracks = self.trackArray;
    }
}
@end






