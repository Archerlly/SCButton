//
//  DisperseBtn.m
//  button散开
//
//  Created by 阿城 on 15/10/17.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "DisperseBtn.h"
#define kCenter CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)
//两个按钮间的圆弧距离
#define kSpace 50
//适配半径时的增长量
#define kRadiusStep 10
#define kButtonW 50

@interface DisperseBtn ()

@property (nonatomic ,weak)UIImageView *folder;
@property (nonatomic, assign) BOOL isOn;

@end

@implementation DisperseBtn

-(void)setBtns:(NSArray *)btns{
    _btns = btns;
    
    for (int i = 0; i< btns.count; i++) {
        UIButton *btn = btns[i];
        btn.bounds = CGRectMake(0, 0, kButtonW * 0.8, kButtonW * 0.8);
        btn.center = kCenter;
        [self addSubview:btn];
    }
    
    [self bringSubviewToFront:_folder];
}

-(void)didMoveToSuperview{
    
    [super didMoveToSuperview];
    
//    NSLog(@"%@",NSStringFromCGRect(self.frame));
//    NSLog(@"%@",NSStringFromCGRect(self.borderRect));
    
    UIImageView *imgView = [UIImageView new];
    _folder = imgView;
    imgView.image = (self.image==nil) ? [UIImage imageNamed:@"folder"] : self.image;
    imgView.bounds = self.bounds;
    imgView.center = kCenter;
    imgView.userInteractionEnabled = YES;
    
    [self addSubview:imgView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1;
    [imgView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 2;
    [imgView addGestureRecognizer:tap];
}

-(void)tap:(UITapGestureRecognizer *)sender{
//    NSLog(@"123");
    [self disperse];
}

-(void)longPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"12");
    }
}

-(void)disperse{
    
    CGFloat startAngle = 0.0;
    CGFloat angle = 2 * M_PI / _btns.count;
    CGFloat rad = kSpace / angle;
    
    CGRect oringinaRect = CGRectMake(self.center.x - rad - kButtonW*0.5, self.center.y - rad - kButtonW*0.5, 2*rad + kButtonW, 2*rad + kButtonW);

    if (!CGRectContainsRect(self.borderRect, oringinaRect)) {
        
        //相交范围
        CGRect intertRect = CGRectIntersection(oringinaRect, self.borderRect);
        NSDictionary *dict = [self adaptableAngelWithRect:intertRect Radius:rad];
        CGFloat start = [dict[@"start"] floatValue];
        CGFloat end = [dict[@"end"] floatValue];
        rad = [dict[@"radius"] floatValue];
        
        angle = (end - start) / _btns.count;
        startAngle = start + angle * 0.5;
        NSLog(@"angle:%.2f",angle * 180 / M_PI);
        NSLog(@"startAngle:%.2f",startAngle * 180 / M_PI);
        NSLog(@"rad:%.2f",rad);
    }

    for (int i = 0; i< _btns.count; i++) {
        CGFloat x = rad * cos(angle * i + startAngle);
        CGFloat y = rad * sin(angle * i + startAngle);
        UIButton *btn = _btns[i];
        [UIView animateWithDuration:0.05 delay:0.05*i options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIsIdentity(btn.transform) ? CGAffineTransformMakeTranslation(x, y) : CGAffineTransformIdentity;
        } completion:nil];
    }
}

