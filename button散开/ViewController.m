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
@property(nonatomic ,weak) UILabel *lab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //散开的view
    DisperseBtn *disView = [[DisperseBtn alloc]init];
    disView.frame = CGRectMake(100, 100, 50, 50);
    disView.borderRect = self.view.frame;
    
    
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i< 8; i++) {
        UIButton *btn = [UIButton new];
        NSString *name = [NSString stringWithFormat:@"found_icons_%d",i];
        [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [marr addObject:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonTagget:) forControlEvents:UIControlEventTouchUpInside];
    }
    disView.btns = marr;
    [self.view addSubview:disView];
    
    
    
    //调试使用
    UILabel *lab = [UILabel new];
    lab.bounds = CGRectMake(0, 0, 300, 200);
    lab.font = [UIFont systemFontOfSize:30];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.center = self.view.center;
    _lab = lab;
    [self.view addSubview:lab];
    
}

-(void)buttonTagget:(UIButton *)sender{
    NSLog(@"sdf%d",sender.tag);
    self.lab.text = [NSString stringWithFormat:@"点击了第%d个按钮",sender.tag+1];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.lab.text = @"点击屏幕";
}

@end
