//
//  CBossReporter.h
//  QQStock
//
//  Created by suning wang on 12-2-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CURLDataLoader.h"
//#import "CTimeRecord.h"
#import "CRequestCommand.h"

enum 
{
	eRepTypeTabZiXuan = 0,						//自选Tab点击次数				// barretzhang CCustomTabbarController.m
	eRepTypeTabNews = 1,						//新闻Tab点击次数				// barretzhang CCustomTabbarController.m
	eRepTypeTabHangqing = 2,					//行情Tab点击次数				// barretzhang CCustomTabbarController.m
	eRepTypeListZixuanQiehuan = 3,				//自选列表切换数据次数			// barretzhang CMyView.m
	eRepTypeListZixuanSort = 4,					//自选列表排序点击次数			// barretzhang CMyView.m
	
	eRepTypeListNewsTabYaowen = 5,				//新闻要闻Tab点击次数			// sonywang  CNewsViewController.m
	eRepTypeListNewsTabZixuan = 6,				//新闻自选Tab点击次数			// sonywang  CNewsViewController.m
	eRepTypeListNewsTabHushen = 7,				//新闻沪深Tab点击次数			// sonywang  CNewsViewController.m
	eRepTypeListNewsTabGanggu = 8,				//新闻港股Tab点击次数			// sonywang  CNewsViewController.m
	eRepTypeListNewsTabQuanqiu = 9,				//新闻全球Tab点击次数			// sonywang  CNewsViewController.m
	
	eRepTypeListNewsYaowen = 10,				//新闻要闻页点击文章次数			// sonywang CNewsListView.m
	eRepTypeListNewsZixuan = 11,				//新闻自选页点击文章次数			// sonywang CNewsListViewForStocks.m
	eRepTypeListNewsHushen = 12,				//新闻沪深页点击文章次数			// sonywang CNewsListView.m
	eRepTypeListNewsGanggu = 13,				//新闻港股页点击文章次数			// sonywang CNewsListView.m
	eRepTypeListNewsQuanqiu = 14,				//新闻全球页点击文章次数			// sonywang CNewsListView.m
	
	eRepTypeListNewsReadedNoNet = 15,			//离线状态下阅读新闻数量			// sonywang CNewsListView.m/CNewsListViewForStocks.m
	
	eRepTypeListHangqingTabHushen = 16,			//行情沪深Tab点击次数			// barretzhang CMarketView.m
	eRepTypeListHangqingTabGanggu = 17,			//行情港股Tab点击次数			// barretzhang CMarketView.m
	eRepTypeListHangqingTabHuanqiu = 18,		//行情环球Tab点击次数			// barretzhang CMarketView.m
	eRepTypeListHangqingTabZhonggaigu = 19,		//行情中概股Tab点击次数			// barretzhang CMarketView.m
	
	eRepTypeListHangqingSort = 20,				//行情页排序点击次数汇总			// barretzhang CSortbleSectionCell.m
	
	eRepTypeRefreshButton = 21,					//刷新按钮点击次数				// barretzhang market myview newcomment newsview stockdetail
	eRepTypeDropdownRefresh = 22,				//下拉刷新次数					// barretzhang UIPullingheaderTableView.m
	
	eRepTypeSearchPage = 23,					//查询页进入次数				// barretzhang CMyViewController.mCMarketViewController.m
	eRepTypeSearchPageAddButton = 24,			//添加按钮点击次数				// barretzhang CSearchView.m
	eRepTypeCustomKeyboardNumPre = 25,			//自定义键盘快捷前缀次数			// xiaokzhang  CStockKeyBoard.m
	eRepTypeCustomKeyboardEn = 26,				//自定义键盘英文键盘次数			// xiaokzhang  CStockKeyBoard.m
	
	eRepTypeDelStock = 27,						//删除股票次数					// barretzhang MyEditView.m
	eRepTypeAddStock = 28,						//添加股票次数					// barretzhang MySearchView.m CStockDetailView.m
	
	eRepTypeEditPageMove = 29,					//编辑页中移动股票次数			// barretzhang MyEditView.m
	eRepTypeEditPageMoveTop = 30,				//编辑页中置顶股票次数			// barretzhang MyEditView.m
	
	eRepTypeStockDetailHorizontal = 31,			//个股详情横屏次数				// alexsun CStockTouchView.m
	eRepTypeStockDetailFromZixuan = 32,			//个股详情从自选进入次数			// barretzhang CMyView.m
	eRepTypeStockDetailFromHangqing = 33,		//个股详情从行情进入次数			// barretzhang CHSView  CHKView CUSCNView
	eRepTypeStockDetailFromChaxun = 34,			//个股详情从查询进入次数			// barretzhang CSearchView.m
	
