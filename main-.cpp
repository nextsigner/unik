/*
    This file was created by @nextsigner 2016/2019
    Use this source code only under GPL Licence.

    For Example Connection for unik engine into uk.cpp method.
    QObject::connect(&engine, SIGNAL(warnings(QList<QQmlError>)), &u, SLOT(errorQML(QList<QQmlError>)));

*/
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>

#include <QQuickImageProvider>
#include <QSettings>

#include <QtTextToSpeech/QTextToSpeech>
#include <QLoggingCategory>
#include <QSplashScreen>

#ifndef Q_OS_ANDROID
#include <stdio.h>
#include <stdlib.h>
#endif

#ifdef Q_OS_WIN
#include <VLCQtCore/Common.h>
#include <VLCQtQml/QmlVideoPlayer.h>
#endif

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>
#include <QDateTime>
#include <QtWidgets/QMessageBox>
#include <QStandardPaths>
#include <QPluginLoader>
#include <QtWidgets/QMessageBox>
#include "uk.h"
#include "unikargsproc.h"
#ifndef Q_OS_ANDROID
#include "qmlclipboardadapter.h"
#ifndef __arm__
#include <QtWebEngine/QtWebEngine>
#endif
#else
#include <android/log.h>
#include <QtWebView>
#include <QtAndroid>
#endif

#include "audiorecorder.h"
#include "chatserver.h"
#include "unikargsproc.h"
#include "uniklogobject.h"
#include "unikimageprovider.h"


#ifdef Q_OS_ANDROID
    #ifndef __arm__
        UK *u0;
        //UK u;
    #endif

#ifdef UNIK_COMPILE_ANDROID_ARM64
        UK u;
#endif
#ifdef UNIK_COMPILE_ANDROID_ARMV7
        UK u;
#endif
#ifdef UNIK_COMPILE_ANDROID_X86
        UK u;
#endif
#ifdef UNIK_COMPILE_ANDROID_X86_64
        UK u;
#endif


       QWebSocketServer *server;
       ChatServer* chatserver;
       QWebChannel channel;
       WebSocketClientWrapper *clientWrapper;
#else
     QWebSocketServer *server;
     WebSocketClientWrapper *clientWrapper;
     QWebChannel channel;
#endif

        UnikLogObject ulo;


