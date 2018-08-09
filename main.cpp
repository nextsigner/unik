#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>

#include <QQuickImageProvider>
#include <QSettings>

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
#ifndef Q_OS_ANDROID
#include "qmlclipboardadapter.h"
#ifndef __arm__
#include <QtWebEngine>
#endif
#else
#include <android/log.h>
#include <QtWebView>
#endif

//#include "uniklog.h"


#ifdef Q_OS_ANDROID
UK *u0;
#endif

QByteArray debugData;
QString debugPrevio;
bool abortar=false;
#ifndef  Q_OS_ANDROID
UK u;
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
    android_LogPriority priority = ANDROID_LOG_DEBUG;
    switch (type) {
    case QtDebugMsg: priority = ANDROID_LOG_DEBUG; break;
    case QtWarningMsg: priority = ANDROID_LOG_WARN; break;
    case QtCriticalMsg: priority = ANDROID_LOG_ERROR; break;
    case QtFatalMsg: priority = ANDROID_LOG_FATAL; break;
    };

    __android_log_print(priority, "Qt", "%s", qPrintable(message));
    u0->log(message.toUtf8());
}
#endif
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setApplicationDisplayName("unik qml engine");
    app.setApplicationName("unik");
    app.setOrganizationDomain("http://unikode.org/");
    app.setOrganizationName("nextsigner");

#ifdef Q_OS_ANDROID
    UK u;
#endif
    QString nomVersion="";
#ifdef Q_OS_LINUX
#ifdef Q_OS_ANDROID
    nomVersion="android_version";
#else
    #ifdef __arm__
        nomVersion="linux_rpi_version";
    #else
        nomVersion="linux_version";
    #endif
#endif
#endif
#ifdef Q_OS_WIN
     //carpComp.append(QString(UNIK_CURRENTDIR_COMPILATION));
    nomVersion="windows_version";
#endif
#ifdef Q_OS_OSX
    carpComp.append("/Users/qt/nsp/unik-recursos/build_osx_clang64/unik.app/Contents/MacOS");
   nomVersion="macos_version";
#endif  
   QString nv;
   QString fvp;
#ifdef Q_OS_ANDROID
   fvp.append("assets:");
#else
   fvp.append(qApp->applicationDirPath());
#endif
   fvp.append("/");
   fvp.append(nomVersion);
   qDebug() << "UNIK FILE VERSION: " << fvp;
   QFile fileVersion(fvp);
   fileVersion.open(QIODevice::ReadOnly);
   nv = fileVersion.readAll();
   fileVersion.close();

   qDebug() << "UNIK VERSION: " << nv;
   app.setApplicationVersion(nv.toUtf8());
    bool updateDay=false;
    QSettings settings;
#ifdef _WIN32
    if (AttachConsole(ATTACH_PARENT_PROCESS)) {
        freopen("CONOUT$", "w", stdout);
        freopen("CONOUT$", "w", stderr);
    }
#endif
    QByteArray user="unik-free";
    QByteArray key="free";
    QByteArray appArg1="";
    QByteArray appArg2="";
    QByteArray appArg3="";
    QByteArray appArg4="";
    QByteArray appArg5="";
    QByteArray appArg6="";

#ifndef __arm__
    QByteArray urlGit="https://github.com/nextsigner/unik-tools";
    QByteArray moduloGit="unik-tools";
#else
#ifdef Q_OS_ANDROID
    QByteArray urlGit="https://github.com/nextsigner/qmlandia";
    QByteArray moduloGit="qmlandia";
#else
    QByteArray urlGit="https://github.com/nextsigner/unik-tools-rpi";
    QByteArray moduloGit="unik-tools-rpi";
#endif
#endif
    QByteArray modoDeEjecucion="indefinido";
    QByteArray lba="";
    QString listaErrores;
    QString dim="";
    QString pos="";

    bool modeFolder=false;
    bool modeFolderToUpk=false;
    bool modeRemoteFolder=false;
    bool modeUpk=false;
    bool modeGit=false;
    bool updateUnikTools=false;
    bool loadConfig=false;
    bool readConfig=true;
    bool debugLog=false;
    bool setPass=false;
    bool setPass1=false;
    bool setPass2=false;
    bool makeUpk=false;


#ifdef Q_OS_ANDROID
    QtWebView::initialize();
#else
    #ifndef __arm__
    QtWebEngine::initialize();
    #endif
#endif

    QQmlApplicationEngine engine;
    /*Esta linea funciona para cargar por ejemplo libboton.so de import unikplugins 1.0 de la carpeta
     * del main.qml
     *no hace falta engine.addPluginsPaths()
    engine.addImportPath("/home/nextsigner/Escritorio/prueba");
    */


#ifndef Q_OS_ANDROID
    QmlClipboardAdapter clipboard;
    engine.rootContext()->setContextProperty("clipboard", &clipboard);
#endif
#ifdef Q_OS_WIN
    qmlRegisterType<VlcQmlVideoPlayer>("VLCQt", 1, 0, "VlcVideoPlayer");
#endif
    u.setEngine(&engine);
#ifndef Q_OS_ANDROID
    qInstallMessageHandler(unikStdOutPut);
