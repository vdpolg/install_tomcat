# install_tomcat

<!-- TOC -->

- [install_tomcat](#install_tomcat)
    - [藍圖](#藍圖)
    - [說明](#說明)
    - [實作測試](#實作測試)
    - [舊資料](#舊資料)

<!-- /TOC -->
## 藍圖 

支援os：RHEL7/CentOS7 

支援Tomcat 8.5.x
1. 單站台 
流程：裝好openjdk之後
    ```=
    ./1_SetTomcatEnv.sh
    ./2_install_tomcat.sh apache-tomcat-8.5.54.tar.gz apache-tomcat-8.5.54.tar.gz.sha512
    ./3_single_ap.sh
    ./31_firewall.sh
    ```
    * example ap帳號：`proap` ,站台名稱：`webB`

    * 啟服務
        ```
        su - proap
        cd /ap/bin
        ./start_webB.sh
        ./show_webB.sh
        ```
    * 開browser測試 ： `http://<server ip>:8080/`

    * 停服務 `./stop_webB.sh`

2. 權限：
    `root`,`apuser`,`tomcat group`
    * root ： /opt/apache-tomcat  , /ap/bin  , /ap/<站台> 
    * apuser ： uid 5xx ~ , /log/<站台> 
    * tomcat ： gid 220
    ```
    root:tomcat /opt/apache-tomcat/
    root:root /ap/bin/
    root:tomcat /ap/bin/*
    $apuser:tomcat /ap/<站台>
    $apuser:tomcat /log/<站台>

    ```
3. 多站台 (下次弄)

4. apache 加自我憑證(下下次)

## 說明

請自行安裝openjdk
```
yum install -y java-1.8.0-openjdk.x86_64
```

* `1_SetTomcatEnv.sh` 建立環境，帳號

* `2_install_tomcat.sh` 安裝tomcat, 需下載tar檔和sha512檢核檔
    ```
    apache-tomcat-8.5.54.tar.gz
    apache-tomcat-8.5.54.tar.gz.sha512
    ```
 
* `3_single_ap.sh` 安裝單一站台
    
    修正ap帳號下上服務檢核
    * 啟服務
    ```=18
    cat <<EOF> /ap/bin/start_${TomcatWebName}.sh
    if [ \$LOGNAME != "$APNAME" ]
    then
            echo "Please use user \"$APNAME\" to execute."
            exit 0
    fi

    /ap/bin/start_tomcat.sh /ap/${TomcatWebName}

    EOF
    ```
    * 停服務
    ```=29
    cat <<EOF> /ap/bin/stop_${TomcatWebName}.sh
    if [ \$LOGNAME != "$APNAME" ]
    then
            echo "Please use user \"$APNAME\" to execute."
            exit 0
    fi

    /ap/bin/stop_tomcat.sh /ap/${TomcatWebName}

    EOF
    ```
* `31_firewall.sh` 設定防火牆(開通8080 port)
* 基本shell
    移除帳號檢核，由`3_single_ap.sh` 處理
    ```
    showui.sh
    start_tomcat.sh
    stop_tomcat.sh
    ```

* `wait_4_multi_ap.sh` 建構中

## 實作測試

環境準備 `1_setenv.sh`
* 帳號
```
建立tomcat group GID 220
建立tomcat ap account UID 5xx
ap join tomcat group
列出tomcat group 的角色
將變數寫入tmp暫存檔供其他sh 使用
```
* 目錄權限
```
/opt/apache-tomcat
/ap/bin
/ap/<Tomcat web name>
/log/<Tomcat web name>
```

---

## 舊資料
```

AP:	create_ap_tomcat.sh

WEB:	install_tomcat.sh

v1      20180830    arthur

v1.1	20180830    全新改款 tomcat_ui

v1.2	20180831    強化重複安裝檢核

v1.3	20180901    web ap 拆開，ap 多站台防呆

v1.4	20180904    web 改為純安裝

v1.5	20180905	新增tomcat service shell

v1.6	20180925	fix ui & javajdk setting,測試服務下上OK

v1.7	20180930	fix remove folder issue

v1.8	20190508	fix stop tomcat fail

```
