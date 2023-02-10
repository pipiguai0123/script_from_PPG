#! /bin/bash
#author:zhangzhenzhou0123@gmail.com
#Remark：自动安装docker及docker-compose

echo "---------开始安装---------"
sleep 1
echo "############判断是否安装了docker##############"
if ! type docker >/dev/null 2>&1; then
#使用yum下载Docker的镜像源，下面为cat直接写入
#yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#
        cat >/etc/yum.repos.d/docker.repo<<EOF
[docker-ce-edge]
name=Docker CE Edge - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/\$basearch/edge
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF

    echo 'docker 未安装';
        echo '开始安装Docker....';
        yum -y install yum-utils device-mapper-persistent-data lvm2
        yum -y install bash-completion.noarch net-tools vim lrzsz wget tree screen lsof tcpdump nc telnet unzip 

        yum -y install docker-ce

        echo '配置Docker开启启动';
        systemctl enable docker
        systemctl start docker

cat >> /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"]
}
EOF

        systemctl restart docker

else
    echo 'docker 已安装';
    docker -v
fi

read -p "是否需要安装docker-compose？[y/n]：    " need_anzhuang
if [ $need_anzhuang == 'y' ]; then
   echo "############判断是否安装了docker-compose##############"
if ! type docker-compose >/dev/null 2>&1; then
    echo 'docker-compose 未安装';
        echo '开始安装docker-compose....';
        wget http://oss.moguit.cn/script//docker-compose-Linux-x86_64
        mv docker-compose-Linux-x86_64  docker-compose
        chmod +x docker-compose
        mv docker-compose /usr/local/bin/
        docker-compose -v

else
    echo 'docker-compose 已安装';
    docker-compose -v
fi

else
    echo '用户取消安装'
fi

