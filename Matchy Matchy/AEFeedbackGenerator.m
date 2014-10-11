//
//  AEFeedbackGenerator.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-03-09.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import "AEFeedbackGenerator.h"
#import "AERandomHelper.h"

@implementation AEFeedbackGenerator

+(NSString *) getFeedbackForPoints: (int) points matching: (int) numMatching correct: (int) numCorrect prev: (int) prevLevel current: (int) currentLevel {
    
    if (currentLevel > prevLevel) {
        return [self getLevelFeedback: currentLevel];
    }
    
    if (numMatching == 3) return [self getRandomFeedbackForTripleMatch];
    else if (numMatching == 2) {
        if (numCorrect == 3) return [self getRandomFeedbackForTwoMatchingPlusOne];
        else return [self getRandomFeedbackForDoubleMatch];
    } else if (numCorrect == 3) {
        return [self getRandomFeedbackForThreeUnique];
    } else if (numCorrect == 2) {
        return [self getRandomFeedbackForTwoCorrect];
    } else if (numCorrect == 1) {
        return [self getRandomFeedbackForOneCorrect];
    } else {
        return [self getRandomFeedbackForZeroCorrect];
    }
}

+(NSString *) getRandomFeedbackForZeroCorrect {
    NSArray *options = @[
                         @"I think you need to try a little harder."
                         ];
    int last = (int)([options count]-1);
    
    int randSelection = [AERandomHelper randomNumberBetween:0 And:last];
    
    return options[randSelection];
}

+(NSString *) getRandomFeedbackForOneCorrect {
    NSArray *options = @[
                         @"One is better than none."
                         ];
    int last = (int)([options count]-1);
    
    int randSelection = [AERandomHelper randomNumberBetween:0 And:last];
    
    return options[randSelection];
}

+(NSString *) getRandomFeedbackForTwoCorrect {
    NSArray *options = @[
                         @"Two correct. Good Job."
                         ];
    int last = (int)([options count]-1);
    
    int randSelection = [AERandomHelper randomNumberBetween:0 And:last];
    
    return options[randSelection];
}

+(NSString *) getRandomFeedbackForThreeUnique {
    NSArray *options = @[
                         @"Nicely done. Have some XP!"
                         ];
    int last = (int)([options count]-1);
    
    int randSelection = [AERandomHelper randomNumberBetween:0 And:last];
    
    return options[randSelection];
}

+(NSString *) getRandomFeedbackForDoubleMatch {
    NSArray *options = @[
                         @"Two outta three ain't bad."
                         ];
    int last = (int)([options count]-1);
    
    int randSelection = [AERandomHelper randomNumberBetween:0 And:last];
    
    return options[randSelection];
}

+(NSString *) getRandomFeedbackForTwoMatchingPlusOne {
    NSArray *options = @[
                         @"One away from 3 of the same kind! Keep on trying."
                         ];
    int last = (int)([options count]-1);
    
    int randSelection = [AERandomHelper randomNumberBetween:0 And:last];
    
    return options[randSelection];
}

+(NSString *) getRandomFeedbackForTripleMatch {
    NSArray *options = @[
                         @"Triple match score!"
                         ];
    int last = (int)([options count]-1);
    
    int randSelection = [AERandomHelper randomNumberBetween:0 And:last];
    
    return options[randSelection];
}

+(NSString *) getLevelFeedback: (int) level {
    NSArray *levelFeedback = @[
                              /* 1 */@"Try and make as many matches as possible. Bonus points for matching the same kind.",
                              @"This seems too easy for you. We're going to increase the speed slightly.",
                              @"What?! You're done that level already? Guess we'll just have to make it a little harder!",
                              @"You're getting the hang of it. Let's speed it up a bit.",
                              @"This still doesnt seem like a challenge for you. Let's make it faster",
                              @"Great job. Lets make it slightly more challenging.",
                              @"Keep on matching them up!",
                              @"Speeding it up once again. Hang on!",
                              @"Getting dizzy yet? We still have some power left to increase the speed.",
                              @"Impressive! Let's see how well you do at maximum speed!",
                              /* 11 */@"Ok ok I get it. You're good at this. Lets slow it back down and shuffle the images a bit and see how well you do.",
                              @"How was that? A little harder than you thought hey? Now lets increase the speed.",
                              @"Next level!",
                              @"Getting challenging yet? Let's add some speed.",
                              @"Faster! Faster! Faster!",
                              @"Great job. Lets make it slightly more challenging.",
                              @"Annnd... lets go a little bit faster!",
                              @"Getting motion sick yet? We're going to increase the speed a little more!",
                              @"Ok seriously. Are you a robot? When did you get so good at this?",
                              @"Maximum speed on shuffle. Let's see how you do!",
                              /* 21 */@"Congratulations. You're becoming an expert matcher. Time to make things slightly more difficult. This time we've split the images into 4 pieces. Good luck!",
                              @"I know, I know. Too easy right? Ok, let's speed it up.",
                              @"Next level!",
                              @"This still doesnt seem like a challenge for you. Let's make it faster",
                              @"Keep on matching them up!",
                              @"Great job. Lets make it slightly more challenging."
                              ];
    
    return (level < [levelFeedback count]) ? levelFeedback[level-1]:@"Whoa, you've gotten to such a high level that we don't even know what to say!";
}

@end
