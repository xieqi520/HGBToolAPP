//
//  AppDelegate.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"


#import "AppDelegate+HGBLog.h"
#import "AppDelegate+HGBDataBase.h"
#import "AppDelegate+HGBSEDataBase.h"
#import "AppDelegate+HGBPush.h"
#import "AppDelegate+HGBPurchase.h"

#import "AppDelegate+HGBUMengAnalytics.h"
#import "AppDelegate+HGBWeex.h"

#import "AppDelegate+HGBUMShare.h"
#import "AppDelegate+HGBAppCheck.h"
#import "HGBRootViewController.h"
#import "AppDelegate+HGBException.h"
#import "AppDelegate+HGB3DTouch.h"
#import "AppDelegate+HGBURLProtocol.h"
#import "AppDelegate+HGBSELog.h"


#define UIApplicationOpenURLNotification @"openURL"
#define UIApplicationHandleOpenURLNotification @"handleOpenURL"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //日志
//    [self init_Log_ServerWithOptions:launchOptions];
    [self init_SELog_ServerWithOptions:launchOptions];
    //数据库初始化
    [self init_DataBase_ServerWithOptions:launchOptions];
    //SE数据库初始化
    [self init_SEDataBase_ServerWithOptions:launchOptions];
    //推送初始化
    [self init_Push_ServerWithOptions:launchOptions];
    //app内购初始化
    [self init_Purchase_ServerWithOptions:launchOptions];
    //错误捕捉
    [self init_Exception_ServerWithOptions:launchOptions];
    //3DTouch
    [self init_3DTouch_ServerWithOptions:launchOptions];
    //URL拦截
    [self init_URLIntercept_ServerWithOptions:launchOptions];



    //weex初始化
    [self init_Weex_ServerWithOptions:launchOptions];
    //百度地图初始化
    
    //友盟统计
    [self init_UMengAnalytics_ServerWithUMengAnalyticsAppKey:@"59df2c8b82b6356c4b00006f" andWithLaunchOptions:launchOptions];

    //友盟分享
    [self init_UMShare_ServerWithLaunchOptions:launchOptions];
    

    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    HGBRootViewController *rootVC=[[HGBRootViewController alloc]init];
    self.window.rootViewController=rootVC;
    [self.window makeKeyAndVisible];
    //app自检
//    [self init_AppCheck_ServerWithOptions:launchOptions];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationHandleOpenURLNotification object:self userInfo:@{@"url":url}];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationOpenURLNotification object:self userInfo:@{@"url":url}];
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationOpenURLNotification object:self userInfo:@{@"url":url}];
    return  YES;
}

@end
