//
// NotificationDefines.h
// HomeService
//
// Created by zheliang on 14-7-28.
// Copyright (c) 2014年 pre-team. All rights reserved.
//

#import <Foundation/Foundation.h>

#define notification(key) k##key##Notification
#define noticication_selector(key) notify##key:

#define nc_declare_notification(key) extern NSString * const notification(key)
#define nc_define_notification(key, value) NSString * const notification(key) = value

#define NCD [NSNotificationCenter defaultCenter]

/**
 *  订阅系统通知
 */
#define nc_subscribe_sys(name_,selector_)\
[[NSNotificationCenter defaultCenter] addObserver : self selector :selector_ name : name_ object : nil]
/**
 *  取消订阅系统通知
 */
#define nc_unsubscribe_sys(name_)\
[[NSNotificationCenter defaultCenter] removeObserver : self name : name_ object : nil]


#define nc_subscribe(name_) \
    [[NSNotificationCenter defaultCenter] addObserver : self selector : @selector(noticication_selector(name_)) name : notification(name_) object : nil]
#define nc_unsubscribe(name_) \
    [[NSNotificationCenter defaultCenter] removeObserver : self name : notification(name_) object : nil]
#define nc_post(name_, userInfo_) \
    [[NSNotificationCenter defaultCenter] postNotificationName : notification(name_) object : nil userInfo : userInfo_]

#define nc_subscribe_from_sender( name_, obj_) \
    [[NSNotificationCenter defaultCenter] addObserver : self selector : @selector(noticication_selector(name_)) name : notification(name_) object : obj_]
#define nc_unsubscribe_from_sender(name_, obj_) \
    [[NSNotificationCenter defaultCenter] removeObserver : self name : notification(name_) object : obj_]
#define nc_post_from_sender( name_, obj_, userInfo_) \
    [[NSNotificationCenter defaultCenter] postNotificationName : notification(name_) object : obj_ userInfo : userInfo_]

#define nc_post_0(name_)                        nc_post(name_, nil)
#define nc_post_1(name_, data_)                 nc_post(name_, data_)
#define nc_post_2(name_, data_, sender_)        nc_post_from_sender(name_, data_, sender_)

#define nc_subscribe_0(name_)
 
