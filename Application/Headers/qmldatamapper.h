#ifndef QMLDATAMAPPER_H
#define QMLDATAMAPPER_H

#include <QObject>
#include <QPointer>
#include <QAbstractItemModel>
#include <QModelIndex>
#include <QQuickItem>

class QmlDataMapperPrivate;

class QmlDataMapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    explicit QmlDataMapper(QObject *parent = nullptr);

    ~QmlDataMapper();

    void clearMapping();

    void removeMapping(QObject *objec);

    int currentIndex() const;
    int count() const;

    QByteArray mappedPropertyName(QObject *object) const;

    int mappedSection(QObject *object) const;

    QObject* mappedControlAt(const int &section) const;

    QAbstractItemModel* model() const;

    void setModel(QAbstractItemModel *model);

public Q_SLOTS:
    void addMapping(QObject *object, const int &section);
    void addMapping(QObject *object, const int &section, const QByteArray &propertyName);
    void revert();
    void setCurrentIndex(int index);
    void toFirst();
    void toLast();
    void toNext();
    void toPrevious();
    void updateData(int index);
    void newData();

Q_SIGNALS:
    void currentIndexChanged(int index);
    void countChanged();
private:
    QmlDataMapperPrivate * const d;
};

#endif // QMLDATAMAPPER_H
