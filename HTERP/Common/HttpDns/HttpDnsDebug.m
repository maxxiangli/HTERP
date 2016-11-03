//
//  HttpDnsDebug.m
//  QQStock
//
//  Created by abelchen on 15/11/13.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "HttpDnsDebug.h"

#ifdef HTTP_DNS_DEBUG

@interface HttpDnsManager ()
- (HttpDnsTable*)currentDnsTable;
@end

@interface HttpDnsDebug()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) HttpDnsTable    *table;
@property (nonatomic, retain) UITableView     *recordsLisView;
@property (nonatomic, retain) UIScrollView    *scrollView;
@property (nonatomic, retain) UITextView      *logView;
@property (nonatomic, retain) NSMutableString *log;
@end

static HttpDnsDebug *sharedDebugController;

@implementation HttpDnsDebug

+ (HttpDnsDebug*)sharedDebugController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDebugController = [[HttpDnsDebug alloc] init];
    });
    return sharedDebugController;
}

- (instancetype)init {
    self = [super init];
    if(self){
        _table = [[HttpDnsManager sharedManager] currentDnsTable];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableChanged:) name:HttpDnsTableChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logChanged:) name:HttpDnsTableLogNotification object:nil];
        [self setDisplayCustomTitleText: _table.name];
        _log = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    Safe_Release(_table);
    Safe_Release(_log);
    Safe_Release(_recordsLisView);
    Safe_Release(_logView);
    Safe_Release(_scrollView);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.scrollView];
    [self.scrollView addSubview: self.recordsLisView];
    [self.scrollView addSubview: self.logView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIButton *clearButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [clearButton setTitle:@"清除日志" forState:UIControlStateNormal];
    [clearButton sizeToFit];
    [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: clearButton] ;
}

#pragma mark - Layout

- (void)refreshLogView {
    self.logView.text = self.log;
    CGSize size = [self.logView sizeThatFits:CGSizeZero];
    CGRect frame = self.logView.frame;
    if(size.width < ScreenWidth) size.width = ScreenWidth;
    frame.size.width = size.width;
    self.logView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(self.recordsLisView.frame.size.width + self.logView.frame.size.width, self.recordsLisView.frame.size.height);
}

- (void)viewDidLayoutSubviews {
    CGRect frame = self.view.bounds;
    self.scrollView.frame = frame;
    frame = self.scrollView.bounds;
    self.recordsLisView.frame = frame;
    frame.origin.x += frame.size.width;
    self.logView.frame = frame;
    [self refreshLogView];
}

#pragma mark - Notification

- (void)tableChanged:(NSNotification*)notification {
    self.table = [[HttpDnsManager sharedManager] currentDnsTable];
    [self setDisplayCustomTitleText: self.table.name];
    [self.recordsLisView reloadData];
}

- (void)logChanged:(NSNotification*)notification {
    [self.log appendFormat:@"%@\n\n", notification.object];
    [self refreshLogView];
}

#pragma mark - Delegate

- (void)clearButtonClick {
    [self.log setString: @""];
    [self refreshLogView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.table.recordsDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"debug cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"debug cell"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    NSString *host = [self.table.recordsDict.allKeys objectAtIndex: indexPath.row];
    HttpDnsRecord *record = self.table.recordsDict[host];
    cell.textLabel.text = record.host;
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ (status:%@ | TTL:%ld | remain:%ld)", record.address, record.statusString, (long)record.TTL, record.TTL + (NSInteger)record.timestamp - (NSInteger)[[NSDate date] timeIntervalSince1970]];
    return cell;
}

#pragma mark - Getter

- (UITableView *)recordsLisView {
    if(!_recordsLisView){
        _recordsLisView = [[UITableView alloc] init];
        _recordsLisView.backgroundColor = [UIColor whiteColor];
        _recordsLisView.delegate = self;
        _recordsLisView.dataSource = self;
        _recordsLisView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _recordsLisView;
}

- (UITextView *)logView {
    if(!_logView){
        _logView = [[UITextView alloc] init];
        _logView.backgroundColor = RGB(16, 16, 16);
        _logView.textColor = [UIColor whiteColor];
        _logView.editable = NO;
    }
    return _logView;
}

- (UIScrollView *)scrollView {
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end

#endif
