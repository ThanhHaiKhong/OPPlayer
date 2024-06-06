//
//  UIFont+Extensions.m
//  
//
//  Created by Thanh Hai Khong on 6/6/24.
//

#import "UIFont+Extensions.h"

@implementation UIFont (Extensions)

+ (UIFont *)roundedFontWithSize:(CGFloat)size weight:(UIFontWeight)weight {
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *roundedDescriptor = [descriptor fontDescriptorByAddingAttributes:@{UIFontDescriptorFeatureSettingsAttribute: @[@{UIFontFeatureTypeIdentifierKey: @(kUpperCaseType), UIFontFeatureSelectorIdentifierKey: @(kUpperCaseSmallCapsSelector)}]}];
    return [self fontWithDescriptor:roundedDescriptor size:size];
}

@end