#else
   u0=&u;
    qInstallMessageHandler(android_message_handler);
#endif
    QByteArray pws=u.getPath(3).toUtf8();//Path WorkSpace
    pws.append("/unik");

    QString appExec = argv[0];
    lba="";
    lba.append("appExec: ");
    lba.append(appExec);
    qInfo()<<lba;
    engine.rootContext()->setContextProperty("appExec", appExec);

    engine.rootContext()->setContextProperty("wait", u.wait);
    engine.rootContext()->setContextProperty("splashvisible", u.splashvisible);
    engine.rootContext()->setContextProperty("setInitString", u.setInitString);
    //engine.rootContext()->setContextProperty("log", u.ukStd);

    engine.rootContext()->setContextProperty("unik", &u);
    engine.rootContext()->setContextProperty("console", &u);
    engine.rootContext()->setContextProperty("unikLog", u.ukStd);
    engine.rootContext()->setContextProperty("unikError", listaErrores);



    qmlRegisterType<UK>("uk", 1, 0, "UK");

#ifdef Q_OS_ANDROID
    engine.load("qrc:/SplashAndroid.qml");
#else
#ifndef __arm__
    engine.load("qrc:/Splash.qml");
#else
    engine.load("://Splash.qml");
#endif
#endif
    //Example Connection for unik engine into uk.cpp method.
    //QObject::connect(&engine, SIGNAL(warnings(QList<QQmlError>)), &u, SLOT(errorQML(QList<QQmlError>)));

    debugLog=true;
    u.debugLog=debugLog;   
    for (int i = 0; i < argc; ++i) {
        if(QByteArray(argv[i])==QByteArray("-debug")){
            debugLog=true;
        }
        if(QByteArray(argv[i])==QByteArray("-no-config")){
            readConfig=false;
        }
        QString arg;
        arg.append(argv[i]);
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
                QDir::setCurrent(marg.at(1));
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
                lba="";
                lba.append("-dir=");
                lba.append(marg.at(1));
                qInfo()<<lba;
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
                //qDebug()<<"____________"<<pUrlGit1.mid(pUrlGit1.size()-4, pUrlGit1.size());
                if(pUrlGit1.contains(".git")||pUrlGit1.mid(pUrlGit1.size()-4, pUrlGit1.size())==".git"){
                    urlGit.append(pUrlGit1.mid(0, pUrlGit1.size()-4));
                }else{
                    urlGit.append(pUrlGit1);
                }
                //QString pUrlGit2 = pUrlGit1.replace(".git", "");
                QString pUrlGit2 = pUrlGit1;
                QStringList m100 = pUrlGit2.split("/");
                if(m100.size()>1){
                    moduloGit="";
                    moduloGit.append(m100.at(m100.size()-1));
                }
                modeGit=true;
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
            }
        }

        if(arg.contains("-update=")){
            QStringList marg = arg.split("-update=");
            if(marg.size()==2){
                QString modulo;
                modulo.append(marg.at(1));
                u.log("Updating "+modulo.toUtf8()+"...");
                if(modulo.contains("unik-tools")){
                    updateDay=true;
                    updateUnikTools=true;
                }
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
            }
        }
    }
    if(setPass1&&setPass2){
        setPass=true;
    }
    //ApplicationWindow Magnitude Data
    if(dim!=""){
        engine.rootContext()->setContextProperty("dim", dim);
    }
    if(pos!=""){
        engine.rootContext()->setContextProperty("pos", pos);
    }
    engine.rootContext()->setContextProperty("ukuser", user);
    engine.rootContext()->setContextProperty("ukkey", key);


    lba="";
    lba.append("unik debug enabled: ");
    lba.append(debugLog ? "true" : "false");
    qInfo()<<lba;
    u.debugLog = debugLog;
    u.debugLog = true;

    QByteArray upkFileName;
    QString upkActivo="";

    QString dupl;
#ifndef Q_OS_ANDROID
    dupl.append(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation));
#else
    dupl.append(u.getPath(3));
#endif
    dupl.append("/unik");
#ifdef Q_OS_ANDROID
    QByteArray mf;
    mf.append(dupl);
    mf.append("/qmlandia/main.qml");
    QFile m(mf);
    if(!m.exists()){
        //bool autd=u.downloadGit("https://github.com/nextsigner/qmlandia", dupl.toUtf8());
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
        qInfo("unik-tools have any fail! repairing..."+dupl.toUtf8());
        bool autd=u.downloadGit("https://github.com/nextsigner/unik-tools-rpi.git", dupl.toUtf8());
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
    if(settings.value("ws").toString().isEmpty()){
        settings.setValue("ws", dupl);
        qInfo()<<"WorkSpace by default: "<<dupl.toUtf8();
    }else{
        qInfo()<<"Current WorkSpace: "<<settings.value("ws").toString().toUtf8();
        QFileInfo fi(dupl);
        if(!fi.isWritable()){
            QString ndulw;
            ndulw.append(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation));
            ndulw.append("/unik");
            dupl = ndulw;
            qInfo()<<"WorkSpace not writable!";
            qInfo("New WorkSpace seted: "+ndulw.toUtf8());
        }else{            
            pws = settings.value("ws").toString().toUtf8();
            dupl = pws;
        }
    }

    QDir dirWS(dupl);
    QString utp;
    utp.append(dupl);
