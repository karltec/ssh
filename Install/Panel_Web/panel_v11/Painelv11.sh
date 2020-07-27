#!/bin/bash
clear
IP=$(wget -qO- ipv4.icanhazip.com)
echo "America/Mexico_City" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Mexico_City /etc/localtime > /dev/null 2>&1
#dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
clear
echo -e "\E[44;1;37m           PAINEL SSHPLUS WEB v11          \E[0m"
echo ""
echo ""
echo -e "                \033[1;31mATENÇÃO"
echo ""
echo -e "\033[1;32mREPITA SEMPRE A MESMA SENHA"
echo -e "\033[1;32mSEMPRE CONFIRMA PERGUNTAS COM \033[1;37m Y"
echo ""
echo -e "\033[1;36mINICIAR INSTALAÇÃO"
echo ""
echo -e "\033[1;33mCARREGANDO..."
apt-get update > /dev/null 2>&1
echo ""
echo -e "\033[1;36mINSTALANDO O APACHE2\033[0m"
echo ""
echo -e "\033[1;33mAGUARDE..."
apt-get install apache2 -y > /dev/null 2>&1
sed -i "s;Listen 80;Listen 81;g" /etc/apache2/ports.conf
service apache2 restart > /dev/null 2>&1
apt-get install cron curl unzip -y > /dev/null 2>&1
echo ""
echo -e "\033[1;36mINSTALANDO DEPENDÊNCIAS\033[0m"
echo ""
echo -e "\033[1;33mAGUARDE..."
apt-get install php5 libapache2-mod-php5 php5-mcrypt -y > /dev/null 2>&1
service apache2 restart 
echo ""
echo -e "\033[1;36mINSTALANDO OU MySQL\033[0m"
echo ""
sleep 1
apt-get install mysql-server -y 
echo ""
clear
echo -e "                \033[1;31mATENÇÃO"
echo ""
echo -e "\033[1;32mREPITA SEMPRE A MESMA SENHA"
echo -e "\033[1;32mSEMPRE CONFIRMA PERGUNTAS COM \033[1;37m Y"
echo ""
echo -ne "\033[1;33mEnter, Para continuar!\033[1;37m"; read
mysql_install_db
mysql_secure_installation
clear
echo -e "\033[1;36mINSTALANDO O PHPMYADMIN\033[0m"
echo ""
echo -e "\033[1;31mATENÇÃO \033[1;33m!!!"
echo ""
echo -e "\033[1;32mSELECIONE A OPÇÃO \033[1;31mAPACHE2 \033[1;32mCON NA TECLA '\033[1;33mE DE ENTER\033[1;32m'"
echo ""
echo -e "\033[1;32mSELECIONE \033[1;31mYES\033[1;32m NA PRÓXIMA OPÇÃO (\033[1;36mdbconfig-common\033[1;32m)"
echo -e "PARA CONFIGURAR A BASE DE DADOS"
echo ""
echo -e "\033[1;32mSEMPRE INSIRA A MESMA SENHA"
echo ""
echo -ne "\033[1;33mEnter, para continuar!\033[1;37m"; read
apt-get install phpmyadmin -y
php5enmod mcrypt
service apache2 restart
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
apt-get install libssh2-1-dev libssh2-php -y > /dev/null 2>&1
apt-get install php5-curl > /dev/null 2>&1
service apache2 restart
clear
echo ""
echo -e "\033[1;31mATENÇÃO \033[1;33m!!!"
echo ""
echo -ne "\033[1;32mENTRE COM A MESMA SENHA\033[1;37m: "; read senha
echo -e "\033[1;32mOK\033[1;37m"
sleep 1
mysql -h localhost -u root -p$senha -e "CRIAR BASE DE DADOS sshplus"
clear
echo -e "\033[1;36mFINALIZANDO A INSTALACAO\033[0m"
echo ""
echo -e "\033[1;33mAGUARDE..."
echo ""
mkdir /var/www/html
cd /var/www/html
wget https://github.com/karltec/ssh/blob/master/Install/Panel_Web/panel_v11/PAINELWEB1.zip > /dev/null 2>&1
sleep 1
unzip PAINELWEB1.zip > /dev/null 2>&1
rm -rf PAINELWEB1.zip index.html > /dev/null 2>&1
service apache2 restart
sleep 1
if [[ -e "/var/www/html/pages/system/pass.php" ]]; then
sed -i "s;suasenha;$senha;g" /var/www/html/pages/system/pass.php > /dev/null 2>&1
fi
sleep 1
cd
wget https://raw.githubusercontent.com/karltec/ssh/master/Install/Panel_Web/panel_v11/sshplus.sql?token=ANNJ2UHVWZMUWBPNW2TNZAS7AFFHU > /dev/null 2>&1
sleep 1
if [[ -e "$HOME/sshplus.sql" ]]; then
    mysql -h localhost -u root -p$senha --default_character_set utf8 sshplus < sshplus.sql
    #rm /root/sshplus.sql
else
    clear
    echo -e "\033[1;31mFALHA NA IMPORTACAO DA BASE DE DADOS\033[0m"
    sleep 2
    exit
fi
echo '* * * * * root /usr/bin/php /var/www/html/pages/system/cron.php' >> /etc/crontab
echo '* * * * * root /usr/bin/php /var/www/html/pages/system/cron.ssh.php ' >> /etc/crontab
echo '* * * * * root /usr/bin/php /var/www/html/pages/system/cron.sms.php' >> /etc/crontab
echo '* * * * * root /usr/bin/php /var/www/html/pages/system/cron.online.ssh.php' >> /etc/crontab
echo '10 * * * * root /usr/bin/php /var/www/html/pages/system/cron.servidor.php' >> /etc/crontab
/etc/init.d/cron reload > /dev/null 2>&1
/etc/init.d/cron restart > /dev/null 2>&1
chmod 777 /var/www/html/admin/pages/servidor/ovpn
chmod 777 /var/www/html/admin/pages/download
chmod 777 /var/www/html/admin/pages/faturas/comprovantes
service apache2 restart
sleep 1
clear
echo -e "\033[1;32mPAINEL INSTALADO COM SUCESSO!"
echo ""
echo -e "\033[1;36mLINK DA AREA DO ADMIN:\033[1;37m $IP:81/admin\033[0m"
echo -e "\033[1;36mLINK DA AREA DO REVENDEDOR: \033[1;37m $IP:81\033[0m"
echo -e "\033[1;36mUSUARIO\033[1;37m admin\033[0m"
echo -e "\033[1;36mSENHA\033[1;37m admin\033[0m"
echo -e "\033[1;33mAltere a senha ao entrar no painel\033[0m"
cat /dev/null > ~/.bash_history && history -c
