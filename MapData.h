//
//  MapData.h
//  MapDisplay
//
//  Created by David Burke on 3/18/12.
//  Copyright (c) 2012 Copart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapData : NSObject <NSXMLParserDelegate>

@property (nonatomic) NSString *path;
@property (nonatomic) NSMutableData *svgData;
@property (nonatomic) NSMutableArray *stateAbbreviations;
@property (nonatomic) NSMutableArray *stateNames;
@property (nonatomic) NSMutableArray *stateCapitals;
@property (nonatomic) NSUInteger numberOfStates;
@property (strong, nonatomic) NSURL *baseURL;
@property (nonatomic) NSUInteger currentState;
@property (nonatomic) BOOL stateIsColoured;

-(void) colourState: (BOOL)reset;

@end