#ifndef Q_OS_ANDROID
    utp.append("/unik-tools");
#else
    utp.append("/qmlandia");
#endif
#ifdef __arm__
#ifndef Q_OS_ANDROID
    utp.append("-rpi");
#endif
#endif
    qInfo()<<"Checking UTP exists...";
    QDir dirUnikToolsLocation(utp);
    QFile utmain(utp+"/main.qml");
    if (!dirWS.exists()||!dirUnikToolsLocation.exists()||!utmain.exists()) {
        dirWS.mkpath(".");
        qInfo()<<"Making folder "<<dupl;
        if(!dirUnikToolsLocation.exists()){
           dirUnikToolsLocation.mkpath(".");
         }
         bool unikToolDownloaded=false;
#ifndef __arm__
            unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/unik-tools", dupl.toUtf8());
#else
#ifdef Q_OS_ANDROID
            unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/qmlandia", dupl.toUtf8());
#else
            unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/unik-tools-rpi", dupl.toUtf8());
#endif
#endif
            lba="";
#ifndef Q_OS_ANDROID
            lba.append("Unik-Tools ");
#else
            lba.append("QmLandia ");
#endif
            if(unikToolDownloaded){
                lba.append("downloaded.");
            }else {
                lba.append("is not downloaded!");
            }
            qInfo()<<lba;        
    }else{
            qInfo()<<"Folder "<<dupl<<" pre existent.";
    }
    if (!dirWS.exists()) {
        qInfo()<<"Closing because folder "<<dupl<<" no existent.";
        return -5;
    }else{
        qInfo()<<"Folder "<<dupl<<" existent.";
    }

    //Obteniendo url del archivo config.json
    QString urlConfigJson;
    urlConfigJson.append(dupl);
    urlConfigJson.append("/config.json");
    QByteArray cfgData;
    cfgData.append("{\"mode\":\"-folder\", \"arg1\": \"");
    cfgData.append(settings.value("ws").toString());
#ifndef Q_OS_ANDROID
    cfgData.append("/unik-tools\"}");
#else
    cfgData.append("/qmlandia\"}");
#endif

    QFile cfg(urlConfigJson);
    if(!cfg.exists()){
        u.setFile(urlConfigJson.toUtf8(), cfgData);
    }


    QString urlConfigJsonT;
    urlConfigJsonT.append(dupl);
    urlConfigJsonT.append("/temp_config.json");
    QFile tjs(urlConfigJsonT);
    if(tjs.exists()){
        urlConfigJson=urlConfigJsonT;
    }

    if(argc == 2 || argc == 4 || argc == 5  ){
        makeUpk=false;
        updateUnikTools=false;
    }

    //MODO upk directo
    if((argc == 2||argc == 3||argc == 4)&&!modeGit){
        QString argUpk;
        argUpk.append(argv[1]);
        QString ext=argUpk.mid(argUpk.size()-4,argUpk.size());
        if(ext==".upk"){
            qInfo()<<"Run mode upk direct file.";
            appArg1=QByteArray(argv[1]);
            modeUpk=true;
            updateUnikTools=false;
        }
    }else{
        //updateUnikTools=true;
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
    }else{
        //updateUnikTools=true;
    }

    //MODO -folder
    if((argc == 3||argc == 4||argc == 5) && QByteArray(argv[1])==QByteArray("-folder")){
        modoDeEjecucion="-folder";
        appArg1=QByteArray(argv[1]);
        appArg2=QByteArray(argv[2]);
        modeFolder=true;
        makeUpk=false;
        if(debugLog){
            lba="";
            lba.append("Prepare mode -folder.");
            qInfo()<<lba;
        }
        updateDay=false;
        updateUnikTools=false;
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
    if((argc == 5 || argc == 6) && QByteArray(argv[1])==QByteArray("-remoteFolder")){
        modoDeEjecucion="-remoteFolder";
        appArg1=QByteArray(argv[2]);
        appArg2=QByteArray(argv[3]);
        appArg3=QByteArray(argv[4]);
        QByteArray ncf;
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
        u.setFile(r, ncf);
        modeRemoteFolder=true;
        makeUpk=false;
        updateUnikTools=false;
    }

    //->Comienza configuracion OS
#ifdef Q_OS_LINUX
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
        cf2.append(u.getPath(1));
        cf2.append("/unik.png");
        QFile icon(cf2);
        icon.copy(cf+"/unik.png");
        qInfo()<<"Copyng unik icon file: "<<cf2<<" to "<<cf+"/unik.png";
    }
#endif
    //<-Finaliza configuracion OS


    engine.rootContext()->setContextProperty("engine", &engine);

    QByteArray tempFolder;
    tempFolder.append(QDateTime::currentDateTime().toString("hhmmss"));
    QString pq;
    pq.append(pws);
#ifndef __arm__
    pq.append("/unik-tools/");
