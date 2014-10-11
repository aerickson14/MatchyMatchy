///
//  AEScene.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-23.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEScene.h"
#import "AEGameScene.h"
#import "AEStartScene.h"

@interface AEScene() {
    
    AEViewController *viewController;
    
    NSMutableDictionary *soundActions;
    
    BOOL musicEnabled;
    BOOL sfxEnabled;
}

@end
@implementation AEScene

-(id) initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        backgroundMusicPlayer = [AEBackgroundMusicPlayer sharedPlayer];
        
        defaultsManager = [[AEDefaultsManager alloc] init];
        
        musicEnabled = [[defaultsManager getSavedStringForKey:@"musicEnabled"] isEqualToString:@"YES"];
        sfxEnabled = [[defaultsManager getSavedStringForKey:@"sfxEnabled"] isEqualToString:@"YES"];
        
        //NSLog(@"musicEnabled: %d", musicEnabled);
        //NSLog(@"sfxEnabled: %d", sfxEnabled);
        
        soundActions = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void) setMusic:(bool) enabled {
    musicEnabled = enabled;
    
    NSString *musicEnabledStr = musicEnabled ? @"YES":@"NO";
    //NSLog(@"Saving music enabled value: %@", musicEnabledStr);
    [defaultsManager saveValueForKey:@"musicEnabled" withValue: musicEnabledStr];
}

-(void) setSFX:(bool) enabled {
    sfxEnabled = enabled;
    NSString *sfxEnabledStr = sfxEnabled ? @"YES":@"NO";
    //NSLog(@"Saving sfx enabled value: %@", sfxEnabledStr);
    
    [defaultsManager saveValueForKey:@"sfxEnabled" withValue: sfxEnabledStr];
}

-(AEBackgroundMusicPlayer *) getBackgroundMusicPlayer {
    return backgroundMusicPlayer;
}

-(BOOL) isMusicEnabled {
    return musicEnabled;
}

-(BOOL) isSfxEnabled {
    return sfxEnabled;
}

-(void) playSound:(NSString *)fileName {
    if ([self isSfxEnabled]) {
        
        SKAction *soundAction = (SKAction *)[soundActions objectForKey:fileName];
        
        if (soundAction == nil) {
            soundAction = [SKAction playSoundFileNamed:fileName waitForCompletion:NO];
            [soundActions setObject:soundAction forKey: fileName];
        }
        
        [self runAction: soundAction];
    }
}

-(void) playMusic {
    if (musicEnabled) {
        [backgroundMusicPlayer play];
    }
}

-(void) stopMusic {
    [backgroundMusicPlayer stop];
}

-(CGFloat) getScreenHeight {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height;
}

-(CGFloat) getScreenWidth {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width;
}

-(NSInteger) getSavedXp {
    return [defaultsManager getSavedNumberForKey:@"xp"];
}

@end
