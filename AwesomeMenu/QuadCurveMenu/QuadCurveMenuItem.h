//
//  QuadCurveMenuItem.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//
//	Amended by Andrea Ottolina on 08/02/12
//  Copyright (c) 2012 Flubbermedia.com. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol QuadCurveMenuItemDelegate;

@interface QuadCurveMenuItem : UIImageView

@property (nonatomic, strong, readonly) UIImageView *contentImageView;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint nearPoint;
@property (nonatomic) CGPoint farPoint;

@property (nonatomic, weak) id<QuadCurveMenuItemDelegate> delegate;

- (id)initWithImage:(UIImage *)img highlightedImage:(UIImage *)himg
       contentImage:(UIImage *)cimg contentHighlightedImage:(UIImage *)chimg;

- (CGPoint)presentLayerPosition;

@end

@protocol QuadCurveMenuItemDelegate <NSObject>

- (void)quadCurveMenuItemTouchesBegan:(QuadCurveMenuItem *)item;
- (void)quadCurveMenuItemTouchesEnd:(QuadCurveMenuItem *)item;

@end