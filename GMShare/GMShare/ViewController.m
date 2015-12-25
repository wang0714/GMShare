//
//  ViewController.m
//  GMShare
//
//  Created by 汪高明 on 15/12/25.
//  Copyright © 2015年 汪高明. All rights reserved.
//

#import "ViewController.h"
#import "GMShare.h"


@interface ViewController ()

@property (weak ,nonatomic) ShareViewbg *share_bgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareBtn:(id)sender {
    ShareViewbg *share_bgView=[[ShareViewbg alloc]initWithFrame:self.view.bounds shareModel:nil];
    [self.view addSubview:share_bgView];
    share_bgView.SSDKResponseStateSuccess=^(){
        NSLog(@"分享成功！");
    };
    share_bgView.SSDKResponseStateCancel=^(){
        NSLog(@"分享取消");
    };
    
    share_bgView.dimissShareView=^(){
        _share_bgView=nil;
    };
}

@end
