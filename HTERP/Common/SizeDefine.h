//
//  SizeDefine.h
//  QQStock
//
//  Created by zheliang on 14/12/4.
//  Copyright (c) 2014年 TencentOrganization. All rights reserved.
//

#ifndef QQStock_SizeDefine_h
#define QQStock_SizeDefine_h
//#import <Foundation/Foundation.h>

void initFontTypeFor6p();   //初始化字体，当系统初始化时调用
void changeFontTypeFor6p(); //运行中改变字体，当从设置中切换字体时调用

// FS_ for FontSize

extern CGFloat FS_ZoomScale;    //放大系数（为6p放大功能使用）
extern BOOL FS_isBigMode;       //是否大字体

//abelchen add
//分界面注释
//// 自选列表盈亏汇总
extern CGFloat FS_ProfitLoss_HeaderLabel;
extern CGFloat FS_ProfitLoss_HeaderContent;
extern CGFloat SZ_ProfitLoss_EidtGroupNameFont;
extern CGFloat SZ_ProfitLoss_BottomNameFont;
//// 自选列表导航头
extern CGFloat FS_PortfolioTableCell_NavSectionLabel;
//// 自选列表Cell
extern CGFloat FS_PortfolioTableCell_Name;
extern CGFloat FS_PortfolioTableCell_Code;
extern CGFloat FS_PortfolioTableCell_Price;
extern CGFloat FS_PortfolioTableCell_Fluctuation;
extern CGFloat FS_PortfolioTableCell_Tips;
extern CGFloat FS_PortfolioTableCell_LoginButton;
//// 个股详情页
extern CGFloat FS_StockDetailCPressedButtonGroup;
extern CGFloat FS_StockDetailNewsCell_Title;
extern CGFloat FS_StockDetailNewsCell_Date;
extern CGFloat FS_StockDetailNewsCell_Detail;
extern CGFloat FS_StockDetailNewsCell_FundLabel;
extern CGFloat FS_StockDetailNewsCell_WolunCode;
extern CGFloat FS_StockDetailNewsCell_DropDown;
extern CGFloat FS_StockDetailAnalysisZoushi_Font;
extern CGFloat FS_StockDetailAnalysisZouShiBGImage;
extern CGFloat FS_StockDetailNewsCell_GaiNianFont;
extern CGFloat FS_StockDetailNewsCell_BanKuaiWidth;
extern CGFloat FS_StockDetailHBFundPrice_TopMargin;
extern CGFloat FS_StockDetailKJFundToolBar_TopMargin;
extern CGFloat FS_StockDetailFundManagerJianJie_TopMargin;
extern CGFloat FS_StockDetailFundManagerDetail_Font;
extern CGFloat FS_StockDetailFundNameForJiancheng_Width;
extern CGFloat FS_StockDetailFenzhongDropViewTitleFontSize;
extern CGFloat FS_StockInfoHolderHeightForGuben;

//// 市场页
extern CGFloat FS_Market_CaptionTableCell;
extern CGFloat FS_Market_SortableTableHeader;
extern CGFloat FS_Market_PairedTableCell_Name;
extern CGFloat FS_Market_PairedTableCell_Price;
extern CGFloat FS_Market_PairedTableCell_Fluctuation;
extern CGFloat FS_Market_PairedTableCell_AToB;
extern CGFloat FS_Market_GlobalTableHeader;
extern CGFloat FS_Market_GlobalTableCell_Name;
extern CGFloat FS_Market_GlobalTableCell_Price;
extern CGFloat FS_Market_GlobalTableCell_Fluctuation;
extern CGFloat FS_Market_PlateInfoCell_Name;
extern CGFloat FS_Market_PlateInfoCell_Fluctuation;
extern CGFloat SZ_Market_NavBar_Height;
//// 搜索页
extern CGFloat FS_SearchBar_PlaceHolder;
extern CGFloat FS_SearchView_Tips;
extern CGFloat FS_SearchView_Item;
//// 持仓明细
extern CGFloat FS_ProfitLoss_Header_Label;
extern CGFloat FS_ProfitLoss_Header_Content;
extern CGFloat FS_ProfitLoss_Header_Profitloss;
extern CGFloat FS_ProfitLoss_Cell_Date;
extern CGFloat FS_ProfitLoss_Cell_Label;
extern CGFloat FS_ProfitLossFund_Header_Label;
extern CGFloat FS_ProfitLossFund_Header_Content;
extern CGFloat FS_ProfitLoss_Edit_Label;
extern CGFloat FS_ProfitLoss_Edit_Content;
//// 财务页
extern CGFloat FS_Finance_Report_Detail_Level1;
extern CGFloat FS_Finance_Report_Detail_Level2;
extern CGFloat SZ_Finance_Report_Detail_Height;
extern CGFloat FS_Finance_Report_Detail_Header;
extern CGFloat SZ_Finance_Report_Detail_AddHeight;
//// ATrade
extern CGFloat SZ_InputSheetTopInset;
extern CGFloat SZ_AccountHeaderCol1Width;
extern CGFloat SZ_BigButtonHeight;

