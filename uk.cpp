﻿#include "uk.h"

UK::UK(QObject *parent) : QObject(parent)
{
    cinj = new QTimer(this);
    lsim<<"g"<<"h"<<"i"<<"j"<<"k"<<"l"<<"m"<<"n"<<"o"<<"p"<<"q"<<"r"<<"s"<<"t"<<"u"<<"v"<<"w"<<"x"<<"y"<<"z";
    lnum<<"11"<<"33"<<"66"<<"77"<<"88"<<"99"<<"20"<<"30"<<"40"<<"60"<<"70"<<"80"<<"90"<<"12"<<"21"<<"57"<<"82"<<"92"<<"84"<<"72";
    file = new QFile();
}

UK::~UK()
{
    db.close();
}

void UK::setHost(QString nh)
{
    h = nh;
    if(debugLog){
        qInfo()<<"Set host:"<<h;
    }
}

QString UK::host()
{
    return h;
}

void UK::ukClose(QQuickCloseEvent *close){
    QSettings settings;
    _engine->rootContext()->setContextProperty("logViewVisible", true);
    qInfo("ApplicationWindow closed. ");
    db.close();

    /*
     * This is a disable unik code :)
     * This method is replaced by
     * onClosing{
     *      //close.accepted=false
     *      engine.load(appDirs+'/unik-tools/main.qml')
     *  }
     *
     *
#ifndef Q_OS_ANDROID
    QByteArray unikMainLocation;

    unikMainLocation.append(settings.value("ws").toString());
    unikMainLocation.append("/unik-tools/main.qml");
    qInfo("Loading "+unikMainLocation);
   //_engine->load(unikMainLocation);
   QStringList listaErrores;
    QQmlComponent component(_engine, QUrl::fromLocalFile(unikMainLocation));
   if (component.errors().size()>0){
       log("Errors detected!");
       for (int i = 0; i < component.errors().size(); ++i) {
           listaErrores.append(component.errors().at(i).toString());
           listaErrores.append("\n");
       }
       //qDebug()<<"------->"<<component.errors();
       _engine->rootContext()->setContextProperty("unikError", listaErrores);
#ifdef Q_OS_ANDROID
       _engine->load(QUrl(QStringLiteral("qrc:/mainAndroid.qml")));
#else
       _engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
#endif

   }

 #else
    _engine->rootContext()->setContextProperty("wait", true);
    log("Android ApplicationWindow closed. ");
    db.close();
    QObject *aw0 = _engine->rootObjects().at(0);
    //qDebug()<<"awsplash: "<<aw0->property("objectName");
    if(aw0->property("objectName")=="awsplash"){
        aw0->setProperty("visible", false);
    }
    QByteArray unikMainLocation;
    //unikMainLocation.append(getPath(3));
    unikMainLocation.append(settings.value("ws").toString());
    unikMainLocation.append("/unik-tools/main.qml");

    //if(!canCloseApp){
        _engine->load(unikMainLocation);
    //}else{
        //qApp->quit();
    //}

#endif        
    */
}

void UK::engineExited(int n)
{
    db.close();
}

void UK::engineQuited(QObject *)
{
    db.close();
}

int UK::getScreenWidth()
{
    QScreen *screen = QGuiApplication::primaryScreen();
    QRect  screenGeometry = screen->geometry();
    return screenGeometry.width();
}

void UK::setWorkSpace(QString ws)
{
    QSettings settings;
    settings.setValue("ws", ws);
    QString duplFolderModel;
#ifdef Q_OS_WIN
    duplFolderModel.append("file:///");
    duplFolderModel.append(ws);
    _engine->rootContext()->setContextProperty("appsDir", duplFolderModel);
#else
    _engine->rootContext()->setContextProperty("appsDir", ws);
#endif

}

void UK::definirCarpetaTrabajo(QString et)
{
    setWorkSpace(et);
}

bool UK::folderToUpk(QString folder, QString upkName, QString user, QString key, QString folderDestination)
{
    return mkUpk(folder.toUtf8(), upkName.toUtf8(), user.toUtf8(), key.toUtf8(), folderDestination.toUtf8());
}

bool UK::carpetaAUpk(QString carpeta, QString nombreUpk, QString usuario, QString clave, QString carpetaDestino)
{
    return folderToUpk(carpeta, nombreUpk, usuario, clave, carpetaDestino);
}

bool UK::downloadRemoteFolder(QString urlFolder, QString list, QString dirDestination)
{
    QStringList m0 = list.split("|");
    if(m0.size()==0){
        return false;
    }
    QDir dir0(dirDestination);
    if (!dir0.exists()) {
        dir0.mkpath(".");
    }

    for (int i = 0; i < m0.size(); ++i) {
        QByteArray rd;
        rd.append(dirDestination);
        rd.append("/");
        rd.append(m0.at(i));
        QByteArray ro;
        ro.append(urlFolder);
        ro.append("/");
        ro.append(m0.at(i));
        ro.append("?r=");
        ro.append(QDateTime::currentDateTime().toString("zzz"));
        QByteArray code;
        code.append(getHttpFile(ro));
        QFile qml(rd);
        if(qml.exists()){
            qml.remove();
        }
        if(qml.open(QIODevice::WriteOnly)){
            if(debugLog){
                if(debugLog){
                    lba="";
                    lba.append("File ");
                    lba.append(rd);
                    lba.append(" downloaded.");
                    log(lba);
                }
            }
            qml.write(code);
            qml.close();
        }else{
            if(debugLog){
                lba="";
                lba.append("Error downloading QML  ");
                lba.append(ro);
                log(lba);
            }
        }
    }
    return true;
}

