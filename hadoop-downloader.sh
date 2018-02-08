#!/bin/bash
hadoop_version= ""
hadoop_location= "/usr/local/hadoop"

function hadoop_search { # search Hadoop package version from ftp
    echo
    echo "receving list of hadoop packages..."
    echo "Please select hadoop package under below"
    echo "========================================"
    curl -l -s ftp://anonymous:passwd@ftp.tc.edu.tw/pub/Apache/hadoop/common/ | grep hadoop | sort
    echo "========================================"
    read -p 'type hadoop version: ' $hadoop_version
    echo "You selected $hadoop_version"
    echo
    hadoop_download
}

function hadoop_download {
    echo "Trying to make directory on /usr/local/hadoop"
    while true; do
        read -p "Would you like different location?[y/n]: " yn
        case $yn in
            [Yy]* ) read -p "Please enter new location:" $hadoop_location; mkdir $hadoop_location ; cd $hadoop_location; break;;
            [Nn]* ) echo "Making directory on /usr/local/hadoop"; echo "done"; 
                    if [ -e $hadoop_location ]
                    then
                        echo "Directory exists..! Continue to download to package"
                        cd $hadoop_location
                    else
                        sudo mkdir $hadoop_location
                        cd $hadoop_location
                    fi
                    break;;
            *) echo "Please type y for yes, n for no.";;
        esac
    done
    echo "Downloading $hadoop_version ..."
    sudo curl --progress-bar http://ftp.tc.edu.tw/pub/Apache/hadoop/common/$hadoop_version/$hadoop_version.tar.gz | sudo tar xz 
    sudo chown -R hadoop $hadoop_location
}

hadoop_search