//zheliang add
//Common
extern CGFloat FS_NavigationBar_Title;
extern CGFloat FS_CustomButton_Default;
extern CGFloat FS_Font10_12;
extern CGFloat FS_Font11_13;
extern CGFloat FS_Font12_14;
extern CGFloat FS_Font13_15;
extern CGFloat FS_Font14_16;
extern CGFloat FS_Font15_17;
extern CGFloat FS_Font16_18;
extern CGFloat FS_Font17_19;
extern CGFloat FS_Font18_20;
extern CGFloat FS_Font19_21;
extern CGFloat FS_Font20_22;
extern CGFloat FS_Font24_26;

//CStockDetail
extern CGFloat FS_CStockDetail_BottomButotn;
extern CGFloat FS_CStockDetail_Block1_Price_1;
extern CGFloat FS_CStockDetail_Block1_Price_2;
extern CGFloat FS_CStockDetail_Block1_Price_3;
extern CGFloat FS_CStockDetail_Block1_Price_4;
extern CGFloat FS_CStockDetail_Block1_Price_5;
extern CGFloat FS_CStockDetail_Block1_Price_6;
extern CGFloat FS_CStockDetail_Block1_Font;
extern CGFloat FS_CStockDetail_Block2_Font;
extern CGFloat FS_CStockDetail_Block2_FontSize1;
extern CGFloat FS_CStockDetail_Block2_FontSize2;
extern CGFloat FS_CStockDetail_Block2_FontSize3;
extern CGFloat FS_CStockDetail_Block3_Font;
extern CGFloat FS_CStockDetail_Block3_FontSize1;
extern CGFloat FS_CStockDetail_Block3_Toolbar;
extern CGFloat FS_CStockDetail_ProfitLoss_Title;
extern CGFloat FS_CStockDetail_ProfitLoss_Content;
extern NSString* StockDetailLandScapeRTViewTitle;
extern NSString* StockDetailLandScapeRTViewFont1;
extern NSString* StockDetailLandScapeRTViewFont2;
extern NSString* StockDetailGroupViewRTViewFont1;
extern NSString* StockDetailGroupViewRTViewFont2;
extern CGFloat FS_CStockDetail_BOTTOMBAR_COMMENTLABEL;


extern CGFloat SZ_CStockDetail_TopMarginInBlock2;
extern CGFloat SZ_CStockDetail_BottomMarginInBlock1_2;
extern CGFloat SZ_CStockDetail_RTViewBackgroudHeight1;
extern CGFloat SZ_CStockDetail_RTViewBackgroudHeight2;
extern CGFloat SZ_CStockDetail_RTViewBackgroudHeight3;
extern CGFloat SZ_CStockDetail_RTViewBackgroudHeight4;
extern CGFloat SZ_CStockDetail_RTViewBackgroudHeight5;

extern CGFloat SZ_CStockDetail_RTViewBlock1_2Height;
extern CGFloat SZ_CStockDetail_RTViewBlock1_2Height_2;

extern CGFloat SZ_CStockDetail_RTViewFundPriceZoneRightHeight;

extern CGFloat SZ_CStockDetail_RTViewBlock3Height;
extern CGFloat SZ_CStockDetail_RTViewBlock3Height_2;

extern CGFloat SZ_CStockDetail_MoreViewFontSize;
extern CGFloat SZ_CStockDetail_FundPriceZoneBottom_MarginRight;
extern CGFloat SZ_CStockDetail_FundPriceZoneBottomViewZhangDieHeight;
extern CGFloat FS_CStockDetail_HBFund_Price_1;
extern CGFloat FS_CStockDetail_HBFund_Price_2;
extern CGFloat FS_CStockDetail_HBFund_Price_3;
extern CGFloat FS_CStockDetail_HBFund_Price_4;
extern CGFloat FS_CStockDetail_HBFund_Price_5;
extern CGFloat FS_CStockDetail_HBFund_Price_6;