	eRepTypeStockDetailPDFDownload = 35,		//个股详情PDF下载量（港股）		// sonywang CPDFDisplayView.m
	eRepTypeStockDetailAddButton = 36,			//个股详情添加自选按钮点击次数	//barretzhang CStockDetailView.m
	eRepTypeStockGeguYanbao = 37,				//个股研报入口进入次数			// sonywang CStockDetailTableView.m
	eRepTypeStockZixunYanbao = 38,				//自选资讯研报入口进入次数		// sonywang CNewsListViewForStocks.m
	eRepTypeStockGeguXinwen = 39,				//个股新闻入口进入次数			// sonywang CStockDetailTableView.m
	eRepTypeStockZixunXinwen = 40,				//自选资讯新闻入口进入次数		// sonywang CNewsListViewForStocks.m
	eRepTypeStockGeguGonggao = 41,				//个股公告入口进入次数			// sonywang CStockDetailTableView.m
	eRepTypeStockZixunGonggao = 42,				//自选资讯公告入口进入次数		// sonywang CNewsListViewForStocks.m
	
    eRepTypeClickAddStockButton = 43,			//编辑页面点击添加按钮			// barretzhang 
    eRepTypeTabSetting = 44,                    //个人Tab点击次数		// barretzhang CCustomTabBarController.m
	
	eRepTypeTixingButtonInEditMode = 45,		//自选列表编辑状态下提醒按钮		// add by suningwang
	eRepTypeSortCancel = 46,					//取消排序按钮					// add by suningwang
	eRepTypeGeguTabCaiwubiaoqian = 47,			//财务标签点击次数				// add by suningwang
	eRepTypeXianjinliuliang = 48,				//现金流量点击次数				// add by suningwang
	eRepTypeZichanfuzhai = 49,					//资产负债点击次数				// add by suningwang
	eRepTypeLirun = 50,							//利润表点击次数				// add by suningwang
	eRepTypeGeguGengduocaozuo = 51,				//个股详情页右下角更多操作点击次数	// add by suningwang
	eRepTypeGeguFenxianggegu = 52,				//个股详情页分享个股点击次数		// add by suningwang
	eRepTypeGeguQuxiaozixuan = 53,				//个股详情页取消自选点击次数		// add by suningwang
	eRepTypeGeguBianjitixing = 54,				//个股详情页编辑/添加提醒点击次数	// add by suningwang
	eRepTypeZixuanListNewsMessageClick = 55,	//自选列表新消息点击次数			// add by suningwang
	eRepTypeZixuanListNewsMessageClose = 56,	//自选列表新消息关闭次数			// add by suningwang
	eRepTypeGeguHuangtiaoClick = 57,			//个股详情页tips黄条点击次数		// add by suningwang
	eRepTypeGeguHuangtiaoClose = 58,			//个股详情页tips黄条关闭次数		// add by suningwang
	eRepTypeSettingZhanghaoguanli = 59,			//设置页面帐号管理点击次数		// add by suningwang
	eRepTypeSettingTixingxiaoxi = 60,			//设置页面提醒消息点击次数		// add by suningwang
	eRepTypeSettingRefreshTime = 61,			//设置页面行情刷新频率点击次数	// add by suningwang
	eRepTypeSettingShow = 62,					//设置页面显示设置点击次数		// add by suningwang
	eRepTypeSettingNewsDownOffline = 63,		//设置页面资讯离线下载点击次数	// add by suningwang
	eRepTypeSettingClearCache = 64,				//设置页面清除缓存点击次数		// add by suningwang
	eRepTypeSettingChangeSkin = 65,				//设置页面切换皮肤点击次数		// add by suningwang
	eRepTypeSettingFeedback = 66,				//设置页面意见反馈点击次数		// add by suningwang
	eRepTypeSettingRuanjianpingfen = 67,		//设置页面软件评分点击次数		// add by suningwang
	eRepTypeSettingYingyongtuijian = 68,		//设置页面应用推荐点击次数		// add by suningwang
	eRepTypeSettingClearMessageBox = 69,		//消息盒子里面点击清空的次数		// add by suningwang
	eRepTypeGeguShareToWeixin = 70,				//个股详情页分享到微信			// add by suningwang
	eRepTypeGeguShareToTencentWeibo = 71,		//个股详情页分享到腾讯微博		// add by suningwang
	eRepTypeGeguShareToSinaWeibo = 72,			//个股详情页分享到新浪微博		// add by suningwang
	eRepTypeGeguShareToMail = 73,				//个股详情页分享到邮件			// add by suningwang
	eRepTypeGeguShareToMessage = 74,			//个股详情页分享到短信			// add by suningwang
	eRepTypeGeguShareCancel = 75,				//个股详情页取消分享			// add by suningwang
	eRepTypeNewsShareToWeixin = 76,				//资讯页分享到微信				// add by suningwang
    eRepTypeNewsShareToTencentWeibo = 77,		//资讯页分享到腾讯微博			// add by suningwang
	eRepTypeNewsShareToSinaWeibo = 78,			//资讯页分享到新浪微博			// add by suningwang
	eRepTypeNewsShareToMail = 79,				//资讯页分享到邮件				// add by suningwang
	eRepTypeNewsShareToMessage = 80,			//资讯页分享到短信				// add by suningwang
	eRepTypeNewsShareCancel = 81,				//资讯页取消分享				// add by suningwang
	eRepTypeSettingTencentLogin = 82,			//点击登录腾讯微博				// add by suningwang
	eRepTypeSettingSinaLogin = 83,				//点击登录新浪微博				// add by suningwang
	eRepTypeGeguTabXinwen = 84,					//点击个股资讯Tab新闻			// add by suningwang
	eRepTypeGeguTabGonggao = 85,				//点击个股资讯Tab公告			// add by suningwang
	eRepTypeGeguTabYanbao = 86,					//点击个股资讯Tab研报			// add by suningwang
    eRepTypeNewsShareToShouQQ = 87,				//资讯页分享到手Q				// add by lixiang
    eRepTypeSettingBanben = 88,                 //设置页面版本点击次数          // add by ericfang
    eRepTypeHSCount = 89,                       //自选列表中沪深股票数量        // add by lixiang
    eRepTypeHKCount = 90,                       //自选列表中港股数量           // add by lixiang
    eRepTypeUSCount = 91,                       //自选列表中美股数量           // add by lixiang
    eRepTypeUpgradeShareTententWb = 92,         //升级安装分享到腾讯微博        // add by lixiang
    eRepTypeUpgradeShareQzone = 93,             //升级安装分享到Qzone           // add by lixiang
    eRepTypeUpgradeShareSinaWb = 94,            //升级安装分享到新浪微博           // add by lixiang
    
