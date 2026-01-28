//
//  LBWModel.m
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import "LBWModel.h"

@implementation LBWModel
+(instancetype)modelWithTitle:(NSString *)title content:(NSString *)content imgURL:(NSString *)imgURL celltype:(CellType)celltype
{
    LBWModel *model=[[LBWModel alloc]init];
    model.titleLabel=title;
    model.content=content;
    model.celltype=celltype;
    model.imgURL=imgURL;
    return model;
}
@end
