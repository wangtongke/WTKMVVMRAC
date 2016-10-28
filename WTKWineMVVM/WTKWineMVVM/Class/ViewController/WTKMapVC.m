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
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "WTKMapSearchTableView.h"

@interface WTKMapVC ()<UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,UISearchBarDelegate>

@property(nonatomic,strong)WTKMapViewModel          *viewModel;

///搜索结果
@property(nonatomic,strong)UITableView              *tableView;

///搜索框tableView
@property(nonatomic,strong)WTKMapSearchTableView    *searchTableView;

@property(nonatomic,strong)BMKMapView               *mapView;
///正向地理编码
@property(nonatomic,strong)BMKGeoCodeSearch         *geoCodeSearch;

@property (nonatomic,strong)BMKReverseGeoCodeOption *reverseGeoCodeOption;
///周边检索
@property(nonatomic,strong)BMKPoiSearch             *searcher;

@property(nonatomic,strong)BMKCitySearchOption      *citySearch;

@property(nonatomic,strong)NSArray<BMKPoiInfo *>    *dataArray;

@property(nonatomic,strong)UISearchBar              *searchBar;

///判断当前结果是搜索还是拖动地图
@property(nonatomic,assign)BOOL                     isSearch;

@property(nonatomic,strong)NSArray<BMKPoiInfo *>    *searchArray;





@end

@implementation WTKMapVC
@dynamic viewModel;
#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    self.geoCodeSearch.delegate = self;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _searcher.delegate = nil;
    self.mapView.delegate = nil;
    self.geoCodeSearch.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self bindViewModel];
    [self initView];
    [self resetNavi];
    if (CURRENT_USER.currentAddress)
    {
        double lng = [CURRENT_USER.currentAddress[@"lng"] doubleValue];
        double lat = [CURRENT_USER.currentAddress[@"lat"] doubleValue];
        [self startPoi:lng lat:lat];
    }

}
- (void)bindViewModel
{
    [super bindViewModel];
    
}
///导航栏
- (void)resetNavi
{
    self.searchBar.barStyle         = UISearchBarStyleDefault;
//    self.searchBar.tintColor        = WTKCOLOR(70, 70, 70, 1);
    self.searchBar.delegate         = self;
    self.searchBar.placeholder      = @"请输入地址";
    _searchBar.layer.cornerRadius   = 5;
    _searchBar.layer.masksToBounds  = YES;
    _searchBar.layer.borderColor    = WTKCOLOR(200, 200, 200, 1).CGColor;
    _searchBar.layer.borderWidth    = 0.5;
    UIView *bgView                  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth - 60, 44)];
    self.navigationItem.titleView   = bgView;
    [bgView addSubview:self.searchBar];
    
}

- (void)initView
{
//    移除右滑返回手势（与百度地图冲突）
    for (UIGestureRecognizer *gesture in [self.view gestureRecognizers])
    {
        [self.view removeGestureRecognizer:gesture];
    }
    
    [self.view addSubview:self.tableView];
    self.tableView.dataSource       = self;
    self.tableView.delegate         = self;
    
    self.mapView.userTrackingMode   = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation  = YES;
    self.mapView.showMapScaleBar    = YES;
    [self.view addSubview:self.mapView];
    if (CURRENT_USER.currentAddress)
    {
        double lng = [CURRENT_USER.currentAddress[@"lng"] doubleValue];
        double lat = [CURRENT_USER.currentAddress[@"lat"] doubleValue];
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lng) animated:YES];
        [self setMapRangeWithLat:lat lng:lng];
    }

    
    ///添加中心点
    UIImageView *locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"w_map_Center"]];
    locationImageView.frame = CGRectMake( kWidth/ 2 - 15,(kHeight - 64) / 4 + 16, 30, 38);
    [self.view addSubview:locationImageView];
}