#else
#ifdef Q_OS_ANDROID
    pq.append("/qmlandia/");
#else
    pq.append("/unik-tools-rpi/");
#endif
#endif
    QDir dir0(pq);
    if (!dir0.exists()) {
        dir0.mkpath(".");
    }
    QString appName;
    QByteArray jsonConfigData;
    //Reading config.json
    readConfig=modeFolderToUpk||modeUpk||modeGit||modeFolder||modeRemoteFolder?false:true;
    if(readConfig){
        qInfo()<<"Reading config file...";
        QFile jsonConfig(urlConfigJson);
        if(jsonConfig.open(QIODevice::ReadOnly)){
            jsonConfigData.append(jsonConfig.readAll());
            qInfo()<<"Loading config...";
            QJsonDocument docConf = QJsonDocument::fromJson(jsonConfigData.constData());
            QJsonObject raizConf = docConf.object();
            if(raizConf.value("appName").toString()!=""){
                appName.append(raizConf.value("appName").toString());
            }
            if(jsonConfigData=="{\"appName\":\"unik-tools\"}"){                
                qInfo()<<"Default config detected...";
            }else{
                qInfo()<<"Config set Mode: "<<jsonConfigData;
                if(raizConf.value("mode").toString()!=""){
                    QString vm =raizConf.value("mode").toString();
                    qInfo()<<"Config set Mode: "<<vm;
                    if(vm=="-folder"){
                        QDir fe(raizConf.value("arg1").toString());
                        if(!fe.exists()){
                                u.log("ModeFolder from config aborted! - Folder not found.");
                        }else{
                                appArg2 = "";
                                appArg2.append(raizConf.value("arg1").toString());
                                pq = "";
                                pq.append(raizConf.value("arg1").toString());
                                pq.append("/");
                                QStringList mappn = raizConf.value("arg1").toString().split("/");
                                if(mappn.size()>1){
                                    appName = mappn.at(mappn.size()-1);
                                }else{
                                    appName = mappn.at(0);
                                }
                                qInfo()<<"Config set arg2: "<<appArg2<<"\nModule name from config.json: "<<appName;
                                modeFolder=true;
                                updateUnikTools=false;
                            }
                    }
                    /*if(vm=="-foldertoupk"){
                        modeFolderToUpk=true;
                        appArg1 = "";
                        appArg1.append(raizConf.value("arg1").toString());
                        appArg2 = "";
                        appArg2.append(raizConf.value("arg2").toString());
                        appArg3 = "";
                        appArg3.append(raizConf.value("arg3").toString());
                        user = "";
                        user.append(u.decData(appArg2, "u", "k"));
                        key = "";
                        key.append(u.decData(appArg3, "u", "k"));

                    }*/
                    if(vm=="-remoteFolder"){
                        modeRemoteFolder=true;
                        appArg1 = "";
                        appArg1.append(raizConf.value("arg1").toString());
                        appArg2 = "";
                        appArg2.append(raizConf.value("arg2").toString());
                        appArg3 = "";
                        appArg3.append(raizConf.value("arg3").toString());
                        if(debugLog){
                            lba="";
                            lba.append("Config set arg1: ");
                            lba.append(appArg1);
                            lba.append(" arg2: ");
                            lba.append(appArg2);
                            lba.append(" arg3: ");
                            lba.append(appArg3);
                            qInfo()<<lba;
                        }
                    }
                    if(vm=="-upk"){
                        //{"mode": "-upk", "arg1" : "/home/nextsigner/Documentos/unik/sqlite-example.upk"}
                        //qInfo("-----------------------------------------------iiiiiiiiiiiiiiiii");
                        loadConfig=true;
                        modeUpk=true;
                        appArg1 = "";
                        appArg1.append(raizConf.value("arg1").toString());
                        QStringList marg = raizConf.value("arg2").toString().split("-user=");
                        //qDebug()<<"marg: "<<marg;
                        if(marg.size()==2){
                            user = "";
                            user.append(marg.at(1));
                            appArg2 = "";
                            appArg2.append(user);
                        }
                        QStringList marg2 = raizConf.value("arg3").toString().split("-key=");
                        //qDebug()<<"marg2: "<<marg2;
                        if(marg2.size()==2){
                            key = "";
                            key.append(marg2.at(1));
                            appArg3 = "";
                            appArg3.append(key);
                        }
                        setPass2=true;
                        modeFolder=false;
                        modeFolderToUpk=false;
                        modeGit=false;
                        modeUpk=true;
                        if(debugLog){
                            qDebug()<<"Config set -upk arg1: "<<appArg1<<" arg2: "<<appArg2<<" arg3: "<<appArg3<<" ";
                        }
                    }
                    if(vm=="-git"){
                        appArg1.clear();
                        appArg1.append(raizConf.value("mode").toString());
                        appArg2.clear();
                        appArg2.append(raizConf.value("arg1").toString());
                        if(!appArg2.isEmpty()){
                            QString pUrlGit1;
                            pUrlGit1.append(appArg2);
                            urlGit = "";

                            //qDebug()<<"____________"<<pUrlGit1.mid(pUrlGit1.size()-4, pUrlGit1.size());
                            if(pUrlGit1.contains(".git")||pUrlGit1.mid(pUrlGit1.size()-4, pUrlGit1.size())==".git"){
                                urlGit.append(pUrlGit1.mid(0, pUrlGit1.size()-4));
                            }else{
                                urlGit.append(pUrlGit1);
                            }
                            qInfo()<<"Updating from Git from config.json: "<<appArg1<<" "<<urlGit;
                            //QString pUrlGit2 = pUrlGit1.replace(".git", "");
                            QString pUrlGit2 = pUrlGit1;
                            QStringList m100 = pUrlGit2.split("/");
                            if(m100.size()>1){
                                moduloGit="";
                                moduloGit.append(m100.at(m100.size()-1));
                            }
                            modeGit=true;
                            modeFolder=false;
                            modeFolderToUpk=false;
                            modeRemoteFolder=false;
                        }else{
                            qInfo()<<"Fail updating from Git from config.json: "<<appArg1<<" Arg2 is empty! "<<appArg2<<" "<<urlGit;
                        }
                    }
                }else{
                    lba="";
                    lba.append("Loading config fail mode ");
                    lba.append(raizConf.value("mode").toString());
                }

            }
        }else{
            if(debugLog){
                lba="";
                lba.append("Loading unik-installer by default.");
                qInfo()<<lba;
            }
            QFile nuevoJsonConfig(urlConfigJson);

            if(!nuevoJsonConfig.exists()&&nuevoJsonConfig.open(QIODevice::WriteOnly)){
                QTextStream e(&nuevoJsonConfig);
                e.setCodec("UTF-8");
                QByteArray jsonPorDefecto;
                jsonPorDefecto.append("{\"-folder\":\""+settings.value("ws").toString()+"/unik-tools"+"\"}");
                e<<jsonPorDefecto;
                nuevoJsonConfig.close();
            }
            appName.append("unik-installer");
        }
    }else{
        upkFileName = "";
        if(debugLog){
            lba="";
            lba.append("Upk filename reset: ");
            lba.append(upkFileName);
            qInfo()<<lba;
        }
    }
    lba="";
    lba.append("Count arguments: ");
    lba.append(QString::number(argc));
    qInfo()<<lba;


    if(modeUpk&&loadConfig){
        qInfo("Mode Upk 1 procces...");
        if(debugLog){
            qDebug()<<"Upk filename: "<<appArg1;
            qDebug()<<"Upk user: "<<user;
            qDebug()<<"Upk key: "<<key;
        }
        QString sl2;
        sl2.append(appArg1);
        QString pathCorr;
        pathCorr = sl2.replace("\\", "/");
        QByteArray urlUpkCorr;
        urlUpkCorr.append(pathCorr);
        QStringList mAppName = sl2.split("/");
        QString nan = mAppName.at(mAppName.size()-1);
        appName=nan.replace(".upk", "");
        if(pathCorr.mid(pathCorr.size()-4, pathCorr.size()-1)==QString(".upk")){
            QByteArray err;
            if(debugLog){
                lba="";
                lba.append("UPK detected: ");
                lba.append(pathCorr);
                qInfo()<<lba;
            }
        }
        QByteArray tf;
        tf.append(QDateTime::currentDateTime().toString("hhmmss"));
        pq="";
        pq.append(QStandardPaths::standardLocations(QStandardPaths::TempLocation).last());
        pq.append("/");
        pq.append(tf);
        u.mkdir(pq);
        pq.append("/");
        QFile upkCheck(urlUpkCorr);
        if(upkCheck.exists()&&u.upkToFolder(urlUpkCorr, user, key, pq.toUtf8())){
            if(debugLog){
                lba="";
                lba.append(argv[1]);
                lba.append(" extract successful...");
                qInfo()<<lba;
            }
            QStringList sl =sl2.split("/");
            QByteArray nAppName;
            nAppName.append(sl.at(sl.size()-1));
            upkActivo = appName;
            updateUnikTools=false;
            //engine2.rootContext()->setContextProperty("upkActivo", appName);
        }else{
            if(!upkCheck.exists()){
                listaErrores.append("Upk file does not exist!\n");
            }else{
                listaErrores.append("Upk unpack fail!\n");
                if(user!="unik-free"||key!="free"){
                    listaErrores.append("User or key pass error. \n \n");
                }
                if(debugLog){
                    lba="";
                    lba.append(argv[1]);
                    lba.append(" extract no successful...");
                    qInfo()<<lba;
                }
            }
        }
    }

    if((argc == 3||argc == 4||argc == 5||argc == 6) && QByteArray(argv[1])==QByteArray("-appName")){
        QByteArray arg1;
        arg1.append(argv[1]);
        QByteArray arg2;
        arg2.append(argv[2]);
        if(debugLog){
            lba="";
            lba.append("Running command line -appName ");
            lba.append(argv[0]);
            lba.append(" ");
            lba.append(argv[1]);
            qInfo()<<lba;
            if(setPass){
                lba="";
                lba.append("Using seted pass.");
                qInfo()<<lba;
                //qDebug()<<"Using seted pass: "<<user<<" "<<key;
            }else{
                lba="";
                lba.append("Using free pass.");
                qInfo()<<lba;
            }
        }
        appName = arg2;
        upkFileName.append(dupl);
        upkFileName.append("/");
        upkFileName.append(appName);
        upkFileName.append(".upk");
        if(debugLog){
            lba="";
            lba.append("Upk filename: ");
            lba.append(upkFileName);
            qInfo()<<lba;
        }
        if(u.upkToFolder(upkFileName, user, key, pq.toUtf8())){
            if(debugLog){
                lba="";
                lba.append(appName);
                lba.append(" extract successful...");
                qInfo()<<lba;
            }
            upkActivo = appName;
            updateUnikTools=false;
            //engine2.rootContext()->setContextProperty("upkActivo", appName);
        }
    }
    if(modeFolder){
        if(debugLog){
            lba="";
            lba.append("Running in folder mode: ");
            lba.append(appArg1);
            lba.append(" ");
            lba.append(appArg2);
            lba.append(" ");
            lba.append(appArg3);
            lba.append(" ");
            qInfo()<<lba;
        }
        pq = "";
        pq.append(appArg2);
        QDir carpetaModeFolder(appArg2);
        QFile mainModeFolder(appArg2+"/main.qml");
        if(carpetaModeFolder.exists()&&mainModeFolder.exists()){
            u.log("Folder to -folder exist...");
            pq.append("/");
        }else{
            if(!carpetaModeFolder.exists()){
                u.log("Folder to -folder not exist...");
            }
            if(!mainModeFolder.exists()){
                u.log("main.qml to -folder not exist...");
            }
            pq="";
            pq.append(pws);
            engine.addImportPath(pq);
            engine.addPluginPath(pq);
#ifndef __arm__
            pq.append("/unik-tools/");
            //engine.addImportPath("C:\\Users\\qt\\Documents\\unik\\unik-tools\\LogView");
            //engine.addPluginPath("C:\\Users\\qt\\Documents\\unik\\unik-tools\\LogView");
#else
#ifdef Q_OS_ANDROID
            pq.append("/qmlandia/");
#else
            pq.append("/unik-tools-rpi/");
#endif
#endif
        }
        u.mkdir(pq);
        QString arg2;
        arg2.append(appArg2);
        QStringList marg2 = arg2.split("/");
        if(marg2.size()>1){
            appName = marg2.at(marg2.size()-1);
        }else{
            appName = marg2.at(0);
        }
    }

    QString arg1Control;
    if(modeUpk&&!loadConfig){
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

        u.log("a1:"+arg1.toUtf8());
        //u.log("a2:"+arg2.toUtf8());
        //u.log("a3:"+arg3.toUtf8());
        //u.log("a4:"+arg4.toUtf8());
#ifdef Q_OS_WIN32
        QStringList sl =arg4.replace("\\","/").split("/");
#else
        QStringList sl =arg4.split("/");
#endif

        QByteArray nAppName;
        nAppName.append(sl.at(sl.size()-1));
        appName=nAppName;
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
                /*lba.append(" user: ");
                lba.append(user);
                lba.append(" key: ");
                lba.append(key);*/
                qInfo()<<lba;
            }
            if(u.upkToFolder(arg1.toUtf8(), user, key, tempFolder)){
                if(setPass){
                    //user = arg2.toLatin1();
                    //key = arg3.toLatin1();
                }
                lba="";
                lba.append(nAppName);
                lba.append(".upk extraido: ");
                lba.append(dupl);
                lba.append("/");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
                appName = nAppName;
                //return 0;
            }else{
                lba="";
                lba.append("Error at extract ");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
            }
            upkFileName.append(dupl);
            upkFileName.append("/");
            upkFileName.append(appName);
            upkFileName.append(".upk");
            if(debugLog){
                lba="";
                lba.append("Upk filename: ");
                lba.append(upkFileName);
                qInfo()<<lba;
            }
            if(u.upkToFolder(upkFileName, user, key, pq.toUtf8())){
                if(debugLog){
                    lba="";
                    lba.append(appName);
                    lba.append(" extract successful...");
                    qInfo()<<lba;
                }
                upkActivo = appName;
                updateUnikTools=false;
                //engine2.rootContext()->setContextProperty("upkActivo", appName);
            }
            //rewriteUpk=true;
        }
    }


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
                lba.append(dupl);
                lba.append("\");");
                lba.append(" user: ");
                lba.append(user);
                lba.append(" key: ");
                lba.append(key);
                qInfo()<<lba;
            }

            qInfo()<<"folderToUpk: "<<arg1<<" "<<nAppName<<" "<<arg2<<" "<<arg3<<" "<<dupl;
            if(u.folderToUpk(arg1, nAppName, arg2, arg3, dupl)){
                if(setPass){
                    //user = arg2.toLatin1();
                    //key = arg3.toLatin1();
                }
                lba="";
                lba.append(nAppName);
                lba.append(".upk creado: ");
                lba.append(dupl);
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
            upkFileName.append(dupl);
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
                upkActivo = appName;
                updateUnikTools=false;
                pq.clear();
                pq.append(fd);
                pq.append("/");
                //engine2.rootContext()->setContextProperty("upkActivo", appName);
            }
            //rewriteUpk=true;
        }
    }


    //if((argc == 5 || argc == 6) && QByteArray(argv[1])==QByteArray("-remoteFolder")){
    if(modeRemoteFolder){
        QString urlRemoteFolder;
        urlRemoteFolder.append(QByteArray(appArg1));
        if(debugLog){
            qDebug()<<"unik working in mode: -remoteFolder";
            qDebug()<<"Remote Folder Url: "<<urlRemoteFolder;
        }
        u.downloadRemoteFolder(urlRemoteFolder, appArg2, appArg3);
        pq = "";
        pq.append(appArg3);
        makeUpk=false;
    }

    engine.rootContext()->setContextProperty("version", app.applicationVersion());
    engine.rootContext()->setContextProperty("host", u.host());
    engine.rootContext()->setContextProperty("appName", appName);
    engine.rootContext()->setContextProperty("upkExtractLocation", pq);
    engine.rootContext()->setContextProperty("sourcePath", pq);
    engine.rootContext()->setContextProperty("unikDocs", dupl);


    QString duplFolderModel;
