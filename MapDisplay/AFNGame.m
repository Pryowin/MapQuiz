//
//  AFNGame.m
//  MapDisplay
//
//  Created by David Burke on 3/19/12.
//  Copyright (c) 2012 Copart. All rights reserved.
//

#import "AFNGame.h"

@implementation AFNGame
{
   
}

@synthesize turn;
@synthesize score;
@synthesize type;

NSUInteger maxTurns;
NSMutableArray *previousAnswers;

-(id) initWithType:(GameType)gameType;
{
    self = [super init];
    self.turn = 0;
    self.score =0;
    self.type = gameType;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    maxTurns = [defaults integerForKey:@"Turns"];
    previousAnswers = [[NSMutableArray alloc] initWithCapacity:maxTurns];
    
    return self;
}

-(BOOL) gameIsOver;
{
    if (self.turn < maxTurns){
        return NO;
    } else {
        return YES;
    }
}
-(BOOL) questionHasBeenAsked:(NSUInteger)state
{
    NSNumber *stateAsObject = [[NSNumber alloc] initWithUnsignedInteger:state];
    if ([previousAnswers indexOfObject:stateAsObject]!=NSNotFound) {
        return YES;     
    } else {
        [previousAnswers addObject:stateAsObject];
        return NO;
    }
}
@end
