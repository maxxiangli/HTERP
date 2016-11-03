//
//  SizeDefine.m
//  QQStock
//
//  Created by zheliang on 14/12/4.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "SizeDefine.h"

BOOL FS_isBigMode;      //是否大字体
CGFloat FS_ZoomScale;   //放大系数（为6p放大功能使用）

//abelchen add
//分界面注释
//// 自选列表盈亏汇总
CGFloat FS_ProfitLoss_HeaderLabel;
CGFloat FS_ProfitLoss_HeaderContent;
CGFloat SZ_ProfitLoss_HeaderLabelHeight;
CGFloat SZ_ProfitLoss_HeaderContentHeight;
CGFloat SZ_ProfitLoss_HeaderTop;
CGFloat SZ_ProfitLoss_HeaderLineMargin;
CGFloat SZ_ProfitLoss_HeaderBottom;
CGFloat SZ_ProfitLoss_EidtGroupNameFont;
CGFloat SZ_ProfitLoss_BottomNameFont;
//// 自选列表导航头
CGFloat FS_PortfolioTableCell_NavSectionLabel;
CGFloat SZ_PortfolioTableCell_NavSectionLabelHeight;
CGFloat SZ_PortfolioTableCell_NavSectionLabelMargin;
//// 自选列表Cell
CGFloat FS_PortfolioTableCell_Name;
CGFloat FS_PortfolioTableCell_Code;
CGFloat FS_PortfolioTableCell_Price;
CGFloat FS_PortfolioTableCell_Fluctuation;
CGFloat SZ_PortfolioTableCell_FluctuationWidth;
CGFloat FS_PortfolioTableCell_Tips;
CGFloat FS_PortfolioTableCell_LoginButton;
CGFloat SZ_PortfolioTableCell_Left;
CGFloat SZ_PortfolioTableCell_Top;
CGFloat SZ_PortfolioTableCell_Bottom;
CGFloat SZ_PortfolioTableCell_CodeMargin;
CGFloat SZ_PortfolioTableCell_NameHeight;
CGFloat SZ_PortfolioTableCell_CodeHeight;
//// 个股详情页
CGFloat SZ_StockDetailBottomBar_MoreButtonWidth;
CGFloat FS_StockDetailCPressedButtonGroup;
CGFloat FS_StockDetailNewsCell_Title;
CGFloat FS_StockDetailNewsCell_Date;
CGFloat FS_StockDetailNewsCell_Detail;
CGFloat SZ_StockDetailNewsCell_SingleLineHeight;
CGFloat FS_StockDetailNewsCell_FundLabel;
CGFloat FS_StockDetailNewsCell_WolunCode;
CGFloat FS_StockDetailNewsCell_DropDown;
CGFloat FS_StockDetailAnalysisZoushi_Font;
CGFloat FS_StockDetailAnalysisZouShiBGImage;
CGFloat FS_StockDetailNewsCell_GaiNianFont;
CGFloat FS_StockDetailNewsCell_BanKuaiWidth;
CGFloat FS_StockDetailHBFundPrice_TopMargin;
CGFloat FS_StockDetailKJFundToolBar_TopMargin;
CGFloat FS_StockDetailFundManagerJianJie_TopMargin;
CGFloat FS_StockDetailFundManagerDetail_Font;
CGFloat FS_StockDetailFundNameForJiancheng_Width;

CGFloat FS_StockDetailFenzhongDropViewTitleFontSize;
CGFloat FS_StockInfoHolderHeightForGuben;
//// 市场页
CGFloat FS_Market_CaptionTableCell;
CGFloat FS_Market_SortableTableHeader;
CGFloat FS_Market_PairedTableCell_Name;
CGFloat FS_Market_PairedTableCell_Price;
CGFloat FS_Market_PairedTableCell_Fluctuation;
CGFloat FS_Market_PairedTableCell_AToB;
CGFloat FS_Market_GlobalTableHeader;
CGFloat FS_Market_GlobalTableCell_Name;
CGFloat FS_Market_GlobalTableCell_Price;
CGFloat FS_Market_GlobalTableCell_Fluctuation;
CGFloat FS_Market_PlateInfoCell_Name;
CGFloat FS_Market_PlateInfoCell_Fluctuation;
CGFloat SZ_Market_NavBar_Height;
//// 搜索页
CGFloat FS_SearchBar_PlaceHolder;
CGFloat FS_SearchView_Tips;
CGFloat FS_SearchView_Item;
//// 持仓明细
CGFloat FS_ProfitLoss_Header_Label;
CGFloat FS_ProfitLoss_Header_Content;
CGFloat FS_ProfitLoss_Header_Profitloss;
CGFloat SZ_ProfitLoss_Header_Label_Height;
CGFloat SZ_ProfitLoss_Header_Content_Height;
CGFloat SZ_ProfitLoss_Header_LabelContentSpace;
CGFloat SZ_ProfitLoss_Header_LineSpace;
CGFloat FS_ProfitLoss_Cell_Date;
CGFloat FS_ProfitLoss_Cell_Label;
CGFloat FS_ProfitLossFund_Header_Label;
CGFloat FS_ProfitLossFund_Header_Content;
CGFloat FS_ProfitLoss_Edit_Label;
CGFloat FS_ProfitLoss_Edit_Content;
//// 财务页
CGFloat FS_Finance_Report_Detail_Level1;
CGFloat FS_Finance_Report_Detail_Level2;
CGFloat SZ_Finance_Report_Detail_Height;
CGFloat FS_Finance_Report_Detail_Header;
CGFloat SZ_Finance_Report_Detail_AddHeight;
//// ATrade
CGFloat SZ_InputSheetTopInset;
CGFloat SZ_AccountHeaderCol1Width;

//zheliang add
//Common
CGFloat FS_NavigationBar_Title;
CGFloat FS_CustomButton_Default;
CGFloat FS_Font10_12;
CGFloat FS_Font11_13;
CGFloat FS_Font12_14;
CGFloat FS_Font13_15;
CGFloat FS_Font14_16;
CGFloat FS_Font15_17;
CGFloat FS_Font16_18;
CGFloat FS_Font17_19;
CGFloat FS_Font18_20;
CGFloat FS_Font19_21;
CGFloat FS_Font20_22;
CGFloat FS_Font24_26;

CGFloat SZ_CustomTabBar_Height;
CGFloat SZ_ToolBarHeight;
CGFloat SZ_NewsContentBottomBarHeight;
CGFloat SZ_BigButtonHeight;