bool UK::mkUpk(QByteArray folder, QByteArray upkName, QByteArray user, QByteArray key, QByteArray folderDestination)
{
    QByteArray dataUpk1="";
    QByteArray sep;
    sep.append(user);
    sep.append(key);
    if(debugLog){
        QByteArray log1;
        log1.append("Making upk from folder ");
        log1.append(folder);
        log1.append(" with upkName: ");
        log1.append(upkName);
        log(log1);
    }
    //Primeras 2 letras a hexadecimal
    QByteArray hsep;
    hsep.append(QString(QCryptographicHash::hash(sep,QCryptographicHash::Md5)));

    //Ubicaciòn final de upk
    QByteArray urlUPK;
    urlUPK.append(folderDestination);
    urlUPK.append("/");
    urlUPK.append(upkName);
    urlUPK.append(".upk");
    QFile upk(urlUPK);

    //Creando carpeta destino
    QDir dir(folder);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    dir.setFilter(QDir::Files | QDir::NoDotAndDotDot | QDir::NoSymLinks);
    if(debugLog){
        lba="";
        lba.append("Scanning: ");
        lba.append(dir.path());
        log(lba);
    }
    //Iterando la lista de archivos
    QStringList fileList = dir.entryList();
    if(debugLog){
        lba="";
        lba.append("For reading ");
        lba.append(fileList.count());
        lba.append(" files...");
        log(lba);
    }
    for (int i=0; i<fileList.count(); i++){
        //qDebug()<<"Upkando: "<<fileList[i];
        QByteArray ro;
        ro.append(folder);
        ro.append("/");
        ro.append(fileList[i]);
        QFile archOrig(ro);
        if(archOrig.size()>0&&!QString(fileList[i]).contains(".qmlc")){
         //if(archOrig.size()>0){
            if(!archOrig.open(QIODevice::ReadOnly)){
                if(debugLog){
                    lba="";
                    lba.append("Read error ");
                    lba.append(ro);
                    log(lba);
                }
                return false;
            }else{
                if(debugLog){
                    lba="";
                    lba.append("Reading: ");
                    lba.append(ro);
                    log(lba);
                }
            }

            //Preparando separador
            QByteArray s1;
            s1.append(hsep);
            QByteArray nsep;
            //nsep.append(hsep);
            if(i!=0){
                nsep.append(s1);
                nsep.append("X-X");
            }
            nsep.append(fileList[i]);
            nsep.append(s1);
            nsep.append("X+X");

            dataUpk1.append(nsep);
            dataUpk1.append(archOrig.readAll());

        }else{
            if(debugLog){
                lba="";
                lba.append("File not has data: ");
                lba.append(fileList[i]);
                log(lba);
            }
        }
    }

    //Abriendo archivo upk
    QFile upk2(urlUPK);
    if(!upk2.open(QIODevice::WriteOnly)){
        if(debugLog){
            lba="";
            lba.append("Error! not open upk: ");
            lba.append(urlUPK);
            log(lba);
        }
        return false;
    }else{
        if(debugLog){
            lba="";
            lba.append("File creation upk: ");
            lba.append(urlUPK);
            log(lba);
        }
    }

    QString dataUpk2=encPrivateData(dataUpk1, user, key);

    QTextStream entradaUpk(&upk2);
    entradaUpk.setCodec("UTF-8");
    entradaUpk<<dataUpk2;
    upk2.close();
    return true;
}

bool UK::upkToFolder(QByteArray upk, QByteArray user, QByteArray key, QByteArray folderDestination)
{
    QFile upkFile(upk);

    //Eliminar el upk existente
    if(!upkFile.exists()){
        if(debugLog){
            lba="";
            lba.append("Upk file not exist: ");
            lba.append(upk);
            log(lba);
        }
        return false;
    }else{
        if(debugLog){
            qDebug()<<"Upk file exist in: "<<upk;
        }
    }

    if(!upkFile.open(QIODevice::ReadOnly)){
        if(debugLog){
            qDebug()<<"Upk file not open or not permission: "<<upk;
        }
        return false;
    }else{
        if(debugLog){
            qDebug()<<"Upk file open in: "<<upk;
        }
    }

    QByteArray sep;
    sep.append(user);
    sep.append(key);

    QByteArray hsep;
    hsep.append(QString(QCryptographicHash::hash(sep,QCryptographicHash::Md5)));

    //Preparando separador 1
    QByteArray s1;
    s1.append(hsep);
    QByteArray nsep;
    nsep.append(s1);
    nsep.append("X-X");

    QTextStream stream(&upkFile);
    stream.setCodec("UTF-8");
    int nl=0;
    QByteArray fileData;
    do{
        fileData.append(stream.read(1));
        nl++;
        }while (nl<upkFile.size());
    upkFile.close();

    QString dec;
    dec.append(decData(fileData, user, key));
    QStringList l1=dec.split(nsep);
    for (int i = 0; i < l1.size(); ++i) {
        QString f=l1.at(i);

        QByteArray nsep2;
        nsep2.append(s1);
        nsep2.append("X+X");

        QStringList m0=f.split(nsep2);
        if(m0.size()!=2||m0.size()>2){
             qDebug()<<"upkToFolder fail in each "<<i <<" data segments "<<m0.size();
            return false;
        }
        QByteArray urlNf;
        urlNf.append(folderDestination);
        urlNf.append("/");
        urlNf.append(m0.at(0));

        QFile f1(urlNf);
        if(f1.open(QIODevice::WriteOnly)){
            QByteArray d;
            d.append(m0.at(1));
            f1.write(d);
        }
        f1.close();
    }
    return true;
}

bool UK::isFree(QString upk)
{
    QFile upkFile(upk);
    if(!upkFile.open(QIODevice::ReadOnly)){
        if(debugLog){
            lba="";
            lba.append("isFree() revision Upk file not open or not permission: ");
            lba.append(upk);
            log(lba);
        }
        return false;
    }else{
        if(debugLog){
            lba="";
            lba.append("isFree() revision Upk file open in: ");
            lba.append(upk);
            log(lba);
        }
    }

    QByteArray sep;
    sep.append("unik-free");
    sep.append("free");

    QByteArray hsep;
    hsep.append(QString(QCryptographicHash::hash(sep,QCryptographicHash::Md5)));

    //Preparando separador 1
    QByteArray s1;
    s1.append(hsep);
    QByteArray nsep;
    nsep.append(s1);
    nsep.append("X-X");

    QTextStream stream(&upkFile);
    stream.setCodec("UTF-8");
    int nl=0;
    QByteArray fileData;
    do{
        fileData.append(stream.read(1));
        nl++;
        }while (nl<upkFile.size());
    upkFile.close();
    QString dec;
    dec.append(decData(fileData, "unik-free", "free"));
    QStringList l1=dec.split(nsep);
    for (int i = 0; i < l1.size(); ++i) {
        QString f=l1.at(i);

        QByteArray nsep2;
        nsep2.append(s1);
        nsep2.append("X+X");

        QStringList m0=f.split(nsep2);
        if(m0.size()!=2||m0.size()>2){
             qDebug()<<"upkToFolder fail in each "<<i <<" data segments "<<m0.size();
            return false;
        }else{
            return true;
        }
    }
    return false;
}

