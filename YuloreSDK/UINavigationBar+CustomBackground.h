//
//  UINavigationBar+CustomBackground.h
//  CustomizingNavigationBarBackground
//
//  Created by Ahmet Ardal on 2/10/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNavigationBarCustomTintColor   [UIColor colorWithRed:0x34/255.f green:0x49/255.f blue:0x5e/255.f alpha:1.0]

@interface UINavigationBar(CustomBackground)

- (void) applyCustomTintColor;

@end
