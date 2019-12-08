//
//  HGBAppManager.h
//  测试
//
//  Created by huangguangbao on 2018/4/2.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBAppManager : NSObject
/**
 单例

 @return 实例
 */
+(instancetype)shareInstance;

/**
 获取所有app列表

 @return app列表
 */
-(NSArray *)getAllAppList;
/**
 获取所有系统app列表

 @return app列表
 */
-(NSArray *)getAllSystemAppList;
/**
 获取所有安装的app列表

 @return app列表
 */
-(NSArray *)getAllInstalledAppList;

/**
 是否安装app

 @param bundleId bundleId
 @return 结果
 */
-(BOOL)isInstalledWithAppBundleId:(NSString *)bundleId;
/**
 通过bundleId打开app

 @param bundleId bundleId
 @return 结果
 */
-(BOOL)openAppWithAppBundleId:(NSString *)bundleId;
@end