//CStockDetail
CGFloat FS_CStockDetail_BottomButotn;
CGFloat FS_CStockDetail_Block1_Price_1;
CGFloat FS_CStockDetail_Block1_Price_2;
CGFloat FS_CStockDetail_Block1_Price_3;
CGFloat FS_CStockDetail_Block1_Price_4;
CGFloat FS_CStockDetail_Block1_Price_5;
CGFloat FS_CStockDetail_Block1_Price_6;
CGFloat FS_CStockDetail_Block1_Font;
CGFloat FS_CStockDetail_Block2_Font;
CGFloat FS_CStockDetail_Block2_FontSize1;
CGFloat FS_CStockDetail_Block2_FontSize2;
CGFloat FS_CStockDetail_Block2_FontSize3;
CGFloat FS_CStockDetail_Block3_Font;
CGFloat FS_CStockDetail_Block3_FontSize1;
CGFloat FS_CStockDetail_Block3_Toolbar;
CGFloat FS_CStockDetail_ProfitLoss_Title;
CGFloat FS_CStockDetail_ProfitLoss_Content;

NSString* StockDetailLandScapeRTViewTitle;
NSString* StockDetailLandScapeRTViewFont1;
NSString* StockDetailLandScapeRTViewFont2;
NSString* StockDetailGroupViewRTViewFont1;
NSString* StockDetailGroupViewRTViewFont2;

CGFloat FS_CStockDetail_BOTTOMBAR_COMMENTLABEL;


CGFloat SZ_CStockDetail_TopMarginInBlock2;
CGFloat SZ_CStockDetail_BottomMarginInBlock1_2;
CGFloat SZ_CStockDetail_RTViewBackgroudHeight1;
CGFloat SZ_CStockDetail_RTViewBackgroudHeight2;
CGFloat SZ_CStockDetail_RTViewBackgroudHeight3;
CGFloat SZ_CStockDetail_RTViewBackgroudHeight4;
CGFloat SZ_CStockDetail_RTViewBackgroudHeight5;
CGFloat SZ_CStockDetail_RTViewBlock1_2Height;
CGFloat SZ_CStockDetail_RTViewBlock1_2Height_2;
CGFloat SZ_CStockDetail_RTViewBlock3Height;
CGFloat SZ_CStockDetail_RTViewBlock3Height_2;

CGFloat SZ_CStockDetail_RTViewFundPriceZoneRightHeight;

CGFloat SZ_CStockDetail_MoreViewFontSize;

CGFloat SZ_CStockDetail_FundPriceZoneBottom_MarginRight;
CGFloat SZ_CStockDetail_FundPriceZoneBottomViewZhangDieHeight;
CGFloat FS_CStockDetail_HBFund_Price_1;
CGFloat FS_CStockDetail_HBFund_Price_2;
CGFloat FS_CStockDetail_HBFund_Price_3;
CGFloat FS_CStockDetail_HBFund_Price_4;
CGFloat FS_CStockDetail_HBFund_Price_5;
CGFloat FS_CStockDetail_HBFund_Price_6;

//CNewsList
CGFloat FS_NewsListHeadName;
CGFloat FS_NewListTitle;
CGFloat FS_NewListTitleAbstract;
CGFloat FS_NewListTitleDate;
CGFloat SZ_NewsListTitle_Y;

//CProfitLossSummary
CGFloat SZ_CProfitLossSummaryStatisticView_Height;
CGFloat SZ_CProfitLossSummaryGraphicView_Height;
CGFloat SZ_CProfitLossSummaryCell_ColumnGap;
CGFloat SZ_CProfitLossSummaryGraphicViewMaxMinRateFontSize;

//ATrade
CGFloat SZ_AccountHeaderCol2Leading;
CGFloat SZ_AccountHeaderBgHeight;
CGFloat SZ_CompetitionAccountHeaderBgHeight;

CGFloat SZ_LoginViewWidth;
CGFloat SZ_LoginViewHeight;

CGFloat SZ_AccountButtonGroupLeadingTrailing;
CGFloat SZ_AccountButtonGroupMargin;
CGFloat SZ_AccountCellButtonMargin;
CGFloat SZ_AccountCellLineHeight;

//CPersonalViewController
CGFloat SZ_Personal_EXPAND_LINE_HEIGHT;
//sonywang add
CGFloat FS_PriceTipsBarFontSize;

//理财通基金
CGFloat FS_TenpayFundHeadViewTitle;
CGFloat FS_TenpayFundHeadViewSubTitle;

//图片识别
CGFloat FS_StepTitleLabelFontSize;
CGFloat FS_StepContentLabelFontSize;
CGFloat SZ_StepImageView_Width;
CGFloat SZ_ImportButton_Height;
CGFloat SZ_StepImage_Width;
CGFloat SZ_StepImage_Height;
CGFloat FS_ShowExampleImageLaelFontSize;
CGFloat FS_ShowExampleProcessLabelFontSize;
CGFloat FS_ImportButtonTileLabelFontSize;
CGFloat SZ_ImportTopLabelHeight;
CGFloat FS_ImportTopLabelFontSize;
CGFloat FS_IndentifyRemindLabelFontSize;
CGFloat FS_ResultEmptyLabelFontSize;
CGFloat SZ_ResultEmptyImageViewHeight;
CGFloat SZ_ResultEmptyImageViewWidth;
CGFloat FS_ResultCellStockNameLabelFontSize;
CGFloat FS_ResultCellStockCodeLabelFontSize;
CGFloat FS_ResultCellImageView_Width_Height;
CGFloat FS_ResultCell_Height;

//相册
CGFloat FS_PhotoDoneButtonFontSize;

#pragma CATradeOpenAccountListController
CGFloat SZ_OpenAccountListIconTop;//other:10 6puls:13
CGFloat SZ_OpenAccountListIconLeading;//other:10 6puls:13
CGFloat SZ_OpenAccountListIconBottom;//other:10 6puls:13
CGFloat SZ_OpenAccountListIconTrailing;//other:10 6puls:13
CGFloat SZ_OpenAccountListQsnameTrailing;//other:10 6puls:20
CGFloat SZ_OpenAccountListTipsTop;//other:8 6puls:13
CGFloat SZ_OpenAccountListTipsBottom;//other:8 6puls:12

#pragma CATradeAccountVertifyCodeController
CGFloat SZ_OpenAccountVertifyCodePhoneLabelTop;//other:20 6p:26
CGFloat SZ_OpenAccountVertifyCodePhoneLabelLeading; //other:15//6p:18
CGFloat SZ_OpenAccountVertifyCodePhoneLabelTrailing;//other:14 6p:17
CGFloat SZ_OpenAccountVertifyCodeVertifyBtnTrailing; //other:15//6p:18