    eRepTypeStockDetailHorizontalPinch = 95,			//个股详情横屏K线缩放				// alexsun CKlineGestureView.m
    eRepTypeStockDetailHorizontalPan = 96,			//个股详情横屏K线滑动				// alexsun CKlineGestureView.m
    eRepTypeNewsKeywordClick = 97,              //所有关键词点击累积数量	// sonywang
    eRepTypeNewsFromPush = 98,                  //打开推送要闻的累积数量	// sonywang
    eRepTypeStockDetailMlineHorizontalPan = 99,       //个股详情横屏分时线滑动				// alexsun CMlineConverView.m
    
    eRepTypeNewsShareToQzone = 100,				//资讯页分享到Qzone				// add by lixiang
    eRepTypeGeguShareToQzone = 101,				//个股页分享到Qzone				// add by lixiang
    eRepTypeGeguShareToShouQQ = 102,            //个股页分享到手Q				// add by lixiang
    eRepTypeNewsShareToFriend = 103,            //资讯页分享到朋友圈				// add by lixiang
    eRepTypeGeguShareToFriend = 104,            //个股页分享到朋友圈				// add by lixiang
    eRepTypeStockGeguCaibao   = 105,            //个股详情点击进入详情             // add by ericfang
    eRepTypeStockFinanceReportSpan = 106,       //财务数据详情报告期点击           // add by ericfang
    eRepTypeStockFinanceReportYearBisisCompare = 107, //财务数据详情同比点击       //add by ericfang
    eRepTypeStockPriceNotifyToDetail = 108,     //股价提醒push进入对应底层页       //add by ericfang
    
    //109 - 200属于市场行情使用
    //add by maxxiangli begin at 2013.03.22
    eRepTypeMarketHSPlateList = 109,              //市场行情  点击沪深热门行业更多按钮
    eRepTypeMarketHSPlateInfor = 110,              //市场行情  点击沪深热门行业中的某个行业
    eRepTypeMarketHSZhangFuBang = 111,              //市场行情  点击沪深涨幅榜按钮
    eRepTypeMarketHSDieFubang = 112,              //市场行情    点击沪深跌幅榜按钮
    eRepTypeMarketHSHuanShouLvBang = 113,           //市场行情  点击沪深换手率榜按钮
    eRepTypeMarketHSZhenFuBang = 114,              //市场行情   点击沪深振幅榜按钮
    eRepTypeMarketHKPlateList = 115,              //市场行情  点击沪港股热门行业列表按钮
    eRepTypeMarketHKPlateInfor = 116,              //市场行情  点击港股热门行业中的某个行业
    eRepTypeMarketHKMainZhangFuBang = 117,          //市场行情  点击港股主板涨幅按钮
    eRepTypeMarketHKMainDieFubang = 118,            //市场行情  点击港股主板跌幅榜按钮
    eRepTypeMarketHKChuangYeZhangFuBang = 119,      //市场行情  点击港股创业板涨幅榜按钮
    eRepTypeMarketHKChuangYeDieFubang = 120,        //市场行情  点击港股创业榜跌幅榜按钮
    eRepTypeMarketHKRenZhengChengJiaoBang = 121,    //市场行情  点击港股认证股成交额榜按钮
    eRepTypeMarketHKRenNiuXiongJiaobang = 122,      //市场行情  点击港股牛熊证成交额榜按钮
    eRepTypeMarketUSZhongGaiGu = 123,              //市场行情  点击美股中概股按钮
    eRepTypeMarketUSMeiGuKeJiGu = 124,              //市场行情  点击美股科技股按钮
    eRepTypeMarketSwitchClicked = 125,       //点击展开关闭
	
