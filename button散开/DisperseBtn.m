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
//最小半径
#define kMinRadius 50
#define kButtonW 50
#define kAnimationDuration 0.4

@interface DisperseBtn ()

@property (nonatomic ,weak)UIImageView *folder;
@property (nonatomic, assign) BOOL isOn;
@property (assign, nonatomic) BOOL isDisperse;

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
    imgView.image = self.closeImage;
    imgView.bounds = self.bounds;
    imgView.center = kCenter;
    imgView.userInteractionEnabled = YES;
    
    [self addSubview:imgView];
    
    //取消长按唤出
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
//    longPress.minimumPressDuration = 0.25;
//    [imgView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 2;
    [imgView addGestureRecognizer:tap];
}

-(void)tap:(UITapGestureRecognizer *)sender{
    
    self.isDisperse ? [self changeFrameWithPoint:self.center] : [self disperse];
    
//    [self disperse];
}

//存在误操作bug
//-(void)longPress:(UILongPressGestureRecognizer *)sender{
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        [self disperse];
//    }
//}

-(void)disperse{
    
    _isDisperse = YES;
    _folder.image = self.openImage;
    
    CGFloat startAngle = -M_PI_2;
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
    }
    
    //过滤过小半径
    rad = rad > kMinRadius ? rad : kMinRadius;

    for (int i = 0; i< _btns.count; i++) {
        
        CGFloat x = rad * cos(angle * i + startAngle);
        CGFloat y = rad * sin(angle * i + startAngle);
        UIButton *btn = _btns[i];
        
        //初始效果
//        [UIView animateWithDuration:0.05 delay:0.05*i options:UIViewAnimationOptionCurveLinear animations:^{
//            btn.transform = CGAffineTransformIsIdentity(btn.transform) ? CGAffineTransformMakeTranslation(x, y) : CGAffineTransformIdentity;
//        } completion:nil];
        
        //弹簧效果
       [UIView animateWithDuration:0.5 delay:0.1*i usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
           btn.transform = CGAffineTransformMakeTranslation(x, y);
           
        } completion:nil];
    }
}

//找到合适的角度
-(NSDictionary *)adaptableAngelWithRect:(CGRect)rect Radius:(CGFloat)rad{
    
    NSDictionary *dict = [self getMaxMinAngleWithRect:rect Radius:rad];
    
    CGFloat startAngle = [dict[@"start"] floatValue];
    CGFloat endAngle = [dict[@"end"] floatValue];
    
    if ((endAngle - startAngle) * rad < _btns.count * kSpace) {
        
        rad += kRadiusStep;
        CGRect oringinaRect = CGRectMake(self.center.x - rad - kButtonW*0.5, self.center.y - rad - kButtonW*0.5, 2*rad + kButtonW, 2*rad + kButtonW);
        //相交范围
        CGRect intertRect = CGRectIntersection(oringinaRect, self.borderRect);

        //递归
        return [self adaptableAngelWithRect:intertRect Radius:rad];
    }else{
        return @{@"start":[NSNumber numberWithFloat:startAngle],@"end":[NSNumber numberWithFloat:endAngle],@"radius":[NSNumber numberWithFloat:rad]};
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint p = [[touches anyObject]locationInView:nil];
    _isOn = CGRectContainsPoint(self.frame, p);

}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint p = [[touches anyObject]locationInView:nil];
    if (_isOn) {
        [self changeFrameWithPoint:p];
    }
}

-(void)changeFrameWithPoint:(CGPoint)point{
    
    self.center = point;
    
    //没展开就返回
    if (!_isDisperse) {
        return;
    }
    
    _isDisperse = NO;
    _folder.image = self.closeImage;
    
    for (int i = 0; i< _btns.count; i++) {
        UIButton *btn = _btns[i];
        
//        [UIView animateWithDuration:0.05 delay:0.05*i options:UIViewAnimationOptionCurveLinear animations:^{
//            btn.transform = CGAffineTransformIdentity;
//        } completion:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGPoint p = [self.superview convertPoint:point toView:btn];
//            NSLog(@"%@",NSStringFromCGPoint(point));
//            NSLog(@"%@",NSStringFromCGPoint(p));
            [self animationWithBtn:btn Point:p];
            NSLog(@"%d",i);
        });
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
    
    //找到所有连续的圆弧
    for (int i = 0; i<= count; i++, angle += step) {
        
        CGFloat x = rad * cos(angle) + centre.x;
        CGFloat y = rad * sin(angle) + centre.y;
        CGPoint point = CGPointMake(x, y);
        
        //进边界
        if (!CGRectContainsPoint(rect, lastPoint) && CGRectContainsPoint(rect, point)) {
            startAngle = angle;
        }
        //出边界
        if (CGRectContainsPoint(rect, lastPoint) && !CGRectContainsPoint(rect, point)) {
            endAngle = angle;
            [marr addObject:[NSNumber numberWithFloat:startAngle]];
            [marr addObject:[NSNumber numberWithFloat:endAngle]];
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

//响应按钮点击
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (_isDisperse) {
        //辨别
        if (CGRectContainsPoint(_folder.frame, point)) {
            return YES;
        }
        for (UIButton *btn in _btns) {
            if (CGRectContainsPoint(btn.frame, point)) {
                return YES;
            }
        }
        return NO;
    }else{
        return [super pointInside:point withEvent:event];
    }
}


-(void)animationWithBtn:(UIButton*)btn Point:(CGPoint)point{
    
    CABasicAnimation *rotation = [CABasicAnimation new];
    rotation.keyPath = @"transform.rotation";
    rotation.toValue = @(5 * M_PI);
//    rotation.duration = 2;
//    rotation.removedOnCompletion = NO;
//    rotation.fillMode = @"forwards";
    
    CABasicAnimation *trans = [CABasicAnimation new];
    trans.keyPath = @"transform";
    trans.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    trans.beginTime = 0.2;
    trans.duration = kAnimationDuration - trans.beginTime;
//    trans.removedOnCompletion = NO;
//    trans.fillMode = @"forwards";
    
    CAAnimationGroup *group = [CAAnimationGroup new];
    group.animations = @[rotation,trans];
    group.duration = kAnimationDuration;
    group.removedOnCompletion = NO;
    group.fillMode = @"forwards";
    
    [btn.layer addAnimation:group forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(group.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.transform = CGAffineTransformIdentity;
        [btn.layer removeAllAnimations];
//        NSLog(@"aaa");
    });
}

@end