bool UK::loadUpk(QString upkLocation, bool closeAppLauncher, QString user, QString key)
{
    //QString c1 = upkLocation.toString();
    QString appName="";
    QString dupl="";
    QStringList m0 = upkLocation.split("/");
    QString ext = upkLocation.mid(upkLocation.size()-4, upkLocation.size()-1);
    QString c1;
    if(m0.size()>=1&&ext==".upk"){
        QString c0 = m0.at(m0.size()-1);
        c1 = c0.replace(".upk", "");
        if(c1==""||c1=="/"||c1=="\\"||c1=="\\\\"){
            return false;
        }else{
            appName=c1;
            if(debugLog){
                qDebug()<<"loadUpk appName: "<<appName;
            }
        }
        QByteArray upk;
        upk.append("/");
        upk.append(appName);
        upk.append(".upk");
        dupl = upkLocation.replace(upk, "");
    }
    QByteArray tempFolder;
    tempFolder.append(QDateTime::currentDateTime().toString("hhmmss"));
    QString pq;
    pq.append(getPath(2));
    pq.append("/");
    pq.append(tempFolder);
    //qDebug()<<"loadUpk Temp Folder: "<<pq;

    QFile arch(upkLocation);
    bool esLocal=arch.exists();
    if(esLocal){
        if(debugLog){
            qDebug()<<"loadUpk local: "<<appName;
        }
        if(upkToFolder(upkLocation.toUtf8(),  user.toUtf8(), key.toUtf8(), pq.toUtf8())){
            if(debugLog){
                qDebug()<<appName<< " extract sucessful";
            }
            _engine->rootContext()->setContextProperty("appName", appName);
            QByteArray mainQml;
            mainQml.append(pq);
            mainQml.append("/main.qml");
            if(closeAppLauncher){
                QObject *rootQml = _engine->rootObjects().at(0);
                rootQml->setProperty("closedModeLaunch", true);
                rootQml->setProperty("visible", false);
            }
            _engine->load(QUrl::fromLocalFile(mainQml));

        }else{
            if(debugLog){
                qDebug()<<appName<< " NO extracted";
            }

        }
    }else{
        if(debugLog){
            qDebug()<<"loadUpk remote intent: "<<appName;
        }
    }
    return false;
}

bool UK::downloadGit(QByteArray url, QByteArray localFolder)
{    
    QString u;
    u.append(url);
    if(u.mid(u.size()-4, 4)!=".git"){
        u.append(".git");
    }
    QString urlZipGit;
    QString carpetaDestino;
    QStringList m0 = u.split(".git");
    if(m0.size()<2){
        qInfo("Url no valid: "+url);
        qInfo("Use: https://github.com/<user>/<repository>.git");

    }else{
        QStringList m1=u.split("/");
        QString cd0=m1.at(m1.size()-1);
        carpetaDestino = cd0.replace(".git", "");
        QString url0=u.replace(".git", "/zip/master");
        urlZipGit=url0.replace("https://github.com/", "https://codeload.github.com/");
        qInfo("Downloading zip file: "+urlZipGit.toUtf8());
    }
    qInfo("Downloading from GitHub: "+url);
    qInfo("Download Folder Location: "+carpetaDestino.toUtf8());
    QDateTime a = QDateTime::currentDateTime();
    QByteArray tempFile;
    tempFile.append(getPath(2));
    tempFile.append("/");
    tempFile.append(QString::number(a.toSecsSinceEpoch()));
    tempFile.append(".zip");
    qInfo("temp zip location "+tempFile);
    //tempFile.append("/nivelfluido-master.zip");



    bool d=downloadZipFile(urlZipGit.toUtf8(), tempFile);
    if(!d){
        qDebug("Git Zip not downloaded.");
        return false;
    }
    qInfo("Git Zip downloaded.");

#ifdef Q_OS_WIN32
    QByteArray carpDestinoFinal;
    carpDestinoFinal.append(localFolder);
    carpDestinoFinal.append("/");
    carpDestinoFinal.append(carpetaDestino);

    QByteArray cl;
    cl.append("\"");
    cl.append(getPath(1));
    cl.append("/7zip/7z.exe");
    cl.append("\"");
    cl.append(" e ");
    cl.append("\"");
    cl.append(tempFile);
    cl.append("\"");
    cl.append(" -o");
    cl.append("\"");
    cl.append(carpDestinoFinal);
    cl.append("\"");
    cl.append(" -y");
    log("Run unzip "+cl);
    run(cl);
#endif
#ifdef Q_OS_LINUX
    QByteArray carpDestinoFinal;
    carpDestinoFinal.append("\"");
    carpDestinoFinal.append(localFolder);
    carpDestinoFinal.append("\"");

    QByteArray cl;
    cl.append("unzip -o ");
    cl.append("\"");
    cl.append(tempFile);
    cl.append("\"");
    cl.append(" -d ");
    cl.append("\"");
    cl.append(getPath(2));
    cl.append("/");
    cl.append(carpetaDestino);
    cl.append("\"");
    QProcess *p1 = new QProcess(this);
    bool *pt=false;
    connect(p1, static_cast<void(QProcess::*)(int, QProcess::ExitStatus)>(&QProcess::finished),
            [=]  (int exitCode, QProcess::ExitStatus exitStatus)
    {       
        //qInfo(">>>>>>>>>>>>>>>>AAAAAAAAAAAAAAAAAAAAAA");
    });

    p1->start(cl);
    p1->deleteLater();
    while (p1->waitForFinished()) {
        qInfo("waiting where git dowloading...");
    }
    cl="";
    cl.append("cp -TRv ");
    cl.append(getPath(2));
    cl.append("/");
    cl.append(carpetaDestino);
    cl.append("/");
    cl.append(carpetaDestino);
    cl.append("-master");
    cl.append(" ");
    cl.append(carpDestinoFinal);
    cl.append("/");
    cl.append(carpetaDestino);
    qInfo("Running "+cl);
    run(cl);
#endif
#ifdef Q_OS_OSX
    QByteArray carpDestinoFinal;
    carpDestinoFinal.append(localFolder);
    //carpDestinoFinal.append("/");
    //carpDestinoFinal.append(carpetaDestino);

    QByteArray cl;
    cl.append("unzip -o ");
    cl.append(tempFile);
    //cl.append(" ");
    //cl.append(" nivelfluido-master/* ");
    cl.append(" -d ");
    cl.append(getPath(2));
    cl.append("/");
    cl.append(carpetaDestino);
    log("Run "+cl);
    run(cl);
    while (proc->waitForFinished(250)&&proc->isOpen()) {
        log(".");
    }
    //sleep(5);
    cl = "cp -R ";
    cl.append(getPath(2));
    cl.append("/");
    cl.append(carpetaDestino);
    cl.append("/");
    cl.append(carpetaDestino);
    cl.append("-master/ ");
    //cl.append(carpetaDestino);
    //cl.append("-master");
    cl.append(" ");
    cl.append(carpDestinoFinal);
    cl.append("/");
    cl.append(carpetaDestino);
    //cl.append(carpDestinoFinal);
    //cl.append("/");
    //cl.append(carpetaDestino);
    //cl.append(" -f");
    //cl.append("-master");
    log(cl);
    run(cl);
#endif

    return true;
}

bool UK::inject(QString mainQml, QString inj)
{
    //return true;
    QFile m(mainQml);
    m.open(QIODevice::ReadOnly);
    QString data = m.readAll();
    QString dataCorr = data.toUtf8();
    //qDebug()<<"XXXXXXXXXXXXXXX-->"<<dataCorr;
    QStringList m00 = data.split("ApplicationWindow");
    if(m.size()>1){
        QString r1 = m00.at(1);
        QByteArray seg;
        seg.append("ApplicationWindow");

        for (int i = 0; i < r1.size()-1; ++i) {
            QString l = r1.at(i);
            if(!l.contains("{")){
                seg.append(l);
            }else{
                break;
            }
        }
        dataCorr = data.replace(seg.constData(), "ApplicationWindow ");
    }else{
        return false;
    }
    m.close();

    QStringList m0 = dataCorr.split("ApplicationWindow {");
    if(m0.size()>1){
        QFile m2(mainQml);
        m2.open(QIODevice::WriteOnly);
        QString dataF;
        dataF.append(m0.at(0));
        dataF.append("ApplicationWindow {");
        dataF.append("\n");
        dataF.append(inj);
        dataF.append("\n");
        dataF.append(m0.at(1));
        QTextStream e(&m2);
        e.setCodec("UTF-8");
        e<<dataF;
        m2.close();
        return true;
    }
    return false;
}

