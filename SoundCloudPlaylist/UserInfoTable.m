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
#import "SCUI.h"

@interface UserInfoTable()

@property (strong, nonatomic) SCAccount *account;
@end
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

        self.userImageView.layer.cornerRadius = 50.0;
        self.userImageView.layer.masksToBounds = YES;
        NSURL *url = [NSURL URLWithString:user.avatarURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.userImageView.image = [UIImage imageWithData:data];

    }
}

#pragma mark -- TABLEVIEW DELEGATES
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
            [SCSoundCloud removeAccess];
            self.logoutLabel.textColor = [UIColor redColor];

            self.account = [SoundCloudManager sharedSettings].account;

            if(self.account == nil)
            {
                [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){

                    SCLoginViewController *loginViewController;
                    loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                                  completionHandler:^(NSError *error){

                                                                                      if (SC_CANCELED(error))
                                                                                      {
                                                                                          NSLog(@"Canceled!");
                                                                                      }
                                                                                      else if (error)
                                                                                      {
                                                                                          NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                                                                      }
                                                                                      else
                                                                                      {
                                                                                          NSLog(@"User Logged in!");
                                                                                      }
                                                                                  }];

                    [self presentViewController:loginViewController animated:YES completion:^{
                        
                        [[SoundCloudManager sharedSettings] accountAccess:self.account];
                        [SoundCloudManager sharedSettings].account = self.account;
                    }];
                }];
            }
            else
            {
                NSLog(@"logged out");
            }
            break;
        default:
            break;
    }
}
@end
