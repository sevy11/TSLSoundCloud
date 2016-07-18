//
//  ArtistInfoTable.m
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/17/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "ArtistInfoTable.h"
#import "SoundCloudManager.h"
#import "UIImage+SC.h"

@implementation ArtistInfoTable

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Track";

    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    self.trackName.text = [SoundCloudManager sharedSettings].selectedTrack.title;
    self.artistLabel.text = [NSString stringWithFormat:@"By: %@", [SoundCloudManager sharedSettings].selectedTrack.username];

    //check for cover art, if no revert to artists art
    if ([SoundCloudManager sharedSettings].selectedTrack.artworkURL.length > 1)
    {
        [self displayCoverArtImage:[SoundCloudManager sharedSettings].selectedTrack.artworkURL];
    }
    else
    {
        [self displayCoverArtImage:[SoundCloudManager sharedSettings].selectedTrack.avatarURL];
    }
}

-(void)displayCoverArtImage:(NSString*)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.coverArtImage.image = [UIImage imageWithImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(100, 100)];
    self.coverArtImage.layer.cornerRadius = 50.0;
    self.coverArtImage.layer.masksToBounds = YES;
}
@end