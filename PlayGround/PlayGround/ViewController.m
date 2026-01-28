//
//  ViewController.m
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import "ViewController.h"
#import "LBWUITableViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray<NSDictionary*> *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"主页";
    self.view.backgroundColor=[UIColor redColor];
    [self setupView];
    [self loadData];
}

-(void)setupView
{
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tableView];
    
    
}
-(void)loadData
{
    self.dataArray=@[
        
        @{@"title":@"TableView深入",@"class":[LBWUITableViewController class]}
    ];
}
#pragma mark-datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    NSDictionary *data=self.dataArray[indexPath.row];
    cell.textLabel.text=data[@"title"];
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data=self.dataArray[indexPath.row];
    Class viewControllerClass=data[@"class"];
    UIViewController *viewController =[[viewControllerClass alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}
@end
