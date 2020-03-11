//
//  KKCategoryListView.m
//  KKCategoryList
//
//  Created by KKWONG on 2020/2/25.
//  Copyright © 2020 KKWONG. All rights reserved.
//

#import "KKCategoryListView.h"

@interface KKCategoryListView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *leftTableViewDataSource;
@property (nonatomic, assign, getter=isDragging) BOOL dragging;
@property (nonatomic, assign, getter=isDraggingUp) BOOL draggingUp;
@property (nonatomic, assign, getter=isDraggingDown) BOOL draggingDown;
@property (nonatomic, assign) CGFloat contentOffsetY;
@end

NSString *KindSectionHeader = @"UICollectionElementKindSectionHeader";
NSString *KindSectionFooter = @"UICollectionElementKindSectionFooter";

@implementation KKCategoryListView {
    CGSize _screenSize;
    /*Left TableView Cell Id*/
    NSString *_leftCellId;
    /*right TableView Cell Id*/
    NSString *_rightCellId;
    /*collectionView 分区头部类型*/
    NSString *_kindSectionHeader;
    /*collectionView 分区尾部类型*/
    NSString *_kindSectionFooter;
    /*collectionView 分区头部ID*/
    NSString *_headerReuseIdentifier;
    /*collectionView 分区尾部ID*/
    NSString *_footerReuseIdentifier;
}

- (instancetype)initWithFrame:(CGRect)frame style:(KKCategoryListViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetup];
        _style = style;
        [self addSubview:self.leftTableView];
        _style == KKCategoryTableViewStyle ? [self addSubview:self.rightTableView] : [self addSubview:self.rightCollectionView];
    }
    return self;
}

+ (instancetype)categoryListViewWithFrame:(CGRect)frame style:(KKCategoryListViewStyle)style {
    return [[self alloc] initWithFrame:frame style:style];
}