	// marteswang: 沪港通行情相关 2014-09-18
	eRepTypeListHangqingTabHGT = 126,			//行情中概股Tab点击次数 这个前面4个tab的统计ID后面没有空间了，只好加在这里了			// CMarketView.m
	
    eRepTypeMarketHGTHGuT = 127,				//市场行情  点击沪港通沪股通按钮
	eRepTypeMarketHGTGGT = 128,					//市场行情  点击沪港通港股通按钮
	eRepTypeMarketHGTAPH = 129,					//市场行情  点击沪港通AH股按钮
	eRepTypeMarketHKZhuZhengChengJiaobang = 130, //市场行情 主证成交榜
	eRepTypeMarketHKGemChengJiaobang = 131,     //市场行情  创业版成交榜

	
    eRepTypeMarketEND = 200,              //市场行情  行业列表
    //add by maxxiangli end at 2013.03.22
    
    eRepTypeReturnToQQNews = 201,              //点击button跳转回腾讯新闻
    
    eRepTypeGeguTabFundInfo = 202,				//点击基金简况			// add by maxxiangli sony
    eRepTypeSkinColor = 203,                    //皮肤颜色 @"Set_SkinColor"			// add by maxxiangli
    eRepTypeGeguTabAscend = 204,            //个股资讯页卡：涨幅榜
    eRepTypeGeguTabDescend = 205,           //个股资讯页卡：跌幅榜
    eRepTypeGeguTabVolume = 206,            //个股资讯页卡：成交量（换手率）
    eRepTypeGeguTabStockInfo = 207,         //个股资讯页卡：股票简况
    eRepTypeGeguTabFlow = 208,              //个股资讯页卡：资金流向
    eRepTypeGeguTabStockHolder = 209,       //个股资讯页卡：股东
    eRepTypeGeguNewsListSeeMoreNews = 210,          //个股资讯列表：查看更多新闻
    eRepTypeGeguNewsListSeeMoreNotice = 211,        //个股资讯列表：查看更多公告
    eRepTypeGeguNewsListSeeMoreResearch = 212,      //个股资讯列表：查看更多研报
    
    eRepTypeGeguTabQuanyi = 213,                    //个股资讯页卡：权益
    eRepTypeGeguTabWolun = 214,                     //个股资讯页卡：涡轮
    eRepTypeGeguNewsListSeeMoreWolun = 215,         //个股涡轮列表：查看更多涡轮
    eRepTypeStockGeguWolun = 216,                   //个股涡轮列表：查看涡轮详情
    eRepTypeStockGeguAnalysis = 217,                //个股页卡：查看分析
    eRepTypeStockGeguReminder = 218,                //个股页卡：查看提示
    eRepTypeStockGeguMarketMaker = 219,                //个股页卡：查看做市
    
    //盈亏
	eRepTypeGeguEnterProfitlossFromOptionList = 231,	//个股进入盈亏：从操作列表进入
	eRepTypeGeguEnterProfitlossFromDisplayArea = 232,	//个股进入盈亏：从盈亏展示区域进入
	eRepTypeProfitlossSummaryPortfolioEnter = 233,      //盈亏统计页面：从自选列表进入
	eRepTypeProfitlossSummaryTabSwitch = 234,           //盈亏统计页面：tab切换
	eRepTypeProfitlossSummaryButtonRefresh = 235,      //盈亏统计页面：点击刷新按钮
	eRepTypeProfitlossSummaryPullRefresh = 236,         //盈亏统计页面：下拉刷新
    eRepTypeProfitlossSummaryTableCellClick = 237,      //盈亏统计页面：点击股票列表进入个股盈亏
    eRepTypeProfitlossSummarySetting = 238,             //设置页面：盈亏汇总设置
    
