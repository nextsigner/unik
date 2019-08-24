#ifndef UK_H
#define UK_H

#include <QObject>
//#include <QCoreApplication>
#include <QGuiApplication>
#include <QScreen>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>


//Librerías Varias
#include <QTimer>
#include <QTextStream>
#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QBuffer>
#include <QDebug>
#include <QMimeDatabase>
#include <QPdfWriter>
#include <QPainter>
#include <QProcess>
#include <QSettings>
#include <QtWidgets/QDesktopWidget>

//Librerias Android
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QtAndroid>
#include <QtAndroidExtras/QAndroidJniObject>
#endif

#include <quazip.h>
#include <quazipfile.h>


//Libreria QtQuick
#include <QQuickWindow>
#include <QQuickItemGrabResult>

//Librerías NetworkAccesManager
#include <QtNetwork/QNetworkInterface>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkCacheMetaData>
#include <QtNetwork/QAbstractNetworkCache>
#include <QUrl>
#include <QUrlQuery>
#include <QEventLoop>

//Librerías Sqlite
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>

//Librelias Multimedia
#include <QMediaPlayer>

//Librerias Json
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>

#include <QDateTime>
#include <QStandardPaths>
#include <QThread>
#include "row.h"
#include "unikimageprovider.h"

//Librerias Chat Server
#include "qwebchannel.h"
#include "chatserver.h"

#include "websocketclientwrapper.h"
#include "websockettransport.h"

#include <QtWebSockets/QWebSocketServer>

//ENCDEC DEF
#define rA1 "9cc9"
#define rA2 "1dd1"
#define rB1 "9dd9"
#define rB2 "1cc1"
#define rC1 "6dd6"
#define rC2 "2cc2"

#define rpA1 "3cc3"
#define rpA2 "2dd2"
#define rpB1 "2aa2";
#define rpB2 "3cc3";
#define rpC1 "6006"
#define rpC2 "4cc4"

//#include "uniksqlitecrypto.h"

#ifdef UNIK_COMPILE_LINUX_RPI
#include "mmapGpio.h"
#endif

class UK : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int porc READ getPorc  NOTIFY porcChanged)
    Q_PROPERTY(QString uploadState READ getUploadState WRITE setUploadState NOTIFY uploadStateChanged)
    Q_PROPERTY(bool runCL READ getRunCL WRITE setRunCL NOTIFY runCLChanged)
    Q_PROPERTY(bool debugLog READ getDebugLog WRITE setDebugLog NOTIFY debugLogChanged)
    Q_PROPERTY(QString ukStd READ getUkStd() WRITE setUkStd NOTIFY ukStdChanged)
    Q_PROPERTY(QString stdErr READ getStdErr WRITE setStdErr NOTIFY stdErrChanged)
    Q_PROPERTY(QString initStdString READ getInitStdString WRITE setInitStdString)
    Q_PROPERTY(QString uWarning READ getUWarning WRITE setUWarning NOTIFY uWarningChanged)
public:
    explicit UK(QObject *parent = nullptr);
    ~UK();
    QGuiApplication *app;
    QWebSocketServer *_server;    
    WebSocketClientWrapper *_clientWrapper;
    QWebChannel *_channel;
    ChatServer* _chatserver;

    //Variables Globales
    QString pws;

    QStringList uErrors;
    QString uWarning;

    //Propiedades para QML
    int porc;
    QString uploadState;
    QString ukStd;
    QString stdErr;
    bool runCL;

    Q_INVOKABLE QString getUWarning(){
        return uWarning;
    }
    Q_INVOKABLE void setUWarning(QString uw){
        uWarning.clear();
        uWarning.append(uw);
        emit uWarningChanged();
    }
    Q_INVOKABLE int getPorc(){
        return porc;
    }
    Q_INVOKABLE void setPorc(int p, int mode){
        porc = p;
        emit porcChanged();
        if(porc>0){
            QByteArray porcent;
            if(mode==0){
                porcent.append("downloaded ");
            }
            if(mode==1){
                porcent.append("uploaded ");
            }
            porcent.append("%");
            porcent.append(QString::number(porc));
            log(porcent);
            }
    }
    Q_INVOKABLE QString getUploadState(){
        return uploadState;
    }
    Q_INVOKABLE void setUploadState(QString us){
        uploadState = us;
        emit uploadStateChanged();
    }
    QString getUkStd(){
        return ukStd;
    }
    void setUkStd(const QString s){
        QString u="";
        u.append(s.toHtmlEscaped());
        u.append("\n");
        ukStd=u;
        if(debugLog){
            qDebug()<<s;
        }
        emit ukStdChanged();
    }
    Q_INVOKABLE QString getStdErr(){
        return stdErr;
    }
    Q_INVOKABLE void setStdErr(QString s){
        stdErr = s;
        emit stdErrChanged();
    }
    Q_INVOKABLE QString getInitStdString(){
        return initStdString;
    }
    Q_INVOKABLE void setInitStdString(QString s){
        initStdString = s;
    }
    Q_INVOKABLE QObject* unik(){
        return this;
    }
    Q_INVOKABLE bool getRunCL(){
        return runCL;
    }
    Q_INVOKABLE void setRunCL(bool b){
        runCL = b;
        emit runCLChanged();
    }
    Q_INVOKABLE void setDebugLog(bool b){
        debugLog = b;
        emit debugLogChanged();
    }
    Q_INVOKABLE bool getDebugLog(){
        return debugLog;
    }
    Q_INVOKABLE void setHost(QString nh);
    Q_INVOKABLE QString host();

    QQmlApplicationEngine *_engine;
    void setEngine(QQmlApplicationEngine *e){
        _engine = e;
        //connect(_engine, SIGNAL(quit()), this, SLOT(engineQuited()));
    }
    Q_INVOKABLE void clearComponentCache(){
        _engine->clearComponentCache();
    }