#ifdef Q_OS_WIN
    //duplFolderModel.append("file:///");
    duplFolderModel.append(dupl);
    engine.rootContext()->setContextProperty("appsDir", duplFolderModel);
#else
    engine.rootContext()->setContextProperty("appsDir", dupl);
#endif
    //'file:///C:/Users/qt/Documents/unik'
#ifdef QT_DEBUG
#ifdef Q_OS_WIN
    /*if(argc > 3){ //SOLO FUNCIONA EN DEBUG
        qDebug()<<"Recibiendo "<<argc<<" argumentos: "<<argv[0];
        QByteArray arg1;
        arg1.append(argv[1]);
        QByteArray arg2;
        arg2.append(argv[2]);
        QByteArray arg3;
        arg3.append("file://");
        arg3.append(argv[3]);
        if(arg1=="-force"){
            qDebug()<<"Ejecutando -reset "<<argv[0]<<" "<<argv[1];

            engine.load(QUrl::fromLocalFile(arg2));// main.qml location
            QQmlComponent component(&engine, QUrl::fromLocalFile(arg2));
            engine.addImportPath(arg3);
            //engine.load(QUrl::fromLocalFile("H:/_qtos/des/unik-installer/main.qml"));
            //engine.addImportPath("file://H://_qtos/des/unik-installer");
        }
    }*/

