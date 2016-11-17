//
//  CLoginVerifyViewController.m
//  HTERP
//
//  Created by li xiang on 16/11/16.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CLoginVerifyViewController.h"
#import "CLoginStateJSONRequestCommand.h"
#import "CATradeLoadingView.h"
#import "CLoginLoginParam.h"
#import "CLoginInforModel.h"
#import "CAlertWaitingViewStyleOne.h"
#import "CRegisterViewController.h"
#import "CLoginSmsCodeParam.h"
#import "IDCountDownButton.h"

@interface CLoginVerifyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;//验证码
@property (weak, nonatomic) IBOutlet IDCountDownButton *sendSmsBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation CLoginVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDisplayCustomTitleText:@"登录"];
    self.view.backgroundColor = [UIColor whiteColor];
    //圆角
    self.loginBtn.layer.cornerRadius = 8;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.borderWidth = 0.5;
    
    
    [self.phoneNumTextField addTarget:self action:@selector(phoneNumTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pswTextField addTarget:self action:@selector(pswTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
// 手机号码验证
- (BOOL)validateMobile:(NSString*)mobile
{
    // 手机号以1开头，10个 \d 数字字符
    NSString      *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate   *phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark -事件响应
- (void)phoneNumTextFieldDidChange:(id)sender
{
    if ( self.phoneNumTextField.text.length > 11 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号不能超过11位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
        
        self.phoneNumTextField.text = [self.phoneNumTextField.text substringToIndex:11];
        return;
    }
}

- (void)pswTextFieldDidChange:(id)sender
{
    if ( self.pswTextField.text.length > 6 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码不能超过6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];

        self.pswTextField.text = [self.pswTextField.text substringToIndex:6];
    }
    
}

//登录
- (IBAction)onLoginBtn:(id)sender
{
    [self.view endEditing:YES];
    
    if ( ![self validateMobile:self.phoneNumTextField.text] )
    {
        [[[UIAlertView alloc] initWithTitle:@"手机号不可用" message:@"请输入有效的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    if ( !self.pswTextField.text || !self.pswTextField.text.length )
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    CLoginLoginParam *param = [[CLoginLoginParam alloc] init];
    param.mobile = self.phoneNumTextField.text;
    param.passwd = self.pswTextField.text;
    param.checktype = 1;
    
    [CATradeLoadingView showLoadingViewAddedTo:self.view];
    __weak typeof(self) weakSelf = self;
    [CLoginStateJSONRequestCommand getWithParams:param modelClass:[CLoginInforModel class] sucess:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand) {
        //关闭loading
        [CATradeLoadingView hideLoadingViewForView:weakSelf.view];
        
        //检测数据有效性
        CLoginInforModel *model = (CLoginInforModel *)requestCommand.responseModel;
        if ( ![model isKindOfClass:[CLoginInforModel class]] )
        {
            [[[CAlertWaitingViewStyleOne alloc] initFailMessage:@"登录失败" closeAfterDelay:0.3] show];
            return;
        }
        [[[CAlertWaitingViewStyleOne alloc] initSuccessMessage:@"登录成功" closeAfterDelay:0.3] show];
        
        //保存数据
        model.uin = param.mobile;
        [GLOBEL_LOGIN_OBJECT saveLoginData:model];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand, NSError *dataParseError) {
        //关闭loading
        [CATradeLoadingView hideLoadingViewForView:weakSelf.view];
        
        CAlertWaitingViewStyleOne *alertView = [[CAlertWaitingViewStyleOne alloc] initFailMessage:@"登录失败" closeAfterDelay:0.3] ;
        [alertView show];
        
    }];
}

//注册
- (IBAction)onRegisterBtn:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"HTLogin" bundle:nil];
    CRegisterViewController *registerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"registerViewController"];
    registerViewController.isRegister = YES;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

//发送验证码
- (IBAction)onVefifyLoginBtn:(id)sender
{
    CLoginSmsCodeParam *param = [[CLoginSmsCodeParam alloc] init];
    param.mobile = self.phoneNumTextField.text;
    
    __weak typeof(self) weakSelf = self;
    [CLoginStateJSONRequestCommand getWithParams:param modelClass:[CRequestJSONModelBase class] sucess:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand) {
        //关闭loading
        [CATradeLoadingView hideLoadingViewForView:weakSelf.view];
        
        if ( 0 == code )
        {
            [[[UIAlertView alloc] initWithTitle:@"验证码发送成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
        
    } failure:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand, NSError *dataParseError) {
        
    }];
}
@end