void UK::restartApp()
{
#ifndef Q_OS_ANDROID
#ifndef Q_OS_IOS
    qApp->quit();
    QProcess::startDetached(qApp->arguments()[0], qApp->arguments());
#endif
#else
    //qApp->quit();
    //QProcess::startDetached(qApp->arguments()[0], qApp->arguments());

    auto activity = QtAndroid::androidActivity();
    auto packageManager = activity.callObjectMethod("getPackageManager", "()Landroid/content/pm/PackageManager;");

    auto activityIntent = packageManager.callObjectMethod("getLaunchIntentForPackage",
                                                          "(Ljava/lang/String;)Landroid/content/Intent;",
                                                          activity.callObjectMethod("getPackageName",
                                                          "()Ljava/lang/String;").object());

    auto pendingIntent = QAndroidJniObject::callStaticObjectMethod("android/app/PendingIntent", "getActivity",
                                                                   "(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;",
                                                                   activity.object(), jint(0), activityIntent.object(),
                                                                   QAndroidJniObject::getStaticField<jint>("android/content/Intent",
                                                                                                           "FLAG_ACTIVITY_CLEAR_TOP"));

    auto alarmManager = activity.callObjectMethod("getSystemService",
                                                  "(Ljava/lang/String;)Ljava/lang/Object;",
                                                  QAndroidJniObject::getStaticObjectField("android/content/Context",
                                                                                          "ALARM_SERVICE",
                                                                                          "Ljava/lang/String;").object());

    alarmManager.callMethod<void>("set",
                                  "(IJLandroid/app/PendingIntent;)V",
                                  QAndroidJniObject::getStaticField<jint>("android/app/AlarmManager", "RTC"),
                                  jlong(QDateTime::currentMSecsSinceEpoch() + 1500), pendingIntent.object());

    qApp->quit();
#endif
}

void UK::restartApp(QString args)
{
    qApp->quit();
    QStringList al = args.split(" ");
    QProcess::startDetached(qApp->arguments()[0], al);
}

bool UK::run(QString commandLine)
{
    proc = new QProcess(this);
    connect(proc, SIGNAL(readyReadStandardOutput()),this, SLOT(salidaRun()));
    connect(proc, SIGNAL(readyReadStandardError()),this, SLOT(salidaRunError()));
    proc->start(commandLine);
    if(proc->isOpen()){
        setRunCL(true);
        QString msg;
        msg.append("Run: ");
        msg.append(commandLine);
        setUkStd(msg);
        return true;
    }else{
        QString msg;
        msg.append("No Run: ");
        msg.append(commandLine);
        setUkStd(msg);
        setRunCL(false);
    }
    return false;
}

void UK::salidaRun()
{
    log(proc->readAllStandardOutput());
}

void UK::salidaRunError()
{
    log(proc->readAllStandardError());
}

void UK::finalizaRun(int e)
{
    QByteArray s;
    s.append("command line finished with status ");
    s.append(QString::number(e));
    log(s);
    proc->close();
}

void UK::log(QByteArray d)
{
    QString d2;
    d2.append(d);
    if(!_engine->rootContext()->property("setInitString").toBool()){
        initStdString.append(d2.toHtmlEscaped());
        initStdString.append("\n");
    }
    setUkStd(d2);
}

void UK::sleep(int ms)
{
    QThread::sleep(ms);
}

QString UK::getPath(int path)
{
    QString r=".";
    if(path==0){//App location Name
        r = QFileInfo(QCoreApplication::applicationFilePath()).fileName();
    }
#ifdef Q_OS_WIN
    if(path==1){//App location
        r = qApp->applicationDirPath();
    }
#endif
#ifdef Q_OS_OSX
    if(path==1){//App location
        r = qApp->applicationDirPath();
    }
#endif
#ifdef Q_OS_LINUX
    if(path==1){//App location
        r = QDir::currentPath();
    }
#endif
    if(path==2){//Temp location
        r = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
        qInfo("getPath(2): "+r.toUtf8());
    }
    if(path==3){//Doc location
#ifndef Q_OS_ANDROID
        r = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
#else
        /*QStringList pl=QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation);
        QByteArray d100;
        for (int i = 0; i < pl.size(); ++i) {
            d100.append(pl.at(i));
            d100.append(" --- ");
        }

        log("Android Docs Paths: "+d100);
        //r=pl.at(1);
        QDir doc(r);
        if(!doc.exists()){
            doc.mkdir(".");
        }*/

        /*r = "/sdcard/Documents";
        QDir doc(r);
        if(!doc.exists()){
            doc.mkdir(".");
        }*/
        //r = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
        r = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
        //r = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
        QDir doc(r);
        if(!doc.exists()){
            doc.mkdir(".");
        }
#endif

    }
    if(path==4){//AppDate location
        r = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    }
    if(path==5){//Current Dir
        r = QDir::currentPath();
    }
    QDir dir(r);
    if (!dir.exists()) {
        if(debugLog){
            lba="";
            lba.append("Making folder ");
            lba.append(r);
            log(lba);
        }
        dir.mkpath(".");
    }else{
        if(debugLog){
            lba="";
            lba.append("Folder ");
            lba.append(r);
            lba.append(" exist.");
        }
    }
    return r;
}

