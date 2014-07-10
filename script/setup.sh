#!/bin/sh

echo "Installing dependencies with cpanminus"
PERL_AUTOINSTALL=--defaultdeps LANG=C cpanm --installdeps --notest . < /dev/null

if [[ $(mysql -N -uroot -e "SELECT 1 FROM mysql.user WHERE user = 'hatena_newbie'") -ne "1" ]]; then
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'hatena_newbie'@'localhost' IDENTIFIED BY 'hatena_newbie' WITH GRANT OPTION"
  echo "User hatena_newbie@localhost (hatena_newbie) created"
fi

mysqladmin -uroot drop hatena_newbie -f > /dev/null 2>&1
mysqladmin -uroot create hatena_newbie
echo "Database \"hatena_newbie\" created"
echo "Initializing \"hatena_newbie\""
mysql -uroot hatena_newbie < db/schema.sql

mysqladmin -uroot drop hatena_newbie_test -f > /dev/null 2>&1
mysqladmin -uroot create hatena_newbie_test
echo "Database \"hatena_newbie_test\" created"
echo "Initializing \"hatena_newbie_test\""
mysql -uroot hatena_newbie_test < db/schema.sql

echo "Done."