#else
    engine.load(QUrl(QStringLiteral("/media/nextsigner/ZONA-A1/_qtos/des/unik-installer/main.qml")));
    QQmlComponent component(&engine, QUrl::fromLocalFile(arg2));
    engine.addImportPath("file://media/nextsigner/ZONA-A1/_qtos/des/unik-installer");
#endif

#else
    QString qmlImportPath;
    if(modeRemoteFolder){
        pq = "";
        pq.append(appArg3);
        pq.append("/");
    }

    QByteArray mainQml;
    mainQml.append(pq);
    mainQml.append("main.qml");

    QByteArray upass;
    QByteArray kpass;
    QByteArray jsonPassData;
    QByteArray jsonPassUrl;
    jsonPassUrl.append(pq);
    jsonPassUrl.append("pass.json");
    QFile jsonPass(jsonPassUrl);
    if(jsonPass.open(QIODevice::ReadOnly)){
        if(debugLog){
            lba="";
            lba.append("Opening config pass file...");
            qInfo()<<lba;
        }
        jsonPassData.append(jsonPass.readAll());
        QJsonDocument docPass = QJsonDocument::fromJson(jsonPassData.constData());
        QJsonObject raizPass = docPass.object();
        upass.append(raizPass.value("user").toString());
        kpass.append(raizPass.value("key").toString());
        if(debugLog){
            lba="";
            lba.append("config pass data: ");
            lba.append(upass);
            lba.append(" ");
            lba.append(kpass);
            //qInfo()<<lba;
        }
        engine.rootContext()->setContextProperty("ukuser", upass);
        engine.rootContext()->setContextProperty("ukkey", kpass);
        QByteArray ukitName;
        ukitName.append("ukit");
        ukitName.append(raizPass.value("key").toString());
        engine.rootContext()->setContextProperty(ukitName.constData(), &u);
    }    

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
        }else{
            lba="";
            lba.append("Fail Zip download: ");
            lba.append(urlGit);
            qInfo()<<lba;
        }
        QByteArray npq;
        npq.append(pws);
        npq.append("/");
        if(moduloGit.contains(".git")||moduloGit.mid(moduloGit.size()-4, moduloGit.size())==".git"){
            npq.append(moduloGit.mid(0, moduloGit.size()-4));
        }else{
            npq.append(moduloGit);
        }
        //npq.append(moduloGit);
        npq.append("/");
        lba="";
        lba.append("Current Application Folder: ");
        lba.append(npq);
        qInfo()<<lba;
        pq = npq;
        mainQml="";
        mainQml.append(pq);
        mainQml.append("main.qml");
        u.log("Updated: "+pq.toUtf8());
    }
    /*if(updateUnikTools||updateDay){
        lba="";
        lba.append("Updating from github: ");
        lba.append(urlGit);
        lba.append("\nupdateUnikTools: ");
        lba.append(updateUnikTools ? "true" : "false");
        lba.append("\nupdateDay: ");
        lba.append(updateDay ? "true" : "false");
        qInfo()<<lba;
        QByteArray unikOsPath;
        unikOsPath.append(pws);
        u.mkdir(unikOsPath);
        bool up=u.downloadZipFile(urlGit, unikOsPath);
        if(up){
            qInfo()<<"Updated from github...";
        }else{
            qInfo()<<"Fail Update from github...";
        }
        unikOsPath.append("/"+moduloGit+"/");
        pq = unikOsPath;
        mainQml="";
        mainQml.append(pq);
        mainQml.append("main.qml");
        u.log("Updated: "+pq.toUtf8());
    }*/

    engine.rootContext()->setContextProperty("pq", pq);

    QByteArray log4;

    log4.append("\nExecute mode: ");
    log4.append(modoDeEjecucion);
    log4.append("\n");

    log4.append("unik version: ");
    log4.append(app.applicationVersion());
    log4.append("\n");

    log4.append("Work Space: ");
    log4.append(settings.value("ws").toString());
    log4.append("\n");


    log4.append("updateDay: ");
    log4.append(updateDay ? "true" : "false");
    log4.append("\n");

    log4.append("updateUnikTools: ");
    log4.append(updateUnikTools ? "true" : "false");
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

    engine.rootContext()->setContextProperty("appStatus", log4);
    if(u.debugLog){
        qInfo()<<log4;
    }
