//
//  LBWUITableViewController.m
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import "LBWUITableViewController.h"
#import "LBWUITableViewCell.h"
#import "LBWModel.h"
#import "LBWCellFactory.h"
#import "LBWImagePreloader.h"
#import "LBWFPSLabel.h"
@interface LBWUITableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataAray;
@property(nonatomic,strong)LBWFPSLabel *fpsLabel;

@end

@implementation LBWUITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupFPSLabel];
    [self loadData];

}
-(void)setupViews
{
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    // 使用工厂模式注册所有 cell 类型
    [LBWCellFactory registerCellsForTableView:self.tableView];
    
    self.tableView.estimatedRowHeight=100;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
}

- (void)setupFPSLabel {
    // 显示 FPS 监控标签
    self.fpsLabel = [LBWFPSLabel showFPSLabelInView:self.view];
}
-(void)loadData
{
    NSMutableArray *array=[NSMutableArray array];
    for (NSInteger i=0; i<50; i++) {
        NSString *title=[NSString stringWithFormat:@"标题 %ld",(long)i];
        NSString *content=[NSString stringWithFormat:@"这是第%ld条内容",(long)i];
        // 2. 生成随机图片 URL
                // 后面加上 ?random=i 是为了防止 URL 完全一样导致缓存不更新，让每一行看起来都不一样
                NSString *randomImgURL = [NSString stringWithFormat:@"https://picsum.photos/200/200?random=%ld", (long)i];
        CellType logicType;
        if (i%3==0) {
            logicType =CellTypeImg;
        }
        else if(i%3==1){
            logicType = CellTypePlain;
        }else
        {
            logicType=CellTypeLong;
        }
        LBWModel *model=[LBWModel modelWithTitle:title content:content imgURL:randomImgURL celltype:logicType];
        [array addObject:model];
        
    }
    self.dataAray=array;
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBWModel *model=self.dataAray[indexPath.row];
    // 使用工厂模式创建 cell
    return [LBWCellFactory cellForTableView:tableView atIndexPath:indexPath withModel:model];
}


#pragma mark-DeleGate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBWModel *model=self.dataAray[indexPath.row];
    // 使用工厂模式获取 cell 高度（带缓存）
    return [LBWCellFactory heightForModel:model atIndexPath:indexPath tableView:tableView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 当 cell 即将显示时，预加载附近的图片
    NSArray<NSIndexPath *> *visibleIndexPaths = [tableView indexPathsForVisibleRows];
    if (visibleIndexPaths.count > 0) {
        [[LBWImagePreloader sharedPreloader] preloadImagesForVisibleIndexPaths:visibleIndexPaths
                                                                     totalCount:self.dataAray.count
                                                                 imageURLBlock:^NSString * _Nullable(NSInteger index) {
            if (index >= 0 && index < self.dataAray.count) {
                LBWModel *model = self.dataAray[index];
                return model.imgURL;
            }
            return nil;
        }
                                                                  preloadCount:3];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 滚动停止时预加载
    NSArray<NSIndexPath *> *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    if (visibleIndexPaths.count > 0) {
        [[LBWImagePreloader sharedPreloader] preloadImagesForVisibleIndexPaths:visibleIndexPaths
                                                                     totalCount:self.dataAray.count
                                                                 imageURLBlock:^NSString * _Nullable(NSInteger index) {
            if (index >= 0 && index < self.dataAray.count) {
                LBWModel *model = self.dataAray[index];
                return model.imgURL;
            }
            return nil;
        }
                                                                  preloadCount:5];
    }
}
@end
