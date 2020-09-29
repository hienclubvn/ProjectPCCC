#ifndef GETCOMPORT_H
#define GETCOMPORT_H
#include <QString>
#include <QObject>


class ComPort: public QObject {
  Q_OBJECT
    Q_PROPERTY( int q_number_port READ getNumberPort  NOTIFY varChanged)
    Q_PROPERTY(QStringList q_port READ getPort NOTIFY varChanged)
    Q_PROPERTY(QString q_current_port WRITE setPort NOTIFY varChanged)
signals:
    void varChanged ();
public:
    ComPort();
    //
    Q_INVOKABLE void getPortAvalable (void);
    //
    QStringList getPort() {return m_port;}
    void setPort(QString port) {m_port_name = port;}
    //
    int getNumberPort(){return m_number_port;}
    //
private:
     QString  m_port_name;          // danh sach cong com
     int m_number_port;               // so luong cong com
     QStringList m_port;

};

#endif // GETCOMPORT_H