    //300-400 自选列表专用
    //主页面
    eRepTypePortfolioMainTitleClick = 300,              //分组页面（可左右滑动），点击title
    eRepTypePortfolioMainSortStockCode = 301,           //分组页面    股票代码排序
    RepTypePortfolioMainSortStockPrice = 302,           //分组页面    股票价格排序
    RepTypePortfolioMainSortStockRange = 303,           //分组页面    股票涨跌幅排序
    RepTypePortfolioMainSwipe = 304,                    //分组页面 左滑滑动切换组合
    RepTypePortfolioMainEidtRemoveBtnClick = 305,       //分组页面    股票编辑页面      点击移动按钮
    RepTypePortfolioMainEidtDeleteBtnClick = 306,       //分组页面    股票编辑页面      点击删除按钮
    RepTypePortfolioMainEidtSelectALlBtnClick = 307,       //分组页面    股票编辑页面      点击选择全部按钮
    //组合选择页面
    RepTypePortfolioCombinationSelectionManageBtnClick = 308,       //组合选择页面      管理组合按钮
    RepTypePortfolioCombinationSelectionAddBtnClick = 309,          //组合选择页面      添加新组合按钮
    RepTypePortfolioCombinationSelectionSort = 310,                 //组合选择页面      组合排序
    RepTypePortfolioCombinationSelectionRename = 311,               //组合选择页面      修改组合名称
    RepTypePortfolioCombinationSelectionDelete = 312,               //组合选择页面      删除组合
    //股票添加移动页面
    RepTypePortfolioStockAddOrMoveAddNewBtnClick = 313,         //股票添加移动页面      点击添加新组合按钮
    RepTypePortfolioCombinationData = 314,         //分组数据上报
    
    //401-430 登录专用
    eRepTypeLoginPortfolio = 401,			//点击登录自选列表 QQ登录
    eRepTypeLoginStockMoments = 402,			//点击登录自选列表 wx登录
    eRepTypeLoginUinPortfolio = 403,			//上报自选列表帐号
    eRepTypeLoginUinstockMoments = 404,			//上报股票圈帐号
	
	//431-450 资讯收藏
	eRepTypeNewsFavoriteClickAdd = 431,			//添加收藏
	eRepTypeNewsFavoriteClickCancel = 432,		//取消收藏（从正文页面）
	eRepTypeNewsFavoriteClickEdit = 433,		//编辑收藏
	eRepTypeNewsFavoriteClickDelete = 434,		//删除收藏（从列表页面）
	eRepTypeNewsFavoriteAlertMaxNumber = 435,	//达到最大限度

    eRepTypeTradingLoginSuccess = 500,          //交易登陆成功 //add by ericfang
    eRepTypeTradingAccountTab = 501,          //交易账户概览tab点击 //add by ericfang
    eRepTypeTradingTradeTab = 502,          //交易交易tab点击 //add by ericfang
    eRepTypeTradingTodayOrderTab = 503,          //交易今日委托tab点击 //add by ericfang
    eRepTypeTradingHistoryTab = 504,          //交易历史记录tab点击 //add by ericfang
    eRepTypeTradingAccountPrice = 505,          //交易账户概览股价提醒 //add by ericfang
    eRepTypeTradingAccountTrade = 506,          //交易账户概览买卖下单 //add by ericfang
    eRepTypeTradingAccountPulling = 507,          //交易账户概览下拉刷新 //add by ericfang
    eRepTypeTradingTradeSwitch = 508,          //交易交易页买入卖出切换 //add by ericfang
    eRepTypeTradingTradeStockCode = 509,          //交易交易页股票代码输入 //add by ericfang
    eRepTypeTradingTradeDelegateType = 510,          //交易交易页委托方式 //add by ericfang
    eRepTypeTradingTradePriceInput = 511,          //交易交易页股价输入 //add by ericfang
    eRepTypeTradingTradePriceAdd = 512,          //交易交易页股价加 //add by ericfang
    eRepTypeTradingTradePriceSub = 513,          //交易交易页股价减 //add by ericfang
    eRepTypeTradingTradeAmountInput = 514,          //交易交易页数量输入 //add by ericfang
    eRepTypeTradingTradeAmountAdd = 515,          //交易交易页数量加 //add by ericfang
    eRepTypeTradingTradeAmountSub = 516,          //交易交易页数量减 //add by ericfang
    eRepTypeTradingTradeBenjin = 517,          //交易交易页本金输入 //add by ericfang
    eRepTypeTradingTodayOrderCancel = 518,          //交易今日委托页点击取消委托 //add by ericfang
    eRepTypeTradingTodayOrderChange = 519,          //交易今日委托页点击更改委托 //add by ericfang
    eRepTypeTradingTodayOrderPulling = 520,          //交易近日委托页点下拉刷新 //add by ericfang
    eRepTypeTradingHistoryPeriod = 521,          //交易历史页点击记录周期 //add by ericfang
    eRepTypeTradingHistoryPulling = 522,          //交易历史页下拉刷新 //add by ericfang
    eRepTypeTradingAccountRefresh = 523,          //交易账户概览页点击刷新 //add by ericfang
    eRepTypeTradingTradeRefresh = 524,          //交易交易页点击刷新 //add by ericfang
    eRepTypeTradingTodayOrderRefresh = 525,          //交易今日委托点击刷新 //add by ericfang
    eRepTypeTradingHistoryRefresh = 526,          //交易历史页点击刷新 //add by ericfang

