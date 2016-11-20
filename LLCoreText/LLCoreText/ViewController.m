//
//  ViewController.m
//  LLCoreText
//
//  Created by liushaohua on 16/11/20.
//  Copyright © 2016年 liushaohua. All rights reserved.
//

#import "ViewController.h"
#import "LLCoreTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LLCoreTextView *context = [LLCoreTextView new];
    context.frame = self.view.bounds;
    context.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:context];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
