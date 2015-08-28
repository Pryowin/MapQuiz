//
//  AFNViewController.m
//  MapDisplay
//
//  Created by David Burke on 3/17/12.
//  Copyright (c) 2012 Copart. All rights reserved.
//

#import "AFNViewController.h"
#import "MapData.h"
#import "AFNGame.h"

#define kCheckTimer 1.0


@interface AFNViewController ()
    -(void) showMap;
    
@end

@implementation AFNViewController
{
    NSArray * gameTypeLabel;
}

@synthesize start;
@synthesize scoreDisplay;
@synthesize gameLabel;
@synthesize answerEntry;
@synthesize checkMark;
@synthesize passButton;
@synthesize webView;

MapData *stateMap;
AFNGame *game;
NSTimer *timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view, typically from a nib.
    stateMap = [[MapData alloc] init];
    [self showMap];
    gameTypeLabel = [[NSArray alloc] initWithObjects:@"Abbreviation",@"State",@"Capital", nil];
}

- (void)viewDidUnload
{
    [self setStart:nil];
    [self setScoreDisplay:nil];
    [self setGameLabel:nil];
    [self setAnswerEntry:nil];
    [self setCheckMark:nil];
    [self setPassButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
-(void) showMap
{
    
    [self.webView 	loadData:stateMap.svgData 
                   MIMEType:@"image/svg+xml"	
           textEncodingName:@"UTF-8" 
                    baseURL:stateMap.baseURL];    
}

- (IBAction)startGame:(id)sender {
    // Hide Start Buttons
    for (UIButton *button in start) {
        [button setHidden:YES];
    }
    //Initialize Game
    game = nil;
    game = [[AFNGame alloc] initWithType:[sender tag]];
    gameLabel.text = [gameTypeLabel objectAtIndex:game.type];
    [self.passButton setEnabled:YES];
    [answerEntry setHidden:NO];

    if (game.type == stateAbbrev){
        answerEntry.autocapitalizationType=UITextAutocapitalizationTypeAllCharacters;
    } else {
        answerEntry.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    
    // Determine if text box should offer suggestions or not
    if (game.autoCorrectIsDisabled){
        answerEntry.autocorrectionType = UITextAutocorrectionTypeNo;
    } else {
        answerEntry.autocorrectionType = UITextAutocorrectionTypeYes;
    }
    
    [self pickNextState];
}

- (IBAction)guessMade:(id)sender 
{
    NSString *guess;
    NSString *alertTitle;
    UITextField *guessTextField;
    // If initiated from textfield use contents, otherwise user has passed and guess is blank
    if ([sender isMemberOfClass:[UITextField class]]) {
        guessTextField = (UITextField *)sender;
        [guessTextField  resignFirstResponder];
        // Convert guess to uppercase and trim any spaces or newline characters
        guess = [[guessTextField.text uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        alertTitle = @"WRONG";
    } else {
        alertTitle = @"You Passed";
        guess = @"";
    }
    
    NSArray *answerArray;
    // Select array that holds the answer for the type of game
    switch (game.type) {
        case stateAbbrev:
            answerArray = stateMap.stateAbbreviations;
            break;
        case stateName:
            answerArray = stateMap.stateNames;
            break;
        case stateNameAndCapital:
            answerArray = stateMap.stateCapitals;
            break;
        default:
            answerArray = nil;
            break;
    }
    NSString *answer = [[NSString alloc] initWithString:[answerArray objectAtIndex:stateMap.currentState]]; 
    game.turn ++;
    
    if ([answer isEqualToString:guess]) {
        [checkMark setHidden:NO];
        game.score++;
        [NSTimer scheduledTimerWithTimeInterval:kCheckTimer target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
    } else {
        NSString *msg =[[NSString alloc] initWithFormat:@"The Correct Answer is %@",answer];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    guessTextField.text=@"";
    if (game.gameIsOver) {
        [self endGame];
    } else {
        [self pickNextState];
    }
}
-(void) pickNextState
{
    if (stateMap.stateIsColoured) {
        [stateMap colourState:NO];
    }
    // Pick a random state, until we find one not previously used in this game
    do
    {
        stateMap.currentState = arc4random() % stateMap.numberOfStates;
    } while ([game questionHasBeenAsked:stateMap.currentState]); 
        
    //Colour the state
    [stateMap colourState:YES];
    [self showMap];
    [self showScore];
    [answerEntry setEnabled:YES];
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    [checkMark setHidden:YES];
}
-(void) showScore
{
    NSString *score = [[NSString alloc] initWithFormat:@"%i/%i", game.score,game.turn];
    scoreDisplay.text = score;
}
-(void) endGame
{
    for (UIButton *button in start) {
        [button setHidden:NO];
    }
    [self.passButton setEnabled:NO];
    [self showScore];
    [stateMap colourState:NO];
    [self showMap];
    [answerEntry setEnabled:NO];
    NSString *msg = [[NSString alloc] initWithFormat:@"You scored %i/%i",game.score,game.turn];
    scoreDisplay.text = @"";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
