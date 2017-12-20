//
//  ZZFDCateViewController.m
//  ZZFLEXDemo
//
//  Created by 李伯坤 on 2017/12/18.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "ZZFDCateViewController.h"
#import "UIView+ZZFLEX.h"
#import "ZZFLEXAngel.h"
#import "ZZFDCateModel.h"
#import "UIColor+ZZFD.h"

@interface ZZFDCateViewController ()

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZZFLEXAngel *tableViewAngel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZZFLEXAngel *collectionViewAngel;

@end

@implementation ZZFDCateViewController

- (void)loadView
{
    [super loadView];
    [self setTitle:@"分类"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView = self.view.addTableView(1)
    .backgroundColor([UIColor colorGrayBG])
    .showsVerticalScrollIndicator(NO)
    .tableFooterView([UIView new])
    .separatorStyle(UITableViewCellSeparatorStyleNone)
    .masonry(^ (MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(0);
        make.width.mas_equalTo(125);
    })
    .view;
    self.tableViewAngel = [[ZZFLEXAngel alloc] initWithHostView:self.tableView];

    self.collectionView = self.view.addCollectionView(2)
    .backgroundColor([UIColor whiteColor])
    .alwaysBounceVertical(YES)
    .showsVerticalScrollIndicator(NO)
    .masonry(^ (MASConstraintMaker *make) {
        make.right.bottom.top.mas_equalTo(0);
        make.left.mas_equalTo(self.tableView.mas_right);
    })
    .view;
    self.collectionViewAngel = [[ZZFLEXAngel alloc] initWithHostView:self.collectionView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    [ZZFDCateModel requestCateModelSuccess:^(NSArray<ZZFDCateModel *> *data) {
        @strongify(self);
        self.data = data;
        [self didSelectedCate:data.firstObject];
    } failure:nil];
}

- (void)setData:(NSArray *)data
{
    _data = data;
    self.tableViewAngel.clear();
    self.tableViewAngel.addSection(1001);
    @weakify(self);
    self.tableViewAngel.addCells(@"ZZFDCateMenuCell").withDataModelArray(data).toSection(1001).selectedAction(^(id item){
        @strongify(self);
        [self didSelectedCate:item];
    });
    [self.tableView reloadData];
}

- (void)didSelectedCate:(ZZFDCateModel *)cate
{
    for (ZZFDCateModel *model in self.data) {
        model.selected = model == cate;
    }
    [self.tableView reloadData];
    
    self.collectionViewAngel.clear();
    @weakify(self);
    for (int i = 0; i < cate.cateSectionItems.count; i++) {
        self.collectionViewAngel.addSection(i);
        ZZFDCateSectionModel *section = cate.cateSectionItems[i];
        self.collectionViewAngel.setHeader(@"ZZFDCateSectionView").toSection(i).withDataModel(section);
        self.collectionViewAngel.addCells(@"ZZFDCateSectionItemCell").toSection(i).withDataModelArray(section.cateSectionItems).selectedAction(^ (ZZFDCateItemModel *model) {
            @strongify(self);
            UIViewController *vc = [[UIViewController alloc] init];
            [vc.view setBackgroundColor:[UIColor whiteColor]];
            [vc setTitle:model.itemName];
            PushVC(vc);
        });
    }
    [self.collectionView reloadData];
}

@end
