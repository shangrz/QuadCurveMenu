//
//  QuadCurveMenu.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//
//	Amended by Andrea Ottolina on 08/02/12
//  Copyright (c) 2012 Flubbermedia.com. All rights reserved.

#import <UIKit/UIKit.h>
#import "QuadCurveMenuItem.h"

#define kAnimationTypeKey		@"animationTypeKey"
#define kMenuItemKey			@"menuItemKey"


typedef enum {
	AnimationTypeNone = 0,
	AnimationTypeExpand,
	AnimationTypeClose,
	AnimationTypeBlowup,
	AnimationTypeShrink
} AnimationType;

@protocol QuadCurveMenuDelegate;

@interface QuadCurveMenu : UIView <QuadCurveMenuItemDelegate>

@property (nonatomic, weak) id<QuadCurveMenuDelegate> delegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIImage *contentHighlightedImage;

@property (nonatomic, readonly) BOOL animating;
@property (nonatomic, readonly) BOOL expanded;

@property (nonatomic, assign, readonly) NSArray *menusPosition;
@property (nonatomic, assign) CGFloat nearRadius;
@property (nonatomic, assign) CGFloat endRadius;
@property (nonatomic, assign) CGFloat farRadius;
// Disabled until updating works correctly
// @property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat timeOffset;
@property (nonatomic, assign) CGFloat rotateAngle;
@property (nonatomic, assign) CGFloat menuWholeAngle;

- (id)initWithFrame:(CGRect)frame menus:(NSArray *)aMenusArray;

@end

@protocol QuadCurveMenuDelegate <NSObject>

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx;

@end