QString UK::encData(QByteArray d, QString user, QString key)
{
    QString ret;
    QByteArray upkData;
    QByteArray r="6226";
    QByteArray r2="6226";
    QByteArray ru;
    QString cdt = QDateTime::currentDateTime().toString("z");
    if(cdt.at(0)=="1"||cdt.at(0)=="2"||cdt.at(0)=="3"){
        //funciona
        r="9cc9";
        r2="1dd1";
    }else if(cdt.at(0)=="1"||cdt.at(0)=="2"||cdt.at(0)=="3"){
        //funciona
        r="9dd9";
        r2="1cc1";
    }else{
        //funciona
        r="6dd6";
        r2="2cc2";
    }
    QByteArray segUser;
    segUser.append(user);
    for (int i = 0; i < 40-user.size()-1; ++i) {
        segUser.append("|");
    }
    segUser.append("-");
    QByteArray segKey;
    segKey.append(key);
    for (int i = 0; i < 20-key.size(); ++i) {
        segKey.append("|");
    }
    QByteArray suH=segUser.toHex();
    QByteArray suHC;
    for (int i = 0; i < suH.size(); ++i) {
        QString uc0;
        uc0.append(suH.at(i));
        if(uc0.contains(r.at(0))){
            suHC.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            suHC.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            suHC.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            suHC.append(r2.at(3));
        }else{
            suHC.append(uc0);
        }
    }

    QByteArray skH=segKey.toHex();
    QByteArray skHC;
    for (int i = 0; i < skH.size(); ++i) {
        QString uc0;
        uc0.append(skH.at(i));
        if(uc0.contains(r.at(0))){
            skHC.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            skHC.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            skHC.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            skHC.append(r2.at(3));
        }else{
            skHC.append(uc0);
        }
    }
    ru.append(suHC);
    ru.append(skHC);
    QString nru;
    nru.append(ru);
    QString cru1 = nru;//.replace("7c7c7c7c7c7c7c7c7c7c", "783d33333b793d31307c");
    QString cru2;
    if(cru1.contains("7c7c7c7c7c7c7c7c7c7c")){
        cru2 = cru1.replace("7c7c7c7c7c7c7c7c7c7c", "783d33333b793d31307c");
    }else if(cru1.contains("7c7c7c7c7c")){
        cru2 = cru1.replace("7c7c7c7c7c", "7a3d313b7c");
    }else{
        cru2=cru1;
    }

    QByteArray ru2;
    ru2.append(cru2);
    QString ret0="";
    ret0.append(r);
    ret0.append(r2);
    ret0.append(ru2);
    QString c;
    c.append(d);
    QByteArray codeUtf8;
    codeUtf8.append(c.toUtf8());
    QString code;
    code.append(codeUtf8.toHex());
    QByteArray encode;
    for (int i = 0; i < code.size(); ++i) {
        QString uc0 = code.at(i);
        if(uc0.contains(r.at(0))){
            encode.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            encode.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            encode.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            encode.append(r2.at(3));
        }else{
            encode.append(uc0);
        }
    }

    ret0.append("||||||");
    ret0.append("I");
    ret0.append(encode);
    ret0.append("O");
    ret0.append(ru);
    return compData(ret0);
}

QString UK::decData(QByteArray d0, QString user, QString key)
{
    QString ret;

    QString pd=QString(d0);
    QByteArray d;
    d.append(desCompData(pd));

    QByteArray arch;
    QByteArray nom;
    int nl=0;
    int tipo=0;
    QByteArray r;
    QByteArray r2;
    QString passData;
    QByteArray passDataBA;
    bool passDataWrite=false;

    for (int i = 0; i < d.size(); ++i) {


        //do{
        QString l;
        l.append(d.at(i));
        QByteArray enc;
        if(l.contains(r.at(0))){
            enc.append(r.at(1));
        }else if(l.contains(r.at(2))){
            enc.append(r.at(3));
        }else if(l.contains(r2.at(0))){
            enc.append(r2.at(1));
        }else if(l.contains(r2.at(2))){
            enc.append(r2.at(3));
        }else{
            enc.append(l);
        }
        if(l.contains("O"))
        {
            tipo=0;
        }else if(l.contains("I")){
            tipo=1;
            if(!passDataWrite){
                QByteArray decSegUK;
                for (int i2 = 0; i2 < passDataBA.size(); ++i2) {
                    QString l2;
                    l2.append(passDataBA.at(i2));
                    if(l2.contains(r.at(0))){
                        decSegUK.append(r.at(1));
                    }else if(l2.contains(r.at(2))){
                        decSegUK.append(r.at(3));
                    }else if(l2.contains(r2.at(0))){
                        decSegUK.append(r2.at(1));
                    }else if(l2.contains(r2.at(2))){
                        decSegUK.append(r2.at(3));
                    }else{
                        decSegUK.append(l2);
                    }
                }
                passData.append(QByteArray::fromHex(decSegUK));
                QString pd2 = passData.replace("x=33;r=60|","|");
                QString pd3 = pd2.replace("z=6;|","|");
                QStringList m0 = pd3.split("|-");
                if(m0.size()>1){
                    QString cu = m0.at(0);
                    QString ck = m0.at(1);
                    QString nuser = cu.replace("|", "");
                    QString nkey = ck.replace("|", "");
                    if(user!=nuser||key!=nkey){
                        return "";
                    }
                }else{
                    if(debugLog){
                        lba="";
                        lba.append("Error extract! pass data not found");
                        log(lba);
                    }
                    return "";
                }
            }
            passDataWrite=true;
        }else  if(i<4){
            r.append(l);
        }else  if(i>=4&&i<8){
            r2.append(l);
        }else  if(i>=8&&i<=67+60){
            passDataBA.append(l);
    }else{
            if(tipo==0){
                //nom.append(enc);
            }else{
                arch.append(enc);
            }
        }
    }
    QString nRet;
    nRet.append(QByteArray::fromHex(arch));
    return nRet;
}

QQuickWindow *UK::mainWindow(int n)
{
    if(!_engine->rootObjects().isEmpty()&&_engine->rootObjects().size()>=n){
        QObject *aw0 = _engine->rootObjects().at(n);
        QQuickWindow *window = qobject_cast<QQuickWindow*>(aw0);
        return window;
    }else{
        QQuickWindow *window2;
        return window2;
    }
}

void UK::setProperty(const QString name, const QVariant &value)
{
    _engine->rootContext()->setProperty(name.toUtf8().constData(), value);
}

QVariant UK::getProperty(const QString name)
{
    return _engine->rootContext()->property(name.toUtf8());
}

QByteArray UK::getHttpFile(QByteArray url)
{
    QEventLoop eventLoop;
    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));
    QNetworkRequest req(QUrl(url.constData()));

    QNetworkReply *reply = mgr.get(req);
    connect(reply,SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(downloadProgress(qint64,qint64)));
    eventLoop.exec();
    QByteArray err;
    if (reply->error() == QNetworkReply::NoError) {

        return reply->readAll();
        delete reply;
    }else if (reply->error() == QNetworkReply::ContentNotFoundError) {
        err.append("Error:404");
        return err;
        delete reply;
    }else{
        if(debugLog){
            lba="";
            lba.append("Failure ");
            lba.append(reply->errorString());
            log(lba);
        }        
        err.append(reply->errorString());
        return err;
        delete reply;
    }
    return "";
}

void UK::httpReadyRead()
{
    //...
}

bool UK::downloadZipFile(QByteArray url, QByteArray ubicacion)
{
    log("downloading zip file from: "+url);
    QEventLoop eventLoop;
    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));
    QNetworkRequest req(QUrl(url.constData()));
    QNetworkReply *reply = mgr.get(req);   
    connect(reply,SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(downloadZipProgress(qint64,qint64)));
    eventLoop.exec();
    if (reply->error() == QNetworkReply::NoError) {
            QFile other(ubicacion);
            other.open(QIODevice::WriteOnly);
            other.write(reply->readAll());
            other.flush();
            other.close();
            return true;
    }else{
        if(debugLog){
            QByteArray log100;
            log100.append("Failure ");
            log100.append(reply->errorString());
            log(log100);
        }
        reply->deleteLater();
        return false;
        delete reply;
    }
    return false;
}

