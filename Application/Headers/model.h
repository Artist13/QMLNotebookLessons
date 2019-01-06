#ifndef MODEL_H
#define MODEL_H

#include <QObject>
#include <QSqlQueryModel>

class Model : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit Model(QObject *parent = nullptr);

    enum Roles{
            IdRole = Qt::UserRole + 1,
            FNameRole,
            SNameRole,
            TNameRole,
            BirthRole,
            ClassRole,
            SubjectRole
        };
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    //Переводит список полей указанных в объекте в запрос
    void addElement(QVariantList data);
    void getWithFilter(QString _filter);
protected:
    QHash<int, QByteArray> roleNames() const;
    QString filter;
signals:

public slots:
    QString getPersonString(int row);
    int getId(int row);
    void updateModel();
    void add(QString _fname, QString _sname, QString _tname, QString _birth = "", QString _class = "", QString _subject = "");
    void setFilter(QString _filter);
};

#endif // MODEL_H
