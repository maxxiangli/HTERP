//
//  CStockLogSenderController.m
//  QQStock
//
//  Created by zheliang on 15/1/7.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "CStockLogSenderController.h"
#include <zlib.h>
#import "AppDelegate.h"

@protocol CPostFileRequestDelegate <NSObject>
@optional
- (void)postProgress:(NSString *)percent;
@end

@interface CPostFileRequest : CRequestCommand
{
    uLong _currentPage;
}
@property (nonatomic,assign) int errorCode;
@property (nonatomic,retain) NSString * fileName;
@property (nonatomic,retain) NSArray * fileData;
@property (nonatomic,weak) id<CRequestCommandDelegate,CPostFileRequestDelegate> postFileDelegate;
@end

@implementation CPostFileRequest

- (void)dealloc
{
    self.fileName = nil;
    self.fileData = nil;
    
}
- (id)initWithDelegate:(id<CRequestCommandDelegate,CPostFileRequestDelegate>)delegate
{
    self = [super initWithDelegate:delegate];
    if(self)
    {
        self.postFileDelegate = delegate;
        _currentPage = 0;
        self.enableLogResponseForDetectError = NO;
    }
    return self;
}

- (void)parserDataInThread:(NSData *)recvData
{
    self.errorCode = ERROR_CODE_ServerDataUnExpected;
    NSString * strData = [self getStringFromData:recvData];
    NSDictionary * dictData = [strData JSONObject];
    if(dictData && [dictData isKindOfClass:[NSDictionary class]])
    {
        self.errorCode = STOCK_PARSER_CODE_INT_VALUE([dictData valueForKey:@"code"]);
    }
}

- (BOOL)postNextPart
{
    if(_currentPage >= self.fileData.count)
    {
        return NO;
    }
    
    if([self.postFileDelegate respondsToSelector:@selector(postProgress:)])
    {
        [self.postFileDelegate performSelector:@selector(postProgress:) withObject:[NSString stringWithFormat:@"%ld%%", _currentPage*100/self.fileData.count]];
    }
    
//    NSString * uin = [NSString stringWithFormat:@"10000_%@",[MTA getMtaUDID]];
    NSString * uin = [NSString stringWithFormat:@"10000_%@",@""];
    if(GLOBEL_LOGIN_OBJECT.uin)
    {
        uin = GLOBEL_LOGIN_OBJECT.uin;
    }
    NSDateFormatter * format = [[NSDateFormatter alloc] init] ;
    [format setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString * token = [CMD5Util md5String:[NSString stringWithFormat:@"%@_hk00700_%@", uin, [format stringFromDate:[NSDate date]]]];
    NSString * fileName = [NSString stringWithFormat:@"%@_%@_%03lu",uin, self.fileName, _currentPage];
    NSData * pageData = [self.fileData objectAtIndex:_currentPage];
    _currentPage ++;
    
    [self startRequest:@"http://arenyuanv.finance.qq.com/appstock/support/LogReport/upload"
              postData:[NSDictionary dictionaryWithObjectsAndKeys:
                        uin,@"uin",
                        token,@"token",
                        fileName,@"name",
                        pageData,@"file",
                        nil]];
    
    
    return YES;
}

- (void)requestCompleteInMainThread
{
    if(0!=self.errorCode)
    {
        //服务器返回错误
        [self.postFileDelegate requestComplete:self];
        return;
    }
    
    if(![self postNextPart])
    {
        //已经发送完毕
        [self.postFileDelegate requestComplete:self];
        return;
    }
}

- (void)postFileData:(NSArray *)fileData fileName:(NSString *)fileName
{
    self.fileData = fileData;
    self.fileName = fileName;
    _currentPage = 0;
    [self postNextPart];
}

@end


@interface CStockLogSenderController ()<CRequestCommandDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) NSString *filePath;
@property (nonatomic,retain) CPostFileRequest * postRequest;
@property (nonatomic,retain) NSMutableArray * fileData;    //将文件压缩为多个小块文件
@end

@implementation CStockLogSenderController

+(void)sendFile:(NSString *)filePath
{
//    if(_shareStockLogSender != nil)
//    {
//        return;
//    }
//    _shareStockLogSender = [[CStockLogSender alloc] initWithFilePath:filePath];
//    [_shareStockLogSender comparessFile];
    CStockLogSenderController* controller = [[CStockLogSenderController alloc] initWithNibName:@"CStockLogSenderController" bundle:nil] ;
    controller.filePath = filePath;
    [SharedAPPDelegate.currentController pushViewController:controller animated:YES];
}


- (void)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) initLeftView
{
    if ((isThaniOS6)) return;
    CCustomButton *button = [CCustomButton buttonWithTitle:@"返回" style:eCustomButtonStyleLeftAngle];
    [button addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLeftView];
    [self setDisplayCustomTitleText:@"日志上报"];
    NSString * fileDate = [self.filePath lastPathComponent];
    if([fileDate length] > 8)
    {
        fileDate = [fileDate substringFromIndex:[fileDate length] - 8];
    }
    self.nameLabel.text = fileDate;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self comparessFile];
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
- (IBAction)send:(id)sender {
    [self start:sender];
}

