//
//  Setting.m
//  NextApp
//
//  Created by wangjun on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Setting.h"

@implementation Setting
@synthesize switchPostlistlayout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    int layout = Config.Instance.getPostListLayout;
    int index = 0;
    switch (layout) {
        case 1:
            index = 0;
            break;
        case 2:
            index = 1;
            break;
        case 3:
            index = 2;
            break;
    }
    self.switchPostlistlayout.selectedSegmentIndex = index;
}

- (void)viewDidUnload
{
    [self setSwitchPostlistlayout:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)selectPostlistLayout:(id)sender {
    
    switch (self.switchPostlistlayout.selectedSegmentIndex) {
        case 0:
            [Config.Instance savePostListLayout:1];
            break;
        case 1:
            [Config.Instance savePostListLayout:2];
            break;
        case 2:
            [Config.Instance savePostListLayout:3];
            break;
    }
}
@end
