//
//  QuadCurveMenu.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//
//	Amended by Andrea Ottolina on 08/02/12
//  Copyright (c) 2012 Flubbermedia.com. All rights reserved.

#import "QuadCurveMenu.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kQuadCurveMenuDefaultNearRadius = 110.0f;
static CGFloat const kQuadCurveMenuDefaultEndRadius = 120.0f;
static CGFloat const kQuadCurveMenuDefaultFarRadius = 140.0f;
static CGFloat const kQuadCurveMenuDefaultStartPointX = 30.0;
static CGFloat const kQuadCurveMenuDefaultStartPointY = 30.0;
static CGFloat const kQuadCurveMenuDefaultTimeOffset = 0.036f;
static CGFloat const kQuadCurveMenuDefaultRotateAngle = 0.0;
static CGFloat const kQuadCurveMenuDefaultMenuWholeAngle = M_PI * 2;

static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, float angle)
{
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);    
}

@interface QuadCurveMenu ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) QuadCurveMenuItem *addButton;
@property (nonatomic, strong) NSArray *menusArray;
@property (nonatomic, strong) NSMutableArray *menusSavedPosition;

- (void)updateMenusData;
- (void)updateMenusData:(BOOL)recenter;
- (void)doAnimation:(NSDictionary *)animationConfig;

- (CAAnimationGroup *)expandAnimationForItem:(QuadCurveMenuItem *)item;
- (CAAnimationGroup *)closeAnimationForItem:(QuadCurveMenuItem *)item;
- (CAAnimationGroup *)blowupAnimationAtPoint:(CGPoint)p;
- (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)p;

@end

@implementation QuadCurveMenu

@synthesize delegate;
@synthesize animating;
@synthesize expanded;
@synthesize menusPosition;

@synthesize nearRadius;
@synthesize endRadius;
@synthesize farRadius;
@synthesize timeOffset;
@synthesize rotateAngle;
@synthesize menuWholeAngle;
@synthesize startPoint;

@synthesize addButton;
@synthesize menusArray;
@synthesize menusSavedPosition;

@synthesize shouldAnimateMainButton;

#pragma mark - initialization & cleaning up

- (id)initWithFrame:(CGRect)frame menus:(NSArray *)aMenusArray
{
	QuadCurveMenuItem *defaultButton = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"] highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"] 
																   contentImage:[UIImage imageNamed:@"icon-plus.png"] contentHighlightedImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
	
	return [self initWithFrame:frame menus:aMenusArray button:defaultButton startPoint:CGPointMake(kQuadCurveMenuDefaultStartPointX, kQuadCurveMenuDefaultStartPointY)];
}

- (id)initWithFrame:(CGRect)frame menus:(NSArray *)aMenusArray button:(QuadCurveMenuItem *)aButton startPoint:(CGPoint)aStartPoint
{
    self = [super initWithFrame:frame];
    if (self) {
		
		expanded = NO;
		
        self.backgroundColor = [UIColor clearColor];
		
		self.nearRadius = kQuadCurveMenuDefaultNearRadius;
		self.endRadius = kQuadCurveMenuDefaultEndRadius;
		self.farRadius = kQuadCurveMenuDefaultFarRadius;
		self.timeOffset = kQuadCurveMenuDefaultTimeOffset;
		self.rotateAngle = kQuadCurveMenuDefaultRotateAngle;
		self.menuWholeAngle = kQuadCurveMenuDefaultMenuWholeAngle;
		self.startPoint = aStartPoint;
        self.shouldAnimateMainButton = YES;
        
        // layout menus
        self.menusArray = aMenusArray;
        
        // add the "Add" Button.
		self.addButton = aButton;

		self.addButton.delegate = self;
        self.addButton.center = aStartPoint;
        [self addSubview:self.addButton];
		
		// array initialisation
		self.menusSavedPosition = [NSMutableArray array];
		
		for (QuadCurveMenuItem *item in menusArray)
		{
			item.autoresizingMask = addButton.autoresizingMask;
            item.center = addButton.center;
			[self.menusSavedPosition addObject:[NSValue valueWithCGPoint:addButton.center]];
		}
    }
    return self;
}



#pragma mark - images

- (void)setImage:(UIImage *)image {
	self.addButton.image = image;
}

