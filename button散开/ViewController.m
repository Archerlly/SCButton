//
//  ViewController.m
//  button散开
//
//  Created by 阿城 on 15/10/17.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "ViewController.h"
#import "DisperseBtn.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DisperseBtn *disView = [[DisperseBtn alloc]init];
    disView.frame = CGRectMake(100, 100, 50, 50);
    disView.borderRect = self.view.frame;

    
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i< 7; i++) {
        UIButton *btn = [UIButton new];
        NSString *name = [NSString stringWithFormat:@"found_icons_%d",i];
        [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [marr addObject:btn];
    }
    disView.btns = marr;
    [self.view addSubview:disView];
    
}

@end
