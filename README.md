# KKCategoryListView

[![CI Status](https://img.shields.io/travis/KKWONG1990/KKCategoryListView.svg?style=flat)](https://travis-ci.org/KKWONG1990/KKCategoryListView)
[![Version](https://img.shields.io/cocoapods/v/KKCategoryListView.svg?style=flat)](https://cocoapods.org/pods/KKCategoryListView)
[![License](https://img.shields.io/cocoapods/l/KKCategoryListView.svg?style=flat)](https://cocoapods.org/pods/KKCategoryListView)
[![Platform](https://img.shields.io/cocoapods/p/KKCategoryListView.svg?style=flat)](https://cocoapods.org/pods/KKCategoryListView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

KKCategoryListView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KKCategoryListView'
```
## Usage

导入头文件
```ruby
#import <KKCategoryListView.h>
```

遵循协议代理和数据源协议
```ruby
KKCategoryListViewDelegate, KKCategoryListViewDataSource
```

自定义cell时，继承以下几个类
```ruby
KKTableViewCell，KKCollectionViewCell，KKCollectionReusableView
```

枚举说明
```ruby
typedef NS_ENUM(NSInteger, KKCategoryListViewStyle) {
    KKCategoryTableViewStyle = 0,  //右边视图是TableView样式
    KKCategoryCollectionViewStyle  //右边类型是CollectionView样式
};

typedef NS_ENUM(NSInteger, KKCategoryListViewCellRegisterType) {
    KKCategoryListViewLeftCellRegisterType = 0,  //注册左边视图的cell
    KKCategoryListViewRightCellRegisterType      //注册右边视图的cell
};
```

使用下面两个方法注册Cell，第一个参数传Class或Nib，第二个参数传cellid字符串，第三个参数传KKCategoryListViewCellRegisterType下面的枚举类型KKCategoryListViewLeftCellRegisterType或KKCategoryListViewRightCellRegisterType，该枚举类型主要是用于区别是注册左边的cell还是右边的cell
```ruby
- (void)registerClass:(Class)cls forCellReuseIdentifier:(NSString *)identifier withCellRegisterType:(KKCategoryListViewCellRegisterType)type;

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier withCellRegisterType:(KKCategoryListViewCellRegisterType)type;
```

如果你的右边视图是CollectionView并且需要设置头部或底部视图使用以下方法注册
```ruby
- (void)registerClass:(Class)cls forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

- (void)registernib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;
```

刷新数据源，获得数据后执行刷新数据源方法用于数据绑定
```ruby
/// Reload Data When you get data
- (void)reloadRightTableViewData;

/// Reload Data When you get data
- (void)reloadLeftTableViewData;
```

数据源方法说明
```ruby

/// 每个分区有多少行
/// @param categoryListView KKCategoryListView
/// @param tableView LeftTableView , rightTableView and RightCollectionView
/// @param section Section Number
- (NSInteger)categoryListView:(KKCategoryListView * _Nullable)categoryListView tableView:(id _Nullable)tableView numberOfRowsInSection:(NSInteger)section;

/// 有多少个分区
/// @param tableView LeftTableView , rightTableView and RightCollectionView
/// @param categoryListView KKCategoryListView
- (NSInteger)numberOfSectionsInTableView:(id _Nullable)tableView CategoryListView:(KKCategoryListView *_Nullable)categoryListView;

/// 设置tableview头部分区标题
/// @param categoryListView KKCategoryListView
/// @param tableView LeftTableView , rightTableView
/// @param section section number
- (NSString *_Nullable)categoryListView:(KKCategoryListView * _Nullable)categoryListView tableView:(UITableView *_Nullable)tableView titleForHeaderInSection:(NSInteger)section;

/// 设置TableView脚部分区标题
/// @param categoryListView KKCategoryListView
/// @param tableView  LeftTableView , rightTableView
/// @param section section number
- (NSString *_Nullable)categoryListView:(KKCategoryListView * _Nullable)categoryListView tableView:(UITableView *_Nullable)tableView titleForFooterInSection:(NSInteger)section;
```

代理方法说明
```ruby
/// cell即将显示代理方法，在该代理方法中绑定你的cell数据
/// @param categoryListView KKCategoryListView
/// @param tableView LeftTableView , rightTableView and RightCollectionView
/// @param cell KKTableViewCell
/// @param indexPath NSIndexPath
- (void)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(id _Nullable )tableView willDisplayCell:(id _Nullable)cell forRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

/// 行选中代理方法
/// @param categoryListView KKCategoryListView
/// @param tableView LeftTableView , rightTableView and RightCollectionView
/// @param indexPath NSIndexPath
- (void)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(id _Nullable )tableView didSelectRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

/// 设置TableView行高代理方法
/// @param categoryListView KKCategoryListView
/// @param tableView UITableView
/// @param indexPath NSIndexPath
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView heightForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

/// 设置TableView头部分区高度
/// @param categoryListView KKCategoryListView
/// @param tableView TableView
/// @param section NSInteger
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView heightForHeaderInSection:(NSInteger)section;

/// 设置TableView尾部分区高度
/// @param categoryListView KKCategoryListView
/// @param tableView TableView
/// @param section NSInteger
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView heightForFooterInSection:(NSInteger)section;

/// 设置TableView头部分区视图
/// @param categoryListView KKCategoryListView
/// @param tableView TableView
/// @param section NSInteger
- (UIView *_Nullable)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView viewForHeaderInSection:(NSInteger)section;

/// 设置TableView尾部分区视图
/// @param categoryListView KKCategoryListView
/// @param tableView TableView
/// @param section NSInteger
- (UIView *_Nullable)categoryListView:(KKCategoryListView *_Nullable)categoryListView tableView:(UITableView *_Nullable)tableView viewForFooterInSection:(NSInteger)section;

/// 设置CollectionView item 的大小
/// @param categoryListView KKCategoryListView
/// @param indexPath NSIndexPath
- (CGSize)categoryListView:(KKCategoryListView *_Nullable)categoryListView sizeForItemAtIndexPath:(NSIndexPath * _Nullable)indexPath;

/// 设置CollectionView Layout 行间距
/// @param categoryListView KKCategoryListView
/// @param section NSInteger
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView minimumLineSpacingForSectionAtIndex:(NSInteger)section;

/// 设置CollectionView Layout item间距
/// @param categoryListView KKCategoryListView
/// @param section NSInteger
- (CGFloat)categoryListView:(KKCategoryListView *_Nullable)categoryListView minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

/// 设置CollectionView Layout Section Insert
/// @param categoryListView KKCategoryListView
/// @param section NSInteger
- (UIEdgeInsets)categoryListView:(KKCategoryListView *_Nullable)categoryListView insetForSectionAtIndex:(NSInteger)section;

/// 设置CollectionView Layout 头部分区大小
/// @param categoryListView KKCategoryListView
/// @param section section Number
- (CGSize)categoryListView:(KKCategoryListView *_Nullable)categoryListView referenceSizeForHeaderInSection:(NSInteger)section;

/// 设置CollectionView Layout 尾部分区大小
/// @param categoryListView KKCategoryListView
/// @param section section Number
- (CGSize)categoryListView:(KKCategoryListView *_Nullable)categoryListView referenceSizeForFooterInSection:(NSInteger)section;

/// 设置CollectionView ReusableView
/// @param categoryListView KKCategoryListView
/// @param kind UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
/// @param indexPath NSIndexPath
- (KKCollectionReusableView *_Nullable)categoryListView:(KKCategoryListView *_Nullable)categoryListView viewForSupplementaryElementOfKind:(NSString *_Nullable)kind atIndexPath:(NSIndexPath *_Nullable)indexPath;
```

![Alt text](https://github.com/KKWONG1990/KKCategoryListView/blob/master/KKCategoryListView.gif?raw=true)

## Author

KKWONG1990, kkwong90@163.com

## License

KKCategoryListView is available under the MIT license. See the LICENSE file for more info.
