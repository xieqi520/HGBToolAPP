//
//  HGBMonitorFileTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/5/22.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBMonitorFileTool : NSObject
/**
 监听文件变化

 @param srcPath 文件路径
 @param block 回调
 @return 结果
 */
- (BOOL)monitorForPath:(NSString *)srcPath block:(void (^)(NSInteger type))block;

@end
