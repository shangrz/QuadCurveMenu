//
//  QuadCurveMenuItem.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//
//	Amended by Andrea Ottolina on 08/02/12
//  Copyright (c) 2012 Flubbermedia.com. All rights reserved.

#import "QuadCurveMenuItem.h"

@implementation QuadCurveMenuItem

@synthesize contentImageView;

@synthesize startPoint;
@synthesize endPoint;
@synthesize nearPoint;
@synthesize farPoint;
@synthesize delegate;

#pragma mark - initialization & cleaning up
- (id)initWithImage:(UIImage *)img highlightedImage:(UIImage *)himg
       contentImage:(UIImage *)cimg contentHighlightedImage:(UIImage *)chimg
{
    if (self = [super init]) 
    {
        self.image = img;
        self.highlightedImage = himg;
        self.userInteractionEnabled = YES;
        contentImageView = [[UIImageView alloc] initWithImage:cimg];
        contentImageView.highlightedImage = chimg;
        [self addSubview:contentImageView];
    }
    return self;
}

#pragma mark - UIView's methods
- (void)layoutSubviews
{
    [super layoutSubviews];
//	[contentImageView sizeToFit];
//	self.bounds = 

    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    
    float width = contentImageView.image.size.width;
    float height = contentImageView.image.size.height;
    contentImageView.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if ([self.delegate respondsToSelector:@selector(quadCurveMenuItemTouchesBegan:)])
    {
       [self.delegate quadCurveMenuItemTouchesBegan:self];
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if move out of 2x rect, cancel highlighted.
    CGPoint location = [[touches anyObject] locationInView:self];
	CGRect touchArea = CGRectApplyAffineTransform(self.bounds, CGAffineTransformMakeScale(2.0f, 2.0f));
    if (!CGRectContainsPoint(touchArea, location))
    {
        self.highlighted = NO;
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    // if stop in the area of 2x rect, response to the touches event.
    CGPoint location = [[touches anyObject] locationInView:self];
	CGRect touchArea = CGRectApplyAffineTransform(self.bounds, CGAffineTransformMakeScale(2.0f, 2.0f));
    if (CGRectContainsPoint(touchArea, location))
	{
        if ([self.delegate respondsToSelector:@selector(quadCurveMenuItemTouchesEnd:)])
        {
            [self.delegate quadCurveMenuItemTouchesEnd:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
}

#pragma mark - instant methods
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [contentImageView setHighlighted:highlighted];
}


@end
