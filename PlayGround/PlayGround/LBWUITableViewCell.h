//
//  LBWUITableViewCell.h
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import <UIKit/UIKit.h>
#import "LBWModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LBWUITableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *img;
@property (nonatomic,strong) UILabel *titlelabel;
@property(nonatomic,strong)UILabel *contentLabel;
-(void)configWithModel:(LBWModel *)model;
@end

NS_ASSUME_NONNULL_END
