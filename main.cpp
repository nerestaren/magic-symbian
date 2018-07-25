#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include <QLocale>
#include <QTranslator>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QTranslator tr;
    tr.load(":/i18n/magic_" + QLocale::system().name());
    app->installTranslator(&tr);

    QmlApplicationViewer viewer;
    viewer.setMainQmlFile(QLatin1String("qml/Magic/main.qml"));

    viewer.showExpanded();

    return app->exec();
}
