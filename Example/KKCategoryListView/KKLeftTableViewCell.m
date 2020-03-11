//
//  KKLeftTableViewCell.m
//  KKCategoryList
//
//  Created by KKWONG on 2020/2/29.
//  Copyright © 2020 KKWONG. All rights reserved.
//

#import "KKLeftTableViewCell.h"

@implementation KKLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self cellSelectedStateChaged:selected];
}

- (void)setSelected:(BOOL)selected {
    [self cellSelectedStateChaged:selected];
}

- (void)cellSelectedStateChaged:(BOOL)selected {
    self.contentView.backgroundColor = selected ? self.selectBgColor : self.normalBgColor;
    self.textLabel.textColor = selected ? self.textSelectColor : self.textNormalColor;
}

@end


