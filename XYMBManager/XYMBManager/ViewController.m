//
//  ViewController.m
//  XYMBManager
//
//  Created by 薛尧 on 16/9/10.
//  Copyright © 2016年 Dom. All rights reserved.
//

#import "ViewController.h"

#import "XYMBManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     *  使用说明：
     *         1、引入头文件： #import "XYMBManager.h"
     *         2、一句代码搞定提示信息
     *         3、只要轻触屏幕或者调用[XYMBManager hideAlert]，提示信息就会消失
     */
}


- (IBAction)showTextOnly:(id)sender {
    [XYMBManager showBriefMessage:@"提示语" inView:self.view];
}


- (IBAction)showStill:(id)sender {
#if 0
    [XYMBManager showPermanentAlert:@"一直显示"];
#else
    [XYMBManager showPermanentMessage:@"一直显示" inView:self.backView];
#endif
}


- (IBAction)showDelay:(id)sender {
#if 1
    [XYMBManager showLoading];
#else
    [XYMBManager hideAlert];
    [XYMBManager showBriefAlert:@"hello"];
#endif
}


- (IBAction)test:(id)sender {
    // 一直显示小菊花加文字,有背景
//    [XYMBManager showLoading];
    
    // 显示文字提示语,无背景,默认2秒钟后消失
//    [XYMBManager showBriefAlert:@"啦啦啦"];
    
    // 一直显示文字提示语,有背景
//    [XYMBManager showPermanentAlert:@"啦啦啦啦啦"];
    
//    [XYMBManager showBriefMessage:@"哈哈哈" inView:self.view];
    
//    [XYMBManager showPermanentMessage:@"哈哈哈哈哈" inView:self.view];
    
//    [XYMBManager showLoadingInView:self.view];
    
    [XYMBManager showAlertWithCustomImage:@"AI_200*200" title:@"默认" inView:self.view];
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
