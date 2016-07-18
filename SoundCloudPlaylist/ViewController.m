//
//  ViewController.m
//  SoundCloudPlaylist
//
//  Created by Michael Sevy on 7/15/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "ViewController.h"
#import "SCUI.h"
#import <AFNetworking.h>
#import "SoundCloud.h"
#import "SoundCloudManager.h"
#import "Track.h"
#import "UIColor+SC.h"
#import "UIImage+SC.h"

@interface ViewController ()<UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate>

#define CLIENT_ID @"5d56ce12bf54a1a60632a180aeb8fa57"

@property (weak, nonatomic) IBOutlet UIBarButtonItem *playlists;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settings;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SCAccount *account;
@property (strong, nonatomic) NSMutableArray *tracks;

@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tracks = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;

    //Search Setup
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search Songs";
    [self.searchBar becomeFirstResponder];

    //NAV Setup
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexValue:@"ff8800"];
    self.playlists.image = [UIImage imageWithImage:[UIImage imageNamed:@"hamburger1"] scaledToSize:CGSizeMake(30, 30)];
    self.playlists.tintColor = [UIColor blackColor];
    self.settings.image = [UIImage imageWithImage:[UIImage imageNamed:@"noun_530953"] scaledToSize:CGSizeMake(30, 30)];
    self.settings.tintColor = [UIColor blackColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    self.account = [SCSoundCloud account];

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
        [[SoundCloudManager sharedSettings] accountAccess:self.account];
        [SoundCloudManager sharedSettings].account = self.account;
    }
}

#pragma SEARCH BAR DELEGATES
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    if(searchText.length == 0)
    {
        [self.tracks removeAllObjects];
        [self.tableView reloadData];
    }
    else
    {
        [[SoundCloudManager sharedSettings] search:self.account track:searchText  withBlock:^(NSMutableArray *tracks, NSError *error) {

            if (tracks)
            {
                self.tracks = tracks;
                [self.tableView reloadData];
            }
            else
            {
                NSLog(@"error: %@", [error localizedDescription]);
            }
        }];

        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (IBAction)onPlaylists:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"Playlist" sender:self];
}

- (IBAction)onSettings:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"Settings" sender:self];
}


#pragma mark -- TABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tracks.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Track *track = [self.tracks objectAtIndex:indexPath.row];

    cell.textLabel.text = track.title;
    cell.detailTextLabel.text = track.username;
    cell.imageView.image = [UIImage imageWithData:[self imageCheck:track.avatarURL]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SoundCloudManager sharedSettings].selectedTrack = [self.tracks objectAtIndex:indexPath.row];
    [self addActionSheetForTrack];
}

#pragma mark -- HELPERS
-(void)addActionSheetForTrack
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Track Options:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Add Song to Playlist" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self performSegueWithIdentifier:@"Playlist" sender:self];

    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"More Info" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self performSegueWithIdentifier:@"TrackDetail" sender:self];
    }]];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(NSData*)imageCheck:(NSString*)trackArt
{
    NSURL *url = [NSURL URLWithString:trackArt];
    NSData *data = [NSData dataWithContentsOfURL:url];

    return data;
}
@end