#ifndef Q_OS_ANDROID
    if (!engine.rootObjects().isEmpty()){
        QObject *aw0 = engine.rootObjects().at(0);
        if(aw0->property("objectName")=="awsplash"){
            aw0->setProperty("ver", false);
        }
    }
#else

#endif
    if (!engine.rootObjects().isEmpty()){
       u.splashvisible=false;
        engine.rootContext()->setContextProperty("splashvisible", u.splashvisible);
    }
#ifdef Q_OS_WIN
    //qmlImportPath.append("C:/Users/qt/Documents/unik/unik-tools");
    qmlImportPath.append(pq);
    engine.addImportPath(qmlImportPath);
    engine.addPluginPath(qmlImportPath);
    qInfo()<<"Import Path: "<<qmlImportPath;
    qInfo()<<"Current Dir: "<<QDir::currentPath();
    qInfo()<<"1-->.>"<<engine.importPathList();
    qInfo()<<"2-->.>"<<engine.pluginPathList();
    qInfo()<<"3<<"<<QLibraryInfo::Qml2ImportsPath;

    engine.load(QUrl::fromLocalFile(mainQml));
    QQmlComponent component(&engine, QUrl::fromLocalFile(mainQml));
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
    QString ncqmls;
    ncqmls.append(pq.mid(0,pq.size()-1).replace("/", "\\"));
    qmlImportPath.append(ncqmls);
    engine.addImportPath(pq);
    QString unikPluginsPath;
    unikPluginsPath.append(u.getPath(1));
    unikPluginsPath.append("/unikplugins");
    engine.addImportPath(unikPluginsPath);

