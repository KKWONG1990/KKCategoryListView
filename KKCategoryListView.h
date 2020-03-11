//
//  KKCategoryListView.h
//  KKCategoryList
//
//  Created by KKWONG on 2020/2/25.
//  Copyright © 2020 KKWONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKTableViewCell.h"
#import "KKCollectionViewCell.h"
#import "KKCollectionReusableView.h"
@class KKCategoryListView;
UIKIT_EXTERN NSString * _Nonnull KindSectionHeader;
UIKIT_EXTERN NSString * _Nonnull KindSectionFooter;

typedef NS_ENUM(NSInteger, KKCategoryListViewStyle) {
    KKCategoryTableViewStyle = 0,  //RightView is TableView Style
    KKCategoryCollectionViewStyle  //RightView is CollectionView Style
};

typedef NS_ENUM(NSInteger, KKCategoryListViewCellRegisterType) {
    KKCategoryListViewLeftCellRegisterType = 0,  //Register Left TableView Cell Type
    KKCategoryListViewRightCellRegisterType      //Register Right TableView Cell Type
};

@protocol KKCategoryListViewDataSource <NSObject>
/// Numbser Of Rows In Section By LeftTableView , rightTableView and RightCollectionView
/// @param categoryListView KKCategoryListView
/// @param tableView LeftTableView , rightTableView and RightCollectionView
/// @param section Section Number
- (NSInteger)categoryListView:(KKCategoryListView * _Nullable)categoryListView tableView:(id _Nullable)tableView numberOfRowsInSection:(NSInteger)section;

@optional
/// Number Of Sections In LeftTableView , rightTableView and RightCollectionView
/// @param tableView LeftTableView , rightTableView and RightCollectionView
/// @param categoryListView KKCategoryListView
- (NSInteger)numberOfSectionsInTableView:(id _Nullable)tableView CategoryListView:(KKCategoryListView *_Nullable)categoryListView;

/// Set Title For Header In TableView
/// @param categoryListView KKCategoryListView
/// @param tableView LeftTableView , rightTableView
/// @param section section number
- (NSString *_Nullable)categoryListView:(KKCategoryListView * _Nullable)categoryListView tableView:(UITableView *_Nullable)tableView titleForHeaderInSection:(NSInteger)section;

/// Set Title For Footer In TableView
/// @param categoryListView KKCategoryListView
/// @param tableView  LeftTableView , rightTableView
/// @param section section number
- (NSString *_Nullable)categoryListView:(KKCategoryListView * _Nullable)categoryListView tableView:(UITableView *_Nullable)tableView titleForFooterInSection:(NSInteger)section;
@end

@protocol KKCategoryListViewDelegate <NSObject>

/// Set TableView willDisplayCell For Binding Data
/// @param categoryListView KKCategoryListView
/// @param tableView LeftTableView , rightTableView and RightCollectionView
/// @param cell KKTableViewCell
/// @param indexPath NSIndexPath
- (void)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(id _Nullable )tableView willDisplayCell:(id _Nullable)cell forRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;
@optional

/// Set TableVeiw Didselect Row
/// @param categoryListView KKCategoryListView
/// @param tableView LeftTableView , rightTableView and RightCollectionView
/// @param indexPath NSIndexPath
- (void)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(id _Nullable )tableView didSelectRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

/// Set TableView Row Height
/// @param categoryListView KKCategoryListView
/// @param tableView UITableView
/// @param indexPath NSIndexPath
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView heightForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

/// Set TableView Header Section Height
/// @param categoryListView KKCategoryListView
/// @param tableView TableView
/// @param section NSInteger
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView heightForHeaderInSection:(NSInteger)section;

/// Set TableView Footer Section Height
/// @param categoryListView KKCategoryListView
/// @param tableView TableView
/// @param section NSInteger
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView heightForFooterInSection:(NSInteger)section;

/// Set TableView Header Section View
/// @param categoryListView KKCategoryListView
/// @param tableView TableView
/// @param section NSInteger
- (UIView *_Nullable)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView viewForHeaderInSection:(NSInteger)section;

/// Set TableView Footer Section View
/// @param categoryListView KKCategoryListView
/// @param tableView TableView
/// @param section NSInteger
- (UIView *_Nullable)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView viewForFooterInSection:(NSInteger)section;

/// Set CollectionView Layout Item Size
/// @param categoryListView KKCategoryListView
/// @param indexPath NSIndexPath
- (CGSize)categoryListView:(KKCategoryListView *_Nullable)categoryListView sizeForItemAtIndexPath:(NSIndexPath * _Nullable)indexPath;

