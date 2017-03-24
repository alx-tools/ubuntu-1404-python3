# Container for developing Python3 at Holberton School

FROM holbertonschool/base-ubuntu-1404
MAINTAINER Guillaume Salva <guillaume@holbertonschool.com>

# Adding this repo for MySQL 5.7
RUN echo 'deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7-dmr' >> /etc/apt/sources.list.d/mysql.list

RUN apt-get update
# curl/wget/git
RUN apt-get install -y curl wget git

# MySQL
RUN echo "mysql-community-server mysql-community-server/data-dir select ''" | debconf-set-selections
RUN echo "mysql-community-server mysql-community-server/root-pass password root" | debconf-set-selections
RUN echo "mysql-community-server mysql-community-server/re-root-pass password root" | debconf-set-selections
RUN echo "mysql-server-5.7 mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server-5.7 mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -y --force-yes mysql-server-5.7
RUN sed -i 's/mysqld_safe >/\/usr\/sbin\/mysqld >/g' /etc/init.d/mysql 
RUN apt-get install -y --force-yes libmysqlclient-dev

# Python3
RUN apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
RUN cd /usr/src ; wget https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz ; tar xzf Python-3.4.3.tgz ; cd Python-3.4.3 ; ./configure ; make altinstall

# be sure it's 3.4 and not 3.5
RUN ! ls /usr/bin/python3.4 && ls /usr/src/Python-3.4.3/python && cp /usr/src/Python-3.4.3/python /usr/bin/python3.4 ; exit 0

# replace python version to have 3.4.4 as default
RUN rm -f /usr/bin/python
RUN rm -f /usr/bin/python3
RUN ln -s /usr/bin/python3.4 /usr/bin/python
RUN ln -s /usr/bin/python3.4 /usr/bin/python3

# Pip3
RUN apt-get install -y python3-pip

# Pep8
RUN pip3 uninstall pep8 ; pip3 install pep8 ; pip3 install --upgrade pep8
# check if pep8 is correctly installed
RUN ! ls /usr/bin/pep8 && ls /usr/lib/python3.4/dist-packages/pep8.py && cp /usr/lib/python3.4/dist-packages/pep8.py /usr/bin/pep8 && chmod u+x /usr/bin/pep8 && sed -i '1 s/^.*$/#!\/usr\/bin\/python3/g' /usr/bin/pep8 ; exit 0

# Modules
RUN pip3 install numpy
RUN pip3 install SQLAlchemy
RUN pip3 install mysqlclient
RUN pip3 install Flask

# Fabric3
RUN apt-get install -y libffi-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y python3.4-dev
RUN apt-get install -y libpython3-dev
RUN pip3 install pyparsing
RUN pip3 install appdirs
RUN pip3 install Fabric3
