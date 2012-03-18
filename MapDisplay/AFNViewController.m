//
//  AFNViewController.m
//  MapDisplay
//
//  Created by David Burke on 3/17/12.
//  Copyright (c) 2012 Copart. All rights reserved.
//

#import "AFNViewController.h"

@interface AFNViewController ()

@end

@implementation AFNViewController

@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
   
    //Get path of HTML, get base URL, load page
    NSString *path = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"svg"];
    NSData *svgData = [NSData dataWithContentsOfFile:path];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
    
    [self.webView 	loadData:svgData 
                   MIMEType:@"image/svg+xml"	
           textEncodingName:@"UTF-8" 
                    baseURL:baseURL];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
