//
//  SCViewController.m
//  SCButton
//
//  Created by 刘成清 on 08/29/2016.
//  Copyright (c) 2016 刘成清. All rights reserved.
//

#import "SCViewController.h"
#import "SCToolButton.h"

@interface SCViewController ()

@property(nonatomic ,weak) UILabel *lab;
@property (weak, nonatomic) SCToolButton *disView;

@end

@implementation SCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //实例化对象
    SCToolButton *disView = [[SCToolButton alloc]init];
    disView.frame = CGRectMake(100, 100, 50, 50);
    //设置适应的边界
    disView.borderRect = self.view.frame;
    //设置两个状态对应的图片
    disView.closeImage = [UIImage imageNamed:@"icon2"];
    disView.openImage = [UIImage imageNamed:@"icon3"];
    [self.view addSubview:disView];
    
    _disView = disView;
    [self setDisViewButtonsNum:3];
    
    //调试使用
    UILabel *lab = [UILabel new];
    lab.bounds = CGRectMake(0, 0, 300, 200);
    lab.font = [UIFont systemFontOfSize:30];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.center = self.view.center;
    _lab = lab;
    [self.view addSubview:lab];
    
    UISlider *slider = [UISlider new];
    slider.maximumValue = 8;
    slider.minimumValue = 2;
    slider.value = 3;
    [slider addTarget:self action:@selector(sliderTarget:) forControlEvents:UIControlEventValueChanged];
    slider.frame = CGRectMake(20, 200, self.view.bounds.size.width - 40, 20);
    [self.view addSubview:slider];
    
}

//调试使用
- (IBAction)sliderTarget:(UISlider *)sender {
    
    int num = sender.value;
    NSLog(@"%d",num);
    [self setDisViewButtonsNum:num];
    
}

- (void)setDisViewButtonsNum:(int)num{
    
    [_disView recoverBotton];
    
    for (UIView *btn in _disView.btns) {
        [btn removeFromSuperview];
    }
    
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i< num; i++) {
        UIButton *btn = [UIButton new];
        NSString *name = [NSString stringWithFormat:@"SC%d",i];
        [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [marr addObject:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonTagget:) forControlEvents:UIControlEventTouchUpInside];
    }
    _disView.btns = [marr copy];
}

-(void)buttonTagget:(UIButton *)sender{
    self.lab.text = [NSString stringWithFormat:@"点击了第%ld个按钮",sender.tag+1];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.lab.text = @"点击屏幕";
}


@end
