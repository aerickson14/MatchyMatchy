//
//  AEBackgroundMusicPlayer.h
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-20.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface AEBackgroundMusicPlayer : NSObject

+(instancetype) sharedPlayer;

-(void) play;

-(void) stop;

-(void) pause;

@end
