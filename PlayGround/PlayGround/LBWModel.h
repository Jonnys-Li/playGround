//
//  LBWModel.h
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,CellType)
{
    CellTypePlain,
    CellTypeImg,
    CellTypeLong
};


@interface LBWModel : NSObject
@property(nonatomic,copy)NSString *titleLabel;
@property(nonatomic,copy)NSString *imgURL;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,assign)CellType celltype;
+(instancetype)modelWithTitle:(NSString *)title content:(NSString *)content imgURL:(NSString *)imgURL celltype:(CellType)celltype;

@end

NS_ASSUME_NONNULL_END