void UK::sendFile(QString file, QString phpReceiver)
{
    if(debugLog){
        lba="";
        lba.append("Starting sending data...");
        log(lba);
    }
    QNetworkAccessManager *am = new QNetworkAccessManager(this);
    QByteArray origen;
    origen.append(file);
    QStringList l = file.split("/");
    QByteArray destino;
    destino.append(l.at(l.size()-1));
    QStringList l2 = phpReceiver.split("/");
    if(l2.size()<2){
        return;
    }
    QString path(origen);
    QMimeDatabase dbMt;
    QMimeType type = dbMt.mimeTypeForFile(path);
    if(debugLog){
        lba="";
        lba.append("Mime type: ");
        lba.append(type.name());
        log(lba);
    }
    QByteArray urlReceiver;
    urlReceiver.append(phpReceiver);
    QNetworkRequest request(QUrl(urlReceiver.constData()));
    QString bound="margin";
    QByteArray data;
    data.append("--");
    data.append(bound);
    data.append("\r\n");
    data.append("Content-Disposition: form-data; name=\"action\"\r\n\r\n");
    data.append(l2.at(l2.size()-1));
    data.append("\r\n");
    data.append("--" + bound + "\r\n");
    data.append("Content-Disposition: form-data; name=\"uploaded\"; filename=\""+destino+"\"\r\n");
    data.append("Content-Type: ");
    data.append(type.name());
    data.append("\r\n\r\n");
    if(debugLog){
        lba="";
        lba.append("Origen: ");
        lba.append(origen);
        lba.append(" Destino: ");
        lba.append(destino);
        lba.append(" Ruta: ");
        lba.append(path);
        log(lba);
    }
    QFile localFile(path);
    if (!localFile.open(QIODevice::ReadOnly)){
        if(debugLog){
            lba="";
            lba.append("Error while opening file.");
            log(lba);
        }
        return;
    }else{
        if(debugLog){
            lba="";
            lba.append("Opening file...");
            log(lba);
        }
    }
    data.append(localFile.readAll());
    data.append("\r\n");
    data.append("--" + bound + "--\r\n");
    request.setRawHeader(QString("Accept-Charset").toUtf8(), QString("ISO-8859-1,utf-8;q=0.7,*;q=0.7").toUtf8());
    request.setRawHeader(QString("Content-Type").toUtf8(),QString("multipart/form-data; boundary="+bound).toUtf8());
    request.setRawHeader(QString("Content-Length").toUtf8(), QString::number(data.length()).toUtf8());
    respuentaSendDatos  = am->post(request,data);
    //qDebug() << data.data();
    connect(respuentaSendDatos, SIGNAL(finished()), this, SLOT(sendFinished()));
    connect(respuentaSendDatos,SIGNAL(uploadProgress(qint64,qint64)), this, SLOT(uploadProgress(qint64,qint64)));
}

void UK::uploadProgress(qint64 bytesSend, qint64 bytesTotal)
{
    double porc = (((double)bytesSend)/bytesTotal)*100;
    QString d1;
    d1.append(QString::number(porc));
    QStringList sd1=d1.split(".");
    setPorc(QString(sd1.at(0)).toInt(), 1);
}

void UK::downloadProgress(qint64 bytesSend, qint64 bytesTotal)
{
    double porc = (((double)bytesSend)/bytesTotal)*100;
    QString d1;
    d1.append(QString::number(porc));
    QStringList sd1=d1.split(".");
    setPorc(QString(sd1.at(0)).toInt(), 0);
}
void UK::sendFinished()
{
    if(debugLog){
        lba="";
        lba.append("Sending data finished!\nResponse: ");
        lba.append(respuentaSendDatos->readAll());
        log(lba);
    }
    setUploadState(respuentaSendDatos->readAll());
}
bool UK::sqliteInit(QString pathName)
{
    bool ret=false;
    if(db.isOpen()){
        db.close();
    }
    db = QSqlDatabase::addDatabase("QSQLITE");
    QByteArray rutaBD;
    rutaBD.append(pathName);
    db.setDatabaseName(rutaBD.constData());
    if(!db.open()){
        if(debugLog){
            lba="";
            lba.append("Sqlite open error");
            log(lba);
        }
    }else{
        if(debugLog){
            lba="";
            lba.append("Sqlite open ");
            lba.append(rutaBD);
            log(lba);
        }
    }
    return ret;
}

bool UK::sqliteCryptoInit(QString pathName, QString user, QString key)
{
    return false;
}

bool UK::sqlQuery(QString query)
{
    QSqlQuery q;
    q.prepare(query);
    if(q.exec()){
        if(debugLog){
            lba="";
            lba.append("sql query exec: ");
            lba.append(query);
            log(lba);

            QByteArray d;
            d.append("sql query exec: ");
            d.append(query);
            log(d);
        }
        return true;
    }
    if(debugLog){
        lba="";
        lba.append("Last command sqlite failed: ");
        lba.append(query);
        lba.append(" \nError SQL! ");
        lba.append(q.lastError().text());
        log(lba);
    }
    return false;
}

QString UK::getJsonSql(QString table, QString query, QString type)
{
    QString j="{}";
    QSqlQuery consultar;
    consultar.prepare(query);
    int cantcols=0;
    if(consultar.exec()){
        cantcols = consultar.record().count();
        j="";
        if(debugLog){
            log("Sql query is exec...");
            QString cc;
            cc.append("Column count: ");
            cc.append(QString::number(cantcols));
            cc.append("\n");
            log(cc.toUtf8());
        }

        j.append("{");
        int v=0;
        while (consultar.next()) {
            QString row;
            if(v!=0){
                row.append(",");
            }
            row.append("\"row");
            row.append(QString::number(v));
            row.append("\":");
            row.append("{");

            for (int i = 0; i < cantcols; ++i) {
                if(i==0){
                    row.append("\"col");
                }else{
                    row.append(",\"col");
                }
                row.append(QString::number(i));
                row.append("\":\"");
                QString dato = consultar.value(i).toString();
                dato.replace("\"", "\\\"");
                dato.replace("\\n", "\\\n");
                row.append(dato);
                row.append("\"");
            }

            row.append("}");
            j.append(row);
            v++;
        }
        j.append("}");
        if(debugLog){
            QString cc;
            cc.append("JSON Query result: ");
            cc.append(j);
            cc.append("\n");
            log(cc.toUtf8());
        }
    }else{
        if(debugLog){
            lba="";
            lba.append("Sql query no exec: ");
            lba.append(consultar.lastError().text());
            log(lba);
        }
        return "{}";
    }
    return j;
}

