#ifndef AUDIORECORDER_H
#define AUDIORECORDER_H

#include <QObject>
#include <QMediaRecorder>
#include <QUrl>

QT_BEGIN_NAMESPACE
namespace Ui { class AudioRecorder; }
class QAudioRecorder;
class QAudioProbe;
class QAudioBuffer;
QT_END_NAMESPACE

class AudioLevel;

class AudioRecorder : public QObject
{
    Q_OBJECT
public:
    explicit AudioRecorder(QObject *parent = nullptr);

signals:

public slots:
    void processBuffer(const QAudioBuffer&);
    void setOutputLocation();
    void togglePause();
    void toggleRecord();

    void updateStatus(QMediaRecorder::Status);
    void onStateChanged(QMediaRecorder::State);
    void updateProgress(qint64 pos);
    void displayErrorMessage();

signals:
    void recorded(QString audioFile);

private:
    QAudioRecorder *m_audioRecorder = nullptr;
    QAudioRecorder *m_audioRecorder2 = nullptr;
    QAudioProbe *m_probe = nullptr;
    QAudioProbe *m_probe2 = nullptr;
    int actual=0;
    QList<AudioLevel*> m_audioLevels;
    bool m_outputLocationSet = false;
    int numClip=0;
};

#endif // AUDIORECORDER_H
/*

#include <QMainWindow>

class AudioRecorder : public QMainWindow
{
    Q_OBJECT

public:
    AudioRecorder();

public slots:


private slots:


private:


};

*/
