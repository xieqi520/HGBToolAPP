//
//  HGBVideoPlayer.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/5/20.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBVideoPlayer : UIViewController
///**
// 代理
// */
//@property(strong,nonatomic)id<HGBAudioPlayerDelegate>delegate;
/**
 标题
 */
@property(strong,nonatomic)NSString *title;
/**
 url
 */
@property(strong,nonatomic)NSString *url;
@end
