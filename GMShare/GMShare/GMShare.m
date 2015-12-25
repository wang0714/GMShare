//
//  GMShare.m
//  test2
//
//  Created by 汪高明 on 15/12/25.
//  Copyright © 2015年 汪高明. All rights reserved.
//

#import "GMShare.h"

// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ShareView()
{
    float heightView;
}

@end


@implementation GMShare

+(void)registApp
{
    /**
     *  初始化ShareSDK应用
     *
     *  @param appKey                   ShareSDK应用标识，可在http://mob.com中登录并创建App后获得
     *  @param activePlatforms          使用的分享平台集合，如:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)];
     *  @param connectHandler           导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作。具体的导入方式可以参考ShareSDKConnector.framework中所提供的方法。
     *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
    [ShareSDK registerApp:@"dd97abdc9735" activePlatforms:@[                                @(SSDKPlatformTypeSinaWeibo),
                                                                                            @(SSDKPlatformTypeCopy),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

@end



@implementation ShareView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        heightView=frame.size.height;
        
        CGFloat typeWidth=60;
        CGFloat typeHeight=60;
        int TotalColumn=4;//总列数.
        CGFloat marginX=(frame.size.width-typeWidth*TotalColumn)/(TotalColumn+1);
        
        for (int index=0; index<4; index++) {
            //1、创建View
            UIButton *btnPlatformType=[UIButton buttonWithType:UIButtonTypeCustom];
            UILabel *labelTitle=[[UILabel alloc]initWithFrame:CGRectZero];
            [btnPlatformType setImage:[UIImage imageNamed:[NSString stringWithFormat:@"share%d",index+1]] forState:UIControlStateNormal];
            
            btnPlatformType.tag=[[NSString stringWithFormat:@"22%d",index] integerValue];
            [btnPlatformType addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnPlatformType];
            [self addSubview:labelTitle];
            
            //3、设置frame
            int row=index/TotalColumn;
            int column=index%TotalColumn;
            CGFloat X=marginX+(marginX+typeWidth)*column;
            CGFloat Y=0;
            if (row==0) {
                Y=25;
            }else{
                Y=131+25;
            }
            btnPlatformType.frame=CGRectMake(X, Y,typeWidth,typeHeight);
            labelTitle.frame=CGRectMake(0, 0,100,24);
            labelTitle.textAlignment=NSTextAlignmentCenter;
            labelTitle.center=btnPlatformType.center;
            labelTitle.frame=CGRectMake(labelTitle.frame.origin.x, Y+btnPlatformType.frame.size.height+10, labelTitle.frame.size.width, labelTitle.frame.size.height);
            //4、设置数据
            switch (index) {
                case 0:
                    labelTitle.text=@"QQ";
                    btnPlatformType.enabled=[ShareSDK isClientInstalled:SSDKPlatformTypeQQ];
                    
                    break;
                case 1:
                    labelTitle.text=@"微信";
                    btnPlatformType.enabled=[ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];
                    
                    break;
                case 2:
                    labelTitle.text=@"微博";
                    [ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo];
                    btnPlatformType.enabled=[ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo];
                    break;
                case 3:
                    labelTitle.text=@"朋友圈";
                    btnPlatformType.enabled=[ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatTimeline];
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}


-(void)button1:(UIButton *)sender
{
    UIButton *button=sender;
    switch (button.tag) {
        case 220://qq好友
            _selectTypeBlock(SSDKPlatformTypeQQ);
        case 221://微信好友
            _selectTypeBlock(SSDKPlatformSubTypeWechatSession);
            break;
        case 222://新浪微博
            _selectTypeBlock(SSDKPlatformTypeSinaWeibo);
            break;
        case 223://微信朋友圈
            _selectTypeBlock(SSDKPlatformSubTypeWechatTimeline);
            break;
        default:
            break;
    }
}

-(void)showAnimation
{
    
    self.transform = CGAffineTransformMakeTranslation(0, heightView);
    [UIView animateWithDuration:1.2
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:2.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
    
    for (int index=0; index<self.subviews.count-1; index++) {
        UIView *subView=self.subviews[index];
        
        subView.transform = CGAffineTransformMakeTranslation(0, subView.frame.size.height);
        [UIView animateWithDuration:1.2
                              delay:(0.0+index*0.03)
             usingSpringWithDamping:0.6
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             subView.transform = CGAffineTransformIdentity;
                         }
                         completion:nil];
    }
}



@end



@implementation ShareViewbg

-(instancetype)initWithFrame:(CGRect)frame shareModel:(ShareModel *)shareModel
{
    if (self=[super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
        [self setAlpha:1.0];
        [self addTarget:self action:@selector(dimissShareView:) forControlEvents:UIControlEventTouchUpInside];
        
        if (shareModel==nil) {
            ShareModel *model=[ShareModel new];
            shareModel=model;
            model.picUrl=@"";
            model.title=@"吃什么";
            model.content=@"吃什么XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
            model.link=@"http://www.baidu.com";
        }
        
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:shareModel.picUrl]];
        //创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@@value(url)",shareModel.content]
                                         images:[UIImage imageWithData:imageData]
                                            url:[NSURL URLWithString:shareModel.link]
                                          title:shareModel.title
                                           type:SSDKContentTypeAuto];
        
        [self selectShareWithType:^(SSDKPlatformType platformType) {
            //            [MBProgressHUD showMessage:@"处理中..." toView:self];
            [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                //                [MBProgressHUD hideHUDForView:self animated:YES];
                switch (state) {
                        
                    case SSDKResponseStateBegin:
                    {
                        //TODO:加载中。。
                        break;
                    }
                    case SSDKResponseStateSuccess:
                    {
                        self.SSDKResponseStateSuccess();
                        [self dimissShareView:nil];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        self.SSDKResponseStateFail([NSString stringWithFormat:@"%@", error]);
                        //                        [MBProgressHUD hideHUDForView:self animated:YES];
                        break;
                    }
                    case SSDKResponseStateCancel:
                    {
                        self.SSDKResponseStateCancel();
                        //                        [MBProgressHUD hideHUDForView:self animated:YES];
                        break;
                    }
                    default:
                        break;
                }
                
                if (state != SSDKResponseStateBegin)
                {
                    //加载结束。。
                }
                
            }];
        }];
    }
    return self;
}



/**
 *  选择分享平台
 *
 *  @param SelectedPlatformType 平台
 */
-(void)selectShareWithType:(void(^)(SSDKPlatformType platformType))SelectedPlatformType
{
    float ShareView_H=194;
    float ShareButton_H=49;
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-ShareView_H, self.frame.size.width,ShareView_H) ];
    shareView.backgroundColor=[UIColor whiteColor];
    [self addSubview:shareView];
    
    //button 取消
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0,ShareView_H-ShareButton_H, self.frame.size.width, ShareButton_H);
    [button setImage:[UIImage imageNamed:@"icon_close_s"] forState:0];
    [button addTarget:self action:@selector(dimissShareView:) forControlEvents:UIControlEventTouchDown];
    [shareView insertSubview:button aboveSubview:self];
    button.backgroundColor=[UIColor clearColor];
    [button setTitleColor:IWColor(42, 183, 251) forState:0];
    
    shareView.selectTypeBlock=^(SSDKPlatformType type){
        SelectedPlatformType(type);
    };
    
    [shareView showAnimation];
    
    
}

/**
 *  让蒙版消失
 */
-(void)dimissShareView:(id)sender
{
    self.dimissShareView();
    [UIView animateWithDuration:.5
                     animations:^{
                         self.alpha=0.0;
                     }];
    [self performSelector:@selector(removeFromSuperview)
               withObject:nil
               afterDelay:0.5];
    
}


@end


@implementation ShareModel

@end


