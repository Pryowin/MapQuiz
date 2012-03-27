//
//  MapData.m
//  MapDisplay
//
//  Created by David Burke on 3/18/12.
//  Copyright (c) 2012 Copart. All rights reserved.
//

#import "MapData.h"

#define kRed "ff0000"
#define kGrey "d3d3d3"
#define kFillText @"fill:#"
#define kCharactersToMoveBack 160
#define kLengthofColourString 6
#define kStartSearch 600

@implementation MapData
@synthesize path;
@synthesize svgData;
@synthesize stateNames;
@synthesize stateAbbreviations;
@synthesize stateCapitals;
@synthesize numberOfStates;
@synthesize currentState;
@synthesize baseURL;
@synthesize stateIsColoured;

-(id) init
{
    self = [super init];
    
    stateAbbreviations = [[NSMutableArray alloc] init];
    stateNames  = [[NSMutableArray alloc]init];
    stateCapitals = [[NSMutableArray alloc] init];
    self.stateIsColoured = NO;
    
    // Load SVG from file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Map" ofType:@"svg"];
    self.svgData = [NSMutableData dataWithContentsOfFile:filePath];
    self.path = filePath;
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    self.baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
    
    // Load XML list of states from file
    NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"xml"];
    NSData *stateListData = [[NSData alloc] initWithContentsOfFile:xmlFilePath];
    NSXMLParser *xmlDoc = [[NSXMLParser alloc] initWithData:stateListData];
    [xmlDoc setDelegate:self];
    
    // Start XML Parsing
    BOOL parseIsOK=[xmlDoc parse];
    if (parseIsOK) {
        self.numberOfStates = [self.stateNames count];
    }
    return self;
}
-(void) colourState: (BOOL)setColour
{
    NSString *state = [self.stateAbbreviations objectAtIndex:self.currentState];
    // Use red unless method has been asked to set back to grey
    
    char *colour;
    if (!setColour) {
        colour = kGrey;
        self.stateIsColoured = NO;
    } else {
        colour = kRed;
        self.stateIsColoured = YES;
    }
    
    NSUInteger dataLength = [self.svgData length];
    NSRange rangeofSearch = NSMakeRange(kStartSearch    , dataLength-kStartSearch);
    
    // Get location of ID=STATE
    NSRange stateRange = [self.svgData rangeOfData:[state dataUsingEncoding:NSUTF8StringEncoding] options:0 range:rangeofSearch];
    
    // If we find state, find fill colour, update to new colour, and save data back to SVG file
    if (stateRange.location != NSNotFound){
        NSRange fill = [self.svgData rangeOfData:[kFillText dataUsingEncoding:NSUTF8StringEncoding] options:0 range:NSMakeRange(stateRange.location-kCharactersToMoveBack, kCharactersToMoveBack)];
        if (fill.location != NSNotFound){
            [self.svgData replaceBytesInRange:NSMakeRange(fill.location+fill.length, kLengthofColourString) withBytes:colour length:kLengthofColourString];
       
        } 
    }
    
}
#pragma mark XMLParser Methods

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{
    if ([elementName isEqualToString:@"state"]){
        
        NSString *state = [attributeDict objectForKey:@"name"];
        NSString *abbreviation = [attributeDict objectForKey:@"abbreviation"];
        NSString *capital = [attributeDict objectForKey:@"capital"];
        
        // Add State details to arrays
        [stateAbbreviations addObject:abbreviation];
        [stateNames addObject:state];
        //Capitals are stored in mixed case, make uppercase for consistentcy
        [stateCapitals addObject:[capital uppercaseString]];
        }
}

@end
