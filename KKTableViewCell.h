//
//  KKTableViewCell.h
//  KKCategoryList
//
//  Created by KKWONG on 2020/2/27.
//  Copyright © 2020 KKWONG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKTableViewCell : UITableViewCell
@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *selectBgColor;
@property (nonatomic, strong) UIColor *textNormalColor;
@property (nonatomic, strong) UIColor *textSelectColor;
@end

NS_ASSUME_NONNULL_END
