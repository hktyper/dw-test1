#!/bin/bash -e

# setting up AMI tools
PYTHON_VERSION_TRUC=${PYTHON_VERSION:0:3}
echo "Switching to root"
sudo su -
yum install -y ruby snappy-devel java-1.8.0-openjdk
wget https://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.noarch.rpm
rpm -K ec2-ami-tools.noarch.rpm
rpm -Kv ec2-ami-tools.noarch.rpm
yum -y install ec2-ami-tools.noarch.rpm
rm ec2-ami-tools.noarch.rpm

echo "export RUBYLIB=$RUBYLIB:/usr/lib/ruby/site_ruby:/usr/lib64/ruby/site_ruby" >> /etc/profile
echo "export PATH=$PATH:/usr/local/bin" >> /etc/profile
echo "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0" >> /etc/profile

# Set these environmental variables python 3 for spark
echo "export PYSPARK_PYTHON=/usr/local/bin/python$PYTHON_VERSION_TRUC" >> /etc/profile
echo "export PYSPARK_DRIVER_PYTHON=/usr/local/bin/python$PYTHON_VERSION_TRUC" >> /etc/profile
. /etc/profile

# Create GPG home dir for yarn user
mkdir -p /var/lib/hadoop-yarn/.gnupg
# TODO Why is this 777?
chmod -R 777 /var/lib/hadoop-yarn/

# install python and install pip
yum -y install gcc gcc-c++ zlib zlib-devel openssl-devel bzip2-devel libffi libffi-devel
mkdir -p /usr/src
cd /usr/src
wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
tar xzf Python-$PYTHON_VERSION.tgz
cd Python-$PYTHON_VERSION
./configure --enable-optimizations
make altinstall

# clean up
rm /usr/src/Python-$PYTHON_VERSION.tgz

# Install python dependencies
/usr/local/bin/pip$PYTHON_VERSION_TRUC install pipenv==2020.11.15
cd /tmp/
/usr/local/bin/pip$PYTHON_VERSION_TRUC install ./data-tech-file-utilities-python-0.0.2.tar.gz
/usr/local/bin/pip$PYTHON_VERSION_TRUC install ./data-tech-cerberus-security-extension-0.1.2.tar.gz
/usr/local/bin/pip$PYTHON_VERSION_TRUC install ./robocrop-1.2.0.tar.gz
/usr/local/bin/pip$PYTHON_VERSION_TRUC install ./library

# Install Kinesis spark streaming jars
mkdir -p /usr/lib/spark/jars/
curl https://repo1.maven.org/maven2/org/apache/spark/spark-streaming-kinesis-asl_2.11/2.4.4/spark-streaming-kinesis-asl_2.11-2.4.4.jar -o /usr/lib/spark/jars/spark-streaming-kinesis-asl_2.11-2.4.4.jar --fail
curl https://repo1.maven.org/maven2/com/amazonaws/amazon-kinesis-client/1.8.10/amazon-kinesis-client-1.8.10.jar -o /usr/lib/spark/jars/amazon-kinesis-client-1.8.10.jar --fail
curl https://repo1.maven.org/maven2/net/snowflake/spark-snowflake_2.11/2.7.0-spark_2.4/spark-snowflake_2.11-2.7.0-spark_2.4.jar -o /usr/lib/spark/jars/spark-snowflake_2.11-2.7.0-spark_2.4.jar --fail
curl https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.12.2/snowflake-jdbc-3.12.2.jar -o /usr/lib/spark/jars/snowflake-jdbc-3.12.2.jar --fail
