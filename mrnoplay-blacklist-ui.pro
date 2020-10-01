QT += quick
QT += quickcontrols2

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        add.cpp \
        main.cpp

TRANSLATIONS += \
    mrnoplay-blacklist-ui_zh_CN.ts \
    mrnoplay-blacklist-ui_en_US.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# The ICON Path
ICON = favicon.icns
RC_ICONS = favicon.ico
RC_FILE = ui.rc

# Define Version
VERSION = 1.0.0.0

# Define Information
QMAKE_TARGET_COMPANY = "Scris Studio"
QMAKE_TARGET_PRODUCT = "Mr Noplay Blacklist UI"
QMAKE_TARGET_DESCRIPTION = "The blacklist part for Mr Noplay"
QMAKE_TARGET_COPYRIGHT = "Copyright (c) 2019-2020 Tianze Ds Qiu from Scris Studio."
QMAKE_TARGET_BUNDLE_PREFIX = 'com.scrisstudio.'
QMAKE_PKGINFO_TYPEINFO = "Copyright (c) 2019-2020 Tianze Ds Qiu from Scris Studio."

DISTFILES += \
    favicon.ico \
    mrnoplay-blacklist-ui_en_US.ts \
    ui.rc

HEADERS += \
    add.h \
    version.h

RESOURCES += qml.qrc
