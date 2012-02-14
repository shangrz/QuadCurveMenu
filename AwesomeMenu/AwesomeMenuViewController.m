//
//  AwesomeMenuViewController.m
//  AwesomeMenu
//
//  Created by Andrea Ottolina on 08/02/2012.
//  Copyright (c) 2012 Flubbermedia.com. All rights reserved.
//

#import "AwesomeMenuViewController.h"

@implementation AwesomeMenuViewController

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
	
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
	
    QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage contentHighlightedImage:nil];
    
	QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage contentHighlightedImage:nil];
    
	QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage contentHighlightedImage:nil];
    
	QuadCurveMenuItem *starMenuItem4 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage contentHighlightedImage:nil];
    
	QuadCurveMenuItem *starMenuItem5 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage contentHighlightedImage:nil];
    
	QuadCurveMenuItem *starMenuItem6 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage contentHighlightedImage:nil];
    
	QuadCurveMenuItem *starMenuItem7 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage contentHighlightedImage:nil];
    
	QuadCurveMenuItem *starMenuItem8 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage contentHighlightedImage:nil];
    
	 
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, starMenuItem7,starMenuItem8, nil];
    
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus ];
    
    //set menu at center :
    [menu updateStartPoint:CGPointMake(160.0, 240.0)];	// customize menu
	//menu.rotateAngle = M_PI_2;
	menu.rotateAngle = -M_PI_2;
    //menu.menuWholeAngle = menu.rotateAngle / (menus.count - 1) * menus.count;
    menu.menuWholeAngle  = M_PI/ (menus.count - 1) * menus.count ;     // div make LR justify
	menu.timeOffset = 0.08f;
	menu.farRadius = 180.0f;
	menu.endRadius = 100.0f;
	menu.nearRadius = 80.0f;
    
    
    
    
    
   

    menu.delegate = self;
    [self.view addSubview:menu];
    
    
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - QuadCurveMenu delegate method

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d", idx);
}

@end
