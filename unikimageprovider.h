#ifndef UNIKIMAGEPROVIDER_H
#define UNIKIMAGEPROVIDER_H

#include <QGuiApplication>
#include <QScreen>
#include <QObject>
#include <QQuickImageProvider>

class UnikImageProvider : public QQuickImageProvider
{
    public:
    UnikImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override
    {
       int width = 100;
       int height = 50;

       if (size)
          *size = QSize(width, height);
       QPixmap pixmap(requestedSize.width() > 0 ? requestedSize.width() : width,
                      requestedSize.height() > 0 ? requestedSize.height() : height);
       //pixmap.fill(QColor(id).rgba());
       QScreen *s = QGuiApplication::primaryScreen();
       pixmap=QPixmap::fromImage(s->grabWindow(0).toImage());
       return pixmap;
    }
};

#endif // UNIKIMAGEPROVIDER_H