- (UIImage*)image {
	return self.addButton.image;
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
	self.addButton.highlightedImage = highlightedImage;
}

- (UIImage*)highlightedImage {
	return self.addButton.highlightedImage;
}

- (void)setContentImage:(UIImage *)contentImage {
	self.addButton.contentImageView.image = contentImage;
}

- (UIImage*)contentImage {
	return self.addButton.contentImageView.image;
}

- (void)setContentHighlightedImage:(UIImage *)contentHighlightedImage {
	self.addButton.contentImageView.highlightedImage = contentHighlightedImage;
}

- (UIImage*)contentHighlightedImage {
	return self.addButton.contentImageView.highlightedImage;
}

#pragma mark - properties setters

- (void)setNearRadius:(CGFloat)value
{
	nearRadius = value;
	[self updateMenusData];
};

- (void)setEndRadius:(CGFloat)value
{
	endRadius = value;
	[self updateMenusData];
}

- (void)setFarRadius:(CGFloat)value
{
	farRadius = value;
	[self updateMenusData];
}

- (void)setStartPoint:(CGPoint)point
{
	startPoint = point;
	[self updateMenusData];
}

- (void)setRotateAngle:(CGFloat)angle
{
	rotateAngle = angle;
	[self updateMenusData];
}

- (void)setMenuWholeAngle:(CGFloat)angle
{
	menuWholeAngle = angle;
	[self updateMenusData];
}

#pragma mark - UIView's methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // if the menu is expanding, you can touch everywhere.
    // only the add button can be touched otherwise...
	if (expanded) 
    {
        return YES;
    }
	return CGRectContainsPoint(addButton.frame, point);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self quadCurveMenuItemTouchesEnd:addButton];
}

#pragma mark - QuadCurveMenuItem delegates

- (void)quadCurveMenuItemTouchesBegan:(QuadCurveMenuItem *)item
{
	//
}

- (void)quadCurveMenuItemTouchesEnd:(QuadCurveMenuItem *)item
{
	AnimationType animationType = AnimationTypeNone;
	animating = YES;
    
    self.userInteractionEnabled = NO;
	
	if ([item isEqual:addButton])
	{
		expanded = !expanded;
		animationType = (expanded) ? AnimationTypeExpand : AnimationTypeClose;
		float angle = expanded ? - M_PI_4 : 0.0f;
		[UIView animateWithDuration:0.2f animations:^{
            if (self.shouldAnimateMainButton)
            {
                item.transform = CGAffineTransformMakeRotation(angle);
            }
		}];
	}
	else
	{
		expanded = NO;
		
		if ([self.delegate respondsToSelector:@selector(quadCurveMenu:didSelectIndex:)])
		{
			[self.delegate quadCurveMenu:self didSelectIndex:[menusArray indexOfObject:item]];
		}
	}
	
	for (QuadCurveMenuItem *arrayItem in menusArray)
	{
		NSTimeInterval delay = [menusArray indexOfObject:arrayItem] * timeOffset;
		
		if (animationType != AnimationTypeExpand && animationType != AnimationTypeClose)
		{
			animationType = ([item isEqual:arrayItem]) ? AnimationTypeBlowup : AnimationTypeShrink;
			delay = 0;
		}
		
		NSDictionary *animationDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:arrayItem, [NSNumber numberWithInt:animationType], nil]
																		forKeys:[NSArray arrayWithObjects:kMenuItemKey, kAnimationTypeKey, nil]];
		
		[self performSelector:@selector(doAnimation:) withObject:animationDictionary afterDelay:delay];
	}

}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	int animationOrder = [[theAnimation valueForKey:kAnimationOrder] intValue];
	int animationCheck = [menusArray count] - 1;
	// Uncomment below line if you want to do the check on inverted order animations
	//int checkAnimation = (expanded) ? [menusArray count] - 1 : 0;
	
	if (animationOrder == animationCheck && flag)
	{
		animating = NO;
        self.userInteractionEnabled = YES;
	}
}

#pragma mark - Animation method

