//
//  HGBClientUSBController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/13.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBClientUSBController.h"

#import "HGBClientUSBTool.h"


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0





@interface HGBClientUSBController ()<HGBClientUSBToolDelegate>
/**
 显示
 */
@property(strong,nonatomic)UITextView *showText;
/**
 发送文本
 */
@property(strong,nonatomic)UITextField *sendText;
/**
 发送按钮
 */
@property(strong,nonatomic)UIButton *sendButton;
@end

@implementation HGBClientUSBController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI
    [[HGBClientUSBTool shareInstance] setDelegate:self];

}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1]];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"USB客户端";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;


    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UI
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor whiteColor];
    self.showText=[[UITextView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 300)];
    self.showText.textColor=[UIColor whiteColor];
    self.showText.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.showText];

    self.sendText=[[UITextField alloc]initWithFrame:CGRectMake(10, 380,kWidth-100, 30)];
    self.sendText.textColor=[UIColor blackColor];
    self.sendText.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:self.sendText];

    self.sendButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.sendButton.backgroundColor=[UIColor blueColor];
    [self.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:(UIControlEventTouchUpInside)];
    self.sendButton.frame=CGRectMake(kWidth-80,380, 70, 30);
    [self.view addSubview:self.sendButton];




}

-(void)sendMessage{

    NSString *text=self.sendText.text;

    [[HGBClientUSBTool shareInstance]sendSource:text];

}
#pragma mark delegate
-(void)USBTool:(HGBClientUSBTool *)USBTool didFailedOnListenServiceWithError:(NSDictionary *)errorInfo{
    NSLog(@"listen error ");
}
-(void)USBTool:(HGBClientUSBTool *)USBTool didReciveMessage:(id)message andWithMessageType:(HGBClientUSBToolDataType)messageType{
    self.showText.text=[NSString stringWithFormat:@"%@\nrecive:%@",self.showText.text,message];
    NSLog(@"%@",message);
}
-(void)USBTool:(HGBClientUSBTool *)USBTool didClosedWithInfo:(NSDictionary *)Info{
    NSLog(@"close:%@",Info);
}
-(void)USBTool:(HGBClientUSBTool *)USBTool didFailedWithError:(NSDictionary *)errorInfo{
    NSLog(@"failed:%@",errorInfo);
}
-(void)USBTool:(HGBClientUSBTool *)USBTool didSucessedToConnectOnIp:(NSString *)ip andWithPort:(NSString *)port{
    NSLog(@"connect:%@  %@",ip,port);
}
-(void)USBTool:(HGBClientUSBTool *)USBTool didSucessedListenServiceOnIp:(NSString *)ip andWithPort:(NSString *)port{
    NSLog(@"listen:%@  %@",ip,port);
}
-(void)USBToolDidSucessSendDeviceInfo:(HGBClientUSBTool *)USBTool{
    NSLog(@"device info");
}
-(void)USBToolDidSucessSendMessage:(HGBClientUSBTool *)USBTool{
    NSLog(@"message");
     self.showText.text=[NSString stringWithFormat:@"%@\nsend:%@",self.showText.text,self.sendText.text];
}
@end