#ifdef __arm__
    engine.addImportPath("/home/pi/unik/qml");
#endif


    //Probe file is for debug any components in the build operations. Set empty for release.
    QByteArray probe = "";
    //probe.append("qrc:/probe.qml");
    engine.load(probe.isEmpty() ? QUrl(mainQml) : QUrl(probe));
    QQmlComponent component(&engine, probe.isEmpty() ? QUrl(mainQml) : QUrl(probe));

    engine.addImportPath(qmlImportPath);
    QByteArray m1;
    m1.append(qmlImportPath);
    QByteArray m2;
    m2.append(mainQml);
#endif
#endif
    if (engine.rootObjects().length()<2&&component.errors().size()>0){
        u.log("Errors detected!");
        for (int i = 0; i < component.errors().size(); ++i) {
            listaErrores.append(component.errors().at(i).toString());
            listaErrores.append("\n");
        }
        //qDebug()<<"------->"<<component.errors();

#ifdef Q_OS_ANDROID
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
#else
#ifndef __arm__
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
#else
        engine.load("://main_rpi.qml");
#endif
#endif
    }
    u.deleteFile(urlConfigJsonT.toUtf8());
 #ifdef Q_OS_ANDROID
    QObject *aw = engine.rootObjects().at(0);//En Android es 0 cuando no carga splash.
#else
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
#endif


    //Probe u.createLink();
    //u.createLink("C:/Windows/notepad.exe", "C:/Users/Nico/Desktop/unik2.lnk", "Pequeña 222descripción para saber que hace el archivo", "E:/");
   //u.createLink("/home/nextsigner/Escritorio/unik_v2.22.2.AppImage", "/home/nextsigner/Escritorio/eee4.desktop",  "rrr777", "Pequeña 222vo", "/home/nextsigner/Imàgenes/ladaga.jpg");


    return app.exec();
}
