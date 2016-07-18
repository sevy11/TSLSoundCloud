//
//  UserInfoTable.m
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/18/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "UserInfoTable.h"
#import "SoundCloudManager.h"
#import "SoundCloud.h"

@implementation UserInfoTable

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"User";

    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    for (SoundCloud *user in [SoundCloudManager sharedSettings].userArray)
    {
        self.usernameLabel.text = user.username;
        NSString *listCount = [NSString stringWithFormat:@"Playlists: %@", user.playlistCount];
        self.infoLabel.text = listCount;
        NSURL *url = [NSURL URLWithString:user.avatarURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.userImageView.image = [UIImage imageWithData:data];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 0.0;
            break;
        case 1:
            return 35.0;
            break;
        default:
            return 0.0;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            break;
        case 1:
            //[SCSoundCloud removeAccess];
            self.logoutLabel.textColor = [UIColor redColor];
            break;
        default:
            break;
    }
}
@end
