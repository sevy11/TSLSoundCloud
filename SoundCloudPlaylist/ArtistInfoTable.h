//
//  ArtistInfoTable.h
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/17/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistInfoTable : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *coverArtImage;
@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

@end