- (void)initSetup {
    self.style = KKCategoryTableViewStyle;
    self.leftTableViewWidth = 100;
    _screenSize = [UIScreen mainScreen].bounds.size;
    self.leftTableViewCellNormalBgColor = UIColor.whiteColor;
    self.leftTableViewCellSelectBgColor = UIColor.lightGrayColor;
    self.leftTableViewCellTextSelectColor = UIColor.whiteColor;
    self.leftTableViewCellTextNormalColor = UIColor.blackColor;
    self.itemNumerOfRowInCollection = 2;
    self.selectedIndex = 0;
    self.followScroll = YES;
    self.dragging = NO;
    self.contentOffsetY = 0;
    self.draggingUp = NO;
    self.draggingDown = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftTableView.frame = CGRectMake(0, 0, self.leftTableViewWidth, self.frame.size.height);
    if (self.style == KKCategoryTableViewStyle) {
        self.rightTableView.frame = CGRectMake(self.leftTableViewWidth, 0, _screenSize.width - self.leftTableViewWidth, self.frame.size.height);
    } else {
        self.rightCollectionView.frame = CGRectMake(self.leftTableViewWidth, 0, _screenSize.width - self.leftTableViewWidth, self.frame.size.height);
    }
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:CategoryListView:)]) {
        return [self.dataSource numberOfSectionsInTableView:tableView CategoryListView:self];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(categoryListView:tableView:numberOfRowsInSection:)]) {
        return [self.dataSource categoryListView:self tableView:tableView numberOfRowsInSection:section];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKTableViewCell *cell;
    if (tableView == self.leftTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:_leftCellId];
        if (!cell) {
            cell = [[KKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_leftCellId];
        }
        cell.normalBgColor   = self.leftTableViewCellNormalBgColor;
        cell.selectBgColor   = self.leftTableViewCellSelectBgColor;
        cell.textNormalColor = self.leftTableViewCellTextNormalColor;
        cell.textSelectColor = self.leftTableViewCellTextSelectColor;
        if (indexPath.row == self.selectedIndex) {
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:indexPath.section] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:_rightCellId];
        if (!cell) {
            cell = [[KKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_rightCellId];
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(categoryListView:tableView:titleForHeaderInSection:)]) {
        return [self.dataSource categoryListView:self tableView:tableView titleForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(categoryListView:tableView:titleForFooterInSection:)]) {
        return [self.dataSource categoryListView:self tableView:tableView titleForFooterInSection:section];
    }
    return nil;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate categoryListView:self tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
   if (tableView == self.rightTableView) {
        if (self.followScroll) {
            if (self.isDragging && self.isDraggingDown) {
                self.selectedIndex = section;
                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (tableView == self.rightTableView) {
        if (self.followScroll) {
            if (self.isDragging && self.isDraggingUp) {
                self.selectedIndex = section + 1;
                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        if (indexPath.row != self.selectedIndex) {
            self.selectedIndex = indexPath.row;
            if (self.followScroll) {
                if (self.style == KKCategoryTableViewStyle) {
                    [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectedIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } else {
                    [self.rightCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectedIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:didSelectRowAtIndexPath:)]) {
                   [self.delegate categoryListView:self tableView:tableView didSelectRowAtIndexPath:indexPath];
                       
           }
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:didSelectRowAtIndexPath:)]) {
            [self.delegate categoryListView:self tableView:tableView didSelectRowAtIndexPath:indexPath];
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate categoryListView:self tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return tableView == self.leftTableView ? self.leftTableView.rowHeight : self.rightTableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:heightForHeaderInSection:)]) {
        return [self.delegate categoryListView:self tableView:tableView heightForHeaderInSection:section];
    }
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:heightForFooterInSection:)]) {
        return [self.delegate categoryListView:self tableView:tableView heightForFooterInSection:section];
    }
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:viewForHeaderInSection:)]) {
        return [self.delegate categoryListView:self tableView:self.rightTableView viewForHeaderInSection:section] ? [self.delegate categoryListView:self tableView:tableView viewForHeaderInSection:section] : [[UIView alloc] init];
    }
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:viewForFooterInSection:)]) {
        return [self.delegate categoryListView:self tableView:tableView viewForFooterInSection:section] ? [self.delegate categoryListView:self tableView:tableView viewForFooterInSection:section] : [[UIView alloc] init];
    }
    return [[UIView alloc] init];
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:CategoryListView:)]) {
        return [self.dataSource numberOfSectionsInTableView:collectionView CategoryListView:self];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(categoryListView:tableView:numberOfRowsInSection:)]) {
        return [self.dataSource categoryListView:self tableView:collectionView numberOfRowsInSection:section];
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_rightCellId forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    KKCollectionReusableView *reusableView;
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
       reusableView =  [self.delegate categoryListView:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    if ([kind isEqualToString:_kindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:_kindSectionHeader withReuseIdentifier:_headerReuseIdentifier forIndexPath:indexPath];
    } else {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:_kindSectionFooter withReuseIdentifier:_footerReuseIdentifier forIndexPath:indexPath];
    }
    return reusableView;
}
#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate categoryListView:self tableView:collectionView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:KindSectionHeader]) {
        if (self.followScroll) {
            if (self.isDragging && self.isDraggingDown) {
                self.selectedIndex = indexPath.section;
                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:KindSectionHeader]) {
        if (self.followScroll) {
            if (self.isDragging && self.isDraggingUp) {
                self.selectedIndex = indexPath.section;
                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate categoryListView:self tableView:collectionView didSelectRowAtIndexPath:indexPath];
        self.selectedIndex = indexPath.row;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:sizeForItemAtIndexPath:)]) {
          CGSize size = [self.delegate categoryListView:self sizeForItemAtIndexPath:indexPath];
       return CGSizeMake(self.rightCollectionView.frame.size.width / self.itemNumerOfRowInCollection, size.height);
      }
    return self.layout.itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:insetForSectionAtIndex:)]) {
        return [self.delegate categoryListView:self insetForSectionAtIndex:section];
    }
    return self.layout.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:minimumLineSpacingForSectionAtIndex:)]) {
       return [self.delegate categoryListView:self minimumLineSpacingForSectionAtIndex:section];
    }
    return self.layout.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:minimumInteritemSpacingForSectionAtIndex:)]) {
       return [self.delegate categoryListView:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return self.layout.minimumInteritemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:referenceSizeForHeaderInSection:)]) {
       return [self.delegate categoryListView:self referenceSizeForHeaderInSection:section];
    }
    return self.layout.headerReferenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:referenceSizeForFooterInSection:)]) {
       return [self.delegate categoryListView:self referenceSizeForFooterInSection:section];
    }
    return self.layout.footerReferenceSize;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.dragging = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.style == KKCategoryTableViewStyle) {
        if (scrollView == self.rightTableView) {
            [self changeDragginStateWithScrollView:scrollView];
        }
    } else {
        [self changeDragginStateWithScrollView:scrollView];
    }
}