- (void)doAnimation:(NSDictionary *)animationConfig
{
	QuadCurveMenuItem *item = [animationConfig objectForKey:kMenuItemKey];
	AnimationType animationType = [[animationConfig objectForKey:kAnimationTypeKey] intValue];
	int counter = [menusArray indexOfObject:item];
	
	CAAnimationGroup *animationGroup;
	CGPoint itemCenter = item.startPoint;
	
	switch (animationType) {
			
		case AnimationTypeExpand:
			animationGroup = [self expandAnimationForItem:item];
			itemCenter = item.endPoint;	
			break;
			
		case AnimationTypeClose:
			animationGroup = [self closeAnimationForItem:item];
			break;
			
		case AnimationTypeBlowup:
			animationGroup = [self blowupAnimationAtPoint:item.center];
			break;
			
		case AnimationTypeShrink:
			animationGroup = [self shrinkAnimationAtPoint:item.center];
			break;
			
		default:
			return;
	}
	
	[animationGroup setValue:[NSNumber numberWithInt:counter] forKey:kAnimationOrder];
	[animationGroup setDelegate:self];
	
	[item.layer addAnimation:animationGroup forKey:nil];
	item.center = itemCenter;
}

#pragma mark - utility methods

- (NSArray *)menusPosition
{

	if (!self.animating)
		return nil;
	
	int i = 0;
	NSMutableArray *returnArray = [NSMutableArray array];
	for (QuadCurveMenuItem *item in self.menusArray)
	{
		
		@try
		{
			CGPoint savedPosition = [[self.menusSavedPosition objectAtIndex:i] CGPointValue];
			CGPoint itemPosition = [item presentLayerPosition];
			
			if (CGPointEqualToPoint(savedPosition, itemPosition) == NO)
			{
				[self.menusSavedPosition replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:itemPosition]];
				[returnArray addObject:[NSValue valueWithCGPoint:itemPosition]];
			}
		}
		@catch (NSException *exception) {
			
		}
		i++;
	}
	
	return returnArray;
}

#pragma mark - instant methods

- (void)updateMenusData
{
    [self updateMenusData:YES];
}

- (void)updateMenusData:(BOOL)recenter
{
	short count = [menusArray count];
	for (QuadCurveMenuItem *item in menusArray)
	{
        CGAffineTransform t = item.transform;
        item.transform = CGAffineTransformIdentity;
        
		short i = [menusArray indexOfObject:item];
		item.startPoint = startPoint;
        CGPoint endPoint = CGPointMake(startPoint.x + endRadius * sinf(i * menuWholeAngle / count), startPoint.y - endRadius * cosf(i * menuWholeAngle / count));
        item.endPoint = RotateCGPointAroundCenter(endPoint, startPoint, rotateAngle);
        CGPoint nearPoint = CGPointMake(startPoint.x + nearRadius * sinf(i * menuWholeAngle / count), startPoint.y - nearRadius * cosf(i * menuWholeAngle / count));
        item.nearPoint = RotateCGPointAroundCenter(nearPoint, startPoint, rotateAngle);
        CGPoint farPoint = CGPointMake(startPoint.x + farRadius * sinf(i * menuWholeAngle / count), startPoint.y - farRadius * cosf(i * menuWholeAngle / count));
        item.farPoint = RotateCGPointAroundCenter(farPoint, startPoint, rotateAngle);  
        if (recenter)
        {
            item.center = item.startPoint;
        }
		if (![item superview])
		{
			[self insertSubview:item atIndex:0];
		}
        
        item.transform = t;
    }
}

- (void)setMenusArray:(NSArray *)aMenusArray
{	
    [menusArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
	menusArray = aMenusArray;
	[menusArray makeObjectsPerformSelector:@selector(setDelegate:) withObject:self];
	[self updateMenusData];
}

#pragma mark - Animation definitions

- (CAAnimationGroup *)expandAnimationForItem:(QuadCurveMenuItem *)item 
{
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = 0.5f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.3], 
                                [NSNumber numberWithFloat:.4], nil]; 
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y); 
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = 0.5f;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];    
	
	return animationgroup;
}

- (CAAnimationGroup *)closeAnimationForItem:(QuadCurveMenuItem *)item
{
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = 0.5f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0], 
                                [NSNumber numberWithFloat:.4],
                                [NSNumber numberWithFloat:.5], nil]; 
        
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = 0.5f;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	return animationgroup;
}

- (CAAnimationGroup *)blowupAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil]; 
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
	
    return animationgroup;
}

- (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil]; 
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

- (void)updateStartPoint
{
    startPoint = self.addButton.center;
    [self updateMenusData:NO];
}

@end
