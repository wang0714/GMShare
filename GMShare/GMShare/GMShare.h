//
//  GMShare.h
//  test2
//
//  Created by 汪高明 on 15/12/25.
//  Copyright © 2015年 汪高明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

//腾讯开放平台 （对应QQ和QQ空间）SDK文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@interface ShareModel :NSObject
@property (nonatomic , strong) NSString              * picUrl;
@property (nonatomic , strong) NSString              * title;
@property (nonatomic , strong) NSString              * content;
@property (nonatomic , strong) NSString              * link;

@end




@interface GMShare : NSObject


/**
 *  注册分享组件
 *  @param activePlatforms          使用的分享平台集合
 */
+(void)registApp;

@end


typedef void(^SelectShareTypeBlock)(SSDKPlatformType platformType);
@interface ShareView : UIView

/**
 *  选择分享平台Block
 */
@property(nonatomic,copy) SelectShareTypeBlock selectTypeBlock;

/**
 *  执行显示动画
 */
-(void)showAnimation;

@end



@interface ShareViewbg : UIControl


-(instancetype)initWithFrame:(CGRect)frame shareModel:(ShareModel *)shareModel;



@property(nonatomic,copy) void(^SSDKResponseStateSuccess)();
@property(nonatomic,copy) void(^SSDKResponseStateFail)(NSString *error);
@property(nonatomic,copy) void(^SSDKResponseStateCancel)();
@property(nonatomic,copy) void(^dimissShareView)();

@end



