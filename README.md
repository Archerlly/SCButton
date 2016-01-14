# SCButton
---
自适应边界的散开按钮，接口已经留好，主要方法也注释了，大家有用就拿去。
#####使用场景：
摆脱千篇一律的按钮布局，为你的App中的Menu添加别样的风格

---
###效果展示

![image](https://github.com/tt3tt3tt/SCButton/raw/master/demoGIF/SCButton.gif)

---
###使用
1. 导入文件
```objectivec
#import "DisperseBtn.h"
```
2. 创建实例
```objectivec
//实例化对象
DisperseBtn *disView = [[DisperseBtn alloc]init];
disView.frame = CGRectMake(100, 100, 50, 50);
//设置适应的边界
disView.borderRect = self.view.frame;
//设置两个状态对应的图片
disView.closeImage = [UIImage imageNamed:@"icon2"];
disView.openImage = [UIImage imageNamed:@"icon3"];
[self.view addSubview:disView];
```
3. 添加需要展示的按钮
```objectivec
NSMutableArray *marr = [NSMutableArray array];
for (int i = 0; i< num; i++) {
UIButton *btn = [UIButton new];
NSString *name = [NSString stringWithFormat:@"SC%d",i];
[btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
[marr addObject:btn];
[btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}
_disView.btns = [marr copy];
```
---
###接口
```objectivec
//边界
@property (assign, nonatomic) CGRect borderRect;
//两种状态的图片
@property (strong, nonatomic) UIImage *closeImage;
@property (strong, nonatomic) UIImage *openImage;
//按钮数组
@property (nonatomic ,copy)NSArray *btns;
//回收按钮
-(void)recoverBotton;
```
---
###自定义参数
```objectivec
//两个按钮间的圆弧距离
#define kSpace 50
//适配半径时的增长量（可以提高精度）
#define kRadiusStep 10
//最小半径
#define kMinRadius 50
//动画时常
#define kAnimationDuration 0.4
//延时时常
#define kAnimationDelay 0.1
```
---
####License
SCButton is available under MIT license. See the LICENSE file for more info.

---
####其他
- 如在使用过程中发现什么BUG，请你Issues我。
- 有什么好的想法也可以Issues我。
- 小弟期待着大家的指点

---