QByteArray debugData;
QString debugPrevio;
bool abortar=false;
#ifndef  Q_OS_ANDROID
UK u;
//A debug log method for send messages to QML LogView and stdout aplication
void unikStdOutPut(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QTextStream out(stdout);
    QByteArray localMsg = msg.toLocal8Bit();
    debugData="";
    abortar=false;
    switch (type) {
    case QtDebugMsg:
        debugData.append("Unik Debug: (");
        debugData.append(msg);
        if(context.file!=NULL){
            fprintf(stderr, "Debug: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
            debugData.append(",");
            debugData.append(context.file);
            debugData.append(",");
            debugData.append(QString::number(context.line));
            debugData.append(",");
            debugData.append(context.function);
        }else{
            fprintf(stderr, "Debug: %s\n", localMsg.constData());
        }
        debugData.append(")\n");
        break;
    case QtInfoMsg:
        debugData.append("Unik Info: (");
        debugData.append(msg);
        if(context.file!=NULL){
            fprintf(stderr, "Info: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
            debugData.append(",");
            debugData.append(context.file);
            debugData.append(",");
            debugData.append(QString::number(context.line));
            debugData.append(",");
            debugData.append(context.function);
        }else{
            fprintf(stderr, "Info: %s\n", localMsg.constData());
        }
        debugData.append(")\n");
        break;
    case QtWarningMsg:
        debugData.append("Unik Warning: (");
        debugData.append(msg);
        if(context.file!=NULL){
            fprintf(stderr, "Warning: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
            debugData.append(",");
            debugData.append(context.file);
            debugData.append(",");
            debugData.append(QString::number(context.line));
            debugData.append(",");
            debugData.append(context.function);
        }else{
            fprintf(stderr, "Warning: %s\n", localMsg.constData());
        }
        debugData.append(")\n");
        break;
    case QtCriticalMsg:
        debugData.append("Unik Critical: (");
        debugData.append(msg);
        if(context.file!=NULL){
            fprintf(stderr, "Critical: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
            debugData.append(",");
            debugData.append(context.file);
            debugData.append(",");
            debugData.append(QString::number(context.line));
            debugData.append(",");
            debugData.append(context.function);
        }else{
            fprintf(stderr, "Critical: %s\n", localMsg.constData());
        }
        debugData.append(")\n");
        break;
    case QtFatalMsg:
        debugData.append("Unik Fatal: (");
        debugData.append(msg);
        debugData.append(",");
        debugData.append(context.file);
        debugData.append(",");
        debugData.append(context.line);
        debugData.append(",");
        debugData.append(context.function);
        debugData.append(")\n");
        abortar=true;
    }
    u.log(debugData);
#ifdef Q_OS_WIN
    out << debugData;
#endif
    if(abortar){
        //abort();
    }
}
#else
static void android_message_handler(QtMsgType type,
                                    const QMessageLogContext &context,
                                    const QString &message)
{
    /*
#ifndef __arm__
     u.log(message.toUtf8());
 #else
 ulo.setLog(message.toUtf8());
 #endif*/
    qDebug()<<message.toUtf8();
    //u.log(message.toUtf8());
    android_LogPriority priority = ANDROID_LOG_DEBUG;
    switch (type) {
    case QtDebugMsg: priority = ANDROID_LOG_DEBUG; break;
    case QtWarningMsg: priority = ANDROID_LOG_WARN; break;
    case QtCriticalMsg: priority = ANDROID_LOG_ERROR; break;
    case QtFatalMsg: priority = ANDROID_LOG_FATAL; break;
    };

    __android_log_print(priority, "Qt", "%s", qPrintable(message));
}
#endif
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    app.setApplicationDisplayName("unik qml engine");
    app.setApplicationName("unik");
    app.setOrganizationDomain("http://www.unikode.org/");
    app.setOrganizationName("unikode.org");



/*#ifdef Q_OS_LINUX
     qputenv("LD_PRELOAD","/media/nextsigner/ZONA-A11/nsp/unik/build_linux/libpepflashplayer.so");
     qInfo()<<"LD_PRELOAD: "<<qgetenv("LD_PRELOAD");
     QString ffp;
     //ffp.append(qApp->applicationDirPath());
     //ffp.append("/lib/libpepflashplayer.so");
     ffp.append("/media/nextsigner/ZONA-A11/nsp/unik/build_linux/PepperFlash/32.0.0.303/libpepflashplayer.so");
     qDebug()<<"Cargando FlashPlayer "<<ffp;
     QPluginLoader* pluginLoader =
             new QPluginLoader(ffp);
     qDebug()<<"FlashPlayer Metadata: "<<pluginLoader->metaData().count();

     bool ret = pluginLoader->load();
     //QThread::sleep(10);
     if (!ret){
         qDebug()<<"Plugin Loader no cargó FlashPlayer "<<pluginLoader->errorString();
     }else{
         qDebug()<<"Plugin Loader cargó FlashPlayer ";
     }
     if (!pluginLoader->isLoaded()){
         qDebug()<<"2 Plugin Loader no cargó FlashPlayer "<<pluginLoader->isWidgetType();
     }else{
         qDebug()<<"2 Plugin Loader cargó FlashPlayer ";
     }
#endif*/


    QQmlApplicationEngine engine;

    //-->Android Permissions
#ifdef Q_OS_ANDROID
    //UK u; //For other OS this declaration is defined previus the main function
    u.setObjectName("uk3");
    auto  result = QtAndroid::checkPermission(QString("android.permission.CAMERA"));
    if(result == QtAndroid::PermissionResult::Denied){
        QtAndroid::PermissionResultMap resultHash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.CAMERA"}));
        if(resultHash["android.permission.CAMERA"] == QtAndroid::PermissionResult::Denied)
            return 0;
    }
    auto  result2 = QtAndroid::checkPermission(QString("android.permission.WRITE_EXTERNAL_STORAGE"));
    if(result2 == QtAndroid::PermissionResult::Denied){
        QtAndroid::PermissionResultMap resultHash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.WRITE_EXTERNAL_STORAGE"}));
        if(resultHash["android.permission.WRITE_EXTERNAL_STORAGE"] == QtAndroid::PermissionResult::Denied)
            return 0;
    }
    auto  result3 = QtAndroid::checkPermission(QString("android.permission.READ_EXTERNAL_STORAGE"));
    if(result3 == QtAndroid::PermissionResult::Denied){
        QtAndroid::PermissionResultMap resultHash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.READ_EXTERNAL_STORAGE"}));
        if(resultHash["android.permission.READ_EXTERNAL_STORAGE"] == QtAndroid::PermissionResult::Denied)
            return 0;
    }
    auto  result4 = QtAndroid::checkPermission(QString("android.permission.INTERNET"));
    if(result4 == QtAndroid::PermissionResult::Denied){
        QtAndroid::PermissionResultMap resultHash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.INTERNET"}));
        if(resultHash["android.permission.INTERNET"] == QtAndroid::PermissionResult::Denied)
            return 0;
    }else {
        qInfo()<<"Este dispositivo tiene permiso para INTERNET.";
    }
#endif
    //<--Android Permissions


    //--> TTS
    QLoggingCategory::setFilterRules(QStringLiteral("qt.speech.tts=true \n qt.speech.tts.*=true"));
    //∫qDebug()<<"TTS AVAILABLE ENGINES: "<<QTextToSpeech::availableEngines();
    QTextToSpeech *tts2 = new QTextToSpeech(QTextToSpeech::availableEngines().at(0));
    u.tts = qobject_cast<QTextToSpeech *>( tts2 );
    Q_ASSERT( u.tts != nullptr );
    QObject::connect(u.tts, SIGNAL(stateChanged(QTextToSpeech::State)), &u, SLOT(stateChanged(QTextToSpeech::State)));
    //qDebug()<<"TTS AVAILABLE ENGINES: "<<u.tts->availableEngines();
    u.ttsEnginesList = u.tts->availableEngines();
    QVoice currentVoice = u.tts->voice();
    foreach (QVoice voice, u.tts->availableVoices()){
        u.ttsVoices.append(voice);
        u.ttsVoicesList.append(QString("%1 - %2 - %3").arg(voice.name())
                                         .arg(QVoice::genderName(voice.gender()))
                                         .arg(QVoice::ageName(voice.age())));
        if (voice.name() == currentVoice.name())
            u.ttsCurrentVoice = u.ttsVoicesList.at(u.ttsVoicesList.count() - 1);
    }
    QVector<QLocale> locales = u.tts->availableLocales();
    QLocale current = u.tts->locale();
    foreach (const QLocale &locale, locales) {
        QString name(QString("%1 (%2)")
                     .arg(QLocale::languageToString(locale.language()))
                     .arg(QLocale::countryToString(locale.country())));
        QLocale localeVariant(locale);
        u.ttsLocales.append(name);
        u.ttsLocalesVariants.append(localeVariant);
        if (locale.name() == current.name())
            u.ttsCurrentLocale = locale;
    }
    QObject::connect(&u, &UK::ttsSelectingEngine, [&tts2](const int index){
                QString engineName = u.ttsEnginesList.at(index);
                delete tts2;
                if (engineName == "default"){
                    tts2 = new QTextToSpeech();
                }else{
                    tts2 = new QTextToSpeech(engineName);
                }
                u.tts = tts2;
        });

    engine.rootContext()->setContextProperty("ttsEngines", u.ttsEnginesList);
    engine.rootContext()->setContextProperty("ttsVoices", u.ttsVoicesList);
    engine.rootContext()->setContextProperty("ttsCurrentVoice", u.ttsCurrentVoice);
    engine.rootContext()->setContextProperty("ttsLocales", u.ttsLocales);
    //<-- TTS


    //-->Variables Declarations
    QByteArray user="unik-free";
    QByteArray key="free";
    QByteArray appArg1="";
    QByteArray appArg2="";
    QByteArray appArg3="";
    QByteArray appArg4="";
    QByteArray appArg5="";
    QByteArray appArg6="";

#ifndef __arm__
#ifdef UNIK_COMPILE_ANDROID_X86
    QByteArray urlGit="https://github.com/nextsigner/unik-android-apps";
    QByteArray moduloGit="unik-android-apps";
    QByteArray moduloZip="unik-tools";
    QByteArray urlZip="";
#else
#ifdef UNIK_COMPILE_ANDROID_X86_64
    QByteArray urlGit="https://github.com/nextsigner/unik-android-apps";
    QByteArray moduloGit="unik-android-apps";
    QByteArray moduloZip="unid-android-apps";
    QByteArray urlZip="";
#else
    QByteArray urlGit="https://github.com/nextsigner/unik-tools";
    QByteArray moduloGit="unik-tools";
    QByteArray moduloZip="unik-tools";
    QByteArray urlZip="";
#endif
#endif
#else
#ifdef Q_OS_ANDROID
    QByteArray urlGit="https://github.com/nextsigner/unik-android-apps";
    QByteArray moduloGit="unik-android-apps";
    QByteArray moduloZip="unid-android-apps";
    QByteArray urlZip="";
#else
    QByteArray urlGit="https://github.com/nextsigner/unik-tools-rpi";
    QByteArray moduloGit="unik-tools-rpi";
#endif
#endif
    QSettings settings;
    QByteArray pws;//Path Work Space
    QString ffmqml;//Folder for Main Qml
    QString appExec = argv[0];
    QDir cAppPath=QDir::current();
    QString nomVersion="";
    UnikArgsProc uap;//Object for to process arguments
    QByteArray modoDeEjecucion;
    bool showLaunch=true;
    bool install=false;
    QByteArray lba="";
    QString listaErrores;
    QString dim="";
    QString pos="";
    bool modeFolder=false;
    bool modeFolderToUpk=false;


    bool modeRemoteFolder=false;
    QString folderFrom;
    QString folderTo;
    QStringList fileList;

    bool modeUrl=false;
    bool modeUpk=false;
    bool modeGit=false;
    bool modeZip=false;
    bool modeGitArg=false;
    bool updateUnikTools=false;
    bool debugLog=false;
    bool setPass=false;
    bool setPass1=false;
    bool setPass2=false;
    bool makeUpk=false;
    bool wss=false;
    bool params=false;
    AudioRecorder ar;
    //Clipboard function for GNU/Linux, Windows and Macos
#ifndef Q_OS_ANDROID
    QmlClipboardAdapter clipboard;
#endif
    //<--Variables Declarations

    //-->Set Unik Version
    QString nv;
    QByteArray fvp;
#ifdef Q_OS_ANDROID
    fvp.append("assets:");
#else
    fvp.append(qApp->applicationDirPath());
#endif
    fvp.append("/version");
    nv = u.getFile(fvp);
    nv = QString(nv).replace("\n", "");
    app.setApplicationVersion(nv);
    //<--Set Unik Version

    //-->Load UAP
    for (int i = 0; i < argc; ++i) {
        QByteArray a;
        a.append(argv[i]);
        uap.args.append(a);
        if(a=="-nl"){
            showLaunch=false;
        }
        //>-version
        if(a=="-version"){
            qInfo()<<"Unik version: "<<nv;
            return 0;
        }
        //<-version
    }    

    if(!qApp->arguments().contains("-install")){
        uap.init();
    }
    showLaunch=uap.showLaunch;
    //<--Load UAP    


    //-->Init Components
#ifdef Q_OS_ANDROID
    QtWebView::initialize();
#else
#ifndef __arm__
    QtWebEngine::initialize();
#endif
#endif
    //<--Init Components

    //-->Setting Unik Vars
    u.pws=pws;
    //<--Setting Unik Vars


    //-->Setting Engine Vars
    u.setEngine(&engine);//Set engine for a variable access into the unik main instance.
    engine.rootContext()->setContextProperty("appExec", appExec);
    engine.addImageProvider(QLatin1String("unik"), new UnikImageProvider);
    engine.rootContext()->setContextProperty("engine", &engine);
    engine.rootContext()->setContextProperty("unik", &u);

    engine.rootContext()->setContextProperty("unikLog", u.ukStd);
    engine.rootContext()->setContextProperty("unikError", listaErrores);
    engine.rootContext()->setContextProperty("uap", uap.args);
    engine.rootContext()->setContextProperty("audioRecorder", &ar);

    //Setting any vars...
    engine.rootContext()->setContextProperty("wait", u.wait);
    engine.rootContext()->setContextProperty("splashvisible", u.splashvisible);
    engine.rootContext()->setContextProperty("setInitString", u.setInitString);
#ifndef Q_OS_ANDROID
    engine.rootContext()->setContextProperty("clipboard", &clipboard);
#else
    engine.rootContext()->setContextProperty("console", &u);
#endif
    u.debugLog = debugLog;
    engine.rootContext()->setContextProperty("debugLog", u.debugLog);
    if(dim!=""){
        engine.rootContext()->setContextProperty("dim", dim);
    }
    if(pos!=""){
        engine.rootContext()->setContextProperty("pos", pos);
    }
    //<--Setting Engine Vars




    //-->Register Types
    //Register VLC Video Player for Windows
#ifdef Q_OS_WIN
    qmlRegisterType<VlcQmlVideoPlayer>("VLCQt", 1, 0, "VlcVideoPlayer");
#endif
    //This register is deprecated.  It will be eliminated.
    qmlRegisterType<UK>("uk", 1, 0, "UK");
    //<--Register Types
    qmlRegisterType<UnikQProcess>("unik.UnikQProcess", 1, 0, "UnikQProcess");


    //-->Install a Message Handler for GNU/Linux, Windows and Macos
#ifndef Q_OS_ANDROID //->[100]
    qInstallMessageHandler(unikStdOutPut);
#else
/*#ifndef __arm__
    u0=&u;
    qInstallMessageHandler(android_message_handler);
#else
    qInstallMessageHandler(android_message_handler);
#endif*/
    //qInstallMessageHandler(android_message_handler);

#endif //<-[100]
    //<--Install a Message Handler for GNU/Linux, Windows and Macos



    //-->Set Path WorkSpace and Folder for Main QML
    pws.append(uap.ws);
    qInfo()<<"Path Unik: "<<pws;
    ffmqml.append(pws);
#ifndef __arm__
#ifdef UNIK_COMPILE_ANDROID_X86
    ffmqml.append("/unik-android-apps/");
#else
#ifdef UNIK_COMPILE_ANDROID_X86_64
    ffmqml.append("/unik-android-apps/");
#else
    ffmqml.append("/unik-tools/");
#endif
#endif
#else
#ifdef Q_OS_ANDROID
    ffmqml.append("/unik-android-apps/");
#else
    ffmqml.append("/unik-tools-rpi/");
#endif
#endif
    if(!u.folderExist(pws+"/unik")){
        u.mkdir(pws+"/unik");
    }
    if(!qApp->arguments().contains("-install")){
        QDir::setCurrent(ffmqml);
    }
    //<--Set Path WorkSpace and Folder for Main QML




    engine.rootContext()->setContextProperty("pws", pws);
    //qDebug()<<"PWS L587: "<<pws;

    //-->Load the splah QML file.
#ifdef Q_OS_ANDROID
    //engine.load("qrc:/SplashAndroid.qml");
    engine.load("qrc:/Splash.qml");
#else
#ifndef __arm__
    engine.load("qrc:/Splash.qml");
#else
    engine.load("://Splash.qml");
#endif
#endif
    //<--Load the splah QML file


    //QThread::sleep(20);



    //-->Iterator for setting all application arguments from app args or cfg.json.
    for (int i = 0; i < uap.args.length(); ++i) {
        if(uap.args.at(i)==QByteArray("-debug")){
            debugLog=true;
        }

        QString arg;
        arg.append(uap.args.at(i));

        //>-install
        if(arg.contains("-install")){
            install=true;
            break;
        }
        //<-install

        if(arg.contains("-user=")){
            QStringList marg = arg.split("-user=");
            if(marg.size()==2){
                user = "";
                user.append(marg.at(1));
            }
            setPass1=true;
        }
        if(arg.contains("-key=")){
            QStringList marg = arg.split("-key=");
            if(marg.size()==2){
                key = "";
                key.append(marg.at(1));
            }
            setPass2=true;
        }
        if(arg.contains("-dir=")){
            QStringList marg = arg.split("-dir=");
            if(marg.size()==2){
                QString ncp;
                ncp.append(marg.at(1));
                QDir fscd(ncp);
                if(!fscd.exists()){
                    fscd.mkdir(ncp);
                }
                if(!qApp->arguments().contains("-install")){
                    QDir::setCurrent(ncp);
                }

#ifndef Q_OS_WIN
                engine.addImportPath(QDir::currentPath());
                engine.addPluginPath(QDir::currentPath());
#else
                QString pip;
                pip.append("file:///");
                pip.append(QDir::currentPath());
                engine.addImportPath(pip);
                engine.addPluginPath(pip);
#endif
                qInfo()<<"-dir="<<marg.at(1);
                showLaunch=false;
                uap.showLaunch=false;
            }
        }

        //>-folder
        if(arg.contains("-folder=")){
            QStringList marg = arg.split("-folder=");
            if(marg.size()==2){
                modoDeEjecucion="-folder";
                appArg1="";
                appArg1.append(QString(marg.at(0)).replace("%20", " "));
                appArg2="";
                appArg2.append(QString(marg.at(1)).replace("%20", " "));
                QString ncp;
                ncp.append(appArg2);
                QDir fscd(ncp);
                if(!fscd.exists()){
                    fscd.mkdir(ncp);
                }
                if(!qApp->arguments().contains("-install")){
                    QDir::setCurrent(ncp);
                }
                showLaunch=false;
                uap.showLaunch=false;
                modeFolder=true;
                makeUpk=false;
                qInfo()<<"[-folder 1] Running in mode -folder="<<ncp;
                qInfo()<<"[-folder 2] Current application directory: "<<QDir::currentPath();
                updateUnikTools=false;
                params=true;
            }
        }
        //<-folder

        //>-url
        if(arg.contains("-url=")){
            QStringList marg = arg.split("-url=");
            if(marg.size()==2){
                modoDeEjecucion="-url";
                //return 0;
                appArg1="";
                appArg1.append(marg.at(0));
                appArg2="";
                appArg2.append(marg.at(1));
                qInfo()<<"[-folder 1] Running in mode -url appArg1: "<<appArg1<<" appArg2: "<<appArg2;
                return 0;
                QString ncp;
                ncp.append(appArg2);

                /*QDir fscd(ncp);
                if(!fscd.exists()){
                    fscd.mkdir(ncp);
                }
                if(!qApp->arguments().contains("-install")){
                    QDir::setCurrent(ncp);
                }*/
                /*showLaunch=false;
                uap.showLaunch=false;
                modeFolder=true;
                makeUpk=false;
                qInfo()<<"[-folder 1] Running in mode -folder="<<ncp;
                qInfo()<<"[-folder 2] Current application directory: "<<QDir::currentPath();
                updateUnikTools=false;
                params=true;*/
            }
        }
        //<-url

        //>-remoteFolder
        if(arg.contains("-folderTo=")){
            QStringList marg = arg.split("-folderTo=");
            appArg2="";
            if(marg.size()==2){
                appArg2.append(marg.at(1));
                folderTo=appArg2;
                qInfo()<<"[-remoteFolder 2] Running in mode -remoteFolder folderTo: "<<appArg2;
            }
        }
        if(arg.contains("-remoteFolder=")){
            QStringList marg = arg.split("-remoteFolder=");
            if(marg.size()==2){
                modoDeEjecucion="-remoteFolder";
                appArg1="";
                appArg1.append(marg.at(1));
                qInfo()<<"[-remoteFolder 1] Running in mode -remoteFolder url: "<<appArg1;
                if(!folderTo.isEmpty()){
                    appArg2.append(folderTo);
                    qInfo()<<"[-remoteFolder 2] Running in mode -remoteFolder folderTo: "<<appArg2;
                }else{
                    appArg2.append(u.getPath(2));
                    appArg2.append("/");
                    appArg2.append(QDateTime::currentDateTime().toString("yyyy-MM-dd-hh-mm-ss"));
                    u.mkdir(appArg2);
                    if(u.folderExist(appArg2)){
                        qInfo()<<"[-remoteFolder 2] Running in mode -remoteFolder folderTo temp: "<<appArg2;
                        folderTo=appArg2;
                        QDir fscd(folderTo);
                        if(fscd.exists()){
                            QDir::setCurrent(folderTo);
                        }
                    }
                }
                QDir fscd(folderTo);
                if(fscd.exists()){
                    QDir::setCurrent(folderTo);
                    modeRemoteFolder=true;
                    showLaunch=false;
                    uap.showLaunch=false;
                    modeFolder=false;
                    makeUpk=false;
                }
                /*QStringList marg2 = arg.split("-folderTo=");
                appArg2="";
                if(marg2.size()==2){
                    appArg2.append(marg2.at(1));
                    qInfo()<<"[-remoteFolder 2] Running in mode -remoteFolder folderTo: "<<appArg2;
                }else{
                    appArg2.append(u.getPath(2));
                    appArg2.append("/");
                    appArg2.append(QDateTime::currentDateTime().toString("yyyy-MM-dd-hh-mm-ss"));
                    u.mkdir(appArg2);
                    if(u.folderExist(appArg2)){
                        qInfo()<<"[-remoteFolder 2] Running in mode -remoteFolder folderTo temp: "<<appArg2;
                        folderTo=appArg2;
                        QDir fscd(folderTo);
                        if(fscd.exists()){
                            QDir::setCurrent(folderTo);
                            modeRemoteFolder=true;
                            showLaunch=false;
                            uap.showLaunch=false;
                            modeFolder=false;
                            makeUpk=false;
                        }
                    }else{
                        qInfo()<<"[-remoteFolder 2] Fail when make path in mode -remoteFolder folderTo temp: "<<appArg2;
                        return  0;
                    }
                }
                */
            }
        }
        if(arg.contains("-fileList=")){
            QStringList marg = arg.split("-fileList=");
            if(marg.size()==2){
                fileList=QString(marg.at(1)).split("|");
            }else{
                fileList.append("main.qml");
            }
        }else{
            fileList.append("main.qml");
        }
        //<-remoteFolder

        if(arg.contains("-zip=")){
            QStringList marg = arg.split("-zip=");
            if(marg.size()==2){
                QString pUrlZip1;
                pUrlZip1.append(marg.at(1));
                lba="";
                lba.append("-zip=");
                lba.append(marg.at(1));
                qInfo()<<lba;
                urlZip = "";
                if(pUrlZip1.contains(".zip")&&pUrlZip1.mid(pUrlZip1.size()-4, pUrlZip1.size())==".zip"){
                    urlZip.append(pUrlZip1);
                    QFileInfo infoZip(urlZip);
                    qInfo()<<"unziping fileName: "<<infoZip.fileName();
                    moduloZip=infoZip.fileName().replace(".zip","").toUtf8();
                    modeZip=true;
                    showLaunch=false;
                    uap.showLaunch=false;
                    modeZip=true;
                    params=true;
                }
            }
        }
        if(arg.contains("-git=")){
            QStringList marg = arg.split("-git=");
            if(marg.size()==2){
                QString pUrlGit1;
                pUrlGit1.append(marg.at(1));
                lba="";
                lba.append("-git=");
                lba.append(marg.at(1));
                qInfo()<<lba;
                urlGit = "";
                if(pUrlGit1.contains(".git")||pUrlGit1.mid(pUrlGit1.size()-4, pUrlGit1.size())==".git"){
                    urlGit.append(pUrlGit1.mid(0, pUrlGit1.size()-4));
                }else{
                    urlGit.append(pUrlGit1);
                }
                QString pUrlGit2 = pUrlGit1;
                QStringList m100 = pUrlGit2.split("/");
                if(m100.size()>1){
                    //moduloGit="";
                    //moduloGit.append(m100.at(m100.size()-1));
                    QString mg1=QString(m100.at(m100.size()-1));
                    QString mg2=mg1.replace(".git","");
                    QString ncp;
                    ncp.append(pws);
                    ncp.append("/");
                    ncp.append(mg2);
                    QDir fscd(ncp);
                    if(!fscd.exists()){
                        fscd.mkdir(ncp);
                    }
                    if(!qApp->arguments().contains("-install")){
                        QDir::setCurrent(ncp);
                    }
                    moduloGit="";
                    moduloGit.append(mg2);
                    modeGitArg=true;
                }
                showLaunch=false;
                uap.showLaunch=false;
                modeGit=true;
                params=true;
            }
        }
        if(arg.contains("-ws=")){
            QStringList marg = arg.split("-ws=");
            QString nws;
            nws.append(marg.at(1));
            if(marg.size()==2){
                qInfo()<<"Setting WorkSpace by user ws: "<<nws;
                bool nWSExist=false;
                QDir nWSDir(nws);
                if(nWSDir.exists()){
                    nWSExist=true;
                }else{
                    qInfo()<<"Making custom WorkSpace "<<nWSDir.currentPath();
                    nWSDir.mkpath(".");
                    if(nWSDir.exists()){
                        qInfo()<<"Custom WorkSpace now is ready: "<<nws;
                        nWSExist=true;
                    }
                }
                if(nWSExist){
                    qInfo()<<"Finishing the custom WorkSpace setting.";
                    u.setWorkSpace(nws);
                    pws.clear();
                    pws.append(nws);
                    modeGit=true;
                }
                params=true;
            }
        }
        if(arg.contains("-dim=")){
            QStringList marg = arg.split("-dim=");
            if(marg.size()==2){
                QString md0;
                md0.append(marg.at(1));
                QStringList md1=md0.split("x");
                if(md1.size()==2){
                    u.log("Dim: "+md0.toUtf8());
                    dim=md1.at(0)+"x"+md1.at(1);
                }
            }
            params=true;
        }
        if(arg.contains("-pos=")){
            QStringList marg = arg.split("-pos=");
            if(marg.size()==2){
                QString mp0;
                mp0.append(marg.at(1));
                QStringList mp1=mp0.split("x");
                if(mp1.size()==2){
                    u.log("Pos: x="+mp0.toUtf8());
                    pos=mp1.at(0)+"x"+mp1.at(1);
                }
                params=true;
            }
        }
        if(arg.contains("-wss")){
            wss=true;
            qInfo()<<"WebSocket Server init request...";
            params=true;
        }
    }
    //<--Iterator for setting all application arguments from app args or cfg.json.

    //->Comienza install gnu/linux
#ifdef Q_OS_LINUX
    if(install){
        QByteArray cf;
        cf.append(u.getPath(4));
        cf.append("/img");
        qInfo()<<"Unik Image Folder: "<<cf;
        QDir configFolder(cf);
        if(!configFolder.exists()){
            qInfo()<<"Making Unik Image Folder...";
            u.mkdir(cf);
        }
        QFile icon2(cf+"/unik.png");
        if(!icon2.exists()){
            QByteArray cf2;
            cf2.append(qApp->applicationDirPath());
            cf2.append("/default.png");
            QFile icon(cf2);
            icon.copy(cf+"/unik.png");
            qInfo()<<"Copyng unik icon file: "<<cf2<<" to "<<cf+"/unik.png";
        }
        QByteArray iconData;
        iconData.append("[Desktop Entry]\n");
        iconData.append("Categories=Development;Qt;Settings;\n");
        iconData.append("Type=Application\n");
        iconData.append("Name=unik_v");
        iconData.append(nv);
        iconData.append("\n");
        iconData.append("Exec=");
        //iconData.append(QDir::currentPath()+"/unik_v");
        //iconData.append(nv);
        //iconData.append("-x86_64.AppImage");
        iconData.append("unik");
        iconData.append("\n");
        iconData.append("Icon=");
        iconData.append(cf+"/unik.png\n");
        iconData.append("Comment=Unik Qml Engine by Unikode.org\n");
        iconData.append("Terminal=false\n");
        u.setFile("/usr/share/applications/unik.desktop", iconData);
        if(!u.fileExist("/usr/share/applications/unik.desktop")){
            qInfo()<<"Error when install Unik. Run Unik whit sudo permission for install this app into GNU/Linux";
        }else{
            qInfo()<<"Unik installed in category Development.";
        }
        if(u.fileExist("/usr/local/bin/unik")){
            u.deleteFile("/usr/local/bin/unik");
        }
        QByteArray cmdLN;
        cmdLN.append("sudo ln ");
        cmdLN.append(QDir::currentPath()+"/unik_v");
        cmdLN.append(nv);
        cmdLN.append("-x86_64.AppImage");
        cmdLN.append(" /usr/local/bin/unik");
        u.ejecutarLineaDeComandoAparte(cmdLN);
        qInfo()<<"Unik Current Path: "<<QDir::currentPath();
        return 0;
    }
#endif
    //<-Finaliza install gnu/linux


    //-->WebSockets and WebSocketServer configuration
#ifndef Q_OS_ANDROID
    //->WSS
    ChatServer* chatserver = new ChatServer(&app);
    engine.rootContext()->setContextProperty("cs", chatserver);
    engine.rootContext()->setContextProperty("cw", clientWrapper);
    QObject::connect(&u, &UK::initWSS, [=](QQmlApplicationEngine *_engine, QByteArray ip, int port, QByteArray serverName){
        qInfo()<<"Unik Server Request: "<<ip<<":"<<port<<" Server Name: "<<serverName;
        server=new QWebSocketServer(QStringLiteral("Unik QWebChannel Standalone Server"),
                                    QWebSocketServer::NonSecureMode);
        QHostAddress addr(ip.constData());

        /*for (const QHostAddress &address: QNetworkInterface::allAddresses()) {
                if (address.protocol() == QAbstractSocket::IPv4Protocol && address != localhost)
                    qDebug() <<"Local ip: "<< address.toString();
                //QHostAddress addr(192.168.1.61);
                qint64 p=5500;
                if (!server->listen(address, p)) {
                    qInfo("Failed to open web socket server.");
                    //return false;
                }else{
                    qInfo()<<"WSS listen in "<<address.toString()<<":"<<p;
                }
                if(address.toString().contains("192.168")){
                    break;
                }
            }*/



        if (!server->listen(addr, port)) {
            qInfo("Failed to open web socket server.");
            //return false;
        }else{
            qInfo()<<"WSS listen in "<<addr.toString()<<":"<<port;
        }
        clientWrapper=new WebSocketClientWrapper(server);
        QObject::connect(clientWrapper, &WebSocketClientWrapper::clientConnected,
                         &channel, &QWebChannel::connectTo);
        //
        channel.registerObject(serverName.constData(), chatserver);
        _engine->rootContext()->setContextProperty("cw", clientWrapper);
    });
    //<-WSS

    /*QWebChannel channel;
        u._channel=&channel;
        WebSocketClientWrapper *clientWrapper;
        u._clientWrapper=clientWrapper;
        ChatServer* chatserver = new ChatServer(&app);
        u._chatserver=chatserver;
        engine.rootContext()->setContextProperty("cs", u._chatserver);
        engine.rootContext()->setContextProperty("cw", u._clientWrapper);
        if(wss){
            QObject::connect(&u, &UK::initWSS, [=](const QByteArray ip, const int port, const QByteArray serverName){
                qInfo()<<"Unik Server Request: "<<ip<<":"<<port<<" Server Name: "<<serverName;

                QWebSocketServer *server;
                u._server=server;
                bool wsss=u.startWSS(ip, port, serverName);//WebSocketsServerStarted
                u._channel->registerObject(serverName.constData(), chatserver);
                qInfo()<<"Unik WebSockets Server Started: "<<wsss;

            });
        }*/
#else
    chatserver = new ChatServer(&app);
    engine.rootContext()->setContextProperty("cs", chatserver);
    engine.rootContext()->setContextProperty("cw", clientWrapper);
    QObject::connect(&u, &UK::initWSS, [=](QQmlApplicationEngine *_engine, QByteArray ip, int port, QByteArray serverName){
        qInfo()<<"Unik Server Request: "<<ip<<":"<<port<<" Server Name: "<<serverName;
        server=new QWebSocketServer(QStringLiteral("Unik QWebChannel Standalone Server"),
                                    QWebSocketServer::NonSecureMode);
        QHostAddress addr(ip.constData());
        qint64 p=5500;
        if (!server->listen(addr, p)) {
            qInfo("Failed to open web socket server.");
        }else{
            qInfo()<<"WSS listen in "<<addr.toString()<<":"<<p;
        }
        //        for (const QHostAddress &address: QNetworkInterface::allAddresses()) {
        //            if (address.protocol() == QAbstractSocket::IPv4Protocol && address != localhost)
        //                qDebug() <<"Local ip: "<< address.toString();
        //            //QHostAddress addr(192.168.1.61);
        //            qint64 p=5500;
        //            if (!server->listen(address, p)) {
        //                qInfo("Failed to open web socket server.");
        //                //return false;
        //            }else{
        //                qInfo()<<"WSS listen in "<<address.toString()<<":"<<p;
        //            }
        //            if(address.toString().contains("192.168")){
        //                break;
        //            }
        //        }

        clientWrapper=new WebSocketClientWrapper(server);
        QObject::connect(clientWrapper, &WebSocketClientWrapper::clientConnected,
                         &channel, &QWebChannel::connectTo);
        //
        channel.registerObject(serverName.constData(), chatserver);
        _engine->rootContext()->setContextProperty("cw", clientWrapper);
    });
#endif
    //<--WebSockets and WebSocketServer configuration

    //-->Check and Donwload Main Module
#ifdef Q_OS_ANDROID
    QByteArray mf;
    mf.append(pws);
    mf.append("/unik-android-apps/main.qml");
    QFile m(mf);
    if(!m.exists()){
        bool autd=u.downloadGit("https://github.com/nextsigner/unik-android-apps", pws);
    }
#else
    if(!modeGit){
        QString cut;
#ifndef __arm__
        cut.append(u.getFile(pws+"/unik-tools/main.qml"));
        QByteArray utf;//unik-tools folder
        utf.append(pws);
        if(!cut.contains("objectName: \'unik-tools\'")){
            qInfo()<<"unik-tools have any fail! repairing..."<<pws;
            bool autd=u.downloadGit("https://github.com/nextsigner/unik-tools.git", pws);
#else
        cut.append(u.getFile(pws+"/unik-tools-rpi/main.qml"));
        if(!cut.contains("objectName: \'unik-tools\'")){
            qInfo("unik-tools have any fail! repairing..."+pws.toUtf8());
            bool autd=u.downloadGit("https://github.com/nextsigner/unik-tools-rpi.git", pws.toUtf8());
#endif
            if(autd){
                qInfo()<<"unik-tools repared.";
            }else{
                qInfo()<<"unik-tools is not repared.";
            }
        }else{
            qInfo("unik-tools module is ready!");
        }
    }
#endif
    //<--Check and Donwload Main Module

    //-->Define the Main Module Location
    QString mainModLocation;
    mainModLocation.append(pws);
#ifndef Q_OS_ANDROID
    mainModLocation.append("/unik-tools");
#else
    mainModLocation.append("/unik-android-apps");
#endif

#ifdef __arm__
#ifndef Q_OS_ANDROID
    mainModLocation.append("-rpi");
#endif
#endif


    //-->Checking if exist the Main Module Path.
    qInfo()<<"Checking UTP exists...";
    QDir dirWS(pws);
    QDir dirUnikToolsLocation(mainModLocation);
    QFile mainFile(mainModLocation+"/main.qml");
    if (!dirWS.exists()||!dirUnikToolsLocation.exists()||!mainFile.exists()) {
        dirWS.mkpath(".");
        qInfo()<<"Making folder "<<pws;
        if(!dirUnikToolsLocation.exists()){
            dirUnikToolsLocation.mkpath(".");
        }
        bool unikToolDownloaded=false;
#ifndef __arm__
#ifndef Q_OS_ANDROID
        unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/unik-tools", pws);
#else
        //UNIK_COMPILE_ANDROID_X86 or UNIK_COMPILE_ANDROID_X86_64
        unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/unik-android-apps", pws);
#endif
#else
#ifdef Q_OS_ANDROID
        if(showLaunch||uap.showLaunch){
            unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/unik-android-apps", pws);
        }
#else
        unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/unik-tools-rpi", pws.toUtf8());
#endif
#endif


        //Log the Main Module Download Status.
        lba="";
#ifndef Q_OS_ANDROID
        lba.append("Unik-Tools ");
#else
        lba.append("unik-android-apps ");
#endif
        if(unikToolDownloaded){
            lba.append("downloaded.");
        }else {
            lba.append("is not downloaded!");
        }
        qInfo()<<lba;
    }else{
        qInfo()<<"Folder "<<pws<<" pre existent.";
    }
    //<--Checking if exist the Main Module Path.

    //---------------------------->1
    //Direct upk mode.
    if((argc == 2||argc == 3||argc == 4)&&!modeGit&&!modeRemoteFolder){
        QString argUpk;
        argUpk.append(argv[1]);
        QString ext=argUpk.mid(argUpk.size()-4,argUpk.size());
        if(ext==".upk"){
            qInfo()<<"Run mode upk direct file.";
            appArg1=QByteArray(argv[1]);
            modeGit=false;
            modeUrl=false;
            modeZip=false;
            modeFolder=false;
            modeFolderToUpk=false;
            modeRemoteFolder=false;
            modeUpk=true;
            updateUnikTools=false;
        }
    }

    //MODO -upk
    if((argc == 2||argc == 3||argc == 4||argc == 5||argc == 6)&&!modeGit&& QByteArray(argv[1])==QByteArray("-upk")){
        u.log("Loanding from mode -upk...");
        QString argUpk;
        argUpk.append(argv[2]);
        QString ext=argUpk.mid(argUpk.size()-4,argUpk.size());
        u.log("File extension: "+ext.toUtf8());
        if(ext==".upk"){
            if(debugLog){
                u.log("Run mode upk file.");
            }

            modeUpk=true;
            modeFolder=false;
            modeRemoteFolder=false;
            modeGit=false;
            modeFolderToUpk=false;
            updateUnikTools=false;
        }else{
            u.log("Upk file not valid: "+argUpk.toUtf8());
        }
    }

    //MODO -foldertoupk
    if((argc == 5||argc == 6) && QByteArray(argv[1])==QByteArray("-foldertoupk")){
        modoDeEjecucion="-foldertoupk";
        appArg1=QByteArray(argv[2]);
        appArg2=QByteArray(argv[3]);
        appArg3=QByteArray(argv[4]);

        modeFolderToUpk=true;
        makeUpk=false;
        updateUnikTools=false;
        if(debugLog){
            qInfo()<<"Prepare mode -foldertoupk.";
        }
    }

    //MODO -remoteFolder
    if(modeRemoteFolder){
        modoDeEjecucion="-remoteFolder";
        //appArg1=QByteArray(argv[2]);
            //appArg2=QByteArray(argv[3]);
            //appArg3=QByteArray(argv[4]);
            /*QByteArray ncf;
            ncf.append("{\"mode\":\"");
            ncf.append(argv[1]);
            ncf.append("\",");
            ncf.append("\"arg1\":\"");
            ncf.append(appArg1);
            ncf.append("\",");
            ncf.append("\"arg2\":\"");
            ncf.append(appArg2);
            ncf.append("\",");
            ncf.append("\"arg3\":\"");
            ncf.append(appArg3);
            ncf.append("\"}");
            QByteArray r;
            r.append(urlConfigJson);
            u.deleteFile(r);
            u.setFile(r, ncf);*/
        modeRemoteFolder=true;
        modeGit=false;
        modeUpk=false;
        modeZip=false;
        makeUpk=false;
        updateUnikTools=false;
        showLaunch=false;
    }

//    //->Comienza configuracion OS
//#ifdef Q_OS_LINUX
//    if(install){
//        QByteArray cf;
//        cf.append(u.getPath(4));
//        cf.append("/img");
//        qInfo()<<"Unik Image Folder: "<<cf;
//        QDir configFolder(cf);
//        if(!configFolder.exists()){
//            qInfo()<<"Making Unik Image Folder...";
//            u.mkdir(cf);
//        }
//        QFile icon2(cf+"/unik.png");
//        if(!icon2.exists()){
//            QByteArray cf2;
//            cf2.append(qApp->applicationDirPath());
//            cf2.append("/default.png");
//            QFile icon(cf2);
//            icon.copy(cf+"/unik.png");
//            qInfo()<<"Copyng unik icon file: "<<cf2<<" to "<<cf+"/unik.png";
//        }
//        QByteArray iconData;
//        iconData.append("[Desktop Entry]\n");
//        iconData.append("Categories=Development;Qt;Settings;\n");
//        iconData.append("Type=Application\n");
//        iconData.append("Name=unik_v4.02.1\n");
//        iconData.append("Exec=");
//        iconData.append(qApp->applicationDirPath()+"/unik");
//        iconData.append("\n");
//        iconData.append("Icon=");
//        iconData.append(cf+"/unik.png\n");
//        iconData.append("Comment=Unik Qml Engine by Unikode.org\n");
//        iconData.append("Terminal=false\n");
//        u.setFile("/usr/share/applications/unik.desktop", iconData);
//        if(!u.fileExist("/usr/share/applications/unik.desktop")){
//            qInfo()<<"Error when install Unik. Run Unik whit sudo permission for install this app into GNU/Linux";
//            return 0;
//        }else{
//            qInfo()<<"Unik installed in category Development.";
//        }

//    }
//#endif
//    //<-Finaliza configuracion OS
    //----------------------------<1



    //-------------------------------------->2
    //Define temp folder name.
    QByteArray tempFolder;
    tempFolder.append(QDateTime::currentDateTime().toString("hhmmss"));

    QDir dir0(ffmqml);
    if (!dir0.exists()) {
        dir0.mkpath(".");
    }
    QString appName;
    qInfo()<<"Count standar no uap arguments: "<<argc;
//    if(modeUpk){
//        qInfo("Mode Upk 1 procces...");
//        if(debugLog){
//            qDebug()<<"Upk filename: "<<appArg1;
//            qDebug()<<"Upk user: "<<user;
//            qDebug()<<"Upk key: "<<key;
//        }
//        QString sl2;
//        sl2.append(appArg1);
//        QString pathCorr;
//        pathCorr = sl2.replace("\\", "/");
//        QByteArray urlUpkCorr;
//        urlUpkCorr.append(pathCorr);
//        QStringList mAppName = sl2.split("/");
//        QString nan = mAppName.at(mAppName.size()-1);
//        //appName=nan.replace(".upk", "");
//        if(pathCorr.mid(pathCorr.size()-4, pathCorr.size()-1)==QString(".upk")){
//            QByteArray err;
//            if(debugLog){
//                lba="";
//                lba.append("UPK detected: ");
//                lba.append(pathCorr);
//                qInfo()<<lba;
//            }
//        }
//        QByteArray tf;
//        tf.append(QDateTime::currentDateTime().toString("hhmmss"));
//        ffmqml="";
//        ffmqml.append(QStandardPaths::standardLocations(QStandardPaths::TempLocation).last());
//        ffmqml.append("/");
//        ffmqml.append(tf);
//        u.mkdir(ffmqml);
//        ffmqml.append("/");
//        QFile upkCheck(urlUpkCorr);
//        if(upkCheck.exists()&&u.upkToFolder(urlUpkCorr, user, key, ffmqml.toUtf8())){
//            if(debugLog){
//                lba="";
//                lba.append(argv[1]);
//                lba.append(" extract successful...");
//                qInfo()<<lba;
//            }
//            QStringList sl =sl2.split("/");
//            QByteArray nAppName;
//            nAppName.append(sl.at(sl.size()-1));
//            updateUnikTools=false;
//        }else{
//            if(!upkCheck.exists()){
//                listaErrores.append("Upk file does not exist!\n");
//            }else{
//                listaErrores.append("Upk unpack fail!\n");
//                if(user!="unik-free"||key!="free"){
//                    listaErrores.append("User or key pass error. \n \n");
//                }
//                if(debugLog){
//                    lba="";
//                    lba.append(argv[1]);
//                    lba.append(" extract no successful...");
//                    qInfo()<<lba;
//                }
//            }
//        }
//    }

    if(modeFolder){
        ffmqml = "";
        ffmqml.append(appArg2);
        ffmqml.append("/");
        u.mkdir(ffmqml);
        QString cmn;
        cmn.append(ffmqml);
        u.setProperty("currentModule", cmn);
    }
    if(!modeFolder&&modeGit){
        ffmqml = "";
        ffmqml.append(pws);
        ffmqml.append("/");
        ffmqml.append(moduloGit);
        ffmqml.append("/");
        u.mkdir(ffmqml);
        QString cmn;
        cmn.append(urlGit);
        cmn.append(" ");
        cmn.append(ffmqml);
        u.setProperty("currentModule", cmn);
    }
    QString arg1Control;
    QByteArray upkFileName;
    if(modeUpk){
        qInfo("Mode Upk 2 procces...");
        if(debugLog){
            lba="";
            lba.append("Prepare mode upk...");
            lba.append(" arg1: ");
            lba.append(appArg1);
            lba.append(" arg2: ");
            lba.append(user);
            lba.append(" arg3: ");
            lba.append(key);
            /*lba.append(" arg4: ");
                lba.append(appArg4);*/
            qInfo()<<lba;
        }

        //upk file
        QString arg1;
        arg1.append(appArg1);

        //Usuario
        QString arg2;
        arg2.append(user);

        //Clave
        QString arg3;
        arg3.append(key);

        //AppName
        QString arg4;
        arg4.append(arg1.replace(".upk", ""));

#ifdef Q_OS_WIN32
        QStringList sl =arg4.replace("\\","/").split("/");
#else
        QStringList sl =arg4.split("/");
#endif


        QByteArray nAppName;
        nAppName.append(sl.at(sl.size()-1));
        if(nAppName!=""){
            if(debugLog){
                lba="";
                lba.append("Run upkToFolder(\"");
                lba.append(arg1);
                lba.append("\", \"");
                lba.append(arg2);
                lba.append("\", \"");
                lba.append(arg3);
                lba.append("\", \"");
                lba.append(tempFolder);
                lba.append("\");");
                qInfo()<<lba;
            }

            QString tf;
            tf.append(u.getPath(2));
            tf.append("/");
            tf.append(tempFolder);
            //ir a upk
            //qInfo()<<"Extrayendo "<<arg1.toUtf8()<<" "<<user<<" "<<key<<" "<<tf;
            if(u.upkToFolder(arg1.toUtf8()+".upk", user, key, tf.toUtf8())){
            //if(true){
                if(setPass){
                    //user = arg2.toLatin1();
                    //key = arg3.toLatin1();
                }
                lba="";
                lba.append(nAppName);
                lba.append(".upk extraido: ");
                lba.append(pws);
                lba.append("/");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
                ffmqml = "";
                ffmqml.append(tf);
                ffmqml.append("/");
                QDir::setCurrent(ffmqml);
                showLaunch=false;
                modeUpk=true;
                uap.showLaunch=false;
                //appName = nAppName;
                //return 0;
            }else{
                lba="";
                lba.append("Error at extract ");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
            }
            upkFileName.append(pws);
            upkFileName.append("/");
            upkFileName.append(nAppName);
            upkFileName.append(".upk");
            if(debugLog){
                lba="";
                lba.append("Upk filename: ");
                lba.append(upkFileName);
                qInfo()<<lba;
            }
        }
    }
    //--------------------------------------<2


    //----------------------------------------->3
    if(modeFolderToUpk){
        if(debugLog){
            lba="";
            lba.append("Prepare mode folder to upk...");
            lba.append("arg1: ");
            lba.append(appArg1);
            lba.append(" arg2: ");
            lba.append(appArg2);
            lba.append(" arg3: ");
            lba.append(appArg3);
            lba.append(" arg4: ");
            lba.append(appArg4);
            qInfo()<<lba;
        }

        //Carpeta para upk
        QByteArray arg1;
        arg1.append(argv[2]);

        //Usuario
        QString arg2;
        arg2.append(user);

        //Clave
        QString arg3;
        arg3.append(key);

        //AppName
        QString arg4;
        arg4.append(arg1);
#ifdef Q_OS_WIN32
        QStringList sl =arg4.replace("\\","/").split("/");
#else
        QStringList sl =arg4.split("/");
#endif

        QByteArray nAppName;
        nAppName.append(sl.at(sl.size()-1));
        if(nAppName!=""){
            if(debugLog){
                lba="";
                lba.append("Run folderToUpk(\"");
                lba.append(arg1);
                lba.append("\", \"");
                lba.append(nAppName);
                lba.append("\", \"");
                lba.append(arg2);
                lba.append("\", \"");
                lba.append(arg3);
                lba.append("\", \"");
                lba.append(pws);
                lba.append("\");");
                lba.append(" user: ");
                lba.append(user);
                lba.append(" key: ");
                lba.append(key);
                qInfo()<<lba;
            }

            qInfo()<<"folderToUpk: "<<arg1<<" "<<nAppName<<" "<<arg2<<" "<<arg3<<" "<<pws;
            if(u.folderToUpk(arg1, nAppName, arg2, arg3, pws)){
                if(setPass){
                    //user = arg2.toLatin1();
                    //key = arg3.toLatin1();
                }
                lba="";
                lba.append(nAppName);
                lba.append(".upk creado: ");
                lba.append(pws);
                lba.append("/");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
                appName = nAppName;
            }else{
                lba="";
                lba.append("Error al crear ");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
            }
            upkFileName.append(pws);
            upkFileName.append("/");
            upkFileName.append(appName);
            upkFileName.append(".upk");
            QByteArray fd;
            fd.append(u.getPath(2));
            fd.append("/");
            fd.append(tempFolder);
            QDir dfd(fd);
            dfd.mkpath(".");
            qInfo()<<"Upk filename: "<<upkFileName;
            qInfo()<<"Upk folder: "<<fd;
            if(u.upkToFolder(upkFileName, user, key, fd)){
                qInfo()<<appName<<" extract successful...";
                updateUnikTools=false;
                ffmqml.clear();
                ffmqml.append(fd);
                ffmqml.append("/");
                //engine2.rootContext()->setContextProperty("upkActivo", appName);
            }
            //rewriteUpk=true;
        }
    }
    if(modeRemoteFolder){
        QString remoteMain;
        remoteMain.append(appArg1);
        for (int i=0;i<fileList.size();i++) {
            qDebug()<<"-remoteFolder downloading "<<fileList.at(i);
            u.downloadRemoteFolder(remoteMain, fileList.at(i), folderTo);
        }

        ffmqml = "";
        ffmqml.append(folderTo);
        ffmqml.append("/");
        qDebug()<<"2 unik working in mode: -remoteFolder "<<ffmqml;
    }
    //-----------------------------------------<3



    //------------------------------------------>4
    //engine.rootContext()->setContextProperty("ver", true);
    engine.rootContext()->setContextProperty("version", app.applicationVersion());
    engine.rootContext()->setContextProperty("host", u.host());
    engine.rootContext()->setContextProperty("appName", appName);
    engine.rootContext()->setContextProperty("upkExtractLocation", ffmqml);
    engine.rootContext()->setContextProperty("sourcePath", ffmqml);
    engine.rootContext()->setContextProperty("unikDocs", pws);
    engine.rootContext()->setContextProperty("pws", pws);
    //engine.rootContext()->setContextProperty("upk", "");
    //engine.rootContext()->setContextProperty("splashsuspend", false);

    u.setProperty("splashsuspend", false);
    u.setProperty("launcherLoaded", false);

    u.setProperty("currentModule", "Unik Qml Engine");

    QString pwsFolderModel;
#ifdef Q_OS_WIN
    //pwsFolderModel.append("file:///");
    pwsFolderModel.append(pws);
    engine.rootContext()->setContextProperty("appsDir", pwsFolderModel);
#else
    engine.rootContext()->setContextProperty("appsDir", pws);
#endif

    //------------------------------------------<4


    //------------------------------------------->5
    QString qmlImportPath;
    /*if(modeRemoteFolder){
        ffmqml = "";
        ffmqml.append(appArg3);
        ffmqml.append("/");
    }*/

    QByteArray mainQml;
    mainQml.append(ffmqml.replace("%20", " "));
    mainQml.append("main.qml");
    qInfo()<<"[0] main: "<<mainQml;

    /*if(modeZip){
        lba="";
        lba.append("Updating from zip file: ");
        lba.append(urlZip);
        qInfo()<<lba;
        QByteArray unzipFolder;
        unzipFolder.append(pws);
        //unzipFolder.append("/");
        //unzipFolder.append(moduloZip);
        qInfo()<<"unziping to folder "<<unzipFolder;
        lba="";
        lba.append("Unziping in folder ");
        lba.append(unzipFolder);
        qInfo()<<lba;
        qInfo()<<"unzip file 1 "<<urlZip;
        bool up=u.runAppFromZip(urlZip, unzipFolder);
        if(up){
            qInfo()<<"Zip unzipped.";
            QString nCurrentDir=unzipFolder;
            nCurrentDir.append("/");
            nCurrentDir.append(moduloZip);
            QDir::setCurrent(nCurrentDir);
            mainQml.clear();
            mainQml.append(nCurrentDir);
            mainQml.append("/main.qml");
            qInfo()<<"Set current dir to zip folder: "<<nCurrentDir;
        }else{
            lba="";
            lba.append("Fail Unzip file: ");
            lba.append(urlZip);
            qInfo()<<lba;
        }
        qInfo()<<"[1] main: "<<mainQml;
        u.log("Updated: "+ffmqml.toUtf8());
    }

    */

    if(modeGit){
        lba="";
        lba.append("Updating from github: ");
        lba.append(urlGit);
        qInfo()<<lba;
        QByteArray tmpZipPath;
        tmpZipPath.append(pws);
        //u.mkdir(tmpZipPath);
        lba="";
        lba.append("Downloading Zip in folder ");
        lba.append(tmpZipPath);
        qInfo()<<lba;
        qInfo()<<"downloadGit() 1"<<urlGit;
        bool up=u.downloadGit(urlGit, tmpZipPath);
        if(up){
            lba="";
            lba.append("Zip downloaded.");
            qInfo()<<lba;
            QString cmn;
            cmn.append(urlGit);
            cmn.append(" ");
            cmn.append(tmpZipPath);
            u.setProperty("currentModule", cmn);
        }else{
            lba="";
            lba.append("Fail Zip download: ");
            lba.append(urlGit);
            qInfo()<<lba;
        }
        /*mainQml="";
            mainQml.append(QDir::currentPath());
            mainQml.append("/main.qml");*/
        qInfo()<<"[1] main: "<<mainQml;
        u.log("Updated: "+ffmqml.toUtf8());
    }

    QByteArray log4;

    log4.append("\nExecute mode: ");
    log4.append(modoDeEjecucion);
    log4.append("\n");

    log4.append("unik version: ");
    log4.append(app.applicationVersion());
    log4.append("\n");

    log4.append("Work Space: ");
    log4.append(settings.value("ws").toString().toUtf8());
    log4.append("\n");

    log4.append("modeFolder: ");
    log4.append(modeFolder ? "true" : "false");
    log4.append("\n");

    log4.append("modeGit: ");
    log4.append(modeGit ? "true" : "false");
    log4.append("\n");

    log4.append("modeFolderToUpk: ");
    log4.append(modeFolderToUpk ? "true" : "false");
    log4.append("\n");

    log4.append("modeRemoteFolder: ");
    log4.append(modeRemoteFolder ? "true" : "false");
    log4.append("\n");

    log4.append("modeUpk: ");
    log4.append(modeUpk ? "true" : "false");
    log4.append("\n");

    log4.append("makeUpk: ");
    log4.append(makeUpk ? "true" : "false");
    log4.append("\n");

    log4.append("setPass: ");
    log4.append(setPass ? "true" : "false");
    log4.append("\n");

    log4.append("DebugMode: ");
    log4.append(debugLog ? "true" : "false");
    log4.append("\n");

    QObject::connect(&engine, SIGNAL(warnings(QList<QQmlError>)), &u, SLOT(errorQML(QList<QQmlError>)));
    QObject::connect(&engine, &QQmlEngine::warnings, [=](QList<QQmlError> le){
        u.setUWarning(le.last().toString());
    });


    engine.rootContext()->setContextProperty("appStatus", log4);
    //if(u.debugLog){
        qInfo()<<log4;
    //}

     /*if (!engine.rootObjects().isEmpty()){
         for (int i=0;i<engine.rootObjects().count();i++) {
             QObject *aw0 = engine.rootObjects().at(i);
             if(aw0->property("objectName")=="awsplash"){
                 aw0->setProperty("ver", false);
                 //engine.rootContext()->setContextProperty("ver", false);
             }
         }
    }*/

    if (!engine.rootObjects().isEmpty()){
        //u.splashvisible=false;
        u.splashvisible=true;
        engine.rootContext()->setContextProperty("splashvisible", u.splashvisible);
    }
#ifdef Q_OS_WIN
    //qmlImportPath.append("C:/Users/qt/Documents/unik/unik-tools");
    qmlImportPath.append(ffmqml);
    engine.addImportPath(qmlImportPath);
    engine.addPluginPath(qmlImportPath);
    qInfo()<<"Import Path: "<<qmlImportPath;
    qInfo()<<"Current Dir: "<<QDir::currentPath();
    qInfo()<<"Engine Import Paths: "<<engine.importPathList();
    qInfo()<<"Engine Plugin Paths: "<<engine.pluginPathList();
    qInfo()<<"QLibraryInfo::Qml2ImportsPath: "<<QLibraryInfo::Qml2ImportsPath;

    /*if(uap.showLaunch||showLaunch){
                mainQml="qrc:/appsListLauncher.qml";
                engine.load(QUrl::fromLocalFile(mainQml));
                QQmlComponent component(&engine, QUrl(QStringLiteral("qrc:/appsListLauncher.qml")));
            }else{
                engine.load(QUrl::fromLocalFile(mainQml));
                QQmlComponent component(&engine, QUrl::fromLocalFile(mainQml));
            }*/
    /*QByteArray prevMainQml=mainQml;
    mainQml=uap.showLaunch||showLaunch?":/appsListLauncher.qml":prevMainQml;
    engine.load(uap.showLaunch||showLaunch?QUrl(QStringLiteral("qrc:/appsListLauncher.qml")):QUrl::fromLocalFile(mainQml));
    QQmlComponent component(&engine, uap.showLaunch||showLaunch?QUrl(QStringLiteral("qrc:/appsListLauncher.qml")):QUrl::fromLocalFile(mainQml));
    qInfo()<<"Init unik: "<<mainQml;
    */
    // engine.load(QUrl(QStringLiteral("qrc:/appsListLauncher.qml")));
    //engine.load(mainQml);
    //engine.load(QUrl::fromLocalFile(mainQml));
    //QQmlComponent component(&engine, QUrl(QStringLiteral("qrc:/main.qml")));
    //QQmlComponent component(&engine, QUrl::fromLocalFile(mainQml));
    /*QQuickWindow *window = qobject_cast<QQuickWindow*>(engine.rootObjects().at(0));
            if (!window) {
                qFatal("Error: Your root item has to be a window.");
                return -1;
            }
            window->show();
            QQuickItem *root = window->contentItem();

            QQmlComponent component(&engine, QUrl("qrc:/Button.qml"));
            QQuickItem *object = qobject_cast<QQuickItem*>(component.create());

            QQmlEngine::setObjectOwnership(object, QQmlEngine::CppOwnership);

            object->setParentItem(root);
            object->setParent(&engine);

            object->setProperty("color", QVariant(QColor(255, 255, 255)));
            object->setProperty("text", QVariant(QString("foo")));
            */

    //u.log("Unik Application initialized.");


#else
    qmlImportPath.append(ffmqml);
    QString ncqmls;
    ncqmls.append(ffmqml.mid(0,ffmqml.size()-1).replace("/", "\\"));
    qmlImportPath.append(ncqmls);
    engine.addImportPath(ffmqml);
    engine.addImportPath(QDir::currentPath());
    //engine.addPluginPath("/sdcard/Documents/unik/unik-ws-android-client-1");
#ifdef UNIK_COMPILE_ANDROID_X86
    engine.addPluginPath("assets:/lib/x86");
#endif
#ifdef UNIK_COMPILE_ANDROID_X86_64
    engine.addPluginPath("assets:/lib/x86");
    engine.addPluginPath("assets:/lib/x86_64");
    engine.addPluginPath("assets:/lib/x86-64");
#endif

    QString unikPluginsPath;
    unikPluginsPath.append(u.getPath(1));
    unikPluginsPath.append("/unikplugins");
    engine.addImportPath(unikPluginsPath);
    qInfo()<<"Imports Paths List: "<<engine.importPathList();
    qInfo()<<"Plugins Paths List: "<<engine.pluginPathList();
#ifdef __arm__
    engine.addImportPath("/home/pi/unik/qml");
#endif
    //Probe file is for debug any components in the build operations. Set empty for release.
    QByteArray probe = "";
    //probe.append("qrc:/probe.qml");
    qInfo()<<"showLaunch: "<<showLaunch;
    qInfo()<<"uap.showLaunch: "<<uap.showLaunch;
    QByteArray prevMainQml=mainQml;
    mainQml=uap.showLaunch||showLaunch?":/appsListLauncher.qml":prevMainQml;

    engine.addImportPath(qmlImportPath);
    QByteArray m1;
    m1.append(qmlImportPath);
    QByteArray m2;
    m2.append(mainQml);
#endif

    //-------------------------------------------<5



    /*QQmlComponent component(&engine, uap.showLaunch||showLaunch?QUrl(QStringLiteral("qrc:/appsListLauncher.qml")):QUrl::fromLocalFile(mainQml));
    QObject::connect(&component, &QQmlComponent::progressChanged, [&component](){
        qInfo()<<"Progreso del componente: "<<component.progress();
    });*/

     /*wQObject::connect(&engine, &QQmlApplicationEngine::objectCreated, [=](QObject *object, const QUrl &url){
        qInfo()<<"Unik Object created: ObjectName="<<object->objectName()<<" Url="<<url;
    });*/


    int vsf=0;
    QObject::connect(&u, &UK::splashFinished, [&vsf, &engine, &uap, showLaunch, mainQml, &listaErrores](){
        if (vsf==0){
            vsf++;
        engine.load(uap.showLaunch||showLaunch?QUrl(QStringLiteral("qrc:/appsListLauncher.qml")):QUrl::fromLocalFile(mainQml));
        QQmlComponent component(&engine, uap.showLaunch||showLaunch?QUrl(QStringLiteral("qrc:/appsListLauncher.qml")):QUrl::fromLocalFile(mainQml));
        qInfo()<<"Init unik: "<<mainQml;
        //if (engine.rootObjects().length()<2&&component.errors().size()>0){
        if (component.errors().size()>0){
            u.log("Errors detected!");
            for (int i = 0; i < component.errors().size(); ++i) {
                listaErrores.append(component.errors().at(i).toString());
                listaErrores.append("\n");
            }
            engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
         }
        }else{
            if (vsf>0){
                qInfo()<<"VSF:: "<<vsf;
                //return 0;
            }
        }
    });

    //------------------------------------------->6
    if(engine.rootObjects().size()>1){
        QObject *aw = engine.rootObjects().at(1);
        QObject::connect(aw, SIGNAL(closing(QQuickCloseEvent *)), &u, SLOT(ukClose(QQuickCloseEvent *)));
        if(dim!=""){
            QStringList m=dim.split("x");
            if(m.size()==2){
                aw->setProperty("width", QString(m.at(0)).toInt());
                aw->setProperty("height", QString(m.at(1)).toInt());
            }
        }
        if(pos!=""){
            QStringList m=pos.split("x");
            if(m.size()==2){
                aw->setProperty("x", QString(m.at(0)).toInt());
                aw->setProperty("y", QString(m.at(1)).toInt());
            }
        }
    }
    //u.deleteFile(urlConfigJsonT.toUtf8());
#ifdef Q_OS_ANDROID
    QObject *aw = engine.rootObjects().at(0);//En Android es 0 cuando no carga splash.
#else
    /*if(engine.rootObjects().size()>1){
            QObject *aw = engine.rootObjects().at(1);
            QObject::connect(aw, SIGNAL(closing(QQuickCloseEvent *)), &u, SLOT(ukClose(QQuickCloseEvent *)));
            if(dim!=""){
                QStringList m=dim.split("x");
                if(m.size()==2){
                    aw->setProperty("width", QString(m.at(0)).toInt());
                    aw->setProperty("height", QString(m.at(1)).toInt());
                }
            }
            if(pos!=""){
                QStringList m=pos.split("x");
                if(m.size()==2){
                    aw->setProperty("x", QString(m.at(0)).toInt());
                    aw->setProperty("y", QString(m.at(1)).toInt());
                }
            }
        }*/
#endif

    //qInfo()<<"Executing from: "<<QDir::currentPath();
    //qInfo()<<"unik.getPath(5)= "<<u.getPath(5);
#ifndef Q_OS_ANDROID
    QByteArray uklData;
    uklData.append("-folder=");
    uklData.append(QString(pws).replace(" ", "%20"));
    uklData.append("/unik-tools");
    QByteArray uklUrl;
    uklUrl.append(pws);
    uklUrl.append("/link_unik-tools.ukl");
    u.setFile(uklUrl, uklData);
    qInfo()<<"UKL file location: "<<uklUrl;
    qInfo()<<"UKL file data: "<<uklData;
#else
    QByteArray uklData;
    uklData.append("-git=https://github.com/nextsigner/unik-android-apps.git");
    uklData.append(" -folder=");
    uklData.append(pws);
    uklData.append("/unik-android-apps");
    QByteArray uklUrl;
    uklUrl.append(pws);
    uklUrl.append("/link_android-apps.ukl");
    u.setFile(uklUrl, uklData);
#endif

#ifdef Q_OS_WIN
    u.createLink(u.getPath(1)+"/unik.exe", "-git=https://github.com/nextsigner/unik-tools.git",  u.getPath(6)+"/Unik-Tools.lnk", "Ejecutar Unik con el Modulo Unik-Tools", "C:/");
#endif
    //u.createLink("unik", "/home/nextsigner/Escritorio/eee4.desktop",  "rrr777", "Pequeña 222vo", "/home/nextsigner/Imàgenes/ladaga.jpg");


    /*Atention! Not ejecute this method u.initWebSocketServer() with out the a correct load of the UnikWebSocketServerView or similar.*/
    //u.initWebSocketServer("127.0.0.1", 12345, "chatserver");

    //Set Unik Start Setting
    //u.setUnikStartSettings("-git=https://github.com/nextsigner/unik-android-apps.git, -nl");


#ifdef UNIK_COMPILE_RPI
    qInfo()<<"Estamos compilando en RPI!";
#endif
    //-------------------------------------------<6


    //-->Prepare Url for load QML
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    //<--Prepare Url for load QML

    //-->Connections
    QObject::connect(&engine, SIGNAL(warnings(QList<QQmlError>)), &u, SLOT(errorQML(QList<QQmlError>)));
    QObject::connect(&engine, &QQmlEngine::warnings, [=](QList<QQmlError> le){
        u.setUWarning(le.last().toString());
    });

    QObject::connect(&u, &UK::restartingApp, [=](){
#ifdef UNIK_COMPILE_ANDROID_X86_64
        /*delete &u;
        delete u0;
        delete &server;
        delete &chatserver;
        delete &channel;
        delete &clientWrapper;*/
#endif
        qApp->quit();
    });
    QObject::connect(&ulo, SIGNAL(logReceived(QByteArray)),
                     &u, SLOT(log(QByteArray)));

    /*QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {

        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);*/
    //<--Connections

    //-->Info
    qInfo()<<"debugLog: "<< debugLog;
    qInfo()<<"appExec: "<<appExec;
    qInfo()<<"CurrentPath: "<<QDir::currentPath();
    qInfo()<<"UAP argv: "<<uap.args;
    qInfo()<<"UAP showLaunch: "<<uap.showLaunch;
    //<--Info

    //-->Latest codes
#ifdef _WIN32
    u.checkWinRegistry();
    if (AttachConsole(ATTACH_PARENT_PROCESS)) {
        freopen("CONOUT$", "w", stdout);
        freopen("CONOUT$", "w", stderr);
    }
#endif
   //<--Latest codes

#ifdef  Q_OS_ANDROID
    //QtAndroid::hideSplashScreen(5);
#endif
    return app.exec();
}
