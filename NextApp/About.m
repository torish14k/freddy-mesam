//
//  About.m
//  NextApp
//
//  Created by wangjun on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "About.h"

@implementation About
@synthesize txt_SiteTitle;
@synthesize txt_SiteDescription;
@synthesize txt_SiteUrl;

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
    self.txt_SiteTitle.text = Config.Instance.blog_title;
    self.txt_SiteDescription.text = Config.Instance.about_description;
    self.txt_SiteUrl.text = Config.Instance.blog_url_root;
}

- (void)viewDidUnload
{
    [self setTxt_SiteTitle:nil];
    [self setTxt_SiteDescription:nil];
    [self setTxt_SiteUrl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