#pragma CATradeOpenAccountItroduceController
CGFloat SZ_OpenAccountIntroduceStepOneTop;// 10 20
CGFloat SZ_OpenAccountIntroduceStepOneMiddle; // 8 13
CGFloat SZ_OpenAccountIntroduceStepTwoTop; // 20 40
CGFloat SZ_OpenAccountIntroduceStepTwoMiddle;// 8 13
CGFloat SZ_OpenAccountIntroduceStepThreeTop;// 30 40
CGFloat SZ_OpenAccountIntroduceStepThreeMiddle;// 8 13
CGFloat SZ_OpenAccountIntroduceAgreementTop;// 20 36
CGFloat SZ_OpenAccountIntroduceNextButtonTop;// 8 18
CGFloat SZ_OpenAccountIntroduceBankViewTitleButtom;// 4 5
CGFloat SZ_OpenAccountIntroduceBankViewTop;// 0 13
CGFloat SZ_OpenAccountIntroduceBankViewTitleTop;// 8 10
CGFloat SZ_OpenAccountIntroduceEnableBankLabelTop;// 4 10
CGFloat SZ_OpenAccountIntroduceEnableBankLbelButtom;// 7 10
CGFloat SZ_OpenAccountIntroducelineTop;// 0 5
CGFloat SZ_OpenAccountIntroduceStepOneTitleLeft;// 5 10
CGFloat SZ_OpenAccountIntroduceStepTwoTitleLeft; // 5 10
CGFloat SZ_OpenAccountIntroduceStepThreeTitleLeft; // 5 10

#pragma CATradeBrokerListController

CGFloat SZ_ATradeBrokerListArrowTrailing;    //other:12 6p:19
CGFloat SZ_ATradeBrokerListIconWidth;       //other:35 6p:46
CGFloat SZ_ATradeBrokerListIconLeading;     //other:10 6p:13
CGFloat SZ_ATradeBrokerListIconTrailing;    //other:10 6p:13
CGFloat SZ_ATradeBrokerListIconTop;         //other:8  6p:13
CGFloat SZ_ATradeBrokerListIconBottom;      //other:10  6p:15
CGFloat SZ_ATradeBrokerListContainerViewBottom;//other:10 6p:13

#pragma HotStockListViewController
CGFloat SZ_HotStockListTopViewFontSize;
CGFloat SZ_HotStockListCellNameFontSize;
CGFloat SZ_HotStockListCellSymbolFontSize;
CGFloat SZ_HotStockListCellZhfFontSize;
CGFloat SZ_HotStockListCellIndexFontSize;
CGFloat SZ_HotStockListCellRowHeight;
CGFloat SZ_HotStockListCellIndexBackViewHeight;
CGFloat SZ_HotStockListCellIndexBackViewWeight;

void initFontTypeFor6p()
{
    changeFontTypeFor6p();
    
    //某些运行中不能更改的数值，在以下初始化
    TFontTypeFor6p  fonttype = [CConfiguration sharedConfiguration].fontTypeFor6p;
    if (isiPhone6Plus && eFontTypeFor6pBig == fonttype)
    {
        //Common
        FS_NavigationBar_Title = 19.f;
        FS_CustomButton_Default = 17.f;
        SZ_CustomTabBar_Height = 49.f;
        SZ_ToolBarHeight = 49.f;
        SZ_NewsContentBottomBarHeight = 49.f;
    }
    else
    {
        FS_NavigationBar_Title = 16.f;
        FS_CustomButton_Default = 14.f;
        SZ_CustomTabBar_Height = 42.f;
        SZ_ToolBarHeight = 42.f;
        SZ_NewsContentBottomBarHeight = 42.f;
    }
    
    // 不同屏幕尺寸数据在此修改
    if(isiPhone55inch){
        SZ_InputSheetTopInset = 150;
    }else if(isiPhone47inch){
        SZ_InputSheetTopInset = 120;
    }else if(isiPhone4inch){
        SZ_InputSheetTopInset = 75;
    }else if(isiPhone35inch){
        SZ_InputSheetTopInset = 45;
    }else{
        SZ_InputSheetTopInset = 66;
    }
}

