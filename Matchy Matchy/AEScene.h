//
//  AEScene.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-23.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AEBackgroundMusicPlayer.h"
#import "AEViewController.h"
#import "AEDefaultsManager.h"

@interface AEScene : SKScene {
    AEBackgroundMusicPlayer * backgroundMusicPlayer;
    SKProduct *removeAdsProduct;
    AEDefaultsManager *defaultsManager;
}

-(void) setMusic:(bool) enabled;

-(void) setSFX:(bool) enabled;

-(AEBackgroundMusicPlayer *) getBackgroundMusicPlayer;

-(BOOL) isMusicEnabled;

-(BOOL) isSfxEnabled;

-(void) playSound:(NSString *)fileName;

-(void) playMusic;

-(void) stopMusic;

-(CGFloat) getScreenHeight;

-(CGFloat) getScreenWidth;

-(NSInteger) getSavedXp;

@end
