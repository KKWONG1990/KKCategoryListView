//
//  KKViewController.m
//  KKCategoryListView
//
//  Created by KKWONG1990 on 03/11/2020.
//  Copyright (c) 2020 KKWONG1990. All rights reserved.
//

#import "KKViewController.h"
#import "KKLeftTableViewCell.h"
#import "RCollectionViewCell.h"
#import "RCollectionReusableView.h"
#import <KKCategoryListView.h>
@interface KKViewController ()<KKCategoryListViewDataSource,KKCategoryListViewDelegate>
@property (nonatomic, strong) KKCategoryListView *categoryListView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation KKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.categoryListView];
        
    self.dataSource = [NSArray arrayWithObjects:@"系列", @"潮搭", @"手表", @"球鞋", @"数码", @"箱包", @"系列", @"潮搭", @"手表", @"球鞋", @"数码", @"箱包", nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.categoryListView reloadLeftTableViewData];
        [self.categoryListView reloadRightTableViewData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(id)tableView CategoryListView:(KKCategoryListView *)categoryListView {
    if (tableView == categoryListView.leftTableView) {
        return 1;
    } else if (tableView == categoryListView.rightTableView) {
        return self.dataSource.count;
    } else {
        return self.dataSource.count;
    }
}

- (NSInteger)categoryListView:(KKCategoryListView *)categoryListView tableView:(id)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == categoryListView.rightTableView) {
        return 12;
    } else if (tableView == categoryListView.leftTableView) {
        return self.dataSource.count;
    } else {
        return 12;
    }
}

- (void)categoryListView:(KKCategoryListView *)categoryListView tableView:(id)tableView willDisplayCell:(id)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == categoryListView.leftTableView) {
        if ([cell isKindOfClass:[KKLeftTableViewCell class]]) {
            KKLeftTableViewCell *leftCell = (KKLeftTableViewCell *)cell;
            NSString *title = [self.dataSource objectAtIndex:indexPath.row];
            leftCell.textLabel.text = title;
        }
    } else if (tableView == categoryListView.rightTableView) {
        if ([cell isKindOfClass:[RCollectionViewCell class]]) {
            
        }
    } else {
        if ([cell isKindOfClass:[RCollectionViewCell class]]) {
            RCollectionViewCell *rightCell = (RCollectionViewCell *)cell;
            rightCell.textLabel.text = @"阿迪达斯";
        }
    }
}

- (void)categoryListView:(KKCategoryListView *)categoryListView tableView:(id)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"玄宗了");
}

- (CGSize)categoryListView:(KKCategoryListView *)categoryListView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(categoryListView.frame.size.width - categoryListView.leftTableViewWidth, 80);
}

- (CGFloat)categoryListView:(KKCategoryListView *)categoryListView minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)categoryListView:(KKCategoryListView *)categoryListView minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (UIEdgeInsets)categoryListView:(KKCategoryListView *)categoryListView insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, -2, 0, -2);
}

- (CGSize)categoryListView:(KKCategoryListView *)categoryListView referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(categoryListView.frame.size.width, 50);
}


- (KKCollectionReusableView *)categoryListView:(KKCategoryListView *)categoryListView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:KindSectionHeader]) {
        return [[RCollectionReusableView alloc] init];
    }
    return nil;
}

- (KKCategoryListView *)categoryListView {
    if (!_categoryListView) {
        _categoryListView = [[KKCategoryListView alloc] initWithFrame:self.view.bounds style:KKCategoryCollectionViewStyle];
        _categoryListView.delegate = self;
        _categoryListView.dataSource = self;
        _categoryListView.leftTableView.rowHeight = 50;
        [_categoryListView registerClass:[KKLeftTableViewCell class] forCellReuseIdentifier:@"leftCellId" withCellRegisterType:KKCategoryListViewLeftCellRegisterType];
        [_categoryListView registerClass:[RCollectionViewCell class] forCellReuseIdentifier:@"rightCellId" withCellRegisterType:KKCategoryListViewRightCellRegisterType];
        [_categoryListView registerClass:[RCollectionReusableView class] forSupplementaryViewOfKind:KindSectionHeader withReuseIdentifier:@"headerId"];
    }
    return _categoryListView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
