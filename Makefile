TARGET := iphone:clang:latest:10.0
ARCHS := armv7

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME := TestBrowser
TestBrowser_FILES := main.m AppDelegate.m BrowserViewController.m
TestBrowser_FRAMEWORKS := UIKit WebKit
TestBrowser_CFLAGS := -fobjc-arc
TestBrowser_INSTALL_PATH := /Applications

include $(THEOS_MAKE_PATH)/application.mk
