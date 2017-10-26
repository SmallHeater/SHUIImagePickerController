//
//  UIColor+Translate.h
//  JHUniversalApp
//
//  Created by pk on 2016/11/30.
//  Copyright © 2016年  William Sterling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Translate)

+(UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(float)alpha;

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

@end