	eRepTypeStockDetailLandscapePankou          = 527,  //股票详情页, 横屏五档盘口点事上报 //by kennazeng.
    eRepTypeStockDetailOpenLandscape            = 528,   //股票详情页，竖屏点击进入横屏事件
    eRepTypeStockDetailLandscapeCloseByButton   = 529,  //股票详情页，按钮关闭横屏事件
    eRepTypeStockDetailLandscapeCloseByClick    = 530,  //股票详情页，点击（双击）关闭横屏事件
    eRepTypeStockDetailLandscapeChuquanClick    = 531,  //股票详情页，横屏复权选择按钮
    eRepTypeStockDetailLandscapeQianfuquanClick = 532,  //股票详情页，横屏复权选择按钮
    eRepTypeStockDetailLandscapeHoufuquanClick  = 533,  //股票详情页，横屏复权选择按钮
    
    eRepTypeSettingKLineChuquanClick            = 534,  //K线设置页面，点击不复权
    eRepTypeSettingKLineQianfuquanClick         = 535,  //K线设置页面，点击前复权
    eRepTypeSettingKLineHoufuquanClick          = 536,  //K线设置页面，点击后复权
    
    eRepTypeStockDetailSwitchStockBySwipe       = 537,  //股票详情页，左右滑动切换股票
    eRepTypeStockDetailRefreshByButton          = 538,  //股票详情页，刷新数据（点击刷新）
    eRepTypeStockDetailRefreshByPull            = 539,  //股票详情页，刷新数据（下拉刷新）
    eRepTypeStockDetailLandScapeRefreshByButton = 540,  //股票详情页，横屏刷新数据（点击刷新）
    
    eRepTypeStockDetailLandscapeZhibiaoBegin    = 541,  //股票详情页，横屏指标选择按钮541-560
    eRepTypeStockDetailLandscapeZhibiaoEnd      = 560,
    eRepTypeSettingKLineZhibiaoClickBegin       = 561,  //K线设置页面，切换指标561-580
    eRepTypeSettingKLineZhibiaoClickEnd         = 580,
    
    //550-650 股票详情页面线图切换按钮专用
    eRepTypeStockDetailLineTypeClickBegin       = 550,  //股票详情页，线图按钮550-600
    eRepTypeStockDetailLandscapeLineTypeClickBegin  = 600,  //股票详情页，横屏线图按钮600-650
    eRepTypeStockDetailLandscapeLineTypeClickEnd    = 650,