//找到合适的角度
-(NSDictionary *)adaptableAngelWithRect:(CGRect)rect Radius:(CGFloat)rad{
    
    NSDictionary *dict = [self getMaxMinAngleWithRect:rect Radius:rad];
    
    CGFloat startAngle = [dict[@"start"] floatValue];
    CGFloat endAngle = [dict[@"end"] floatValue];
//    NSLog(@"%.2f  %.2f",startAngle * 180 / M_PI,endAngle * 180 / M_PI);
    
    if ((endAngle - startAngle) * rad < _btns.count * kSpace) {
        
        rad += kRadiusStep;
        CGRect oringinaRect = CGRectMake(self.center.x - rad - kButtonW*0.5, self.center.y - rad - kButtonW*0.5, 2*rad + kButtonW, 2*rad + kButtonW);
        //相交范围
        CGRect intertRect = CGRectIntersection(oringinaRect, self.borderRect);
        NSLog(@"%@",NSStringFromCGRect(intertRect));
        //递归
        return [self adaptableAngelWithRect:intertRect Radius:rad];
    }else{
        return @{@"start":[NSNumber numberWithFloat:startAngle],@"end":[NSNumber numberWithFloat:endAngle],@"radius":[NSNumber numberWithFloat:rad]};
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint p = [[touches anyObject]locationInView:nil];
    _isOn = CGRectContainsPoint(self.frame, p);
//    NSLog(@"%@",NSStringFromCGPoint(p));
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint p = [[touches anyObject]locationInView:nil];
    if (_isOn) {
        [self changeFrameWithPoint:p];
    }
//    NSLog(@"%@",NSStringFromCGPoint(p));
}

-(void)changeFrameWithPoint:(CGPoint)point{
    
    self.center = point;
    
    for (int i = 0; i< _btns.count; i++) {
        UIButton *btn = _btns[i];
        [UIView animateWithDuration:0.05 delay:0.05*i options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
    
}

-(NSDictionary *)getMaxMinAngleWithRect:(CGRect)rect Radius:(CGFloat)rad{
    
//    UIView *v = [[UIView alloc]initWithFrame:rect];
//    v.backgroundColor = [UIColor redColor];
//    [self.superview addSubview:v];
//    [self.superview  sendSubviewToBack:v];
    
    CGFloat angle = 0;
    CGFloat startAngle = 0;
    CGFloat endAngle = 0;
    CGPoint centre = self.center;
    //加上宽度
    rad += kButtonW * 0.4;
    
    CGPoint lastPoint = CGPointMake(centre.x + rad, centre.y);
    NSMutableArray *marr = [NSMutableArray array];
    
    CGFloat step = M_PI * 0.01;
    NSInteger count = 4 * M_PI / step;
    
//    NSLog(@"交界%@,%.2f,%@",NSStringFromCGRect(rect),rad,NSStringFromCGPoint(centre));
    
    //找到所有连续的圆弧
    for (int i = 0; i<= count; i++, angle += step) {
        
        CGFloat x = rad * cos(angle) + centre.x;
        CGFloat y = rad * sin(angle) + centre.y;
        CGPoint point = CGPointMake(x, y);
        
//        NSLog(@"%@",NSStringFromCGPoint(point));
        //进边界
        if (!CGRectContainsPoint(rect, lastPoint) && CGRectContainsPoint(rect, point)) {
            startAngle = angle;
//            NSLog(@"startAngle:%.2f",startAngle * 180 / M_PI);
        }
        //出边界
        if (CGRectContainsPoint(rect, lastPoint) && !CGRectContainsPoint(rect, point)) {
            endAngle = angle;
            [marr addObject:[NSNumber numberWithFloat:startAngle]];
            [marr addObject:[NSNumber numberWithFloat:endAngle]];
//            NSLog(@"endAngle:%.2f",endAngle * 180 / M_PI);
        }
        lastPoint = point;
    }
    
    //找出圆弧最大值
    CGFloat maxInterver = 0;
    for (int i = 0; i< marr.count; i += 2) {
        
        CGFloat start = [marr[i] floatValue];
        CGFloat end = [marr[i + 1] floatValue];
        
        if (end - start > maxInterver) {
            startAngle = start;
            endAngle = end;
            maxInterver = end - start;
        }
    }

    return @{@"start":[NSNumber numberWithFloat:startAngle],@"end":[NSNumber numberWithFloat:endAngle]};
    
}

@end