/// Set CollectionView Layout minimumLineSpacingForSection
/// @param categoryListView KKCategoryListView
/// @param section NSInteger
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView minimumLineSpacingForSectionAtIndex:(NSInteger)section;

/// Set CollectionView Layout MinimunInteriItemSpacing For Section
/// @param categoryListView KKCategoryListView
/// @param section NSInteger
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

/// Set CollectionView Layout Section Insert
/// @param categoryListView KKCategoryListView
/// @param section NSInteger
- (UIEdgeInsets)categoryListView:(KKCategoryListView *_Nullable)categoryListView insetForSectionAtIndex:(NSInteger)section;

/// Set CollectionView Layout Section Header Size
/// @param categoryListView KKCategoryListView
/// @param section section Number
- (CGSize)categoryListView:(KKCategoryListView *_Nullable)categoryListView referenceSizeForHeaderInSection:(NSInteger)section;

/// Set CollectionView Layout section Footer Size
/// @param categoryListView KKCategoryListView
/// @param section section Number
- (CGSize)categoryListView:(KKCategoryListView *_Nullable)categoryListView referenceSizeForFooterInSection:(NSInteger)section;

/// Set CollectionView ReusableView
/// @param categoryListView KKCategoryListView
/// @param kind UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
/// @param indexPath NSIndexPath
- (KKCollectionReusableView *_Nullable)categoryListView:(KKCategoryListView *_Nullable)categoryListView viewForSupplementaryElementOfKind:(NSString *_Nullable)kind atIndexPath:(NSIndexPath *_Nullable)indexPath;
@end

NS_ASSUME_NONNULL_BEGIN

@interface KKCategoryListView : UIView

/// Init Methond
/// @param frame CGRect
/// @param style KKCategoryListViewStyle
- (instancetype)initWithFrame:(CGRect)frame style:(KKCategoryListViewStyle)style;

/// Class Methond
/// @param frame CGRect
/// @param style KKCategoryListViewStyle
+ (instancetype)categoryListViewWithFrame:(CGRect)frame style:(KKCategoryListViewStyle)style;

/// View Style
@property (nonatomic, assign) KKCategoryListViewStyle style;

/// View Delegate
@property (nonatomic, weak) id<KKCategoryListViewDelegate> delegate;

/// View DataSource
@property (nonatomic, weak) id<KKCategoryListViewDataSource> dataSource;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
/// Left TableView Width
@property (nonatomic) CGFloat leftTableViewWidth;

/// Left TableView Cell Normal BackGround Color;
@property (nonatomic, strong) UIColor *leftTableViewCellNormalBgColor;

/// Left TableView Cell Select BackGround Color
@property (nonatomic, strong) UIColor *leftTableViewCellSelectBgColor;

/// Left TableView Cell Text Normal Color
@property (nonatomic, strong) UIColor *leftTableViewCellTextNormalColor;

/// Left TableView Cell Text Select Color
@property (nonatomic, strong) UIColor *leftTableViewCellTextSelectColor;

/// The left tableview selectedIndex, default 0
@property (nonatomic, assign) NSInteger selectedIndex;

/// The Left TableView Follow and Change Selecte State By The Right TableView Scroll, If Set Yes, The Right TableView or CollectionView Have To One and more sections - Default No
@property (nonatomic, assign, getter=isFollowScroll) BOOL followScroll;

/// How Many Item Of Row in CollectionView
@property (nonatomic) NSInteger itemNumerOfRowInCollection;

/// Reload Data When you get data
- (void)reloadRightTableViewData;

/// Reload Data When you get data
- (void)reloadLeftTableViewData;

/// Register TableView or Collection Cell for Class
/// @param cls Cell Class
/// @param identifier Cell ID
/// @param type KKCategoryListViewCellRegisterType
- (void)registerClass:(Class)cls forCellReuseIdentifier:(NSString *)identifier withCellRegisterType:(KKCategoryListViewCellRegisterType)type;

/// Register TableView or Collection Cell for Nib
/// @param nib Cell Nib
/// @param identifier Cell ID
/// @param type KKCategoryListViewCellRegisterType
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier withCellRegisterType:(KKCategoryListViewCellRegisterType)type;

/// Register CollectionView's header or footer View For Class
/// @param cls View Class
/// @param kind UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
/// @param identifier View ID
- (void)registerClass:(Class)cls forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

/// Register CollectionView's header or footer View For Nib
/// @param nib View Class
/// @param kind UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
/// @param identifier View ID
- (void)registernib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
