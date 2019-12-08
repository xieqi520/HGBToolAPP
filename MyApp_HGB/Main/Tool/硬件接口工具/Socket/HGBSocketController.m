//
//  HGBSocketController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/22.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBSocketController.h"

#import "HGBClientSocketTool.h"
#import "HGBServerSocketTool.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0


@interface HGBSocketController ()
/**
 服务端开启
 */
@property(strong,nonatomic)UIButton *serverButton;
/**
 客户端连接
 */
@property(strong,nonatomic)UIButton *clientButton;
/**
 服务端发送文本
 */
@property(strong,nonatomic)UITextField *serverSendText;
/**
 客户端发送文本
 */
@property(strong,nonatomic)UITextField *clientSendText;
/**
 服务端发送消息
 */
@property(strong,nonatomic)UIButton *serverSendButton;
/**
 客户端发送消息
 */
@property(strong,nonatomic)UIButton *clientSendButton;

@end

@implementation HGBSocketController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI

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
    titleLab.text=@"Socket";
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


    self.serverButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.serverButton.tag=0;
    [self.serverButton addTarget:self action:@selector(startServerListen:) forControlEvents:(UIControlEventTouchUpInside)];
    self.serverButton.frame=CGRectMake(30*wScale, 80,(kWidth-90*wScale)*0.5, 30);
    [self.serverButton setTitle:@"开启socket服务" forState:(UIControlStateNormal)];
    [self.serverButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.serverButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.serverButton];


    self.clientButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.clientButton.tag=1;
    [self.clientButton addTarget:self action:@selector(connectServerListen:) forControlEvents:(UIControlEventTouchUpInside)];
    self.clientButton.frame=CGRectMake(60*wScale+(kWidth-90*wScale)*0.5, 80,(kWidth-90*wScale)*0.5, 30);
    [self.clientButton setTitle:@"链接socket服务" forState:(UIControlStateNormal)];
    [self.clientButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.clientButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.clientButton];

    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 120, kWidth, 1)];
    line1.backgroundColor=[UIColor redColor];
    [self.view addSubview:line1];






    self.clientSendText=[[UITextField alloc]initWithFrame:CGRectMake(30*wScale, 130, (kWidth-360*wScale), 30)];
    self.clientSendText.placeholder=@"请输入客户端传输信息";
    self.clientSendText.layer.borderColor=[[UIColor grayColor]CGColor];
    self.clientSendText.layer.borderWidth=1;
    [self.view addSubview:self.clientSendText];


    self.clientSendButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.clientSendButton.tag=2;
    [self.clientSendButton addTarget:self action:@selector(clientSend:) forControlEvents:(UIControlEventTouchUpInside)];
    self.clientSendButton.frame=CGRectMake((kWidth-300*wScale), 130,270*wScale,30);
    [self.clientSendButton setTitle:@"客户端发送消息" forState:(UIControlStateNormal)];
    [self.clientSendButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.clientSendButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.clientSendButton];



    self.serverSendText=[[UITextField alloc]initWithFrame:CGRectMake(30*wScale, 170, (kWidth-360*wScale), 30)];
    self.serverSendText.placeholder=@"请输入服务端传输信息";
    self.serverSendText.layer.borderColor=[[UIColor grayColor]CGColor];
    self.serverSendText.layer.borderWidth=1;
    [self.view addSubview:self.serverSendText];


    self.serverSendButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.serverSendButton.tag=3;
    [self.serverSendButton addTarget:self action:@selector(serverSend:) forControlEvents:(UIControlEventTouchUpInside)];
    self.serverSendButton.frame=CGRectMake((kWidth-300*wScale), 170,270*wScale,30);
    [self.serverSendButton setTitle:@"服务端发送消息" forState:(UIControlStateNormal)];
    [self.serverSendButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.serverSendButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.serverSendButton];





}
#pragma mark action
/**
 开启服务

 @param _b 按钮
 */
-(void)startServerListen:(UIButton *)_b{
    [[HGBServerSocketTool shareInstance]listenToPort:@"8389"];
}
/**
链接服务

 @param _b 按钮
 */
-(void)connectServerListen:(UIButton *)_b{
    [[HGBClientSocketTool shareInstance]connectWithIp:@"127.0.0.1" andWithPort:@"8389"];
}
/**
 服务端发送消息

 @param _b 按钮
 */
-(void)serverSend:(UIButton *)_b{
    [[HGBServerSocketTool shareInstance]serverSendData:self.serverSendText.text];
}

/**
 客户端发送消息

 @param _b 按钮
 */
-(void)clientSend:(UIButton *)_b{
    [[HGBClientSocketTool shareInstance]clientSendData:self.clientSendText.text];
}



@end