//ATrade
extern CGFloat SZ_AccountHeaderCol2Leading;
extern CGFloat SZ_AccountHeaderBgHeight;
extern CGFloat SZ_CompetitionAccountHeaderBgHeight;

extern CGFloat SZ_AccountButtonGroupLeadingTrailing;
extern CGFloat SZ_AccountButtonGroupMargin;

extern CGFloat SZ_AccountCellButtonMargin;
extern CGFloat SZ_AccountCellLineHeight;

extern CGFloat SZ_LoginViewWidth;
extern CGFloat SZ_LoginViewHeight;

//CNessList
extern CGFloat FS_NewsListHeadName;
extern CGFloat FS_NewListTitle;
extern CGFloat FS_NewListTitleAbstract;
extern CGFloat FS_NewListTitleDate;


//sonywang add
//分界面注释
//个股详情页提醒
extern CGFloat FS_PriceTipsBarFontSize;


//SZ_ for  ViewSize or viewMargin
//abelchen add
//分界面注释
//// 自选列表盈亏汇总
extern CGFloat SZ_ProfitLoss_HeaderLabelHeight;
extern CGFloat SZ_ProfitLoss_HeaderContentHeight;
extern CGFloat SZ_ProfitLoss_HeaderTop;
extern CGFloat SZ_ProfitLoss_HeaderLineMargin;
extern CGFloat SZ_ProfitLoss_HeaderBottom;
//// 自选列表导航头
extern CGFloat SZ_PortfolioTableCell_NavSectionLabelHeight;
extern CGFloat SZ_PortfolioTableCell_NavSectionLabelMargin;
//// 自选列表Cell
extern CGFloat SZ_PortfolioTableCell_FluctuationWidth;
extern CGFloat SZ_PortfolioTableCell_Left;
extern CGFloat SZ_PortfolioTableCell_Top;
extern CGFloat SZ_PortfolioTableCell_Bottom;
extern CGFloat SZ_PortfolioTableCell_CodeMargin;
extern CGFloat SZ_PortfolioTableCell_NameHeight;
extern CGFloat SZ_PortfolioTableCell_CodeHeight;
//// 个股详情页
extern CGFloat SZ_StockDetailBottomBar_MoreButtonWidth;
extern CGFloat SZ_StockDetailNewsCell_SingleLineHeight;
//// 持仓明细
extern CGFloat SZ_ProfitLoss_Header_Label_Height;
extern CGFloat SZ_ProfitLoss_Header_Content_Height;
extern CGFloat SZ_ProfitLoss_Header_LabelContentSpace;
extern CGFloat SZ_ProfitLoss_Header_LineSpace;

//zheliang add
//Common
extern CGFloat SZ_CustomTabBar_Height;
extern CGFloat SZ_ToolBarHeight;
extern CGFloat SZ_NewsContentBottomBarHeight;

//CNessList
extern CGFloat SZ_NewsListTitle_Y;
//CProfitLossSummary
extern CGFloat SZ_CProfitLossSummaryStatisticView_Height;
extern CGFloat SZ_CProfitLossSummaryGraphicView_Height;
extern CGFloat SZ_CProfitLossSummaryCell_ColumnGap;
extern CGFloat SZ_CProfitLossSummaryGraphicViewMaxMinRateFontSize;

//CPersonalViewController
extern CGFloat SZ_Personal_EXPAND_LINE_HEIGHT;

extern CGFloat FS_TenpayFundHeadViewTitle;
extern CGFloat FS_TenpayFundHeadViewSubTitle;
//sonywang add
//分界面注释

//图片识别
extern CGFloat FS_StepTitleLabelFontSize;
extern CGFloat FS_StepContentLabelFontSize;
extern CGFloat SZ_StepImageView_Width;
extern CGFloat SZ_ImportButton_Height;
extern CGFloat SZ_StepImage_Width;
extern CGFloat SZ_StepImage_Height;
extern CGFloat FS_ShowExampleImageLaelFontSize;
extern CGFloat FS_ShowExampleProcessLabelFontSize;
extern CGFloat FS_ImportButtonTileLabelFontSize;
extern CGFloat SZ_ImportTopLabelHeight;
extern CGFloat FS_ImportTopLabelFontSize;
extern CGFloat FS_IndentifyRemindLabelFontSize;
extern CGFloat FS_ResultEmptyLabelFontSize;
extern CGFloat SZ_ResultEmptyImageViewHeight;
extern CGFloat SZ_ResultEmptyImageViewWidth;
extern CGFloat FS_ResultCellStockNameLabelFontSize;
extern CGFloat FS_ResultCellStockCodeLabelFontSize;
extern CGFloat FS_ResultCellImageView_Width_Height;
extern CGFloat FS_ResultCell_Height;

