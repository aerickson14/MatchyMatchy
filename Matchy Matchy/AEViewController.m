//
//  AEViewController.m
//  Spinner
//
//  Created by Andrew Erickson on 2/6/2014.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEViewController.h"
#import "AEStartScene.h"
#import "AEGameScene.h"
#import "AEBackgroundMusicPlayer.h"
#import "AEConstants.h"
#import "AEAppDelegate.h"
#import "AEPaymentManager.h"
#import "AEProductsManager.h"
#import "AEConfig.h"
@import AVFoundation;

@interface AEViewController() {
    UIView *overlayView;
    AEBackgroundMusicPlayer * backgroundMusicPlayer;
    AEScene *scene;
    
    AEProductsManager *productsManager;
    AEPaymentManager *paymentManager;
    AEDefaultsManager *defaultsManager;
    
    BOOL gameCenterEnabled;
}

@property (nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic) IBOutlet UIButton *leaderboardButton;
@property (nonatomic) IBOutlet UIButton *backToMainButton;
@property (nonatomic) IBOutlet UIButton *goToAppStoreButton;
@property (nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic) IBOutlet UILabel *musicLabel;
@property (nonatomic, retain) IBOutlet UISwitch *musicSwitch;
@property (nonatomic) IBOutlet UILabel *sfxLabel;
@property (nonatomic, retain) IBOutlet UISwitch *sfxSwitch;
@property (nonatomic) IBOutlet ADBannerView *adBanner;
@property (nonatomic) IBOutlet UIButton *removeAdsButton;

@property (nonatomic) IBOutlet UIButton *pauseButton;

@end

@implementation AEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self authenticatePlayer];
    
    [self setUpProducts];
    
    [self setUpPaymentManager];
    
    defaultsManager = [[AEDefaultsManager alloc] init];
    
    [self checkForAdRemoval];
    
    SKView *skView = (SKView *)self.view;
    
    if ([skView class] == [SKView class]) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        scene = [AEStartScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        self.musicSwitch.on = [scene isMusicEnabled];
        self.sfxSwitch.on = [scene isSfxEnabled];
        [self hideGameUIElements:YES];
        [self hideStartUIElements:NO];
        
        [skView presentScene:scene];
    }
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void) viewWillLayoutSubviews {
    backgroundMusicPlayer = [AEBackgroundMusicPlayer sharedPlayer];
}

-(BOOL) prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) viewWillDisappear:(BOOL)animated {
    //Pause the game
    //NSLog(@"View disappearing in vc");
}

-(void) viewDidAppear:(BOOL)animated {
    //Unpause the game
    //NSLog(@"View appearing in vc");
}

#pragma mark - iAd

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    //NSLog(@"failed to receive ad");

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    
    [banner setAlpha: 0];
    
    [UIView commitAnimations];
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner {

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    
    [banner setAlpha: 1];
    
    [UIView commitAnimations];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [scene setPaused:YES];
    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    [scene setPaused:NO];
}

#pragma mark - GameCenter

-(IBAction) showDefaultLeaderboard:(id)sender {
    [self showLeaderboard: @"matchymatchytotalxp"];
}

- (void) showLeaderboard: (NSString*) leaderboardID {
    
    if (gameCenterEnabled) {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        
        if (gameCenterController != nil) {
            
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
            gameCenterController.leaderboardIdentifier = leaderboardID;
            
            [self presentViewController: gameCenterController animated: YES completion:nil];
        }
    }
}

-(void) authenticatePlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    __weak GKLocalPlayer *weakPlayer = localPlayer;
    
    weakPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        
        if (viewController != nil) {
            [self presentViewController: viewController animated: YES completion:nil];
        } else {
            gameCenterEnabled = weakPlayer.isAuthenticated;
            
            [self.leaderboardButton setHidden: !gameCenterEnabled];

        }
    };
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

-(IBAction) playGame:(id)sender {
    [self hideStartUIElements:YES];
    
    SKView *skView = scene.view;
    
    scene = [[AEGameScene alloc] initWithSize:skView.bounds.size];
    SKTransition *fadeIn = [SKTransition fadeWithDuration:0.5];
    fadeIn.pausesIncomingScene = NO;
    
    [skView presentScene:scene transition: fadeIn];
    
    [self hideGameUIElements:NO];
}

-(IBAction) pauseGame:(id)sender {
    if (scene.isPaused) {
        [scene setPaused:NO];
        UIImage *pauseImage = [UIImage imageNamed:@"btn_pause"];
        [self.pauseButton setImage:pauseImage forState:UIControlStateNormal];
    } else {
        UIImage *playImage = [UIImage imageNamed:@"btn_play"];
        [self.pauseButton setImage:playImage forState:UIControlStateNormal];
        [scene setPaused:YES];
    }
}

-(IBAction) goToMainMenu:(id)sender {
    [self hideGameUIElements:YES];
    
    [scene stopMusic];
    
    SKView *skView = scene.view;
    
    scene = [[AEStartScene alloc] initWithSize:skView.bounds.size];
    SKTransition *fadeIn = [SKTransition fadeWithDuration:0.5];
    fadeIn.pausesIncomingScene = NO;
    
    [skView presentScene:scene transition: fadeIn];
    
    [self hideStartUIElements:NO];
}

