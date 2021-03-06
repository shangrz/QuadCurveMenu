QuadCurveMenu is a menu with the same look as [the Path app's menu](https://path.com/)'s story menu.

Here is a [**declaration in my blog**](http://www.lunaapp.com/blog/?p=66) :)

---

**How To**:


Create the menu by setting up the menu items:

	UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
	UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
	UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   ContentImage:starImage 
                                                        highlightedContentImage:nil];
	QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   ContentImage:starImage 
                                                        highlightedContentImage:nil];

Then, setup the menu and options:

	QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.window.bounds [NSArray arrayWithObjects:starMenuItem1, starMenuItem2]];
	menu.delegate = self;
	[self.window addSubview:menu];

You can also use menu options:

to locate the center of "Add" button:

	[menu updateStartPoint:CGPointMake(160.0, 240.0)];// shangrz version use this	
	//menu.startPoint = CGPointMake(160.0, 240.0);

to set the rotate angle:

	menu.rotateAngle = 0.0;

to set the whole menu angle:

	menu.menuWholeAngle = M_PI * 2;

to set the delay of every menu flying out animation:

	menu.timeOffset = 0.036f;

to adjust the bounce animation:

	menu.farRadius = 140.0f;
	menu.nearRadius = 110.0f;

to set the distance between the "Add" button and Menu Items:

	menu.endRadius = 120.0f;

---

Twitter: [@LeveyZhu](https://twitter.com/#!/LeveyZhu) 

Sina Weibo: [@SORA-Levey](http://weibo.com/leveyzhu) 

Thanks for [pashields](https://github.com/pashields) providing the [youtube demo](http://www.youtube.com/watch?v=vddaYMtETjo) :)

Thanks for [acoomans](https://github.com/acoomans/QuadCurveMenu) for the options.


![screenshots](http://k.minus.com/ib1kHc4lnLB8bd.gif) ![screenshots](http://k.minus.com/iovTFVTQQ192K.gif) ![screenshots](http://k.minus.com/i4BrO2tfCJxzk.gif)