#ifndef Q_OS_ANDROID
#ifdef __arm__
    Q_INVOKABLE bool createLnk(QString execString, QString destopLocationFilename, QString name, QString comment){
        return createLink(execString, destopLocationFilename, name, comment);
    }
#endif
#endif
    QString initStdString;
    bool debugLog=false;
    bool canCloseApp=false;
    bool splashClosed=false;

    //Engine Root Context Properties
    bool wait=false;
    bool splashvisible=true;
    bool setInitString=false;

#ifdef UNIK_COMPILE_RPI
    //GPIO functions for RPI
    //This function returns void values for other os.
    Q_INVOKABLE void initRpiGpio();
    Q_INVOKABLE void setPinType(int pin, int type);
    Q_INVOKABLE void setPinState(int pin, int state);
    Q_INVOKABLE unsigned int readPin(unsigned int pin);
    Q_INVOKABLE void writePinHigh(unsigned int pinnum);
    Q_INVOKABLE void writePinLow(unsigned int pinnum);
    Q_INVOKABLE bool pinIsHigh(int pin);
#endif
    //For Audio Stream
    qint64 uFileSize=0;

 signals:
    //Señales para QML
    void log();
    void uWarningChanged();
    void porcChanged();
    void uploadStateChanged();
    void ukStdChanged();
    void stdErrChanged();
    void runCLChanged();
    void debugLogChanged();
//#ifdef Q_OS_ANDROID
    void initWSS(QQmlApplicationEngine *_engine, const QByteArray, const int, const QByteArray);
/*#else
    void initWSS(const QByteArray, const int, const QByteArray);
#endif*/
    void restartingApp();

public slots:
    void ukClose(QQuickCloseEvent *close);
    void engineExited(int n);
    void engineQuited(QObject*);

    //Funciones del OS
    int getScreenWidth();
    int getScreenHeight();

    //Funciones del Sistema Unik
    QString getUnikProperty(const QByteArray propertyName);
    void setUnikStartSettings(const QString params);
    QList<QString> getUnikStartSetting();
    void setWorkSpace(QString ws);
    void definirCarpetaTrabajo(QString et);
    bool folderToUpk(QString folder, QString upkName, QString user, QString key, QString folderDestination);
    bool carpetaAUpk(QString carpeta, QString nombreUpk, QString usuario, QString clave, QString carpetaDestino);
    bool runAppFromZip(QByteArray url, QByteArray localFolder);
    bool downloadRemoteFolder(QString urlFolder, QString list, QString dirDestination);
    //bool extraerUpk(QString appName, QString origen, QString dirDestino, QString user, QString key);
    bool mkUpk(QByteArray folder, QByteArray upkName, QByteArray user, QByteArray key, QByteArray folderDestination);
    bool upkToFolder(QByteArray upk, QByteArray user, QByteArray key, QByteArray folderDestination);
    bool isFree(QString upk);
    bool loadUpk(QString upkLocation, bool closeAppLauncher, QString user, QString key);
    bool downloadGit(QByteArray url, QByteArray localFolder);
    void restartApp();
    void restartApp(QString args);
    bool run(QString commandLine);
    void writeRun(QString data);
    bool ejecutarLineaDeComandoAparte(QString lineaDeComando);
    void salidaRun();
    void salidaRunError();
    void finalizaRun(int e);
    void log(QByteArray d);
    void sleep(int ms);
    QString getPath(int path);
    QString encData(QByteArray d, QString user, QString key);
    QString decData(QByteArray d0, QString user, QString key);
    QQuickWindow *mainWindow(int n);
    void setProperty(const QString name, const QVariant &value);
    QVariant getProperty(const QString name);
    bool isRPI();

    //Funciones Network
    QByteArray getHttpFile(QByteArray url);
    void httpReadyRead();
    bool downloadZipFile(QByteArray url, QByteArray ubicacion);
    void sendFile(QString file, QString phpReceiver);
    void uploadProgress(qint64 bytesSend, qint64 bytesTotal);
    void downloadProgress(qint64 bytesSend, qint64 bytesTotal);
    void sendFinished();
    bool startWSS(QByteArray ip,  int port, QByteArray serverName);

    //Funciones Sqlite
    bool sqliteInit(QString pathName);
    bool sqlQuery(QString query);
    QList<QObject *> getSqlData(QString query);
    bool mysqlInit(QString hostName, QString dataBaseName, QString userName, QString password, int firtOrSecondDB);
    void setMySqlDatabase(QString databaseName, int firtOrSecondDB);
    void sqliteClose();

    //Funciones de Sistema de Archivos
    void cd(QString folder);
    QString currentFolderPath();
    QString currentFolderName();
    void deleteFile(QByteArray f);
    bool setFile(QByteArray n, QByteArray d);
    QString getFile(QByteArray n);
    bool mkdir(const QString path);
    QList<QString> getFolderFileList(const QByteArray folder);
    QString getUpkTempPath();
    QString getUpksLocalPath();
    bool fileExist(QByteArray fileName);
    QByteArray base64ToByteArray(const QByteArray data);
    QByteArray byteArrayToBase64(const QByteArray data);
    QByteArray uCompressed(const QByteArray data);

