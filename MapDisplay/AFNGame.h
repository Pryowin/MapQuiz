//
//  AFNGame.h
//  MapDisplay
//
//  Created by David Burke on 3/19/12.
//  Copyright (c) 2012 Copart. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    stateAbbrev,
    stateName,
    stateNameAndCapital
} GameType;

@interface AFNGame : NSObject

@property (nonatomic) NSUInteger score;
@property (nonatomic) NSUInteger turn;
@property (nonatomic) GameType type;

-(BOOL) gameIsOver;
-(id) initWithType: (GameType)type;
-(BOOL) questionHasBeenAsked:(NSUInteger)state;


@end
