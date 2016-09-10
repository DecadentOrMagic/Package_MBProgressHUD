//
//  XYMBManager.h
//  XYMBManager
//
//  Created by 薛尧 on 16/9/10.
//  Copyright © 2016年 Dom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MBProgressHUD/MBProgressHUD.h>

// http://www.jianshu.com/p/478ffcde2377

static NSString *const kLoadingMessage = @"加载中";// 定义网络加载时显示的提示语,可以在此直接修改成想要的提示,达到定义一次,全局都有
static CGFloat const kShowTime         = 2.0f;// 定义自动消失的提示语显示的时间,可直接修改

@interface XYMBManager : NSObject

/**
 *  是否显示变淡效果,默认为 YES. ps.只为 showPermanentAlert:(NSString *)alert 和 showLoading 方法添加
 */
@property (nonatomic, assign) BOOL isShowGloomy;




/**
 *  一直显示小菊花加文字,有背景
 *  若要修改显示文字,直接修改 kLoadingMessage 的值即可
 */
+ (void)showLoading;

/**
 *  显示文字提示语,无背景,默认2秒钟后消失
 *  若要修改显示时间,可直接修改kShowTime
 *
 *  @param alert 需要显示的提示信息
 */
+ (void)showBriefAlert:(NSString *)alert;

/**
 *  一直显示文字提示语,有背景
 *
 *  @param alert 需要显示的提示信息
 */
+ (void)showPermanentAlert:(NSString *)alert;

/**
 *  隐藏alert
 */
+(void)hideAlert;

/***************************************
 *                                     *
 *  以下方法根据情况可选择使用，一般使用不到  *
 *  除非要添加提示框到特定的view上         *
 *                                     *
 ***************************************
 */

/**
 *   显示文字提示语到view上,无背景,默认2秒钟后消失
 *
 *  @param message 需要显示的提示信息
 *  @param view    要添加到的view
 */
+ (void)showBriefMessage:(NSString *)message inView:(UIView *)view;

/**
 *  一直显示文字提示语到view上,有背景(只要不用手触摸屏幕或者调用hideAlert方法就会一直显示)
 *
 *  @param message 需要显示的提示信息
 *  @param view    要添加到的view
 */
+ (void)showPermanentMessage:(NSString *)message inView:(UIView *)view;

/**
 *  一直显示小菊花加文字到view上,有背景
 *
 *  @param view 要添加到的view
 */
+ (void)showLoadingInView:(UIView *)view;

/**
 *  自定义加载视图接口,支持自定义图片
 *
 *  @param imageName 需要显示的图片,最好是37*37大小的图片
 *  @param title     需要显示的提示文字
 *  @param view      要把提示框添加到的view
 */
+ (void)showAlertWithCustomImage:(NSString *)imageName title:(NSString *)title inView:(UIView *)view;

@end
