#!/bin/bash

hadoop_location=$(echo "/usr/local/hadoop")

function hadoop_search { # search Hadoop package version from ftp
    echo
    echo "receving list of hadoop packages..."
    echo "Please select hadoop package under below"
    echo "========================================"
    curl -l -s ftp://anonymous:passwd@ftp.tc.edu.tw/pub/Apache/hadoop/common/ | grep hadoop | sort
    echo "========================================"
    read -p 'type hadoop version: ' hadoop_version
    echo "You selected $hadoop_version"
    echo
    hadoop_download
}

function hadoop_download {
    echo "Trying to make directory on $hadoop_location"
    while true; do
        read -p "Would you like different location?[y/n]: " yn
        case $yn in
            [Yy]) 
                read -p "Please enter new location:" location
                hadoop_location=$(echo $location)
                sudo mkdir -p $hadoop_location
                cd $hadoop_location
                break;;
            [Nn]) echo "Making directory on /usr/local/hadoop"
                    echo "done"
                    if [ -e $hadoop_location ]
                    then
                        echo "Directory exists..! Continue to download package"
                    else
                        sudo mkdir -p $hadoop_location
                    fi
                    break;;
            *) echo "Please type y for yes, n for no.";;
        esac
    done
    cd $hadoop_location
    echo "Downloading $hadoop_version ..."
    sudo curl --progress-bar http://ftp.tc.edu.tw/pub/Apache/hadoop/common/$hadoop_version/$hadoop_version.tar.gz | sudo tar xz 
    sudo chown -R hadoop $hadoop_location
}

function setup_core_xml {
    export HADOOP_HOME=$hadoop_location
    local tmpFile=/tmp/core_site.xml
    local file=$HADOOP_HOME/etc/hadoop/core-site.xml
    sudo rm -rf $
    echo "========================================"
    echo "Creating core-site.xml..."
    read -p "Please type option for \"fs.default.name\" :" default_name
    read -p "Please type option for \"hadoop.tmp.dir\" :" tmp_dir
    cat >> $tmpfile <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    <configuration>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/tmp/hadooop</value>
        <description>Temporary directories.</description>
    </property>

    <property>
        <name>fs.default.name</name>
        <value>hdfs://localhost:54310</value>
        <description>A URI whose scheme and authority determine the FileSystem implementation. </description>
    </property>
    </configuration>

    EOF
}

hadoop_search