- (void)setMapRangeWithLat:(double)lat lng:(double)lng
{
    CLLocationCoordinate2D latlng = CLLocationCoordinate2DMake(lat, lng);
    BMKCoordinateSpan span = (BMKCoordinateSpan){0.02f,0.02f};
    BMKCoordinateRegion viewRegion = (BMKCoordinateRegion){latlng,span} ;
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    //用户位置类
    BMKLocationViewDisplayParam* param = [[BMKLocationViewDisplayParam alloc] init];
    param.locationViewOffsetY = 0;//偏移量
    param.locationViewOffsetX = 0;
    param.isAccuracyCircleShow = YES;//设置是否显示定位的那个精度圈
    param.isRotateAngleValid = NO;
    [self.mapView updateLocationViewWithParam:param];
}

///发起检索
- (void)startPoi:(double)lng lat:(double)lat
{
    self.searcher.delegate          = self;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageCapacity = 20;
    option.location = CLLocationCoordinate2DMake(lat, lng);

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

#pragma mark - mapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    double lat = mapView.centerCoordinate.latitude;
    double lng = mapView.centerCoordinate.longitude;
    [self startPoi:lng lat:lat];
    
//    屏幕坐标转地图经纬度
//    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapView.center toCoordinateFromView:_mapView];
//    
//    self.reverseGeoCodeOption.reverseGeoPoint = CLLocationCoordinate2DMake(MapCoordinate.latitude, MapCoordinate.longitude);
//    [self.geoCodeSearch reverseGeoCode:self.reverseGeoCodeOption];
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"12312312");
}
#pragma mark - poiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    if(errorCode == BMK_SEARCH_NO_ERROR)
    {
        //      检索成功
        NSArray *array = poiResult.poiInfoList;
        if (self.isSearch)
        {
            self.searchTableView.searchArray = array;
            [self.searchTableView reloadData];
        }
        else
        {
            self.dataArray = array;
            [self.tableView reloadData];
        }
    }
    self.isSearch = NO;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    [self.viewModel.cellClick execute:self.dataArray[indexPath.row]];
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

#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    开始检索
    if (searchText.length > 0)
    {
        self.isSearch = YES;
        self.citySearch.city = CURRENT_USER.city;
        self.citySearch.keyword = searchText;
        self.citySearch.pageIndex = 0;
        self.citySearch.pageCapacity = 20;
        BOOL flag = [self.searcher poiSearchInCity:self.citySearch];
        if (flag)
        {
            NSLog(@"周边检索成功");
        }
        else
        {
            NSLog(@"周边检索失败");
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.view addSubview:self.searchTableView];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.searchTableView removeFromSuperview];
    [searchBar resignFirstResponder];
}



#pragma mark - lazyLoad
- (BMKCitySearchOption *)citySearch
{
    if (!_citySearch)
    {
        _citySearch = [[BMKCitySearchOption alloc]init];
    }
    return _citySearch;
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
- (WTKMapSearchTableView *)searchTableView
{
    if (!_searchTableView)
    {
        _searchTableView = [[WTKMapSearchTableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64) style:UITableViewStylePlain];
        _searchTableView.viewModel = self.viewModel;
    }
    return _searchTableView;
}
- (NSArray<BMKPoiInfo *> *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[];
    }
    return _dataArray;
}
- (NSArray<BMKPoiInfo *> *)searchArray
{
    if (!_searchArray)
    {
        _searchArray = @[];
    }
    return _searchArray;
}
- (BMKMapView *)mapView
{
    if (!_mapView)
    {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, kWidth, (kHeight - 64) / 2.0)];
    }
    return _mapView;
}
- (BMKGeoCodeSearch *)geoCodeSearch
{
    if (!_geoCodeSearch)
    {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    }
    return _geoCodeSearch;
}
- (BMKReverseGeoCodeOption *)reverseGeoCodeOption
{
    if (!_reverseGeoCodeOption)
    {
        _reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc]init];
    }
    return _reverseGeoCodeOption;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(1, 8, kWidth - 62, 28)];
    }
    return _searchBar;
}

- (void)dealloc
{
    self.mapView = nil;
    self.searcher = nil;
    self.geoCodeSearch = nil;
}


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
