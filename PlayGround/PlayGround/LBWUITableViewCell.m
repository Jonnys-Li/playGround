//
//  LBWUITableViewCell.m
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import "LBWUITableViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
@implementation LBWUITableViewCell

// 1. 在初始化方法里【只创建一次】控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    self.titlelabel=[[UILabel alloc]init];
    self.titlelabel.font=[UIFont systemFontOfSize:16];
    self.titlelabel.textColor=[UIColor blackColor];
    [self.contentView addSubview:self.titlelabel];
    
    self.contentLabel=[[UILabel alloc]init];
    self.contentLabel.numberOfLines=0;
    self.contentLabel.textColor=[UIColor lightGrayColor];
    
    [self.contentView addSubview:self.contentLabel];
    
    self.img=[[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"loading_icon"]];
    [self.contentView addSubview:self.img];
    
    CGFloat space=10.0;
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.top.equalTo(self.contentView.mas_top).offset(space);
        make.left.equalTo(self.contentView.mas_left).offset(space);
        make.right.equalTo(self.img.mas_left).offset(-space);
    }];
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.top.equalTo(self.titlelabel.mas_bottom).offset(space);
        make.left.equalTo(self.contentView.mas_left).offset(space);
        make.right.equalTo(self.img.mas_left).offset(-space);
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-space);
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.top.equalTo(self.contentView.mas_top).offset(space);
        make.right.equalTo(self.contentView.mas_right).offset(-space);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-space);
        make.width.equalTo(@80);
    }];
}

-(void)configWithModel:(LBWModel *)model
{
    self.titlelabel.text=model.titleLabel;
    self.contentLabel.text=model.content;
    // 一行搞定：自动把字符串转 URL 并异步加载图片
    if (model.celltype== CellTypePlain) {
        self.img.hidden=YES;
    }else
    {
        self.img.hidden=NO;
        [self.img sd_setImageWithURL:[NSURL URLWithString:model.imgURL]
                     placeholderImage:[UIImage imageNamed:@"loading_icon"]];
    }
   
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.titlelabel.text=nil;
    self.contentLabel.text=nil;
    self.img.image = nil;
    self.img.hidden = NO;
}
@end
