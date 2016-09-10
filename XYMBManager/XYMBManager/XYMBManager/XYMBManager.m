//
//  XYMBManager.m
//  XYMBManager
//
//  Created by 薛尧 on 16/9/10.
//  Copyright © 2016年 Dom. All rights reserved.
//

#import "XYMBManager.h"

#define kScreen_height  [[UIScreen mainScreen] bounds].size.height
#define kScreen_width   [[UIScreen mainScreen] bounds].size.width

@interface XYMBManager ()<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *tap;
}
@end

static XYMBManager *hudManager = nil;
UIView *bottomView;
UIView *hudAddedView;
@implementation XYMBManager

#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super init]) {
        [self initBackView];// 创建窗口蒙层,出现背景变淡的效果
        self.isShowGloomy = YES;// 默认打开蒙层,如果不想要这个效果,可以直接修改为NO
    }
    return self;
}

#pragma mark - 初始化深色背景
- (void)initBackView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.5;
    bottomView.hidden = YES;
}

#pragma mark - 单例方法
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hudManager = [[self alloc] init];
    });
    return hudManager;
}




#pragma mark - 深色背景
- (void)showBackView
{
    bottomView.hidden = NO;
}

- (void)hideBackView
{
    bottomView.hidden = YES;
    [tap removeTarget:nil action:nil];
    bottomView.frame = CGRectMake(0, 0, kScreen_width, kScreen_height);
}

#pragma mark - 添加手势,触摸屏幕将隐藏提示框
- (void)addGestureInView:(UIView *)view
{
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheScreen)];
    tap.delegate = self;
    [view addGestureRecognizer:tap];
}

#pragma mark - 点击屏幕
- (void)tapTheScreen
{
    NSLog(@"点击屏幕");
    [hudManager hideBackView];
    [tap removeTarget:nil action:nil];
    [XYMBManager hideAlert];
}

#pragma mark - 解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[MBProgressHUD class]]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}




#pragma mark - 一直显示小菊花加文字,有背景
+ (void)showLoading
{
    [self showLoadingInView:nil];
}

#pragma mark - 显示文字提示语,无背景,默认2秒钟后消失
+ (void)showBriefAlert:(NSString *)alert
{
    [self showBriefMessage:alert inView:nil];
}

#pragma mark - 一直显示文字提示语,有背景
+ (void)showPermanentAlert:(NSString *)alert
{
    [self showPermanentMessage:alert inView:nil];
}

#pragma mark - 隐藏提示框
+ (void)hideAlert
{
    [hudManager hideBackView];
    UIView *view;
    if (hudAddedView) {
        view = hudAddedView;
    }
    else {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [self hideHUDForView:view];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:animated];
        return YES;
    }
    return NO;
}

+ (MBProgressHUD *)HUDForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            return (MBProgressHUD *)subview;
        }
    }
    return nil;
}

#pragma mark - 显示文字提示语到view上,无背景,默认2秒钟后消失
+ (void)showBriefMessage:(NSString *)message inView:(UIView *)view
{
    // 这种效果就是很窄的那种一句话提示，默认2秒后自动消失，当然也是支持手势的
    hudAddedView = view;
    [self shareManager];
    if (view == nil) {
        view = [[UIApplication sharedApplication] windows].lastObject;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:kShowTime];// 要显示的时间可以在这里修改
    [hudManager addGestureInView:view];
}

#pragma mark - 一直显示文字提示语到view上,有背景(只要不用手触摸屏幕或者调用hideAlert方法就会一直显示)
+ (void)showPermanentMessage:(NSString *)message inView:(UIView *)view
{
    // 调用此方法产生的提示框会长时间的停留在界面，直到用手触摸屏幕或者调用hideAlert方法
    hudAddedView = view;
    [self shareManager];
    if (view == nil) {
        view = [[UIApplication sharedApplication] windows].lastObject;// 如果view为nil，则把当前的window赋值为view，把提示框添加到当前的window上
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeCustomView;
    if (hudManager.isShowGloomy) {
        //如果添加了view则将botomView的frame修改与view一样大
        if (hudAddedView) {
            bottomView.frame = CGRectMake(0, 0, hudAddedView.frame.size.width, hudAddedView.frame.size.height);
        }
        [view addSubview:bottomView];// 添加蒙层到view上
        [hudManager showBackView];// 此时蒙层并没有显示，因为botomView的hide属性为YES，需调用此方法蒙层效果才会出现
    }
    [view bringSubviewToFront:hud];// 把hud移到最上面，否则hud的效果有点淡，因为被botomView遮挡了
    [hudManager addGestureInView:view];// 添加手势
}

#pragma mark - 一直显示小菊花加文字到view上,有背景
+ (void)showLoadingInView:(UIView *)view
{
    hudAddedView = view;
    [self shareManager];
    if (view == nil) {
        view = [[UIApplication sharedApplication] windows].lastObject;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.labelText = kLoadingMessage;// 预设的提示语，直接修改其值
    hud.removeFromSuperViewOnHide = YES;
    if (hudManager.isShowGloomy) {
        // 如果添加了view,则将bottomView的frame修改与view一样大
        if (hudAddedView) {
            bottomView.frame = CGRectMake(0, 0, hudAddedView.frame.size.width, hudAddedView.frame.size.height);
        }
        [view addSubview:bottomView];
        [hudManager showBackView];
    }
    [view addSubview:hud];
    [hud show:YES];// 调用此方法后才会显示
    [hudManager addGestureInView:view];
}

#pragma mark - 自定义加载视图接口,支持自定义图片
+ (void)showAlertWithCustomImage:(NSString *)imageName title:(NSString *)title inView:(UIView *)view
{
    hudAddedView = view;
    [self shareManager];
    if (view == nil) {
        view = [[UIApplication sharedApplication] windows].lastObject;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    UIImageView *littleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    littleView.image = [UIImage imageNamed:imageName];
    hud.customView = littleView;
    hud.removeFromSuperViewOnHide = YES;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.labelText = title;
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];
    [hud hide:YES afterDelay:kShowTime];
    [hudManager addGestureInView:view];
}

@end
