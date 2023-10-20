//
//
//  CollectionViewController.h
//
//
//  Create by wesleyxiao on 2021/11/12
//  Copyright © 2021 xiaoxiang. All rights reserved.
#import "CollectionViewController.h"
#import <Masonry/Masonry.h>

@interface EmojiCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@end

@implementation EmojiCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        NSInteger aRedValue = arc4random()%255;
        NSInteger aGreenValue = arc4random()%255;
        NSInteger aBlueValue = arc4random()%255;
    
        UIColor * color = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
        
        self.contentView.backgroundColor = color;
        self.contentView.layer.cornerRadius = 20;
        self.contentView.layer.masksToBounds = YES;
        
        
         _label = [[UILabel alloc]init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:200];
        _label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.height.equalTo(self.contentView.mas_height);
            make.width.equalTo(self.contentView.mas_width);
        }];
    }
    return self;
}
@end


@interface CollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataList = @[@"🐁", @"🐂", @"🐅", @"🐇", @"🐉", @"🐍", @"🐎", @"🐏", @"🐒", @"🐓", @"🐕", @"🐖"];
  
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:[self newCustomFlowLayout]];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[EmojiCell class] forCellWithReuseIdentifier:@"EmojiCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    //update the contraints
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(self.view.mas_height);
        make.width.equalTo(self.view.mas_width);
    }];
    self.currentPage = 0;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout * layout =[self newCustomFlowLayout];
    
    [_collectionView reloadData];
    [_collectionView setCollectionViewLayout:layout];
    [_collectionView.collectionViewLayout invalidateLayout];
    
    //according current page to calculate the offsetx
    CGFloat cellWidth = self.view.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right;
    CGFloat cellPadding = layout.minimumLineSpacing;
    
    if (self.currentPage>-1) {
        CGFloat offsetX =  (self.currentPage ) * (cellWidth + cellPadding);
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self->_collectionView.collectionViewLayout invalidateLayout];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

//paging by cell | paging with one cell at a time
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat cellWidth = self.view.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right;
    CGFloat cellPadding = layout.minimumLineSpacing;
    self.currentPage = (scrollView.contentOffset.x - cellWidth / 2) / (cellWidth + cellPadding) + 1;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat cellWidth = self.view.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right;
    CGFloat cellPadding = layout.minimumLineSpacing;
    NSInteger page = (scrollView.contentOffset.x - cellWidth / 2) / (cellWidth + cellPadding) + 1;

    if (velocity.x > 0) page++;
    if (velocity.x < 0) page--;
    page = MAX(page, 0);
    
    //!!!!:此处注掉：会导致快速滑动会跨越多个cell
    NSInteger prePage = self.currentPage - 1;
    if(prePage > 0 && page < prePage){
        page = prePage;
    } else if (page > self.currentPage + 1){
        page = self.currentPage + 1;
    }
    
    self.currentPage = page;
    
    CGFloat newOffset = page * (cellWidth + cellPadding);
    targetContentOffset->x = newOffset;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCell" forIndexPath:indexPath];
    cell.label.text = self.dataList[indexPath.row];
    return cell;
}

-(UICollectionViewFlowLayout *)newCustomFlowLayout{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    return layout;
}
@end
