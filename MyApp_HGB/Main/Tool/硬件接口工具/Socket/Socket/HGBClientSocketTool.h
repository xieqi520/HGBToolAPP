//
//  HGBClientSocketTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/22.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>





#ifdef DEBUG
#define HGBLogFlag YES
#else
#endif



/**
 数据类型
 */
typedef enum HGBClientSocketToolDataType
{
    HGBClientSocketToolDataTypeData,//二进制数据
    HGBClientSocketToolDataTypeImage,//图片
    HGBClientSocketToolDataTypeDictionary,//字典
    HGBClientSocketToolDataTypeArray,//数组
    HGBClientSocketToolDataTypeString,//字符串
    HGBClientSocketToolDataTypeNumber//数字
}HGBClientSocketToolDataType;



@class HGBClientSocketTool;
@protocol HGBClientSocketToolDelegate <NSObject>
@optional

/**
 连接成功

 @param socketTool socket工具
 */
- (void)socketToolDidSucessedToConnect:(HGBClientSocketTool*)socketTool;
/**
 断开连接

 @param socketTool socket工具
 */
- (void)socketToolDidDisconnect:(HGBClientSocketTool*)socketTool;


/**
 发送信息成功
  @param socketTool socket工具
 */
- (void)socketToolDidSucessSendMessage:(HGBClientSocketTool*)socketTool;


/**
 收到消息
  @param socketTool socket工具
 @param message 信息
 @param messageType 数据类型
 */
- (void)socketTool:(HGBClientSocketTool*)socketTool didReciveMessage:(id )message andWithMessageType:(HGBClientSocketToolDataType )messageType;

@end

@interface HGBClientSocketTool : NSObject
/**
 代理
 */
@property(strong,nonatomic)id<HGBClientSocketToolDelegate>delegate;

/**
 是否链接
 */
@property(assign,nonatomic)BOOL isConnect;
/**
 客户端ip
 */
@property(strong,nonatomic)NSString *clinetIp;
/**
 客户端端口
 */
@property(strong,nonatomic)NSString *clinetPort;

/**
 单例

 @return 单例
 */
+ (instancetype)shareInstance;

/**
 握手操作

 @param ip ip地址
 @param port 端口号
 @return 结果
 */
-(BOOL)connectWithIp:(NSString *)ip andWithPort:(NSString *)port;
/**
 客户端断开连接
 */
-(void)disconnectClient;
/**
 客户端发送数据

 @param data 数据
 @return 结果
 */
-(BOOL)clientSendData:(id)data;
@end
