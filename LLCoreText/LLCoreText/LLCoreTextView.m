//
//  LLCoreTextView.m
//  LLCoreText
//
//  Created by liushaohua on 16/11/20.
//  Copyright © 2016年 liushaohua. All rights reserved.
//

#import "LLCoreTextView.h"
#import <CoreText/CoreText.h>


@implementation LLCoreTextView


- (void)drawRect:(CGRect)rect {

    // 1 coreText 要配合 Core Graphic 配合使用 如Core Graphic 一样要在图像上下文上绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2 翻转当前的坐标系 因为底层的绘制引擎左下角是为(0.0)
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 3 创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    // 4 创建需要绘制的文字与计算需要的区域
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:@"LL为大家分享CoreText图文混排的基础，进阶篇可以去唐巧的博客学习，你将学会如何图文混排之后，给内容添加点击事件等高端大气上档次的技术，给你超赞的体验，带你装bbbBBB带你飞~~!@#$%^&*()LL为大家分享CoreText图文混排的基础，进阶篇可以去唐巧的博客学习，你将学会如何图文混排之后，给内容添加点击事件等高端大气上档次的技术，给你超赞的体验，带你装bbbBBB带你飞~~!@#$%^&*()LL为大家分享CoreText图文混排的基础，进阶篇可以去唐巧的博客学习，你将学会如何图文混排之后，给内容添加点击事件等高端大气上档次的技术，给你超赞的体验，带你装bbbBBB带你飞~~!@#$%^&*()LL为大家分享CoreText图文混排的基础，进阶篇可以去唐巧的博客学习，你将学会如何图文混排之后，给内容添加点击事件等高端大气上档次的技术，给你超赞的体验，带你装bbbBBB带你飞~~!@#$%^&*()LL为大家分享CoreText图文混排的基础，进阶篇可以去唐巧的博客学习，你将学会如何图文混排之后，给内容添加点击事件等高端大气上档次的技术，给你超赞的体验，带你装bbbBBB带你飞~~!@#$%^&*()"];
    
    // 8 设置部分文字颜色
    [attrString addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(200, 200)];
    
    // 设置部分文字大小
    CGFloat fontSize = 20;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    [attrString addAttribute:(id)kCTFontAttributeName value:(__bridge id _Nonnull)(fontRef) range:NSMakeRange(15, 10)];
    CFRelease(fontRef);
    
    // 设置行间距
    CGFloat lineSpacing = 10;
    const CFIndex kNumberOfSetting = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSetting] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpacing}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSetting);
    [attrString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id _Nonnull)theParagraphRef range:NSMakeRange(0, [attrString length])];
    CFRelease(theParagraphRef);
    
    // 9 图文混排部分
//    CTRunDelegateCallbacks 一共用于保存一个结构体指针/
    
    
    
    // 5 根据attr 生成 CTFramesetterRef
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attrString length] ), path,NULL);
    
    // 6 进行绘制
    CTFrameDraw(frame, context);
    
    // 7 内存管理
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
    
    
    
    
}


@end
