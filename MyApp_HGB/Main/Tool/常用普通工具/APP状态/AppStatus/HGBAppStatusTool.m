//
//  HGBAppStatusTool.m
//  测试
//
//  Created by huangguangbao on 2018/1/13.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBAppStatusTool.h"
#import <UIKit/UIKit.h>

#define UIApplicationOpenURLNotification @"openURL"
#define UIApplicationHandleOpenURLNotification @"handleOpenURL"


@interface HGBAppStatusTool ()
/**
 监听App状态回调
 */
@property(strong,nonatomic)HGBAppStatusToolReslutBlock reslut;
/**
 app状态回调集合
 */
@property(strong,nonatomic)NSMutableArray *resluts;
@end
@implementation HGBAppStatusTool
#pragma mark 单例
static HGBAppStatusTool*instance=nil;
+(instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBAppStatusTool alloc]init];
    }
    return instance;
}
#pragma mark 功能
/**
 监听app状态

 @param reslut app状态
 */
-(void)monitorAppStatusWithReslutBlock:(HGBAppStatusToolReslutBlock)reslut{

    self.reslut = reslut;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appLanuch:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillActive:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillBack:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appBack:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appOpenURL:) name:UIApplicationHandleOpenURLNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appOpenURL:) name:UIApplicationOpenURLNotification object:nil];

}
/**
 app登陆

 @param _n 消息
 */
-(void)appLanuch:(NSNotification *)_n{
    self.reslut(HGBAppStatusLanuch,_n.userInfo);
}
/**
 app将要进入前台

 @param _n 消息
 */
-(void)appWillActive:(NSNotification *)_n{
    self.reslut(HGBAppStatusWillActive,_n.userInfo);
}
/**
 app将要进入后台

 @param _n 消息
 */
-(void)appWillBack:(NSNotification *)_n{
    self.reslut(HGBAppStatusWillBackGround,_n.userInfo);
}
/**
 app进入前台

 @param _n 消息
 */
-(void)appActive:(NSNotification *)_n{
    self.reslut(HGBAppStatusActive,_n.userInfo);
}
/**
 app进入后台

 @param _n 消息
 */
-(void)appBack:(NSNotification *)_n{
    self.reslut(HGBAppStatusBackGround,_n.userInfo);
}
/**
 app将要终止

 @param _n 消息
 */
-(void)appTerminate:(NSNotification *)_n{
    self.reslut(HGBAppStatusTerminate,_n.userInfo);
}
/**
 app打开URL

 @param _n 消息
 */
-(void)appOpenURL:(NSNotification *)_n{
    self.reslut(HGBAppStatusOpenURL,_n.userInfo);
}
#pragma mark getter-setter
-(NSMutableArray *)resluts{
    if(_resluts==nil){
        _resluts=[NSMutableArray array];
    }
    return _resluts;
}
@end