	//700 交易
    eRepTypeTradingTradeInputOrder = 701,		//下单按钮
	eRepTypeTradingTradeSendOrder = 702,		//发送订单
	eRepTypeTradingTradeOrderAccept = 703,		//下单成功

	
	//801-899 股票圈
	//发布帖子
	eRepTypeCommunityPubSubjectStockDing = 801,				//发布主贴：股票顶操作（包括用户输入股评和未输入股评）
	eRepTypeCommunityPubSubjectStockDingWithInput = 802,	//发布主贴：股票顶操作（只包括用户输入股评）
	eRepTypeCommunityPubSubjectStockCai = 803,				//发布主贴：股票踩操作（包括用户输入股评和未输入股评）
	eRepTypeCommunityPubSubjectStockCaiWithInput = 804,		//发布主贴：股票踩操作（只包括用户输入股评）
	eRepTypeCommunityPubSubjectNews = 805,					//发布主贴：新闻（包括用户输入股评和未输入股评）
	eRepTypeCommunityPubSubjectNewsWithInput = 806,			//发布主贴：新闻（只包括用户输入股评）
	eRepTypeCommunityPubSubjectText = 807,					//发布主贴：文本
	eRepTypeCommunityPubSubjectImage = 808,					//发布主贴：图片（暂时未用）
	//删除帖子
	eRepTypeCommunityRemoveSubject = 810,					//删除主贴
	//发布评论/删除评论
	eRepTypeCommunityCommentDing = 811,						//评论：顶
	eRepTypeCommunityCommentDingRemove = 812,				//评论：取消顶
	eRepTypeCommunityCommentCai = 813,						//评论：踩
	eRepTypeCommunityCommentCaiRemove = 814,				//评论：取消踩
	eRepTypeCommunityCommentInputComment = 815,				//评论：点击“评论”输入内容
	eRepTypeCommunityCommentReplyComment = 816,				//评论：回复
	eRepTypeCommunityCommentRemoveComment = 817,			//评论：删除评论
	//各大页面
	eRepTypeCommunitySubjectListFromSetting = 821,			//从设置进入主列表
	eRepTypeCommunitySubjectListFromStockDetail = 822,		//从个股详情进入主列表
	eRepTypeCommunityFriendList = 825,						//朋友列表
	eRepTypeCommunityUserCenterSelf = 826,					//我的主题
	eRepTypeCommunityUserCenterOther = 827,					//用户中心（不区分是否自己）
	eRepTypeCommunityUserPrivacy = 828,						//进入隐私
	eRepTypeCommunityUserBlackList = 829,					//黑名单（点击完成才算）
	eRepTypeCommunityUserNoConcernList = 830,				//不关注他人（点击完成才算）
	eRepTypeCommunityInviteFriend = 831,					//邀请好友
	eRepTypeCommunitySubjectDetail = 832,					//进入单个帖子详情页
	eRepTypeCommunityMessageListFromNewMessage = 833,		//新消息点击进入消息列表
	eRepTypeCommunityMessageListFromUserCenter = 834,		//从个人中心进入消息列表
	eRepTypeCommunityMessageListClear = 835,				//清空消息列表
	eRepTypeCommunityLinkToStockDetail = 836,				//点击进入个股详情
	eRepTypeCommunityLinkToNews = 837,						//点击进入新闻
	eRepTypeCommunitySubjectListForOneStockFromStockDetail = 838,  //从个股详情页进入个股聚合
	//插入表情、股票关键词等
	eRepTypeCommunityContentInsertStockKeyword = 841,		//插入股票关键词
	eRepTypeCommunityContentInsertQQEmoji = 842,			//插入QQ表情
	
	
	
    
    //1000-2000 段, 全局专用.
    
    eRepTypeNavigationDragBack = 1001,         //拖拽返回.
    
	
	//2000~2200 活动专用
	eRepTypeActive_list_access = 2000, // 活动中心列表访问数据
	eRepTypeActive_jump_into_active = 2001, //单个活动访问数据
	eRepTypeActive_messege_access = 2002, //  消息中心进入数据
	eRepTypeActive_share_wx_friend = 2003, //  分享到微信好友
	eRepTypeActive_share_wx_fzone = 2004, //  分享到微信朋友圈
	eRepTypeActive_share_qq_qzone = 2005, //  分享到qq空间
	eRepTypeActive_share_qq_friend = 2006, //  分享到qq好友
	eRepTypeActive_share_wb_qq = 2007, //   分享到腾讯微博
	eRepTypeActive_share_wb_sina = 2008, //  分享到新浪微博
	eRepTypeActive_share_email = 2009, //  分享到邮件
    
	
    //5000-6000（5999）新闻专用
    //5000-5200 新闻相关按钮（不区分栏目）
    //5200-5400 进入某栏目新闻正文（区分栏目）
    //5400-5600 进入某栏目新闻列表（区分栏目）
    //5600-5800 订阅某栏目新闻（区分栏目）
    eRepTypeNewsListOpenContent = 5200,         //打开栏目新闻正文
    eRepTypeNewsListOpenList    = 5400,         //打开栏目新闻列表
    eRepTypeNewsListSelectList  = 5600,         //栏目订阅完成后发送所有订阅栏目，非动作统计，而是结果统计
    eRepTypeNewsListStocksAll   = 6,            //见 eRepTypeListNewsTabZixuan，自选新闻标签点击
    eRepTypeNewsListSelectedAll = 5001,         //综合资讯标签点击
    eRepTypeNewsListClickConfig = 5011,         //点击新闻订阅
    eRepTypeNewsListConfigMoved   = 5012,       //移动新栏目
    eRepTypeNewsListConfigClicked = 5013,       //点击栏目（改变选定状态）
    eRepTypeNewsListSwitchClicked = 5014,       //点击展开关闭
	
	//begin at 6001
	eRepTypeLiveInAPP = 6001,       //APP停留时间
    
    //个股页面 6500
    eRepTypeGeguAddzixuan = 6500,				//个股详情页添加自选点击次数		// add by maxxiangli
    
    //新添加的item，在此之上添加，不可覆盖其他的item
	eReqTypeTimeSlot1 = 8000,					//时间段1(毫秒)，从网络请求开始，到接收到第一个数据包结束
	eReqTypeTimeSlot2 = 8001,					//时间段2(毫秒)，从网络请求开始，到接收到所有数据包结束
	eRepTypeForTest								//测试专用ID
    
