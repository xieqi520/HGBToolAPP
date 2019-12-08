//
//  AppDelegate+HGBPurchase.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/5/25.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HGBPurchase)
/**
 内购初始化

 @param launchOptions 加载参数
 */
-(void)init_Purchase_ServerWithOptions:(NSDictionary *)launchOptions;
@end
