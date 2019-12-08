//
//  HGBAppStatusTool.h
//  测试
//
//  Created by huangguangbao on 2018/1/13.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 app 状态
 */
typedef enum HGBAppStatus
{
    HGBAppStatusLanuch,//登陆
    HGBAppStatusWillActive,//将要进入前台
    HGBAppStatusActive,//进入前台
    HGBAppStatusWillBackGround,//将要进入后台
    HGBAppStatusBackGround,//进入后台
    HGBAppStatusTerminate,//将要终止
    HGBAppStatusOpenURL//打开URL

}HGBAppStatus;

/**
 app状态结果

 @param status 状态
 @param returnMessage 返回信息
 */
typedef void (^HGBAppStatusToolReslutBlock)(HGBAppStatus status,NSDictionary *returnMessage);



@interface HGBAppStatusTool : NSObject
#pragma mark 单例
+(instancetype)shareInstance;

/**
 监听app状态

 @param reslut app状态
 */
-(void)monitorAppStatusWithReslutBlock:(HGBAppStatusToolReslutBlock)reslut;
@end
