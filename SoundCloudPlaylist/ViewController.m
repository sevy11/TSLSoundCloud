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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playlists;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settings;
@property (strong, nonatomic) SCAccount *account;

#define CLIENT_ID @"5d56ce12bf54a1a60632a180aeb8fa57"

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


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

                [self accountAccess:self.account];
            }];
        }];
    }

    else
    {
        [self accountAccess:self.account];
       // NSLog(@"user is logged in: %@", self.account);
        [self accountAccess:self.account];
    }
}

- (IBAction)onPlaylists:(UIBarButtonItem *)sender
{
    [self loadUserData:@"playlists"];
}
- (IBAction)onSettings:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"Settings" sender:self];
    
    //put in account page: [SCSoundCloud removeAccess];
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
                              NSArray *objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                              for (NSDictionary *sound in objects)
                              {
                                  [self parseSCUserData:sound];
                              }
                          }
                      }];
}

-(void)parseSCUserData:(NSDictionary*)soundDict
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
//atomic) NSString *userId;
//@property (strong, nonatomic) NSString *username;
//@property (strong, nonatomic) NSString *fullName;
//
//@property (strong, nonatomic) NSString *avatarURL;
//@property (strong, nonatomic) NSString *city;
//@property (strong, nonatomic) NSString *userPageURL;
//@property int *playlistCount;
//@property int *trackCount;

-(void)loadUserSettings
{
    NSString *url = [NSString stringWithFormat:@"http://api.soundcloud.com/tracks?client_id=%@", CLIENT_ID];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, NSData *data , NSError * _Nullable error) {

        if (!response)
        {
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"user data: %@", response);
            NSArray *objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

            for (NSDictionary *sound in objects)
            {
                NSLog(@"data serialized: %@", sound[@"title"]);
            }

        }
    }];
    
    [dTask resume];
}

-(void)loadUserData:(NSString*)userDataEndPoint
{
    NSString *url = [NSString stringWithFormat:@"http://api.soundcloud.com/%@?client_id=%@", userDataEndPoint, CLIENT_ID];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, NSData *data , NSError * _Nullable error) {

        if (!response)
        {
            NSLog(@"error: %@", error);
            //[self.delegate failedToFetchPagnation:error];
        }
        else
        {
            NSArray *objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

            for (NSDictionary *sound in objects)
            {
                NSLog(@"data serialized: %@", sound[@"title"]);
            }
        }
    }];

    [dTask resume];
}
@end







