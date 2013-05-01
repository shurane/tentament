LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := $(call all-java-files-under, src)

LOCAL_STATIC_JAVA_LIBRARIES := \
    android-common \
    android-support-v4
#	libgson \

LOCAL_PACKAGE_NAME := Tentament
LOCAL_CERTIFICATE := shared

LOCAL_PROGUARD_FLAG_FILES := proguard.flags

include $(BUILD_PACKAGE)


#LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES := libgson:lib/gson-2.2.1.jar
#include $(BUILD_MULTI_PREBUILT)

# Use the folloing include to make our test apk.
include $(call all-makefiles-under,$(LOCAL_PATH))