#ifdef Q_OS_WIN
    bool createLink(QString execString,  QString arguments, QString lnkLocationFileName, QString description, QString workingDirectory);
#endif
#ifdef Q_OS_LINUX
    Q_INVOKABLE bool createLink(QString execString, QString desktopLocationFileName, QString name, QString comment);
    Q_INVOKABLE bool createLink(QString execString, QString desktopLocationFileName, QString name, QString comment, QString iconPath);


    //Funciones de Imagen

    QImage getScreen(int screen);
    Q_INVOKABLE QByteArray imageCameraCapturaToByteArray(QString url);
    //From Qml call
    /*item.grabToImage(function(result) {
        unik.setFile('/tmp/imageData.txt',unik.itemToImageData(result));
    });*/
    Q_INVOKABLE QByteArray itemToImageData(QObject *item);
    Q_INVOKABLE QByteArray screenImageData(int screen);


    //Funciones para Audio
    Q_INVOKABLE QByteArray  sendAudioStreamWSS(const QString audioFilePath, int bytes);
    Q_INVOKABLE void appendAudioStreamFileWSS(const QString audioFilePath, const QByteArray data);
#endif

    //Funciones Varias
    QString toHtmlEscaped(QString htmlCode);
    void crearPDF(QString captura, QString url, int orientacion);

#ifdef Q_OS_WIN
    int frameHeight(QObject *window);
    int frameWidth(QObject *window);
#endif


private slots:
    QString encPrivateData(QByteArray d, QString user, QString key);
    QString decPrivateData(QByteArray d0, QString user, QString key);

    QString compData(QString d);
    QString desCompData(QString d);

    void downloadZipProgress(qint64 bytesSend, qint64 bytesTotal);

private:
    QSqlDatabase db;
    QSqlDatabase firstDB;
    QSqlDatabase secondDB;
    QStringList lsim;//=QStringList()<<"g"<<"h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z";
    QStringList lnum;//=QStringList("11,33,66,77,88,99,20,30,40,60,70,80,90,12,21,57,82,92,84,72");
    QByteArray lba;    
    QString h;

    //UnikSqliteCrypto dbc;

   QString uZipUrl;
   int uZipSize;
   int uZipSizeReg;
   bool doResume;
   bool httpRequestAborted;
   bool retried;
   int bytesWritten;
   QNetworkReply *reply2;
   QNetworkAccessManager *qnam;
   QFile *file;
   QByteArray dzip;

    //QQuickItem itemLogView;

    QProcess *proc;

    QNetworkReply *respuentaSendDatos;
    QImage *frame;

    //Variables de Imagen
    UnikImageProvider *uip;

    //Variables Multimedia
    QMediaPlayer *mPlayer;
    QBuffer *mBuffer;
    QByteArray databuf;



#ifndef Q_OS_ANDROID
#ifdef __arm__
    mmapGpio *rpiGpio;
#endif
#endif
};

/*void UK::unikStdOut(QtMsgType type,
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
        //log(message.toUtf8());
    //}
}*/
#endif