// 相册
extern CGFloat FS_PhotoDoneButtonFontSize;

#pragma CATradeOpenAccountListController
extern CGFloat SZ_OpenAccountListIconTop;//other:10 6puls:13
extern CGFloat SZ_OpenAccountListIconLeading;//other:10 6puls:13
extern CGFloat SZ_OpenAccountListIconBottom;//other:10 6puls:13
extern CGFloat SZ_OpenAccountListIconTrailing;//other:10 6puls:13
extern CGFloat SZ_OpenAccountListQsnameTrailing;//other:10 6puls:20
extern CGFloat SZ_OpenAccountListTipsTop;//other:8 6puls:13
extern CGFloat SZ_OpenAccountListTipsBottom;//other:8 6puls:12

#pragma CATradeAccountVertifyCodeController
extern CGFloat SZ_OpenAccountVertifyCodePhoneLabelTop;//other:20 6p:26
extern CGFloat SZ_OpenAccountVertifyCodePhoneLabelLeading; //other:15//6p:18
extern CGFloat SZ_OpenAccountVertifyCodePhoneLabelTrailing;//other:14 6p:17
extern CGFloat SZ_OpenAccountVertifyCodeVertifyBtnTrailing; //other:15//6p:18

#pragma CATradeBrokerListController

#pragma CATradeOpenAccountItroduceController
extern CGFloat SZ_OpenAccountIntroduceStepOneTop;
extern CGFloat SZ_OpenAccountIntroduceStepOneMiddle;
extern CGFloat SZ_OpenAccountIntroduceStepTwoTop;
extern CGFloat SZ_OpenAccountIntroduceStepTwoMiddle;
extern CGFloat SZ_OpenAccountIntroduceStepThreeTop;
extern CGFloat SZ_OpenAccountIntroduceStepThreeMiddle;
extern CGFloat SZ_OpenAccountIntroduceAgreementTop;
extern CGFloat SZ_OpenAccountIntroduceNextButtonTop;
extern CGFloat SZ_OpenAccountIntroduceBankViewTitleButtom;
extern CGFloat SZ_OpenAccountIntroduceBankViewTop;
extern CGFloat SZ_OpenAccountIntroduceBankViewTitleTop;
extern CGFloat SZ_OpenAccountIntroduceEnableBankLabelTop;
extern CGFloat SZ_OpenAccountIntroduceEnableBankLbelButtom;
extern CGFloat SZ_OpenAccountIntroducelineTop;
extern CGFloat SZ_OpenAccountIntroduceStepOneTitleLeft;
extern CGFloat SZ_OpenAccountIntroduceStepTwoTitleLeft;
extern CGFloat SZ_OpenAccountIntroduceStepThreeTitleLeft;

extern CGFloat SZ_ATradeBrokerListArrowTrailing;    //other:12 6p:19
extern CGFloat SZ_ATradeBrokerListIconWidth;       //other:35 6p:46
extern CGFloat SZ_ATradeBrokerListIconLeading;     //other:10 6p:13
extern CGFloat SZ_ATradeBrokerListIconTrailing;    //other:10 6p:13
extern CGFloat SZ_ATradeBrokerListIconTop;         //other:8  6p:13
extern CGFloat SZ_ATradeBrokerListIconBottom;      //other:10  6p:15
extern CGFloat SZ_ATradeBrokerListContainerViewBottom;//other:10 6p:13

#pragma HotStockListViewController
extern CGFloat SZ_HotStockListTopViewFontSize;    //other:12 6p:16
extern CGFloat SZ_HotStockListCellNameFontSize;
extern CGFloat SZ_HotStockListCellSymbolFontSize;
extern CGFloat SZ_HotStockListCellZhfFontSize;
extern CGFloat SZ_HotStockListCellIndexFontSize;
extern CGFloat SZ_HotStockListCellRowHeight;
extern CGFloat SZ_HotStockListCellIndexBackViewHeight;
extern CGFloat SZ_HotStockListCellIndexBackViewWeight;




#endif