QList<QObject *> UK::getSqlData(QString table, QString query, QString type)
{
    QList<QObject*> ret;
    QSqlQuery consultar;
    consultar.prepare(query);
    int cantcols=0;
    if(consultar.exec()){
        cantcols = consultar.record().count();
        ret.clear();
        if(debugLog){
            qDebug()<<"Sql query is exec...";
            setUkStd("Sql query is exec...");
            QString cc;
            cc.append("Column count: ");
            cc.append(QString::number(cantcols));
            setUkStd(cc);
        }
        int v=0;
        while (consultar.next()) {
            Row *r = new Row(this);
            for (int i = 0; i < cantcols; ++i) {
                r->col.append(consultar.value(i).toString());
                v++;
            }
            ret.append(r);
        }
        if(debugLog){
            QByteArray cc;
            cc.append("Row count result: ");
            cc.append(QString::number(v));
            cc.append(" ");
            cc.append("Column count result: ");
            cc.append(QString::number(cantcols));
            log(cc);
        }
    }else{
        if(debugLog){
            lba="";
            lba.append("Sql query no exec: ");
            lba.append(consultar.lastError().text());
            log(lba);
        }
    }
    return ret;
}

bool UK::mysqlInit(QString hostName, QString dataBaseName, QString userName, QString password, int firtOrSecondDB)
{
    bool ret=false;
    if(firtOrSecondDB==1){
        firstDB = QSqlDatabase::addDatabase("QMYSQL");
        firstDB.setHostName(hostName);
        firstDB.setDatabaseName(dataBaseName);
        firstDB.setUserName(userName);
        firstDB.setPassword(password);
        ret = firstDB.open();
    }else{
        secondDB = QSqlDatabase::addDatabase("QMYSQL");
        secondDB.setHostName(hostName);
        secondDB.setDatabaseName(dataBaseName);
        secondDB.setUserName(userName);
        secondDB.setPassword(password);
        ret = secondDB.open();
    }
    return ret;
}

void UK::setMySqlDatabase(QString databaseName, int firtOrSecondDB)
{
    if(firtOrSecondDB==1){
        firstDB.setDatabaseName(databaseName);
    }else{
        secondDB.setDatabaseName(databaseName);
    }
}
void UK::deleteFile(QByteArray f)
{
    QFile arch(f);
    arch.remove();
}

bool UK::setFile(QByteArray n, QByteArray d)
{
    QFile file(n);
    if (!file.open(QIODevice::WriteOnly)) {
            lba="";
            lba.append("Cannot open file for writing: ");
            lba.append(file.errorString());
            log(lba);    
        return false;
    }
    QTextStream out(&file);
    out.setCodec("UTF-8");
    out << d;
    file.close();
    return true;
}

QString UK::getFile(QByteArray n)
{
    QString r;    
    QFile file(n);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        return "error";
    }
    return file.readAll();
}

bool UK::mkdir(const QString path)
{
    QDir dir0(path);
    if (!dir0.exists()) {
        dir0.mkpath(".");
    }
    return dir0.exists();
}

QString UK::getUpkTempPath()
{
    QString pq;
    pq.append(QStandardPaths::writableLocation(QStandardPaths::TempLocation));
    pq.append("/");
    pq.append(QDateTime::currentDateTime().toString("hhmmss"));
    pq.append("/");
    if(debugLog){
        lba="";
        lba.append("Temp folder of Qmls: ");
        lba.append(pq);
        //log(lba);
    }
    QDir dir0(pq);
    if (!dir0.exists()) {
        dir0.mkpath(".");
    }
    return pq;
}

QString UK::getUpksLocalPath()
{
    QSettings s;
    QString dupl;
    dupl.append(s.value("ws").toString());
    QDir dirUnikPackLocation(dupl);
    if (!dirUnikPackLocation.exists()) {
        dirUnikPackLocation.mkpath(".");
    }
    return dupl;
}

bool UK::fileExist(QByteArray fileName)
{
    QFile a(fileName);
    return a.exists();
}

void UK::unZip(QString zip_filename, QString filename)
{
       QFile infile(zip_filename);
       QFile outfile(filename);
       infile.open(QIODevice::ReadOnly);
       outfile.open(QIODevice::WriteOnly);
       QByteArray uncompressed_data = QByteArray::fromBase64(infile.readAll());
       QByteArray compressed_data = qUncompress(uncompressed_data);
       outfile.write(compressed_data);
       infile.close();
       outfile.close();
}

bool UK::createLink(QString location, QString name)
{
    return false;
}

QString UK::toHtmlEscaped(QString htmlCode)
{
    return htmlCode.toHtmlEscaped();
}

void UK::crearPDF(QString captura, QString url, int orientacion)
{
    QPdfWriter writer(url);
    QPainter painter(&writer);
    writer.setPageSize(QPagedPaintDevice::A4);
    writer.setPageOrientation(QPageLayout::Portrait);
    writer.setCreator("unik");
    //ESTO SETEADO EN 300 OBLIGA A ESCALAR * 4 LAS IMAGENES
    writer.setResolution(1200);//si esta en 600 va writer.logicalDpiX()*8*2
    //qDebug()<<"Resolucion de QPdfWriter: "<<writer.resolution();
    //qDebug()<<"QPdfWriter Logical DPI X: "<<writer.logicalDpiX();
    //qDebug()<<"QPdfWriter Logical DPI Y: "<<writer.logicalDpiY();
    if(orientacion==1){
        painter.drawPixmap(QRect(0,0,writer.logicalDpiX()*8,writer.logicalDpiY()*11.4),QPixmap(captura));
    }else{
        QMatrix rm;
        rm.rotate(90);
        QPixmap pixmapTemp(captura);
        QPixmap pixmap = pixmapTemp.transformed(rm);
        pixmap.scaled(pixmapTemp.height(), pixmapTemp.width());
        painter.drawPixmap(QRect(0,0,writer.logicalDpiX()*8,writer.logicalDpiY()*11.4),pixmap);
    }
    painter.end();
}

