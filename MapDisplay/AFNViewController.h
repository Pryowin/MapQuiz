//
//  AFNViewController.h
//  MapDisplay
//
//  Created by David Burke on 3/17/12.
//  Copyright (c) 2012 Copart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFNViewController : UIViewController 

@property(nonatomic, retain) IBOutlet UIWebView *webView;
- (IBAction)startGame:(id)sender;
- (IBAction)guessMade:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *start;
@property (weak, nonatomic) IBOutlet UILabel *scoreDisplay;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerEntry;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;

@end
