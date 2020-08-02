https://www.tightvnc.com/

http://www.9bis.net/kitty/

https://www.autoitscript.com/site/

1.выдаёт Пользователю только ID


![alt text](https://github.com/maxlinus/TightVNCHELPDESK/blob/master/image/1.png)


при подключении у пользователя появляется окно с подтверждением.


![alt text](https://github.com/maxlinus/TightVNCHELPDESK/blob/master/image/2.png)

подключаться к одному пользователю может не ограниченное количество людей по одному ID.
 
для подключения можно использовать любой VNC Client
указывается строчка IP ретранслятора и ID в виде порта. Например для подключения с телефонов и планшетов


![alt text](https://github.com/maxlinus/TightVNCHELPDESK/blob/master/image/3.png)


2.Добавлена возможность проброса любого порта до клиента и дальше.(ssh tunnel)
Это удобно если из вне нету доступа к серверу например rdp , можно пробросить порт прямо до него минуя nat .

![alt text](https://github.com/maxlinus/TightVNCHELPDESK/blob/master/image/4.png)

для такого проброса нужно указать какой порт будет снаружи и какой внутри сети 


![alt text](https://github.com/maxlinus/TightVNCHELPDESK/blob/master/image/5.png)


для подключения по нужному протоколу используйте клиента со СВОЕГО компьютера ,  нужно указать ip  ретранслятора и порт для подключения.

![alt text](https://github.com/maxlinus/TightVNCHELPDESK/blob/master/image/6.png)

пробрасывать можно любые порты TCP.

после закрытия helpdesk Убедитесь что порты снаружи закрыты. 


# Для работы потребуется SSH Server

Если SSH-сервер у вас не предустановлен, устанавливаем на примере Debian GNU/Linux:

apt-get install openssh-server

Добавляем в конфигурацию ‘/etc/ssh/sshd_config’ в конце файла:


;ssh reverse tunnel bind to all interfaces

GatewayPorts yes

TCPKeepAlive yes

ClientAliveInterval 5

ClientAliveCountMax 2

Перезапускаем SSH-сервер:

service ssh restart

И добавляем служебного пользователя, к примеру ‘helper’, без доступа к консоли:

useradd -M -s /bin/false helper

passwd helper

Если вы настраивали iptables, то откройте диапазон портов 20000-60000:

iptables -A INPUT -p TCP --dport 20000:60000 -j ACCEPT

Взято у https://zerolab.net/

kitty создать сессию для покдлючения к ssh , сохранить в \InstantSupport_Files\Sessions

В файл repeaterData.au3 указать данные для подключения (ip, port, пароль из файлы сесии kitty)

Пароль берется в kitty, пример "Password\66133Pgfgf8zp0dgfdgfduIe0xKEUq7iwQP\"

# Для компиляции потребуется Autoit