//切换字体：切换字体时，不更改导航栏和底部高度，以免界面出错
void changeFontTypeFor6p()
{
    TFontTypeFor6p  fonttype = [CConfiguration sharedConfiguration].fontTypeFor6p;
	if (isiPhone6Plus && eFontTypeFor6pBig == fonttype)
	{
        FS_isBigMode = YES;
        FS_ZoomScale = 1.1f;
        
		//abelchen add
        //// 自选列表盈亏汇总
		FS_ProfitLoss_HeaderLabel = 14.f;
		FS_ProfitLoss_HeaderContent = 22.f;
        SZ_ProfitLoss_HeaderLabelHeight = FS_ProfitLoss_HeaderLabel;
        SZ_ProfitLoss_HeaderContentHeight = FS_ProfitLoss_HeaderContent;
        SZ_ProfitLoss_HeaderTop = 10.f;
        SZ_ProfitLoss_HeaderLineMargin = 10.f;
        SZ_ProfitLoss_HeaderBottom = 10.f;
        SZ_ProfitLoss_EidtGroupNameFont = 17.f;
        SZ_ProfitLoss_BottomNameFont = 17.f;
        //// 自选列表导航头
        FS_PortfolioTableCell_NavSectionLabel = 16.f;
        SZ_PortfolioTableCell_NavSectionLabelHeight = FS_PortfolioTableCell_NavSectionLabel;
        SZ_PortfolioTableCell_NavSectionLabelMargin = 10.f;
        //// 自选列表Cell
        FS_PortfolioTableCell_Name = 20.f;
        FS_PortfolioTableCell_Code = 11.f;
        FS_PortfolioTableCell_Price = 26.f;
        FS_PortfolioTableCell_Fluctuation = 19.f;
        SZ_PortfolioTableCell_FluctuationWidth = 86.f;
        SZ_PortfolioTableCell_Left = 15.f;
        SZ_PortfolioTableCell_Top = 10.f;
        SZ_PortfolioTableCell_Bottom = 8.f;
        SZ_PortfolioTableCell_CodeMargin = 3.f;
        SZ_PortfolioTableCell_NameHeight = FS_PortfolioTableCell_Name + 4;
        SZ_PortfolioTableCell_CodeHeight = FS_PortfolioTableCell_Code;
        FS_PortfolioTableCell_Tips = 13.f;
        FS_PortfolioTableCell_LoginButton = 15.f;
        //// 个股详情页
        SZ_StockDetailBottomBar_MoreButtonWidth = 80.f;
        FS_StockDetailCPressedButtonGroup = 17.f;
        FS_StockDetailNewsCell_Title = 17.f;
        FS_StockDetailNewsCell_Date = 13.f;
        FS_StockDetailNewsCell_Detail = 15.f;
        FS_StockDetailFundManagerDetail_Font = 16.f;
        FS_StockDetailAnalysisZoushi_Font = 11.5f;
        FS_StockDetailAnalysisZouShiBGImage = 1.f;
        SZ_StockDetailNewsCell_SingleLineHeight = FS_StockDetailNewsCell_Title + 7.f;
        FS_StockDetailNewsCell_FundLabel = 19.f;
        FS_StockDetailNewsCell_WolunCode = 13.f;
        FS_StockDetailNewsCell_DropDown = 13.f;
        FS_StockDetailNewsCell_GaiNianFont = 15.f;
        FS_StockDetailNewsCell_BanKuaiWidth = 68.f;
        FS_StockDetailHBFundPrice_TopMargin = 5.f;
        FS_StockDetailFundNameForJiancheng_Width = 85.f;
        FS_StockDetailFenzhongDropViewTitleFontSize = 14.f;
        FS_StockInfoHolderHeightForGuben  = 150.f;
        //// 市场页
        FS_Market_CaptionTableCell = 15.f;
        FS_Market_SortableTableHeader = 18.f;
        FS_Market_PairedTableCell_Name = 20.f;
        FS_Market_PairedTableCell_Price = 21.f;
        FS_Market_PairedTableCell_Fluctuation = 14.f;
        FS_Market_PairedTableCell_AToB = 19.f;
        FS_Market_GlobalTableHeader = 17.f;
        FS_Market_GlobalTableCell_Name = 20.f;
        FS_Market_GlobalTableCell_Price = 20.f;
        FS_Market_GlobalTableCell_Fluctuation = 19.f;
        FS_Market_PlateInfoCell_Name = 20.f;
        FS_Market_PlateInfoCell_Fluctuation = 23.f;
        SZ_Market_NavBar_Height = 38.f;
        //// 搜索页
        FS_SearchBar_PlaceHolder = 16.f;
        FS_SearchView_Tips = 17.f;
        FS_SearchView_Item = 17.f;
        //// 持仓明细
        FS_ProfitLoss_Header_Label = 17.f;
        FS_ProfitLoss_Header_Content = 22.f;
        FS_ProfitLoss_Header_Profitloss = 30.f;
        SZ_ProfitLoss_Header_Label_Height = FS_ProfitLoss_Header_Label;
        SZ_ProfitLoss_Header_Content_Height = FS_ProfitLoss_Header_Content;
        SZ_ProfitLoss_Header_LabelContentSpace = 5.f;
        SZ_ProfitLoss_Header_LineSpace = 10.f;
        FS_ProfitLoss_Cell_Date = 13.f;
        FS_ProfitLoss_Cell_Label = 20.f;
        FS_ProfitLossFund_Header_Label = 14.f;
        FS_ProfitLossFund_Header_Content = 30.f;
        FS_ProfitLoss_Edit_Label = 21.f;
        FS_ProfitLoss_Edit_Content = 22.f;
        //// 财务页
        FS_Finance_Report_Detail_Level1 = 17.f;
        FS_Finance_Report_Detail_Level2 = 14.f;
        SZ_Finance_Report_Detail_Height = 35.f;
        FS_Finance_Report_Detail_Header = 13.f;
        SZ_Finance_Report_Detail_AddHeight = 27.f;
		
		//zheliang add
		//CStockDetail
		FS_CStockDetail_BottomButotn = 18.f;
		FS_CStockDetail_Block1_Price_1 = 57.f;
		FS_CStockDetail_Block1_Price_2 = 51.f;
		FS_CStockDetail_Block1_Price_3 = 48.f;
		FS_CStockDetail_Block1_Price_4 = 43.f;
		FS_CStockDetail_Block1_Price_5 = 35.f;
		FS_CStockDetail_Block1_Price_6 = 33.f;
        
        FS_CStockDetail_HBFund_Price_1 = 53.f;
        FS_CStockDetail_HBFund_Price_2 = 47.f;
        FS_CStockDetail_HBFund_Price_3 = 44.f;
        FS_CStockDetail_HBFund_Price_4 = 39.f;
        FS_CStockDetail_HBFund_Price_5 = 31.f;
        FS_CStockDetail_HBFund_Price_6 = 29.f;;
        
		FS_CStockDetail_Block1_Font = 21.f;
		FS_CStockDetail_Block2_Font      = 16.0f;
		FS_CStockDetail_Block2_FontSize1 = 18.0f;
		FS_CStockDetail_Block2_FontSize2 = 18.0f;
		FS_CStockDetail_Block2_FontSize3 = 28.0f;
		FS_CStockDetail_Block3_Font		 = 16.f;
		FS_CStockDetail_Block3_FontSize1 = 16.f;
        FS_CStockDetail_Block3_Toolbar   = 16.f;
        FS_CStockDetail_ProfitLoss_Title    = 15.f;
        FS_CStockDetail_ProfitLoss_Content  = 15.f;
        FS_Font10_12 = 12.f;
        FS_Font11_13 = 13.f;
        FS_Font12_14 = 14.f;
        FS_Font13_15 = 15.f;
        FS_Font14_16 = 16.f;
        FS_Font15_17 = 17.f;
        FS_Font16_18 = 18.f;
        FS_Font17_19 = 19.f;
        FS_Font18_20 = 20.f;
        FS_Font19_21 = 21.f;
        FS_Font20_22 = 22.f;
        FS_Font24_26 = 26.f;
        
        SZ_BigButtonHeight = 54.f;
        StockDetailLandScapeRTViewTitle = @"18";
        StockDetailLandScapeRTViewFont1 = @"16";
        StockDetailLandScapeRTViewFont2 = @"16";
        StockDetailGroupViewRTViewFont1 = @"16";
        StockDetailGroupViewRTViewFont2 = @"16";
        FS_CStockDetail_BOTTOMBAR_COMMENTLABEL = 13.f;

		SZ_CStockDetail_TopMarginInBlock2 = 10.f;
		SZ_CStockDetail_BottomMarginInBlock1_2 = 10.f;
		
		SZ_CStockDetail_RTViewBackgroudHeight1 = 178.f;
		SZ_CStockDetail_RTViewBackgroudHeight2 = 149.f;
		SZ_CStockDetail_RTViewBackgroudHeight3 = 172.f;
		SZ_CStockDetail_RTViewBackgroudHeight4 = 203.f;
        SZ_CStockDetail_RTViewBackgroudHeight5 = 135.f;
        
		SZ_CStockDetail_RTViewBlock1_2Height = 100.f;
		SZ_CStockDetail_RTViewBlock1_2Height_2 = 112.f;

		SZ_CStockDetail_RTViewBlock3Height = 70.f;
		SZ_CStockDetail_RTViewBlock3Height_2 = 50.f;
        
        SZ_CStockDetail_MoreViewFontSize   = 15.f;
        
        SZ_CStockDetail_RTViewFundPriceZoneRightHeight = 112.f;
        
        SZ_CStockDetail_FundPriceZoneBottom_MarginRight = 20.f;
        SZ_CStockDetail_FundPriceZoneBottomViewZhangDieHeight = 44.f;
        FS_StockDetailKJFundToolBar_TopMargin = 16.f;
        FS_StockDetailFundManagerJianJie_TopMargin = 7.f;
        
        //ATrade
        SZ_AccountHeaderCol1Width = 133.f;
        SZ_AccountHeaderCol2Leading = 27.f;
        SZ_AccountHeaderBgHeight = 168.f;
        SZ_CompetitionAccountHeaderBgHeight = 210.f;
        
        SZ_LoginViewWidth = 344.f;
        SZ_LoginViewHeight = 170.f;
        SZ_AccountButtonGroupLeadingTrailing = 20.f;
        SZ_AccountButtonGroupMargin = 30.f;
        SZ_AccountCellButtonMargin = 25.0;
        SZ_AccountCellLineHeight = 20.f;
		//CNessLis=
		FS_NewsListHeadName = 17.f;
		FS_NewListTitle = 18.f;
		FS_NewListTitleAbstract = 16.f;
		FS_NewListTitleDate = 13.f;
		
		SZ_NewsListTitle_Y = 17.f;
        //CProfitLossSummary
        SZ_CProfitLossSummaryStatisticView_Height = 213.f;
        SZ_CProfitLossSummaryGraphicView_Height = 200.f;
        SZ_CProfitLossSummaryCell_ColumnGap = 18.f;
        SZ_CProfitLossSummaryGraphicViewMaxMinRateFontSize = 12.f;
        
        SZ_Personal_EXPAND_LINE_HEIGHT = 105.f;
		//sonywang add
        FS_PriceTipsBarFontSize = 15.f;
		
		//理财通基金
		FS_TenpayFundHeadViewTitle = 18.f;
		FS_TenpayFundHeadViewSubTitle = 16.f;
        
        //图片识别
        FS_StepTitleLabelFontSize = 19.f;
        FS_StepContentLabelFontSize = 17.f;
        SZ_ImportButton_Height = 50.f;
        SZ_StepImage_Width = 30.f;
        SZ_StepImage_Height = 30.f;
        FS_ShowExampleImageLaelFontSize = 17.f;
        FS_ShowExampleProcessLabelFontSize = 17.f;
        FS_ImportButtonTileLabelFontSize = 19.f;
        SZ_ImportTopLabelHeight = 40.f;
        FS_ImportTopLabelFontSize = 18.f;
        FS_IndentifyRemindLabelFontSize = 17.f;
        FS_ResultEmptyLabelFontSize = 17.f;
        SZ_ResultEmptyImageViewHeight = 75.f;
        SZ_ResultEmptyImageViewWidth = 65.f;
        FS_ResultCellStockNameLabelFontSize = 21.f;
        FS_ResultCellStockCodeLabelFontSize = 13.f;
        FS_ResultCellImageView_Width_Height = 25.f;
        FS_ResultCell_Height = 56.f;
        
        //相册
        FS_PhotoDoneButtonFontSize = 14.f;
        
        //CATradeOpenAccountListController
        SZ_OpenAccountListIconTop = //other:10 6puls:13
        SZ_OpenAccountListIconLeading = //other:10 6puls:13
        SZ_OpenAccountListIconBottom =//other:10 6puls:13
        SZ_OpenAccountListIconTrailing = 13.f;//other:10 6puls:13
        SZ_OpenAccountListQsnameTrailing = 20.f;//other:10 6puls:20
        SZ_OpenAccountListTipsTop = 13.f;//other:8 6puls:13
        SZ_OpenAccountListTipsBottom = 12.f;//other:8 6puls:12
        
        //CATradeAccountVertifyCodeController
        SZ_OpenAccountVertifyCodePhoneLabelTop = 26.f;//other:20 6p:26
        SZ_OpenAccountVertifyCodePhoneLabelLeading = 18.f; //other:15//6p:18
        SZ_OpenAccountVertifyCodePhoneLabelTrailing = 17.f;//other:14 6p:17
        SZ_OpenAccountVertifyCodeVertifyBtnTrailing = 18.f; //other:15//6p:18
        
        //CATradeOpenAccountItroduceController
        SZ_OpenAccountIntroduceStepOneTop = 20.f;// 10 20
        SZ_OpenAccountIntroduceStepOneMiddle = 13.f; // 8 13
        SZ_OpenAccountIntroduceStepTwoTop = 40.f; // 20 40
        SZ_OpenAccountIntroduceStepTwoMiddle = 13.f;// 8 13
        SZ_OpenAccountIntroduceStepThreeTop = 40.f;// 30 40
        SZ_OpenAccountIntroduceStepThreeMiddle = 13.f;// 8 13
        SZ_OpenAccountIntroduceAgreementTop = 36.f;// 20 36
        SZ_OpenAccountIntroduceNextButtonTop = 18.f;// 8 18
        SZ_OpenAccountIntroduceBankViewTitleButtom = 5.f;// 4 5
        SZ_OpenAccountIntroduceBankViewTop = 13.f;// 0 13
        SZ_OpenAccountIntroduceBankViewTitleTop = 10.f;// 8 10
        SZ_OpenAccountIntroduceEnableBankLabelTop = 10.f;// 4 10
        SZ_OpenAccountIntroduceEnableBankLbelButtom  = 10.f;// 7 10
        SZ_OpenAccountIntroducelineTop = 5.f;// 0 5
        SZ_OpenAccountIntroduceStepOneTitleLeft = 10;// 5 10
        SZ_OpenAccountIntroduceStepTwoTitleLeft = 10; // 5 10
        SZ_OpenAccountIntroduceStepThreeTitleLeft = 10; // 5 10

        
        //CATradeBrokerListController
        SZ_ATradeBrokerListArrowTrailing = 19.f;    //other:12 6p:19
        SZ_ATradeBrokerListIconWidth = 46.f;       //other:35 6p:46
        SZ_ATradeBrokerListIconLeading = 13.f;     //other:10 6p:13
        SZ_ATradeBrokerListIconTrailing = 13.f;    //other:10 6p:13
        SZ_ATradeBrokerListIconTop = 13.f;         //other:8  6p:13
        SZ_ATradeBrokerListIconBottom = 15.f;      //other:10  6p:15
        SZ_ATradeBrokerListContainerViewBottom = 13.f;//other:10 6p:13
        
        SZ_HotStockListTopViewFontSize = 16.f;
        SZ_HotStockListCellNameFontSize = 20.f;
        SZ_HotStockListCellSymbolFontSize = 12.f;
        SZ_HotStockListCellZhfFontSize = 22.f;
        SZ_HotStockListCellIndexFontSize = 20.f;
        SZ_HotStockListCellRowHeight = 55.f;
        SZ_HotStockListCellIndexBackViewHeight = 38.f;
        SZ_HotStockListCellIndexBackViewWeight = 86.f;
	}
	else
	{
        FS_isBigMode = NO;
        FS_ZoomScale = 1.0f;
        
		//abelchen add
        //// 自选列表盈亏汇总
		FS_ProfitLoss_HeaderLabel = 12.0f;
		FS_ProfitLoss_HeaderContent = 18.0f;
        SZ_ProfitLoss_HeaderLabelHeight = FS_ProfitLoss_HeaderLabel;
        SZ_ProfitLoss_HeaderContentHeight = FS_ProfitLoss_HeaderContent;
        SZ_ProfitLoss_HeaderTop = 14.f;
        SZ_ProfitLoss_HeaderLineMargin = 5.f;
        SZ_ProfitLoss_HeaderBottom = 5.f;
        SZ_ProfitLoss_EidtGroupNameFont = 16.f;
        SZ_ProfitLoss_BottomNameFont = 15.f;
        //// 自选列表导航头
        FS_PortfolioTableCell_NavSectionLabel = 14.f;
        SZ_PortfolioTableCell_NavSectionLabelHeight = FS_PortfolioTableCell_NavSectionLabel;
        SZ_PortfolioTableCell_NavSectionLabelMargin = 10.5f;
        //// 自选列表Cell
        FS_PortfolioTableCell_Name = 17.f;
        FS_PortfolioTableCell_Code = 10.f;
        FS_PortfolioTableCell_Price = 22.f;
        FS_PortfolioTableCell_Fluctuation = 18.f;
        SZ_PortfolioTableCell_FluctuationWidth = 75.f;
        SZ_PortfolioTableCell_Left = 15.f;
        SZ_PortfolioTableCell_Top = 8.f;
        SZ_PortfolioTableCell_Bottom = 7.f;
        SZ_PortfolioTableCell_CodeMargin = 1.f;
        SZ_PortfolioTableCell_NameHeight = FS_PortfolioTableCell_Name + 4;
        SZ_PortfolioTableCell_CodeHeight = FS_PortfolioTableCell_Code;
        FS_PortfolioTableCell_Tips = 10.f;
        FS_PortfolioTableCell_LoginButton = 12.5f;
        //// 个股详情页
        SZ_StockDetailBottomBar_MoreButtonWidth = 60.f;
        FS_StockDetailCPressedButtonGroup = 14.f;
        FS_StockDetailNewsCell_Title = 15.f;
        FS_StockDetailNewsCell_Date = 12.f;
        FS_StockDetailNewsCell_Detail = 13.f;
        FS_StockDetailFundManagerDetail_Font = 14.f;
        FS_StockDetailAnalysisZoushi_Font = 11.5f;
        FS_StockDetailAnalysisZouShiBGImage = 0.f;
        SZ_StockDetailNewsCell_SingleLineHeight = FS_StockDetailNewsCell_Title + 5.f;
        FS_StockDetailNewsCell_FundLabel = 15.f;
        FS_StockDetailNewsCell_WolunCode = 12.f;
        FS_StockDetailNewsCell_DropDown = 12.f;
        FS_StockDetailNewsCell_GaiNianFont = 13.f;
        FS_StockDetailKJFundToolBar_TopMargin = 16.f;
        FS_StockDetailFundManagerJianJie_TopMargin = 5.f;
        FS_StockDetailFenzhongDropViewTitleFontSize = 14.f;
        FS_StockInfoHolderHeightForGuben  = 140.f;


        //// 市场页
        FS_Market_CaptionTableCell = 13.f;
        FS_Market_SortableTableHeader = 13.f;
        FS_Market_PairedTableCell_Name = 16.f;
        FS_Market_PairedTableCell_Price = 17.f;
        FS_Market_PairedTableCell_Fluctuation = 12.f;
        FS_Market_PairedTableCell_AToB = 15.f;
        FS_Market_GlobalTableHeader = 13.f;
        FS_Market_GlobalTableCell_Name = 16.f;
        FS_Market_GlobalTableCell_Price = 16.f;
        FS_Market_GlobalTableCell_Fluctuation = 15.f;
        FS_Market_PlateInfoCell_Name = 16.f;
        FS_Market_PlateInfoCell_Fluctuation = 20.f;
        SZ_Market_NavBar_Height = 35.f;
        //// 搜索页
        FS_SearchBar_PlaceHolder = 13.f;
        FS_SearchView_Tips = 15.f;
        FS_SearchView_Item = 14.f;
        //// 持仓明细
        FS_ProfitLoss_Header_Label = 15.f;
        FS_ProfitLoss_Header_Content = 21.f;
        FS_ProfitLoss_Header_Profitloss = 25.f;
        SZ_ProfitLoss_Header_Label_Height = FS_ProfitLoss_Header_Label;
        SZ_ProfitLoss_Header_Content_Height = FS_ProfitLoss_Header_Content;
        SZ_ProfitLoss_Header_LabelContentSpace = 3.f;
        SZ_ProfitLoss_Header_LineSpace = 8.f;
        FS_ProfitLoss_Cell_Date = 11.f;
        FS_ProfitLoss_Cell_Label = 16.f;
        FS_ProfitLossFund_Header_Label = 12.f;
        FS_ProfitLossFund_Header_Content = 25.f;
        FS_ProfitLoss_Edit_Label = 17.f;
        FS_ProfitLoss_Edit_Content = 19.f;
        //// 财务页
        FS_Finance_Report_Detail_Level1 = 15.f;
        FS_Finance_Report_Detail_Level2 = 12.f;
        SZ_Finance_Report_Detail_Height = 23.f;
        FS_Finance_Report_Detail_Header = 10.f;
        SZ_Finance_Report_Detail_AddHeight = 23.f;
		
		//zheliang add
		//CStockDetail
		FS_CStockDetail_BottomButotn = 14.f;
		FS_CStockDetail_Block1_Price_1 = 54.f;
		FS_CStockDetail_Block1_Price_2 = 48.f;
		FS_CStockDetail_Block1_Price_3 = 45.f;
		FS_CStockDetail_Block1_Price_4 = 40.f;
		FS_CStockDetail_Block1_Price_5 = 32.f;
		FS_CStockDetail_Block1_Price_6 = 30.f;
        
        FS_CStockDetail_HBFund_Price_1 = 51.f;
        FS_CStockDetail_HBFund_Price_2 = 44.f;
        FS_CStockDetail_HBFund_Price_3 = 41.f;
        FS_CStockDetail_HBFund_Price_4 = 36.f;
        FS_CStockDetail_HBFund_Price_5 = 28.f;
        FS_CStockDetail_HBFund_Price_6 = 26.f;;

		FS_CStockDetail_Block1_Font = 18.f;
		FS_CStockDetail_Block2_Font      = 14.0f;
		FS_CStockDetail_Block2_FontSize1 = 15.0f;
		FS_CStockDetail_Block2_FontSize2 = 15.0f;
		FS_CStockDetail_Block2_FontSize3 = 28.0f;
		FS_CStockDetail_Block3_Font		 = 13.f;
		FS_CStockDetail_Block3_FontSize1 = 13.5f;
        FS_CStockDetail_Block3_Toolbar   = 13.f;
        FS_CStockDetail_ProfitLoss_Title    = 13.f;
        FS_CStockDetail_ProfitLoss_Content  = 13.5f;
        FS_Font10_12 = 10.f;
        FS_Font11_13 = 11.f;
        FS_Font12_14 = 12.f;
        FS_Font13_15 = 13.f;
        FS_Font14_16 = 14.f;
        FS_Font15_17 = 15.f;
        FS_Font16_18 = 16.f;
        FS_Font17_19 = 17.f;
        FS_Font18_20 = 18.f;
        FS_Font19_21 = 19.f;
        FS_Font20_22 = 20.f;
        FS_Font24_26 = 24.f;
        
        SZ_BigButtonHeight = 45.f;

        
        StockDetailLandScapeRTViewTitle = @"16";
        StockDetailLandScapeRTViewFont1 = @"13";
        StockDetailLandScapeRTViewFont2 = @"12";
        StockDetailGroupViewRTViewFont1 = @"12";
        StockDetailGroupViewRTViewFont2 = @"12";
        FS_CStockDetail_BOTTOMBAR_COMMENTLABEL = 13.f;

		SZ_CStockDetail_TopMarginInBlock2 = 8.f;
		SZ_CStockDetail_BottomMarginInBlock1_2 = 8.f;
		SZ_CStockDetail_RTViewBackgroudHeight1 = 158.f;
		SZ_CStockDetail_RTViewBackgroudHeight2 = 129.f;
        SZ_CStockDetail_RTViewBackgroudHeight5 = 115.f;

		SZ_CStockDetail_RTViewBlock1_2Height = 88.f;
		SZ_CStockDetail_RTViewBlock1_2Height_2 = 100.f;
		SZ_CStockDetail_RTViewBlock3Height = 61.f;
		SZ_CStockDetail_RTViewBlock3Height_2 = 40.f;

        SZ_CStockDetail_MoreViewFontSize    = 14.f;
        
        SZ_CStockDetail_RTViewFundPriceZoneRightHeight = 100.f;
        
        //ATrade
        /**
         *  iphone6puls小字体时
         */
        if (isiPhone6Plus) {
            SZ_AccountHeaderCol1Width = 133.f;
            SZ_AccountHeaderCol2Leading = 27.f;
            SZ_AccountHeaderBgHeight = 168.f;
            SZ_CompetitionAccountHeaderBgHeight = 210.f;

            SZ_LoginViewWidth = 344.f;
            SZ_LoginViewHeight = 170.f;
            SZ_AccountButtonGroupLeadingTrailing = 20.f;
            SZ_AccountButtonGroupMargin = 30.f;
            SZ_AccountCellButtonMargin = 25.0;
            SZ_AccountCellLineHeight = 20.f;
            SZ_Personal_EXPAND_LINE_HEIGHT = 105.f;
            
            SZ_CStockDetail_FundPriceZoneBottom_MarginRight = 28.f;
            SZ_CStockDetail_RTViewBackgroudHeight4 = 187.f;
            SZ_CStockDetail_RTViewBackgroudHeight3 = 155.f;

            SZ_CStockDetail_FundPriceZoneBottomViewZhangDieHeight = 38.f;
            FS_StockDetailNewsCell_BanKuaiWidth = 68.f;
            FS_StockDetailHBFundPrice_TopMargin = 3.f;
            FS_StockDetailFundNameForJiancheng_Width = 85.f;
            FS_StockDetailFenzhongDropViewTitleFontSize = 14.f;
            SZ_CProfitLossSummaryGraphicViewMaxMinRateFontSize = 12.f;
        }
        else
        {
            if (isiPhone6) {
                SZ_AccountHeaderCol1Width = 125.f;
                SZ_AccountHeaderCol2Leading = 30.f;
                
                SZ_CStockDetail_FundPriceZoneBottom_MarginRight = 18.f;
                SZ_CStockDetail_RTViewBackgroudHeight4 = 187.f;
                SZ_CStockDetail_RTViewBackgroudHeight3 = 155.f;
                SZ_CStockDetail_FundPriceZoneBottomViewZhangDieHeight = 38.f;
                FS_StockDetailNewsCell_BanKuaiWidth = 61.f;
                FS_StockDetailHBFundPrice_TopMargin = 3.f;
                FS_StockDetailFundNameForJiancheng_Width = 70.f;
            }
            else{
                SZ_AccountHeaderCol1Width = 107.f;
                SZ_AccountHeaderCol2Leading = 24.f;
                
                SZ_CStockDetail_FundPriceZoneBottom_MarginRight = 8.f;
                SZ_CStockDetail_RTViewBackgroudHeight4 = 177.f;
                SZ_CStockDetail_RTViewBackgroudHeight3 = 142.f;
                SZ_CStockDetail_FundPriceZoneBottomViewZhangDieHeight = 34.f;
                FS_StockDetailNewsCell_GaiNianFont = 11.f;
                FS_StockDetailNewsCell_BanKuaiWidth = 52.f;
                FS_StockDetailHBFundPrice_TopMargin = 1.f;
                FS_StockDetailKJFundToolBar_TopMargin = 14.f;
                FS_StockDetailFundManagerJianJie_TopMargin = 6.f;
                FS_StockDetailFundManagerDetail_Font = 13.f;
                FS_StockDetailFundNameForJiancheng_Width = 70.f;

                FS_CStockDetail_HBFund_Price_1 = 46.f;
                FS_CStockDetail_HBFund_Price_2 = 39.f;
                FS_CStockDetail_HBFund_Price_3 = 36.f;
                FS_CStockDetail_HBFund_Price_4 = 33.f;
                FS_CStockDetail_HBFund_Price_5 = 23.f;
                FS_CStockDetail_HBFund_Price_6 = 21.f;;

            }
            SZ_AccountHeaderBgHeight = 154.f;
            SZ_CompetitionAccountHeaderBgHeight = 198.f;

            SZ_LoginViewWidth = 300.f;
            SZ_LoginViewHeight = 170.f;
            SZ_AccountButtonGroupLeadingTrailing = 10.f;
            SZ_AccountButtonGroupMargin = 20.f;
            SZ_AccountCellButtonMargin = 20.f;
            if (isiPhone6) {
                
                SZ_AccountCellLineHeight = 18.f;
            }
            else{
                SZ_AccountCellLineHeight = 14.0;
            }
            
            SZ_CProfitLossSummaryGraphicViewMaxMinRateFontSize = 10.f;
        }
        
        SZ_Personal_EXPAND_LINE_HEIGHT = 90.f;
    
		//CNessList
		FS_NewsListHeadName = 14.f;
		FS_NewListTitle = 16.f;
		FS_NewListTitleAbstract = 14.f;
		FS_NewListTitleDate = 12.f;

		SZ_NewsListTitle_Y = 15.f;
        //CProfitLossSummary
        SZ_CProfitLossSummaryStatisticView_Height = 213.f;
        SZ_CProfitLossSummaryGraphicView_Height = 150.f;
        SZ_CProfitLossSummaryCell_ColumnGap = 10.f;
       

		//sonywang add
        FS_PriceTipsBarFontSize = 12.f;
		
		//理财通基金
		FS_TenpayFundHeadViewTitle = 14.f;
		FS_TenpayFundHeadViewSubTitle = 13.f;
        
        //图片识别
        FS_StepTitleLabelFontSize = 15.f;
        FS_StepContentLabelFontSize = 13.f;
        SZ_ImportButton_Height = 42.f;
        SZ_StepImage_Width = 25.f;
        SZ_StepImage_Height = 25.f;
        FS_ShowExampleImageLaelFontSize = 13.f;
        FS_ShowExampleProcessLabelFontSize = 13.f;
        FS_ImportButtonTileLabelFontSize = 15.f;
        SZ_ImportTopLabelHeight = 30.f;
        FS_ImportTopLabelFontSize = 14.f;
        FS_IndentifyRemindLabelFontSize = 13.f;
        FS_ResultEmptyLabelFontSize = 13.f;
        SZ_ResultEmptyImageViewHeight = 50.f;
        SZ_ResultEmptyImageViewWidth = 45.f;
        FS_ResultCellStockNameLabelFontSize = 17.f;
        FS_ResultCellStockCodeLabelFontSize = 11.f;
        FS_ResultCellImageView_Width_Height = 25.f;
        FS_ResultCell_Height = 50.f;
        
        //相册
        FS_PhotoDoneButtonFontSize = 14.f;
        
        FS_StockDetailFenzhongDropViewTitleFontSize = 12.f;
        
        //CATradeOpenAccountListController
        SZ_OpenAccountListIconTop = //other:10 6puls:13
        SZ_OpenAccountListIconLeading = //other:10 6puls:13
        SZ_OpenAccountListIconBottom =//other:10 6puls:13
        SZ_OpenAccountListIconTrailing = 10.f;//other:10 6puls:13
        SZ_OpenAccountListQsnameTrailing = 10.f;//other:10 6puls:20
        SZ_OpenAccountListTipsTop = 8.f;//other:8 6puls:13
        SZ_OpenAccountListTipsBottom = 8.f;//other:8 6puls:12
        
        //CATradeAccountVertifyCodeController
        SZ_OpenAccountVertifyCodePhoneLabelTop = 20.f;//other:20 6p:26
        SZ_OpenAccountVertifyCodePhoneLabelLeading = 15.f; //other:15//6p:18
        SZ_OpenAccountVertifyCodePhoneLabelTrailing = 14.f;//other:14 6p:17
        SZ_OpenAccountVertifyCodeVertifyBtnTrailing = 15.f; //other:15//6p:18
        
        //CATradeOpenAccountItroduceController
        SZ_OpenAccountIntroduceStepOneTop = 10.f;// 10 20
        SZ_OpenAccountIntroduceStepOneMiddle = 8.f; // 8 13
        SZ_OpenAccountIntroduceStepTwoTop = 20.f; // 20 40
        SZ_OpenAccountIntroduceStepTwoMiddle = 8.f;// 8 13
        SZ_OpenAccountIntroduceStepThreeTop = 30.f;// 30 40
        SZ_OpenAccountIntroduceStepThreeMiddle = 8.f;// 8 13
        SZ_OpenAccountIntroduceAgreementTop = 15.f;// 20 36
        SZ_OpenAccountIntroduceNextButtonTop = 8.f;// 8 18
        SZ_OpenAccountIntroduceBankViewTitleButtom = 4.f;// 4 5
        SZ_OpenAccountIntroduceBankViewTop = 0.f;// 0 13
        SZ_OpenAccountIntroduceBankViewTitleTop = 8.f;// 8 10
        SZ_OpenAccountIntroduceEnableBankLabelTop = 4.f;// 4 10
        SZ_OpenAccountIntroduceEnableBankLbelButtom  = 7.f;// 7 10
        SZ_OpenAccountIntroducelineTop = 0.f;// 0 5
        SZ_OpenAccountIntroduceStepOneTitleLeft = 5;// 5 10
        SZ_OpenAccountIntroduceStepTwoTitleLeft = 5; // 5 10
        SZ_OpenAccountIntroduceStepThreeTitleLeft = 5; // 5 10

        
        //CATradeBrokerListController
        SZ_ATradeBrokerListArrowTrailing = 12.f;    //other:12 6p:19
        SZ_ATradeBrokerListIconWidth = 35.f;       //other:35 6p:46
        SZ_ATradeBrokerListIconLeading = 10.f;     //other:10 6p:13
        SZ_ATradeBrokerListIconTrailing = 10.f;    //other:10 6p:13
        SZ_ATradeBrokerListIconTop = 8.f;         //other:8  6p:13
        SZ_ATradeBrokerListIconBottom = 10.f;      //other:10  6p:15
        SZ_ATradeBrokerListContainerViewBottom = 10.f;//other:10 6p:13
        
        SZ_HotStockListTopViewFontSize = 14.f;
        SZ_HotStockListCellNameFontSize = 18.f;
        SZ_HotStockListCellSymbolFontSize = 11.f;
        SZ_HotStockListCellZhfFontSize = 20.f;
        SZ_HotStockListCellIndexFontSize = 18.f;
        SZ_HotStockListCellRowHeight = 48.f;
        SZ_HotStockListCellIndexBackViewHeight = 32.f;
        SZ_HotStockListCellIndexBackViewWeight = 75.f;
	}
    
}
