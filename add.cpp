#include "add.h"
#include "stdlib.h"
#include <QDebug>
#include <QGuiApplication>
#include <QProcess>

#ifdef Q_OS_WIN32
#include "windows.h"
#include <tlhelp32.h>
#endif

bool isProcessRunning(QString processName) {
#ifdef Q_OS_WIN32
  bool ret = false;
  HANDLE proHandle = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if ((HANDLE)-1 == proHandle) {
    return false;
  }
  PROCESSENTRY32 pInfo;
  pInfo.dwSize = sizeof(PROCESSENTRY32);

  BOOL bResult = Process32First(proHandle, &pInfo);
  if (!bResult) {
    return false;
  }

  QString curProcessName;
  while (bResult) {
    curProcessName = QString("%1").arg(QString::fromUtf16(
        reinterpret_cast<const unsigned short *>(pInfo.szExeFile)));

    if (curProcessName == processName) {
      ret = true;
      break;
    }

    bResult = Process32Next(proHandle, &pInfo);
  }

  CloseHandle(proHandle);
  return ret;
#else
  return true;
#endif
}

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
#ifdef Q_OS_WIN32
  Sleep(1000);
  while (true) {
    if (!isProcessRunning("mrnoplay-blacklist-killer-windows.exe")) {
      process = new QProcess;
      process->start(text, args);
    }
    Sleep(2000);
  }
#endif
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