#pragma mark - Private Methonds
- (void)changeDragginStateWithScrollView:(UIScrollView *)scrollView {
    if (self.isDragging) {
        if (self.contentOffsetY <= scrollView.contentOffset.y) {
            self.contentOffsetY = scrollView.contentOffset.y;
            self.draggingUp = YES;
            self.draggingDown = NO;
        } else {
            self.contentOffsetY = scrollView.contentOffset.y;
            self.draggingUp = NO;
            self.draggingDown = YES;
        }
    }
}

- (void)reloadLeftTableViewData {
    [self.leftTableView reloadData];
}

- (void)reloadRightTableViewData {
    if (self.style == KKCategoryTableViewStyle) {
        [self.rightTableView reloadData];
    } else {
        [self.rightCollectionView reloadData];
    }
}

#pragma setter / getter
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.showsHorizontalScrollIndicator = NO;
    }
    return _rightTableView;
}

- (UICollectionView *)rightCollectionView {
    if (!_rightCollectionView) {
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.backgroundColor = UIColor.whiteColor;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _rightCollectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (void)setStyle:(KKCategoryListViewStyle)style {
    _style = style;
}

- (void)setLeftTableViewCellNormalBgColor:(UIColor *)leftTableViewCellNormalBgColor {
    _leftTableViewCellNormalBgColor = leftTableViewCellNormalBgColor;
}

- (void)setLeftTableViewCellSelectBgColor:(UIColor *)leftTableViewCellSelectBgColor {
    _leftTableViewCellSelectBgColor = leftTableViewCellSelectBgColor;
}

- (void)setLeftTableViewCellTextNormalColor:(UIColor *)leftTableViewCellTextNormalColor {
    _leftTableViewCellTextNormalColor = leftTableViewCellTextNormalColor;
}

- (void)setLeftTableViewCellTextSelectColor:(UIColor *)leftTableViewCellTextSelectColor {
    _leftTableViewCellTextSelectColor = leftTableViewCellTextSelectColor;
}

- (void)setItemNumerOfRowInCollection:(NSInteger)itemNumerOfRowInCollection {
    _itemNumerOfRowInCollection = itemNumerOfRowInCollection;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
}

- (void)setFollowScroll:(BOOL)followScroll {
    _followScroll = followScroll;
}

- (void)registerClass:(Class)cls forCellReuseIdentifier:(NSString *)identifier withCellRegisterType:(KKCategoryListViewCellRegisterType)type {
    if (self.style == KKCategoryTableViewStyle) {
        if (type == KKCategoryListViewLeftCellRegisterType) {
            _leftCellId = identifier;
            [self.leftTableView registerClass:cls forCellReuseIdentifier:identifier];
        } else {
            _rightCellId = identifier;
            [self.rightTableView registerClass:cls forCellReuseIdentifier:identifier];
        }
    } else {
        if (type == KKCategoryListViewLeftCellRegisterType) {
            _leftCellId = identifier;
           [self.leftTableView registerClass:cls forCellReuseIdentifier:identifier];
        } else {
            _rightCellId = identifier;
            [self.rightCollectionView registerClass:cls forCellWithReuseIdentifier:identifier];
        }
    }
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier withCellRegisterType:(KKCategoryListViewCellRegisterType)type {
    if (self.style == KKCategoryTableViewStyle) {
        if (type == KKCategoryListViewLeftCellRegisterType) {
            _leftCellId = identifier;
            [self.leftTableView registerNib:nib forCellReuseIdentifier:identifier];
        } else {
            _rightCellId = identifier;
            [self.rightTableView registerNib:nib forCellReuseIdentifier:identifier];
        }
    } else {
        _rightCellId = identifier;
        [self.rightCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    }
}

- (void)registernib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    [self.rightCollectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
    if ([kind isEqualToString:KindSectionHeader]) {
        _kindSectionHeader = kind;
        _headerReuseIdentifier = identifier;
    } else {
        _kindSectionFooter = kind;
        _footerReuseIdentifier = identifier;
    }
}

- (void)registerClass:(Class)cls forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    [self.rightCollectionView registerClass:cls forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
    if ([kind isEqualToString:KindSectionHeader]) {
           _kindSectionHeader = kind;
           _headerReuseIdentifier = identifier;
       } else {
           _kindSectionFooter = kind;
           _footerReuseIdentifier = identifier;
       }
    
}
@end
