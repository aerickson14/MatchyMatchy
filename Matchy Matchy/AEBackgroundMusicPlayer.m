//
//  AEBackgroundMusicPlayer.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-20.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEBackgroundMusicPlayer.h"

@interface AEBackgroundMusicPlayer() {
    AVAudioPlayer *audioPlayer;
}
@end

@implementation AEBackgroundMusicPlayer

+(instancetype) sharedPlayer {
    static AEBackgroundMusicPlayer *sharedPlayer;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^ {
        sharedPlayer = [self new];
        [sharedPlayer setFilename:@"adrenaline" andExtension:@"mp3"];
    });
    
    return sharedPlayer;
}

-(void)setFilename:(NSString *) fileName andExtension:(NSString *) extension {
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:extension];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer prepareToPlay];
}

-(void) play {
    [audioPlayer play];
}

-(void) stop {
    [audioPlayer stop];
}

-(void) pause {
    [audioPlayer pause];
}

@end
