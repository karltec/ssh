#!/bin/bash
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
IP=$(wget -qO- ipv4.icanhazip.com)
clear
echo -e "\E[44;1;37m           PAINEL SSH BR V20           \E[0m"
echo ""
echo -e "                \033[1;31mATENCAO"
echo ""
echo -e "\033[1;32m INFORME SEMPRE A MESMA SENHA"
echo -e "\033[1;32m SEMPRE COMFIME AS QUESTOES COM\033[1;37m Y"
echo ""
echo -e "\033[1;36m INICIANDO INSTALACAO"
echo ""
echo -e "\033[1;33m AGUARDE..."
apt-get update > /dev/null 2>&1
echo ""
echo -e "\033[1;36m INSTALANDO O APACHE2\033[0m"
echo ""
echo -e "\033[1;33m AGUARDE..."
apt-get install apache2 -y > /dev/null 2>&1
sed -i "s/Listen 80/Listen 81/g" /etc/apache2/ports.conf
apt-get install cron curl unzip -y > /dev/null 2>&1
echo ""
echo -e "\033[1;36m INSTALANDO DEPENDENCIAS\033[0m"
echo ""
echo -e "\033[1;33m AGUARDE..."
apt-get install php5 libapache2-mod-php5 php5-mcrypt -y > /dev/null 2>&1
service apache2 restart 
echo ""
echo -e "\033[1;36m INSTALANDO O MySQL\033[0m"
echo ""
sleep 1
apt-get install mysql-server -y
echo ""
clear
echo -e "                \033[1;31m ATENCAO"
echo ""
echo -e "\033[1;32m INFORME SEMPRE A MESMA SENHA QUANDO PEDIR"
echo -e "\033[1;32m SEMPRE COMFIME AS QUESTOES COM\033[1;37m Y"
echo ""
echo -ne "\033[1;33m Enter, Para Prosseguir!\033[1;37m"; read
mysql_install_db 
mysql_secure_installation 
clear
echo -e "\033[1;36m INSTALANDO O PHPMYADMIN\033[0m"
echo ""
echo -e "\033[1;31m ATENCAO \033[1;33m!!!"
echo ""
echo -e "\033[1;32m SELECIONE A OPCAO \033[1;31mAPACHE2 \033[1;32mCOM A TECLA '\033[1;33mESPACO\033[1;32m'"
echo ""
echo -e "\033[1;32m SELECIONE \033[1;31mYES\033[1;32m NA OPCAO A SEGUIR (\033[1;36mdbconfig-common\033[1;32m)"
echo -e "PARA CONFIGURAR O BANCO DE DADOS"
echo ""
echo -e "\033[1;32m LEMBRE-SE INFORME A MESMA SENHA QUANDO SOLICITADO"
echo ""
echo -ne "\033[1;33m Enter, Para Prosseguir!\033[1;37m"; read
apt-get install phpmyadmin -y 
php5enmod mcrypt 
service apache2 restart
ln -s /usr/share/phpmyadmin /var/www/phpmyadmin 
apt-get install libssh2-1-dev libssh2-php -y 
if [ "$(php -m |grep ssh2)" = "ssh2" ]; then
  true
else
  clear
  echo -e "\033[1;31m ERRO CRITICO\033[0m"
  rm $HOME/install.sh
  exit
fi
apt-get install php5-curl > /dev/null 2>&1
service apache2 restart
clear
echo ""
echo -e "\033[1;31m ATENCAO \033[1;33m!!!"
echo ""
echo -ne "\033[1;32m INFORME A MESMA SENHA\033[1;37m: "; read senha
echo -e "\033[1;32m OK\033[1;37m"
sleep 1
mysql -h localhost -u root -p$senha -e "CREATE DATABASE sshplus" > /dev/null 2>&1
clear
echo -e "\033[1;36m FINALIZANDO INSTALACAO\033[0m"
echo ""
echo -e "\033[1;33m AGUARDE..."
echo ""
cd /var/www
rm -f -R *
wget https://github.com/karltec/ssh/blob/master/Install/Panel_Web/painel_v20/painel_v20.zip > /dev/null 2>&1
sleep 1
unzip painel_v20.zip > /dev/null 2>&1
rm -rf painel_v20.zip index.html > /dev/null 2>&1
service apache2 restart
sleep 1
if [[ -e "/var/www/pages/system/pass.php" ]]; then
sed -i "s;roote19;$senha;g" /var/www/pages/system/pass.php > /dev/null 2>&1
fi
sleep 1
cd
wget https://raw.githubusercontent.com/karltec/ssh/master/Install/Panel_Web/painel_v20/pv20.sql?token=ANNJ2UHPMYQIUEM43D5CJWC7AFQHM > /dev/null 2>&1
sleep 1
if [[ -e "$HOME/pv20.sql" ]]; then
    mysql -h localhost -u root -p$senha --default_character_set utf8 sshplus < pv20.sql
    rm /root/pv20.sql
else
    clear
    echo -e "\033[1;31m ERRO AO IMPORTAR BANCO DE DADOS\033[0m"
    sleep 2
    rm /root/install.sh > /dev/null 2>&1
    exit
fi
echo '*,10 * * * * root /usr/bin/php /var/www/pages/system/cron.php' >> /etc/crontab
echo '*,10 * * * * root /usr/bin/php /var/www/pages/system/cron.ssh.php ' >> /etc/crontab
echo '*,10 * * * * root /usr/bin/php /var/www/pages/system/cron.online.ssh.php' >> /etc/crontab
echo '10 * * * * root /usr/bin/php /var/www/pages/system/cron.servidor.php' >> /etc/crontab
echo '*,10 * * * root /bin/autobackup.sh' >> /etc/crontab
echo '*,10 * * * root /bin/usersteste.sh' >> /etc/crontab
/etc/init.d/cron reload > /dev/null 2>&1
/etc/init.d/cron restart > /dev/null 2>&1
chmod 777 /var/www/admin/pages/servidor/ovpn
chmod 777 /var/www/admin/pages/download
chmod 777 /var/www/admin/pages/faturas/comprovantes
cd /bin
wget https://github.com/karltec/ssh/blob/master/Install/Panel_Web/painel_v20/usersteste.sh > /dev/null 2>&1
wget https://github.com/karltec/ssh/blob/master/Install/Panel_Web/painel_v20/autobackup.sh > /dev/null 2>&1
chmod 777 usersteste.sh
chmod 777 autobackup.sh
cd
service apache2 restart
sleep 1
clear
echo -e "\033[1;32m PAINEL INSTALADO COM SUCESSO!"
echo ""
echo -e "\033[1;36m SEU PAINEL\033[1;37m http://$IP:81\033[0m"
echo -e "\033[1;36m USUARIO\033[1;37m admin\033[0m"
echo -e "\033[1;36m SENHA\033[1;37m admin\033[0m"
echo ""
echo -e "\033[1;33m Altere a senha quando logar no painel\033[0m"
cat /dev/null > ~/.bash_history && history -c
rm /root/install.sh > /dev/null 2>&1
