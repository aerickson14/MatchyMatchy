//
//  AEViewController.h
//  Spinner
//

//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
@import GameKit;
@import StoreKit;

@interface AEViewController : UIViewController  <GKGameCenterControllerDelegate, ADBannerViewDelegate>

-(IBAction) showDefaultLeaderboard:(id)sender;

-(IBAction) pauseGame:(id)sender;

-(IBAction) purchaseAdRemoval:(id)sender;

-(void) showTutorial;

-(void) enableUIElements:(BOOL) shouldEnable;

-(void) removeAds;

@end