    //@"boss_RequestData"                       //网络耗时统计
    //@"Set_SkinColor"                          皮肤颜色
    //@"boss_Share_StartAPPFromOther"           //从哪里启动的自选股
    //@"markets_alltrees_click"                    //行情页卡，点击折叠／展开
    //@"markets_alltrees_clickformore"                    //行情页卡，点击查看更多
    
    //@"stock_detail_analysistab_click"             //个股详情点击分析tab
    //@"sd_generalprofile_holderdetails_click"      //个股详情简况点击跳转股东详情
    //@"sd_generalprofile_industry_click"           //个股详情简况点击所属行业跳转
    //@"sd_generalprofile_concept_click"            //个股详情简况点击所属概念跳转
    //@"search_hotsearchwords_click_sd"             //热搜推荐点击进入个股详情页
    //@"hkwarrants_bid_click_details"               //港股窝轮点击跳转所属标的详情页
    
    //@"portfolio_group_create"               //新建股票分组次数
    //@"portfolio_group_delete"               //删除股票分组次数
    //@"portfolio_slip"               //自选页内滑动次数
    //@"portfolio_group_share"               //股票组合分享次数
};
typedef NSUInteger TReportType;

//这个只在boss统计用到。
typedef enum {
    UnknowDevice,
    Simulator,
    iPhone1G,
    iPhone3G,
    iPhone3GS,
    iPhone4,
    iPhone4S,
    iPhone5,
    iPhone5S,
    iPhone5C,
    iPhone6,
    iPhone6Plus,
    iPhone6S,
    iPhone6SPlus,
    AppleWatch1G,
    iPod1G,
    iPod2G,
    iPod3G,
    iPod4G,
    iPod5G,
    iPod6G,
    iPad1G,
    iPad2G,
    iPad3G,
    iPad4G,
    iPadAir1G,
    iPadAir2G,
    iPadMini1G,
    iPadMini2G,
    iPadMini3G,
    iPadMini4G
} iPhoneTypes;

@interface CBossReporter : NSObject
+(void)enableAlertForMumu:(BOOL)enable;//是否弹框：为木木测试使用，从smartbox中隐藏，默认为false

+ (CBossReporter *)sharedBossReporter;

//这三个上报用来定位异常使用，不再向服务器上报统计；向服务器上报统计的，请使用reportUserEvent
+ (void)reportTickInfo:(TReportType)reportType;
+ (void)reportTickInfo:(NSString *)reportKey props:(NSDictionary*)kvs;
+ (void)reportTickInfoReportType:(TReportType)reportType props:(NSDictionary*)kvs;

//向服务器发送统计信息
+ (void)reportUserEvent:(NSString *)userEvent;
+ (void)reportUserEvent:(NSString *)userEvent stockCode:(NSString *)stockCode;      //上报事件以及对应的股票ID／行情名称／资讯ID，等。
+ (void)reportUserEvent:(NSString *)userEvent keyValues:(NSDictionary *)keyValues;  //上报事件以及对应的股票ID／行情名称／资讯ID，等。
+ (void)reportDeviceInfo;//上报硬件信息

//上报自选列表帐号
+ (void)reportPortfolioUin;
//上报股票圈帐号
+ (void)reportStockMomentsUin;
- (NSString*) getDeviceType2;
//+ (iPhoneTypes) getDeviceType;
+ (NSString*) getDeviceTypeString;
- (NSString *)getBundleVersion;
+ (BOOL)isBigScreenIphone;

//上报页面停留时间
+(void)trackPageViewBegin:(TReportType)reportType;
+(void)trackPageViewEnd:(TReportType)reportType;

//----------以下方法是为了定位错误和异常而添加的自选股代码，非MTA自有方法，但数据依然会post到MTA后台--------//
//记录用户事件：按钮点击、个股详情页进入，等历史操作，以供crash定位
+(void)trackUserEvent:(NSString *)event;
//记录请求历史，以供crash定位
+(void)trackRequest:(CRequestCommand *)request urlOrStatus:(NSString *)urlOrStatus;
+(void)trackRequest:(CRequestCommand *)request responseData:(NSString *)responseData;
//异常上报
+(void)reportException:(NSException *)exception file:(const char *)file function:(const char *)function line:(unsigned long)line data:(NSString*)data;
//未捕捉异常保存到磁盘
+(void)saveUncaughtException:(NSException *)exception;
+(void)processLastUncaughtException;
@end

#define REPORT_EXCEPTION_DATA(exception,description) [CBossReporter reportException:exception file:__FILE__ function:__FUNCTION__ line:__LINE__ data:description]

#define REPORT_EXCEPTION(exception) [CBossReporter reportException:exception file:__FILE__ function:__FUNCTION__ line:__LINE__ data:nil]


