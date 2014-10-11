//
//  AELevelHelperTests.m
//  Matchy Matchy
//
//  Created by Andrew Erickson on 2014-04-27.
//  Copyright (c) 2014 Andrew Erickson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AELevelHelper.h"
#import "AEConstants.h"

@interface AELevelHelperTests : XCTestCase

@end

@implementation AELevelHelperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLevelProgression {
    NSArray *expected = [self getExpectedLevelProgression];
    
    for(int level=1; level<[expected count]; level++) {
        NSLog(@"Testing min max for level %d", level);
        int expectedMin = [(NSNumber *)expected[level-1] intValue];
        int expectedMax = [(NSNumber *)expected[level] intValue] - 1;
        if (level == 1) expectedMin = 0;
        
        int xp = (expectedMin + expectedMax)/2;
        NSArray* actualMinMax = [AELevelHelper getMinMaxXpFromXp: xp];
        NSLog(@"XP: %d, exp min: %d, max: %d", xp, expectedMin, expectedMax);
        int actualMin = [(NSNumber *) actualMinMax[0] intValue];
        int actualMax = [(NSNumber *) actualMinMax[1] intValue];
        XCTAssertEqual(expectedMin, actualMin);
        XCTAssertEqual(expectedMax, actualMax);
                    
    }
}

- (NSArray *) getExpectedLevelProgression {
    return @[@0,
             @100,
             @300,
             @600,
             @1000,
             @1500,
             @2100,
             @2800,
             @3600,
             @4500,
             @5500,
             @6600,
             @7800,
             @9100,
             @10500,
             @12000,
             @13600,
             @15300,
             @17100,
             @19000,
             @21000];
}

- (void) testBarSpeeds {
    NSArray *expectedLevelBaseSpeeds = [self getExpectedBarSpeeds];
    
    for(int level=1; level<[expectedLevelBaseSpeeds count]/3; level++) {
        NSArray *actualSpeeds = [AELevelHelper get:3 speedsForLevel:level];
        
        CGFloat bar1Speed = [(NSNumber *)actualSpeeds[0] floatValue];
        CGFloat bar2Speed = [(NSNumber *)actualSpeeds[1] floatValue];
        CGFloat bar3Speed = [(NSNumber *)actualSpeeds[2] floatValue];
        
        CGFloat expectedBar2Speed = [(NSNumber *)expectedLevelBaseSpeeds[level-1] floatValue];
        CGFloat expectedBar3Speed = expectedBar2Speed+50;
        CGFloat expectedBar1Speed = expectedBar2Speed+100;
        
        XCTAssertEqual(bar1Speed, expectedBar1Speed);
        XCTAssertEqual(bar2Speed, expectedBar2Speed);
        XCTAssertEqual(bar3Speed, expectedBar3Speed);
    }
}

- (NSArray *) getExpectedBarSpeeds {
    return @[
             @200,
             @225,
             @250,
             @275,
             @300,
             @325,
             @350,
             @375,
             @400,
             @425,
             @200,
             @225,
             @250,
             @275,
             @300,
             @325,
             @350,
             @375,
             @400,
             @425
             ];
}

-(void) testShouldShuffle {
    XCTAssertFalse([AELevelHelper shouldShuffle:1]);
    XCTAssertFalse([AELevelHelper shouldShuffle:10]);
    XCTAssertTrue([AELevelHelper shouldShuffle:11]);
    XCTAssertTrue([AELevelHelper shouldShuffle:20]);
    XCTAssertFalse([AELevelHelper shouldShuffle:21]);
    XCTAssertFalse([AELevelHelper shouldShuffle:30]);
    XCTAssertTrue([AELevelHelper shouldShuffle:31]);
    XCTAssertTrue([AELevelHelper shouldShuffle:40]);
    XCTAssertFalse([AELevelHelper shouldShuffle:41]);
    XCTAssertFalse([AELevelHelper shouldShuffle:50]);
}

-(void) testNumRingsForLevel {
    XCTAssertEqual(3, [AELevelHelper numRingsFor: 1]);
    XCTAssertEqual(3, [AELevelHelper numRingsFor: 5]);
    XCTAssertEqual(3, [AELevelHelper numRingsFor: 19]);
    XCTAssertEqual(3, [AELevelHelper numRingsFor: 20]);
    XCTAssertEqual(4, [AELevelHelper numRingsFor: 21]);
    XCTAssertEqual(4, [AELevelHelper numRingsFor: 30]);
    XCTAssertEqual(4, [AELevelHelper numRingsFor: 31]);
    XCTAssertEqual(4, [AELevelHelper numRingsFor: 40]);
    XCTAssertEqual(5, [AELevelHelper numRingsFor: 41]);
    XCTAssertEqual(5, [AELevelHelper numRingsFor: 50]);
    XCTAssertEqual(5, [AELevelHelper numRingsFor: 51]);
    XCTAssertEqual(5, [AELevelHelper numRingsFor: 60]);
    XCTAssertEqual(6, [AELevelHelper numRingsFor: 61]);
}

@end