QString UK::encPrivateData(QByteArray d, QString user, QString key)
{
    QString ret;
    QByteArray upkData;
    QByteArray r="6226";
    QByteArray r2="6226";
    QByteArray ru;
    QString cdt = QDateTime::currentDateTime().toString("z");
    if(cdt.at(0)=="1"||cdt.at(0)=="2"||cdt.at(0)=="3"){
        //funciona
        r="3cc3";
        r2="2dd2";
    }else if(cdt.at(0)=="1"||cdt.at(0)=="2"||cdt.at(0)=="3"){
        //funciona
        r="2aa2";
        r2="3cc3";
    }else{
        //funciona
        r="6006";
        r2="4cc4";
    }
    QByteArray segUser;
    segUser.append(user);
    for (int i = 0; i < 40-user.size()-1; ++i) {
        segUser.append("|");
    }
    segUser.append("-");
    QByteArray segKey;
    segKey.append(key);
    for (int i = 0; i < 20-key.size(); ++i) {
        segKey.append("|");
    }
    QByteArray suH=segUser.toHex();
    QByteArray suHC;
    for (int i = 0; i < suH.size(); ++i) {
        QString uc0;
        uc0.append(suH.at(i));
        if(uc0.contains(r.at(0))){
            suHC.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            suHC.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            suHC.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            suHC.append(r2.at(3));
        }else{
            suHC.append(uc0);
        }
    }

    QByteArray skH=segKey.toHex();
    QByteArray skHC;
    for (int i = 0; i < skH.size(); ++i) {
        QString uc0;
        uc0.append(skH.at(i));
        if(uc0.contains(r.at(0))){
            skHC.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            skHC.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            skHC.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            skHC.append(r2.at(3));
        }else{
            skHC.append(uc0);
        }
    }
    ru.append(suHC);
    ru.append(skHC);
    QString nru;
    nru.append(ru);
    QString cru1 = nru;//.replace("7c7c7c7c7c7c7c7c7c7c", "783d33333b793d31307c");
    QString cru2;
    if(cru1.contains("7c7c7c7c7c7c7c7c7c7c")){
        cru2 = cru1.replace("7c7c7c7c7c7c7c7c7c7c", "783d33333b793d31307c");
    }else if(cru1.contains("7c7c7c7c7c")){
        cru2 = cru1.replace("7c7c7c7c7c", "7a3d313b7c");
    }else{
        cru2=cru1;
    }

    QByteArray ru2;
    ru2.append(cru2);

    QString ret0="";
    ret0.append(r);
    ret0.append(r2);
    ret0.append(ru2);
    QString c;
    c.append(d);
    QByteArray codeUtf8;
    codeUtf8.append(c.toUtf8());
    QString code;
    code.append(codeUtf8.toHex());
    QByteArray encode;
    for (int i = 0; i < code.size(); ++i) {
        QString uc0 = code.at(i);
        if(uc0.contains(r.at(0))){
            encode.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            encode.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            encode.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            encode.append(r2.at(3));
        }else{
            encode.append(uc0);
        }        
    }

    ret0.append("||||||");
    ret0.append("I");
    ret0.append(encode);
    ret0.append("O");
    ret0.append(ru);

    return compData(ret0);
}

QString UK::decPrivateData(QByteArray d0, QString user, QString key)
{
    QString ret;

    QString pd=QString(d0);
    QByteArray d;
    d.append(desCompData(pd));

    QByteArray arch;
    QByteArray nom;
    int nl=0;
    int tipo=0;
    QByteArray r;
    QByteArray r2;
    QString passData;
    QByteArray passDataBA;
    bool passDataWrite=false;

    for (int i = 0; i < d.size(); ++i) {
       QString l;
        l.append(d.at(i));
        QByteArray enc;
        if(l.contains(r.at(0))){
            enc.append(r.at(1));
        }else if(l.contains(r.at(2))){
            enc.append(r.at(3));
        }else if(l.contains(r2.at(0))){
            enc.append(r2.at(1));
        }else if(l.contains(r2.at(2))){
            enc.append(r2.at(3));
        }else{
            enc.append(l);
        }
        if(l.contains("O"))
        {
            tipo=0;
        }else if(l.contains("I")){
            tipo=1;
            if(!passDataWrite){
                QByteArray decSegUK;
                for (int i2 = 0; i2 < passDataBA.size(); ++i2) {
                    QString l2;
                    l2.append(passDataBA.at(i2));
                    if(l2.contains(r.at(0))){
                        decSegUK.append(r.at(1));
                    }else if(l2.contains(r.at(2))){
                        decSegUK.append(r.at(3));
                    }else if(l2.contains(r2.at(0))){
                        decSegUK.append(r2.at(1));
                    }else if(l2.contains(r2.at(2))){
                        decSegUK.append(r2.at(3));
                    }else{
                        decSegUK.append(l2);
                    }
                }
                passData.append(QByteArray::fromHex(decSegUK));
                QString pd2 = passData.replace("x=33;r=60|","|");
                QString pd3 = pd2.replace("z=6;|","|");
                QStringList m0 = pd3.split("|-");
                if(m0.size()>1){
                    QString cu = m0.at(0);
                    QString ck = m0.at(1);
                    QString nuser = cu.replace("|", "");
                    QString nkey = ck.replace("|", "");
                    if(user!=nuser||key!=nkey){
                        return "";
                    }
                }else{
                    if(debugLog){
                        lba="";
                        lba.append("Error extract! pass data not found.");
                        log(lba);
                    }
                    return "";
                }
            }
            passDataWrite=true;
        }else  if(i<4){
            if(l=="0"){
                r.append("d");
            }else if(l=="2"){
                r.append("9");
            }else if(l=="3"){
                r.append("9");
            }else{
                r.append(l);
            }
        }else  if(i>=4&&i<8){
            if(l=="4"){
                r2.append("c");
            }else if(l=="3"){
                r2.append("1");
            }else if(l=="2"){
                r2.append("1");
            }else{
                r2.append(l);
            }
        }else  if(i>=8&&i<=67+60){
            passDataBA.append(l);
        }else{
            if(tipo==0){
                //nom.append(enc);
            }else{
                arch.append(enc);
            }
        }
    }
    QString nRet;
    nRet.append(QByteArray::fromHex(arch));
    return nRet;
}

QString UK::compData(QString d)
{
    QString nd=d;
    for (int i = 0; i < lsim.size(); ++i) {
        QByteArray rs;
        rs.append(lsim.at(i));
        QByteArray rn;
        rn.append(lnum.at(i));
        QString ad = nd;
        nd=ad.replace(rn, rs);
    }
    return nd;
}

QString UK::desCompData(QString d)
{
    QString nd=d;
    for (int i = 0; i < lsim.size(); ++i) {
        QByteArray rs;
        rs.append(lsim.at(i));
        QByteArray rn;
        rn.append(lnum.at(i));
        QString ad = nd;
        nd=ad.replace(rs, rn);
    }
    return nd;
}

bool UK::unpackUpk(QString upk, QString user, QString key, QString folderDestination, QString appName)
{
    QByteArray lba;
    lba.append("This function unpackUpk() is not finished");
    log(lba);
    return false;
}

void UK::descZip()
{
    QByteArray file3;
    file3.append("/home/nextsigner/Documentos/nivelfluido-master.zip");
    qDebug()<<"unziping "<<file3<<"...";
    QByteArray file2;
    file2.append("nivelfluido-master");
    unZip(file3, file2);
}

void UK::downloadZipProgress(qint64 bytesSend, qint64 bytesTotal)
{
    double porc = (((double)bytesSend)/bytesTotal)*100;
    QString d1;
    d1.append(QString::number(porc));
    QStringList sd1=d1.split(".");
    setPorc(QString(sd1.at(0)).toInt(), 0);
}

#ifdef Q_OS_WIN
int UK::frameHeight(QObject *window)
{
    QQuickWindow *qw = qobject_cast<QQuickWindow *>(window);
    if(qw)
        return qw->frameGeometry().height();
    return QRect().height();
}

int UK::frameWidth(QObject *window)
{
    QQuickWindow *qw = qobject_cast<QQuickWindow *>(window);
    if(qw)
        return qw->frameGeometry().width();
    return QRect().width();
}
#endif
