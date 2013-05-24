//
//  UISearchBar+FlatUI.m
//  FlatUIKitExample
//
//  Created by Zhang Heyin on 13-5-20.
//
//

#import "UISearchBar+FlatUI.h"
#import "UIImage+FlatUI.h"
#import "UIColor+FlatUI.h"
@implementation UISearchBar (FlatUI)
- (void)drawRect:(CGRect)rect
{
  UIImage *image = [UIImage imageWithColor:[UIColor midnightBlueColor] cornerRadius:0];
  [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
