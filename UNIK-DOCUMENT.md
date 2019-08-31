# unik document

<code>
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
</code>