-(IBAction) toggleMusic:(id) sender {
    [scene setMusic: self.musicSwitch.on];
}

-(IBAction) toggleSfx:(id) sender {
    [scene setSFX: self.sfxSwitch.on];
}

-(void) showTutorial {
    SKView *skView = scene.view;
    overlayView = [[UIView alloc] initWithFrame: skView.frame];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:@"btn_play"];
    [dismissButton setImage: btnImage forState: UIControlStateNormal];
    dismissButton.frame = CGRectMake(CGRectGetMidX(scene.frame) - 42, scene.frame.size.height - 70, 85, 50);
    [dismissButton addTarget:self action:@selector(dismissTutorial) forControlEvents:UIControlEventTouchUpInside];
    [overlayView addSubview: dismissButton];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, skView.frame.size.width-20, 350)];
    textView.text = @"Welcome to Matchy Matchy.\n\nTap on the scrolling icons to try and match up each of the rows to form an image.\n\nGetting multiple matches of the same image will improve your score.\n\nAs you progress through the levels the rows will start to spin faster and you will have to concentrate more to match them up.\n\nGood Luck!";
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont fontWithName:@"Arial" size:18];
    textView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    textView.editable = NO;
    [overlayView addSubview: textView];
    
    [skView addSubview: overlayView];
}

-(void) dismissTutorial {
    [overlayView removeFromSuperview];
    [self pauseGame: nil];
}

#pragma mark - UI Display and Actions

- (void)hideStartUIElements:(BOOL)shouldHide {
    CGFloat alpha = shouldHide ? 0.0f : 1.0f;

    [self.playButton setAlpha:alpha];
    [self.leaderboardButton setAlpha:alpha];
    [self.musicLabel setAlpha:alpha];
    [self.musicSwitch setAlpha:alpha];
    [self.sfxLabel setAlpha:alpha];
    [self.sfxSwitch setAlpha:alpha];
    [self.goToAppStoreButton setAlpha:alpha];
    [self.shareButton setAlpha:alpha];
}

- (void) hideGameUIElements:(BOOL) shouldHide {
    CGFloat alpha = shouldHide ? 0.0f : 1.0f;
    
    [self.backToMainButton setAlpha:alpha];
    [self.pauseButton setAlpha:alpha];
}

-(void) enableUIElements:(BOOL) shouldEnable {
    
    [self.playButton setEnabled:shouldEnable];
    [self.leaderboardButton setEnabled:shouldEnable];
    [self.musicLabel setEnabled:shouldEnable];
    [self.musicSwitch setEnabled:shouldEnable];
    [self.sfxLabel setEnabled:shouldEnable];
    [self.sfxSwitch setEnabled:shouldEnable];
    [self.goToAppStoreButton setEnabled:shouldEnable];
    [self.backToMainButton setEnabled:shouldEnable];
    [self.pauseButton setEnabled:shouldEnable];
    [self.shareButton setEnabled:shouldEnable];
    
}

-(IBAction) goToAppStore:(id) sender {
    NSString* appId = @"847131791";
    NSString *appStoreUrl = [NSString stringWithFormat:@"itms://itunes.apple.com/app/id%@", appId];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appStoreUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
    }
}

-(IBAction) shareWithFriends:(id)sender {
    NSString* appId = @"847131791";
    NSString *appStoreUrl = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", appId];
    NSString *placeholder = @"My score in Matchy Matchy is %ld! Can you beat it? %@";
    NSString *texttoshare = [NSString stringWithFormat: placeholder, (long)[scene getSavedXp], appStoreUrl];
    
    UIImage *screenshot = [self snapshot];
    
    NSArray *activityItems = @[texttoshare,screenshot];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    UIViewController *vc = self.view.window.rootViewController;
    [vc presentViewController:activityVC animated:TRUE completion:nil];
}

-(UIImage *) snapshot {
    
    UIGraphicsBeginImageContextWithOptions(scene.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [scene.view drawViewHierarchyInRect:scene.view.bounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return snapshotImage;
}

#pragma mark - In App Purchases

-(void) setUpProducts {
    productsManager = [[AEProductsManager alloc] init];
    
    [productsManager loadProducts];
}

-(void) setUpPaymentManager {
    paymentManager = [[AEPaymentManager alloc] init];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver: paymentManager];
}

-(IBAction)purchaseAdRemoval:(id)sender {
    SKProduct *product = [productsManager getProduct: REMOVE_ADS_PRODUCT_ID];
    
    if (product != nil) {
        [paymentManager purchaseProduct: product];
    }
}

-(void) removeAds {
    [self.adBanner removeFromSuperview];
    [self.removeAdsButton removeFromSuperview];
}

-(void) checkForAdRemoval {
    
    NSString *savedAdRemoval = [defaultsManager getSavedStringForKey: REMOVE_ADS_PRODUCT_ID];
    
    if ([savedAdRemoval isEqualToString: @"YES"]) {
        [self removeAds];
    }
}


@end
