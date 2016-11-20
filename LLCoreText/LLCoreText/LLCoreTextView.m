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
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    
    // 图片信息字典
    NSDictionary *imgInfoDict = @{@"width":@"200",@"height":@"100"};
    
    // 设置 CTRun 的代理
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void * _Nullable)(imgInfoDict));
    
    // 使用0xFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc]initWithString:content];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    
    // 将创建的空白 attributeString 插入到当前string 中 位置可以随便指定 不能越界
    [attrString insertAttributedString:space atIndex:50];
    
    
    // 5 根据attr 生成 CTFramesetterRef
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attrString length] ), path,NULL);
    
    // 6 进行绘制
    CTFrameDraw(frame, context);
    
    // 10 绘制图片
    UIImage *img = [UIImage imageNamed:@"123"];
    CGContextDrawImage(context, [self calculateImagePositionInCTFrame:frame], img.CGImage);
    
    // 7 内存管理
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
    
}
    // 下面都是第11步
#pragma mark - CTRun delegate 回调方法
static CGFloat ascentCallback(void *ref) {
    
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}


static CGFloat descentCallback(void *ref) {
    
    return 0;
}

static CGFloat widthCallback(void *ref) {
    
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}




/**
 *  根据CTFrameRef获得绘制图片的区域
 *
 *  @param ctFrame CTFrameRef对象
 *
 *  @return绘制图片的区域
 */
- (CGRect)calculateImagePositionInCTFrame:(CTFrameRef)ctFrame {
    
    // 获得CTLine数组
    NSArray *lines = (NSArray *)CTFrameGetLines(ctFrame);
    NSInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    // 遍历每个CTLine
    for (NSInteger i = 0 ; i < lineCount; i++) {
        
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        
        // 遍历每个CTLine中的CTRun
        for (id runObj in runObjArray) {
            
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            
            NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            return delegateBounds;
        }
    }
    return CGRectZero;
}
@end

