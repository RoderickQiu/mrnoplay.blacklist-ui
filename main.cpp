#include <QDebug>
#include <QGuiApplication>
#include <QProcess>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QTranslator>

#include "add.h"

struct MArguments // Command Arguments
{
  bool LangCn; // true = lang is zh-CN
  bool FromMr; // true = is from Mr Noplay
  bool On_Off; // true = on Blacklisting
};

MArguments MAppArgs = {false, false, false};

void parseArguments() {
  // Get Command Arguments
  QStringList arguments = QCoreApplication::arguments();

  qDebug() << "Arguments : " << arguments;

  if (arguments.count() < 3)
    return;

  MAppArgs.LangCn = arguments.at(1) == "cn";
  MAppArgs.FromMr = arguments.at(2) == "_COMMAND";
  MAppArgs.On_Off = arguments.at(3) == "on";
}

QString shell_in_main(QString text) {
  QProcess process;
  process.start(text);
  process.waitForFinished();
  return QString::fromLocal8Bit(process.readAllStandardOutput());
}

int main(int argc, char *argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;
  qmlRegisterType<AddTransfer>("AddTransfer", 1, 0, "AddTransfer");
  QQuickStyle::setStyle("Universal");
  const QUrl url(QStringLiteral("qrc:/main.qml"));
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreated, &app,
      [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
          QCoreApplication::exit(-1);
      },
      Qt::QueuedConnection);

  parseArguments();

  QString qmFilename;
  static QTranslator *translator;
  if (translator != NULL) {
    qApp->removeTranslator(translator);
    delete translator;
    translator = NULL;
  }
  translator = new QTranslator;
  QString runPath;
  if (!MAppArgs.LangCn) {
    runPath = ":/mrnoplay-blacklist-ui_en_US.qm";
  } else {
    runPath = ":/mrnoplay-blacklist-ui_zh_CN.qm";
  }
  if (translator->load(runPath)) {
    qApp->installTranslator(translator);
  }

  if (!MAppArgs.FromMr) {
    const QUrl urlNotFromMr(QStringLiteral("qrc:/not-from-mr.qml"));
    engine.load(urlNotFromMr);
  } else {
    if (!MAppArgs.On_Off) {
      engine.load(url);
    } else {
      const QUrl urlBlocking(QStringLiteral("qrc:/blocking.qml"));
      engine.load(urlBlocking);
    }
  }
  return app.exec();
}

/*
 * Windeployqt
 * C:\Qt\5.9.9\5.9.9\mingw53_32\bin\windeployqt.exe
 * C:\Users\tianzeds\Documents\GitHub\release-mrnoplay-blacklist-ui\release\mrnoplay-blacklist-ui.exe
 * --qmldir C:\Qt\5.9.9\5.9.9\mingw53_32\qml
 */

/*
 * Run on macOS
 * open
 * /Users/we/Documents/GitHub/mrnoplay-blacklist-ui/release/mrnoplay-blacklist-ui.app
 * --args cn _COMMAND
 */
