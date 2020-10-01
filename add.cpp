#include "add.h"
#include "stdlib.h"
#include <QDebug>
#include <QGuiApplication>
#include <QProcess>

AddTransfer::AddTransfer() { _text = ""; }

AddTransfer::~AddTransfer() {}

QString AddTransfer::text() { return _text; }

QString shell(QString text) {
  QProcess process;
  QString shellchar;
#ifdef Q_OS_WIN32
  return text.right(text.length() - 1);
#else
  shellchar =
      "mdls -name kMDItemCFBundleIdentifier -r " + text.replace(" ", "\" \"");
#endif
  process.start(shellchar);
  process.waitForFinished();
  return QString::fromLocal8Bit(process.readAllStandardOutput());
}

void shellWithArgumentsWithoutResponse(QString text, QStringList args) {
  QProcess *process = new QProcess;
  process->start(text, args);
}

void AddTransfer::goTerminal(QString gttext) {
  if (_text != gttext) {
    _text = gttext;
    emit sig_getFromTerminal(shell(_text));
  }
}

void AddTransfer::slot_getFromTerminal(QString sgftext) { goTerminal(sgftext); }

void AddTransfer::slot_openBlocking(QString way, QStringList listnames) {
  QStringList args;
#ifdef Q_OS_WIN32
  args << way << listnames;
  QString pgmptr = _pgmptr;
  pgmptr = pgmptr.left(pgmptr.length() - 26);
  shellWithArgumentsWithoutResponse(
      pgmptr + "\\killer\\mrnoplay-blacklist-killer-windows.exe", args);
#else
  args << ((QCoreApplication::arguments().at(1) == "cn") ? "cn" : "en") << way
       << listnames;
  shellWithArgumentsWithoutResponse("/Applications/Mr Noplay Tools/mbks", args);
  qDebug() << args;
#endif
}
