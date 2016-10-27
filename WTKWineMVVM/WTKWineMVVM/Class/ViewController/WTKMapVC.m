//
//  WTKMapVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKMapVC.h"
#import "WTKMapViewModel.h"
#import "WTKMapManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface WTKMapVC ()<UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate,BMKMapViewDelegate>

@property(nonatomic,strong)WTKMapViewModel          *viewModel;

///搜索结果
@property(nonatomic,strong)UITableView              *tableView;

@property(nonatomic,strong)BMKMapView               *mapView;

///周边检索
@property(nonatomic,strong)BMKPoiSearch             *searcher;

@property(nonatomic,strong)NSArray<BMKPoiInfo *>    *dataArray;



@end

@implementation WTKMapVC
@dynamic viewModel;
#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _searcher.delegate = nil;
    self.mapView.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self bindViewModel];
    [self initView];
    [self startPoi];
}
- (void)bindViewModel
{
    [super bindViewModel];
    
}

- (void)initView
{
    [self.view addSubview:self.tableView];
    self.tableView.dataSource       = self;
    self.tableView.delegate         = self;
    if (CURRENT_USER.currentAddress)
    {
        double lng = [CURRENT_USER.currentAddress[@"lng"] doubleValue];
        double lat = [CURRENT_USER.currentAddress[@"lat"] doubleValue];
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lng) animated:YES];
    }
//    self.mapView.userTrackingMode   = BMKUserTrackingModeFollow;
//    self.mapView.showsUserLocation  = YES;
//    self.mapView.showMapScaleBar    = YES;
//    [self.view addSubview:self.mapView];
    
    
}
///发起检索
- (void)startPoi
{
    self.searcher.delegate          = self;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageCapacity = 20;
    if (CURRENT_USER.currentAddress)
    {
        double lng = [CURRENT_USER.currentAddress[@"lng"] doubleValue];
        double lat = [CURRENT_USER.currentAddress[@"lat"] doubleValue];
        option.location = CLLocationCoordinate2DMake(lat, lng);
    }
    option.keyword = @"小区";
    BOOL flag = [self.searcher poiSearchNearBy:option];
    if (flag)
    {
        NSLog(@"发起周边检索成功");
    }
    else
    {
        NSLog(@"发起周边检索失败");
    }
}
#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont wtkNormalFont:14];
        cell.textLabel.textColor = WTKCOLOR(80, 80, 80, 1);
        cell.detailTextLabel.textColor = WTKCOLOR(120, 120, 120, 1);
    }
    BMKPoiInfo *poitInfo = self.dataArray[indexPath.row];
    cell.textLabel.text = poitInfo.name;
    cell.detailTextLabel.text = poitInfo.address;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark - poiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    if(errorCode == BMK_SEARCH_NO_ERROR)
    {
//      检索成功
        NSArray *array = poiResult.poiInfoList;
        self.dataArray = array;
        [self.tableView reloadData];
        for (BMKPoiInfo *obj in array)
        {
            NSLog(@"%@",obj.name);
        }
    }
}

- (BMKPoiSearch *)searcher
{
    if (!_searcher)
    {
        _searcher = [[BMKPoiSearch alloc]init];
    }
    return _searcher;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + (kHeight - 64) / 2.0, kWidth, (kHeight - 64) / 2.0) style:UITableViewStylePlain];
    }
    return _tableView;
}
- (NSArray<BMKPoiInfo *> *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[];
    }
    return _dataArray;
}
//- (BMKMapView *)mapView
//{
//    if (!_mapView)
//    {
//        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, kWidth, (kHeight - 64) / 2.0)];
//    }
//    return _mapView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
