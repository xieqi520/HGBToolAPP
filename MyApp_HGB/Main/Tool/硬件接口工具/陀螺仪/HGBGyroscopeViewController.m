
//
//  HGBGyroscopeViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/1/17.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBGyroscopeViewController.h"
#import "HGBCommonSelectCell.h"
#import "HGBGyroscopeTool.h"
#define Identify_Cell @"cell"


@interface HGBGyroscopeViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBGyroscopeViewController


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
    titleLab.text=@"陀螺仪";
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
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kWidth, kHeight) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.dataDictionary=@{@"陀螺仪":@[@"陀螺仪",@"关闭",@"开启摇一摇"]};
    self.keys=@[@"陀螺仪"];

    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];
}
#pragma mark table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72 * hScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 72 * hScale)];
    headView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    //信息提示栏
    UILabel *tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(32 * wScale, 0, kWidth - 32 * wScale, CGRectGetHeight(headView.frame))];
    tipMessageLabel.backgroundColor = [UIColor clearColor];
    tipMessageLabel.text =self.keys[section];
    tipMessageLabel.textColor = [UIColor grayColor];
    tipMessageLabel.textAlignment = NSTextAlignmentLeft;
    tipMessageLabel.font = [UIFont systemFontOfSize:12.0];
    tipMessageLabel.numberOfLines = 0;
    [headView addSubview:tipMessageLabel];
    return headView;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=self.keys[section];
    NSArray *dataAraay=[self.dataDictionary objectForKey:key];
    return  dataAraay.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGBCommonSelectCell *cell=[tableView dequeueReusableCellWithIdentifier:Identify_Cell forIndexPath:indexPath];
    NSString *key=self.keys[indexPath.section];
    NSArray *dataArray=[self.dataDictionary objectForKey:key];
    cell.title.text=dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){

        if (indexPath.row==0){
            [[HGBGyroscopeTool shareInstance] setTimeInterval:1];
                [[HGBGyroscopeTool shareInstance] startGyroscoperWithReslut:^(BOOL status, NSDictionary *returnMessage) {
                    NSLog(@"%@",returnMessage);
                }];
        }else if(indexPath.row==1){
            [[HGBGyroscopeTool shareInstance] stoptGyroscoperWithReslut:^(BOOL status, NSDictionary *returnMessage) {
                
            }];
        }else if (indexPath.row==2){
            // 设置允许摇一摇功能
            [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
        }

    }
}
#pragma maerk -- 摇一摇

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"开始摇了，坐稳咯");
}

-  (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"不摇了，你走吧");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇完了，下车吧");
}
#pragma mark get
-(NSDictionary *)dataDictionary{
    if(_dataDictionary==nil){
        _dataDictionary=[NSDictionary dictionary];
    }
    return _dataDictionary;
}
-(NSArray *)keys{
    if(_keys==nil){
        _keys=[NSArray array];
    }
    return _keys;
}
@end
