//
//  IPhoneViewController.m
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 4/18/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "IPhoneViewController.h"
#import "AirplayViewController.h"
#import "DataStore.h"
#import <FontAwesomeKit.h>



@interface IphoneViewController ()

@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UIButton *playPauseButton;
@property (strong, nonatomic) MPVolumeView *volumeView;


-(void)playButtonTapped;


@end

@implementation IphoneViewController

{
    BOOL _isPlaying;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

    FAKIonIcons *playPauseButton = [FAKIonIcons ios7PlayIconWithSize:150.0];
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.playPauseButton.frame = CGRectMake(300.0, 100.0, 120.0, 120.0);
    [self.playPauseButton addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.playPauseButton setAttributedTitle:[playPauseButton attributedString] forState:UIControlStateNormal];
    
    //[playButton setTitle:@"Play" forState:UIControlStateNormal];

    
    FAKIonIcons *musicSearch = [FAKIonIcons ios7SearchIconWithSize:150.0];
    UIButton *pickSong = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pickSong.frame = CGRectMake(50.0, 100.0, 120.0, 120.0);
    [pickSong addTarget:self action:@selector(pickSong) forControlEvents:UIControlEventTouchUpInside];
    [pickSong setAttributedTitle:[musicSearch attributedString] forState:UIControlStateNormal];
    
    

    CGRect frame = self.view.frame;
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height)];//44
    [self.navBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    UINavigationItem *navTitleItem = [[UINavigationItem alloc] initWithTitle:@"Pop Music"];
    [self.navBar pushNavigationItem:navTitleItem animated:NO];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];

    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.navBar];
    [self.view addSubview:pickSong];
    [self.view addSubview:self.playPauseButton];
    [self.view addSubview:volumeView];
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - Media (song) Picker

- (void)pickSong
{
    
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [picker setDelegate:self];
    [picker setAllowsPickingMultipleItems: NO];
    [self presentViewController:picker animated:YES completion:NULL];
    
}

#pragma mark - Media Picker Delegate

- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *) collection
{
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    

    MPMediaItem *item = [[collection items] objectAtIndex:0];
    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
    [_navBar.topItem setTitle:title];
    
    // get a URL reference to the selected item
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    // pass the URL to playURL
    
    DataStore *dataStore = [DataStore sharedDataStore];
    
    AirplayViewController *airplayVC = dataStore.airplayViewController;
 
    [airplayVC playURL:url];
    
    _isPlaying = YES;
    
    [self showPlayPauseButton];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *) mediaPicker

{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)playButtonTapped
{
    
    DataStore *dataStore =[DataStore sharedDataStore];
    
    AirplayViewController *airplayVC = dataStore.airplayViewController;
    
    [airplayVC playPause];
    
    _isPlaying = !_isPlaying;
    
    [self showPlayPauseButton];
        
}

-(void)showPlayPauseButton
{
    
    if (_isPlaying)
    {
        FAKIonIcons *playPauseButton = [FAKIonIcons ios7PauseIconWithSize:150.0];
        [self.playPauseButton setAttributedTitle:[playPauseButton attributedString] forState:UIControlStateNormal];
    }
    
    else
    {
        FAKIonIcons *playPauseButton = [FAKIonIcons ios7PlayIconWithSize:150.0];
        [self.playPauseButton setAttributedTitle:[playPauseButton attributedString] forState:UIControlStateNormal];
    }
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

