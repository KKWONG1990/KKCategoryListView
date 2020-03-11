//
//  RCollectionViewCell.m
//  KKCategoryList
//
//  Created by KKWONG on 2020/2/27.
//  Copyright © 2020 KKWONG. All rights reserved.
//

#import "RCollectionViewCell.h"

@implementation RCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5, 0, self.frame.size.width - 10, 55);
    self.textLabel.frame = CGRectMake(0, 60, self.frame.size.width, 20);
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adidas.png"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
@end