- (void)dealloc {
    if(self.postRequest)
    {
        self.postRequest.delegate = nil;
        [self.postRequest stopRequest];
        self.postRequest = nil;
    }
    

    Safe_Release(_fileData);
    Safe_Release(_filePath);
    
    
    
    
    
    
}


- (NSData *)compressData:(NSData *)data
{
    uLongf length = [data length];
    Bytef * buffer = (Bytef *)malloc(length);
    compress(buffer, &length, data.bytes, data.length);
    NSData * retData = [NSData dataWithBytes:buffer length:length];
    free(buffer);
    return retData;
}

- (NSData *)zipData:(NSData *)srcData
{
    z_stream stream;
    memset(&stream, 0, sizeof(stream));
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)[srcData length];
    stream.next_in = (Bytef *)[srcData bytes];
    stream.total_out = 0;
    stream.avail_out = 0;
    uLong length = deflateBound(&stream, [srcData length]);
    if (deflateInit2(&stream, Z_BEST_COMPRESSION, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
    {
        NSMutableData *data = [NSMutableData dataWithLength:length];
        while (stream.avail_out == 0)
        {
            if (stream.total_out >= [data length])
            {
                data.length += length;
            }
            stream.next_out = (uint8_t *)[data mutableBytes] + stream.total_out;
            stream.avail_out = (uInt)([data length] - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        data.length = stream.total_out;
        return data;
    }
    return nil;
}

- (NSString *)reportHead
{
    NSString *appVersion = [NSString stringWithFormat:@"%@.%@", MAJOR_VERSION, MINOR_VERSION];
    NSString *model = [[CBossReporter sharedBossReporter] getDeviceType2];
    NSString *iosV = [UIDevice currentDevice].systemVersion;
//    NSString *deviceid = [MTA getMtaUDID];
    NSString *deviceid = @"";
    NSString *uin = GLOBEL_LOGIN_OBJECT.uin ? GLOBEL_LOGIN_OBJECT.uin : @"10000";
    NSString *wxuin = GLOBEL_LOGIN_OBJECT.uin ? GLOBEL_LOGIN_OBJECT.uin : @"20000";
    
    NSString *head = [NSString stringWithFormat:@"DIAG QQ%@ \n %@ %@ %@ %@ %@\n",
                      uin, deviceid, wxuin, appVersion, model, iosV];
    return head;
}

- (void)comparessFile
{
    if([[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
    {
        NSMutableData * fileData = [NSMutableData dataWithContentsOfFile:self.filePath];
        if(nil == fileData)
        {
            [self sizeLabel].text = @"读取文件失败";
            return;
        }
        
        //添加环境信息
        NSString * head = [self reportHead];
        [fileData appendBytes:[head UTF8String] length:strlen([head UTF8String])];
        
        //将文件切分为2M大小，并压缩
        NSMutableArray * fileArray = [NSMutableArray array];
        NSUInteger loc = 0;
        NSUInteger totalLength = 0;
        do{
            NSUInteger partSize = 2*1024*1024;
            
            if(loc + partSize > fileData.length)
            {
                partSize = fileData.length - loc;
            }
            NSData * partData = [fileData subdataWithRange:NSMakeRange(loc, partSize)];
            NSData * zipData = [self zipData:partData];
            if(zipData)
            {
                [fileArray addObject:zipData];
                totalLength += [zipData length];
            }
            else
            {
                break;
            }
            loc += partSize;
        }while(loc < fileData.length);
        
        if([fileArray count] > 0)
        {
            self.fileData = fileArray;
        }
        
        if(self.fileData)
        {
            self.sizeLabel.text = [NSString stringWithFormat:@"%u K", (unsigned int)totalLength/1024];
            self.statusLabel.text = [NSString stringWithFormat:@"请点击发送"];
            self.sendBtn.enabled = YES;
        }
        else
        {
            [self sizeLabel].text = [NSString stringWithFormat:@"压缩失败"];
        }
    }
    else
    {
        self.sizeLabel.text = [NSString stringWithFormat:@"文件不存在"];
    }
}
- (void)start:(UIButton *)button
{
    button.hidden = YES;
    
    [self statusLabel].text = @"发送中...";
    
    self.postRequest = [[CPostFileRequest alloc] initWithDelegate:self] ;
    [self.postRequest postFileData:self.fileData fileName:[self.filePath lastPathComponent]];
}


- (void)postProgress:(NSString *)percent
{
    [self statusLabel].text = [NSString stringWithFormat:@"发送中... %@", percent];
}

- (void)requestComplete:(CRequestCommand *)requestCommand
{
    if(self.postRequest.errorCode != 0)
    {
        [self statusLabel].text = [NSString stringWithFormat:@"发送失败：%d", self.postRequest.errorCode];
    }
    else
    {
        [self statusLabel].text = @"发送完成！";
        self.sendBtn.titleLabel.text = @"发送完成";
        self.sendBtn.enabled = NO;
    }
}

- (void)requestErrored:(CRequestCommand *)requestCommand
{
    [self statusLabel].text = @"发送失败";
}
@end
