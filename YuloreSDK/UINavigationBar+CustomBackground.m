//
//  UINavigationBar+CustomBackground.m
//  CustomizingNavigationBarBackground
//
//  Created by Ahmet Ardal on 2/10/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "UINavigationBar+CustomBackground.h"

@implementation UINavigationBar(CustomBackground)

+ (UIImage *) bgImagePortrait
{
    static UIImage *image = nil;
    if (image == nil) {
        image = [UIImage imageNamed:@"titlebar_bg.jpg"];
    }

    return image;
}

+ (UIImage *) bgImageLandscape
{
    static UIImage *image = nil;
    if (image == nil) {
        image = [UIImage imageNamed:@"titlebar_bg.jpg"];
    }

    return image;
}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if ([self isMemberOfClass:[UINavigationBar class]] == NO) {
        return;
    }

    UIImage *image = (self.frame.size.width > 320) ?
                        [UINavigationBar bgImageLandscape] : [UINavigationBar bgImagePortrait];
    CGContextClip(ctx);
    CGContextTranslateCTM(ctx, 0, image.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), image.CGImage);
}

- (void) applyCustomTintColor
{
    [self setTintColor:kNavigationBarCustomTintColor];

}
//
//
//
//- (UIImage *)barBackground
//{
//  return [ imageNamed:@"titlebar_bg.jpg"];
//}
//
//- (void)didMoveToSuperview
//{
//  //iOS5 only
//  if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//  {
//    [self setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
//  }
//}
//
////this doesn't work on iOS5 but is needed for iOS4 and earlier
//- (void)drawRect:(CGRect)rect
//{
//  //draw image
//  [[self barBackground] drawInRect:rect];
//}
//

@end
