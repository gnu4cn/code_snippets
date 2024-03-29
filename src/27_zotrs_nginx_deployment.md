# 将社区版 OTRS 与 PostgreSQL、NGINX 及 M$ AD 部署在一起


OTRS 是一间德国公司开发的、用 Perl 语言实现的 Helpdesk/Ticketing 系统，商业版已经发展到 8.x，该公司自 6.0.37 版本便不再支持社区版，有个网站 [otrscommunityedition.com](https://otrscommunityedition.com/)。有好事者接手了这个不被支持的社区，在 [znuny.org](https://www.znuny.org/en) 上试图延续其寿命，并在 [github.com/znuny](https://github.com/znuny) 公开了源代码，znuny.org 推出了 LTS 版与包含了错误修复与新增小特性的版本。

OTRS 安装默认使用 Apache httpd 作为 HTTP 服务器，这里将改用 nginx 作为 HTTP 服务器。其会建立用户 otrs 作为 otrs 系统用户，并将 `/opt/otrs` 作为该用户的主目录。在安装结束后，访问网页 `http://localhost/otrs/installer.pl`，运行安装程序会要求获得 PostgreSQL 数据库的管理员账号与口令，随后会在数据库中建立一个新用户，并其随后所使用的创建数据库。接下来分别给出 Nginx 与 M$ AD 配置两个部分的配置文件。


## 细节配置

- “系统配置” -> 搜索 `ProductName` 配置窗口标题；搜索 “CustomerHeadline”，可修改 “Example Company”；

- 除了使用 `sudo yum install "perl(XX:YY)" -y` 方式安装 Perl 的依赖包之外，还可以使用 `sudo cpanm XX::YY` 方式安装（注意安装失败可能是因为系统没有 `gcc`）；

- 需要修改 `Sysconfig` 中默认的 `NotificationSenderEmail` 选项；

- 需要修改 `Sysconfig` 中默认的 `NotificationRecipientEmail` 选项，否则会导致邮件回执发送失败；

- `Sysconfig` -> `SendmailModule` 即可设置 SMTP 相关参数；

- “打印” 功能中 PDF 用到的 TTF 字体存放在 `/opt/otrs/var/fonts` 目录，在 `Sysconfig` -> `PDF::TTFontFile` 或许可设置打印 PDF 的汉字字体。

- 需要修改 `SendmailNotificationEnvelopFrom` 选项，否则邮件通知发送会报错：


```console
10 		Kernel::System::Email::SMTP 	Envelope from '' not accepted by the server: 501, mail from address must be same as authorization user ! 	2024.01.09 13:31:17 (Asia/Shanghai)
11 		Kernel::System::Email 	        Error sending message using backend 'Kernel::System::Email::SMTP'. 	2024.01.09 13:31:17 (Asia/Shanghai)
12 		Kernel::System::MailQueue 	    Message could not be sent! Error message: Envelope from '' not accepted by the server: 501, mail from address must be same as authorization user ! 	2024.01.09 13:31:17 (Asia/Shanghai)
13 		Kernel::System::MailQueue 	    Permanent sending problem or we reached the sending attempt limit. Message will be removed
```

- 修改 Nginx 配置，解决 `perl-fcgi` 过早退出问题：

```console
 upstream prematurely closed FastCGI stdout while reading response header from upstream
```

要在 Nginx 配置文件中，提升 `client_body_timeout` 与 `client_header_timeout` 两个变量的值。


## 使用 `cpanm` 安装 Perl 模组


参考：[Perl 基础笔记：使用 `cpanm` 安装 Perl 模块](https://blog.csdn.net/memray/article/details/17543791)


`cpanm` 是安装 Perl 模块的最简便方法。关于 `cpanm`：

[App::cpanminus](https://metacpan.org/release/MIYAGAWA/App-cpanminus-1.0015/view/lib/App/cpanminus.pm)


### 安装 `cpanm`

有 Debian 软件包、RPM、FreeBSD 移植版，以及适用于其他操作系统的软件包。如果咱们打算使用包管理系统，请搜索 `cpanminus` 并使用适当的命令进行安装。这使得咱们可以轻松地将 `cpanm`，安装到咱们的系统中，而无需考虑安装位置以及以后的升级。

咱们也可以使用最新的 `cpanminus`，来安装 `cpanminus` 本身（又称 bootstrap）：

```console
curl -L http://cpanmin.us | perl - --sudo App::cpanminus
```

这将把 `cpanm` 安装到 `/usr/local/bin` 等 `bin` 目录中（除非咱们在 `INSTALL_BASE` 中，配置了 `local::lib`），因此咱们可能需要 `--sudo` 选项。

之后，咱们就可以 `cpanm --self-upgrade --sudo`，来升级到最新版本。

否则，

```console
cd ~/bin
wget http://xrl.us/cpanm
chmod +x cpanm
# edit shebang if you don't have /usr/bin/env
```

也会工作，但升级时一定要手动抓取新版本（`--self-upgrade` 可能不起作用）。


### 使用 `cpanm`


命令行参数直接为 Perl 模组即可。例如：


```console
$ sudo cpanm CGI::Session
$ sudo cpanm Template
```

> 注: 如果不是 root 权限，`cpanm` 也一样能用。他会将模块下载安装到用户的根目录( `~` )下。（没试过，一直只用 sudo 安装。）

为了加快 `cpanm` 下载速度, 可以指定使用镜像，并只从镜像下载。如下:


```console
$ sudo cpanm --mirror http://mirrors.163.com/cpan --mirror-only CGI::Session
```


## 登录网址

- 管理登录：/otrs/index.pl
- 用户登录：/otrs/customer.pl


## 运行中的问题


- PDF 打印中 PNG 的问题


```console
[Fri Feb 17 15:12:27 2023] customer.pl: Unsupported Interlace(1) Method at /opt/znuny-6.4.5/bin/fcgi-bin/../../Kernel/cpan-lib/PDF/API2/Resource/XObject/Image/PNG.pm line 51.
```

参考：[Tiket printing](https://community.znuny.org/viewtopic.php?t=41070)

不支持 PNG 的 Interlace 特性。

## 通过邮件关闭工单

参考：[SOLVED - Close Ticket from E-mail](https://community.znuny.org/viewtopic.php?t=28822)


## Nginx 部分的配置

Nginx 并不直接支持 CGI，但支持 FastCGI。这里的问题是 OTRS 在 FastCGI 下存在问题。为了让 Nginx 来提供 OTRS，就必须使用 FastCGI 封装器（FastCGI wrapper），来将 FastCGI 作为 CGI 进行加载。

这里使用的 FastCGI 封装器脚本，是由 [Denis S. Filimonov](https://www.ruby-forum.com/t/nginx-perl-cgi/131807#645832) 编写的，这里还使用到另一个用于 `start/stop` 这个 FastCGI 进程的脚本。这里已从 [nginxlibrary.com](http://nginxlibrary.com/perl-fastcgi/) 下载了这两个脚本。下面就是这个快速而不那么干净的开头。

```console
# wget http://nginxlibrary.com/downloads/perl-fcgi/fastcgi-wrapper -O /usr/bin/fastcgi-wrapper.pl
# wget http://nginxlibrary.com/downloads/perl-fcgi/perl-fcgi -O /etc/init.d/perl-fcgi
# chmod +x /usr/bin/fastcgi-wrapper.pl
# chmod +x /etc/init.d/perl-fcgi
```

接下来就要确保在系统启动过程（the boot process），`start/stop` 脚本能被执行。

```console
# chkconfig --add perl-fcgi
# chkconfig perl-fcgi on
```

现在就应该能启动这个 FastCGI 进程了。

```console
# service perl-fcgi start
```

> **注意**：在运行 `sudo service perl-fcgi stop` 时，会报出 `killall: command not found` 错误，这是要安装 `psmisc` 软件包：`sudo yum install psmisc -y`。

将 `nginx.conf` 配置为支持 OTRS 与 FastCGI：

```nginx
#
# /etc/nginx/conf.d/default.conf
#
server {
    listen       80;
    server_name  10.12.7.133;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    include /etc/nginx/conf.d/otrs.data;
}

```

*代码清单 27-1：`/etc/nginx/conf.d/default.conf`*


现在就可以进一步启动 Nginx 与 OTRS 了:

```console
$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

$ sudo systemctl start nginx.service
$ sudo su otrs
bash-4.2$ /opt/otrs/bin/otrs.Daemon.pl start

Manage the OTRS daemon process.

Daemon started
```

```nginx
#
# /etc/nginx/conf.d/otrs.data
#
location /otrs-web {
        gzip on;
        alias /opt/otrs/var/httpd/htdocs;
}

   location ~ ^/otrs/(.*\.pl)(/.*)?$ {
        fastcgi_pass 127.0.0.1:8999;
        fastcgi_index index.pl;
        fastcgi_param SCRIPT_FILENAME /opt/otrs/bin/fcgi-bin/$1;
        fastcgi_param QUERY_STRING $query_string;
        fastcgi_param REQUEST_METHOD $request_method;
        fastcgi_param CONTENT_TYPE $content_type;
        fastcgi_param CONTENT_LENGTH $content_length;
        fastcgi_param GATEWAY_INTERFACE CGI/1.1;
        fastcgi_param SERVER_SOFTWARE nginx;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
        fastcgi_param REQUEST_URI $request_uri;
        fastcgi_param DOCUMENT_URI $document_uri;
        fastcgi_param DOCUMENT_ROOT $document_root;
        fastcgi_param SERVER_PROTOCOL $server_protocol;
        fastcgi_param REMOTE_ADDR $remote_addr;
        fastcgi_param REMOTE_PORT $remote_port;
        fastcgi_param SERVER_ADDR $server_addr;
        fastcgi_param SERVER_PORT $server_port;
        fastcgi_param SERVER_NAME $server_name;
  }
```

*代码清单 27-2：`/etc/nginx/conf.d/otrs.data`*

```perl
#!/usr/bin/perl
#
# /usr/bin/fastcgi-wrapper.pl
#

use FCGI;
use Socket;
use POSIX qw(setsid);

require 'syscall.ph';

&daemonize;

#this keeps the program alive or something after exec'ing perl scripts
END() { } BEGIN() { }
*CORE::GLOBAL::exit = sub { die "fakeexit\nrc=".shift()."\n"; };
eval q{exit};
if ($@) {
        exit unless $@ =~ /^fakeexit/;
};

&main;

sub daemonize() {
    chdir '/'                 or die "Can't chdir to /: $!";
    defined(my $pid = fork)   or die "Can't fork: $!";
    exit if $pid;
    setsid                    or die "Can't start a new session: $!";
    umask 0;
}

sub main {
        $socket = FCGI::OpenSocket( "127.0.0.1:8999", 10 ); #use IP sockets
        $request = FCGI::Request( \*STDIN, \*STDOUT, \*STDERR, \%req_params, $socket );
        if ($request) { request_loop()};
            FCGI::CloseSocket( $socket );
}

sub request_loop {
        while( $request->Accept() >= 0 ) {

           #processing any STDIN input from WebServer (for CGI-POST actions)
           $stdin_passthrough ='';
           $req_len = 0 + $req_params{'CONTENT_LENGTH'};
           if (($req_params{'REQUEST_METHOD'} eq 'POST') && ($req_len != 0) ){
                my $bytes_read = 0;
                while ($bytes_read < $req_len) {
                        my $data = '';
                        my $bytes = read(STDIN, $data, ($req_len - $bytes_read));
                        last if ($bytes == 0 || !defined($bytes));
                        $stdin_passthrough .= $data;
                        $bytes_read += $bytes;
                }
            }

            #running the cgi app
            if ( (-x $req_params{SCRIPT_FILENAME}) &&  #can I execute this?
                 (-s $req_params{SCRIPT_FILENAME}) &&  #Is this file empty?
                 (-r $req_params{SCRIPT_FILENAME})     #can I read this file?
            ){
                pipe(CHILD_RD, PARENT_WR);
                my $pid = open(KID_TO_READ, "-|");
                unless(defined($pid)) {
                        print("Content-type: text/plain\r\n\r\n");
                        print "Error: CGI app returned no output - ";
                        print "Executing $req_params{SCRIPT_FILENAME} failed !\n";
                        next;
                }
                if ($pid > 0) {
                        close(CHILD_RD);
                        print PARENT_WR $stdin_passthrough;
                        close(PARENT_WR);

                        while(my $s = <KID_TO_READ>) { print $s; }
                        close KID_TO_READ;
                        waitpid($pid, 0);
                } else {
                        foreach $key ( keys %req_params){
                           $ENV{$key} = $req_params{$key};
                        }
                        # cd to the script's local directory
                        if ($req_params{SCRIPT_FILENAME} =~ /^(.*)\/[^\/]+$/) {
                                chdir $1;
                        }

                        close(PARENT_WR);
                        close(STDIN);
                        #fcntl(CHILD_RD, F_DUPFD, 0);
                        syscall(&SYS_dup2, fileno(CHILD_RD), 0);
                        #open(STDIN, "<&CHILD_RD");
                        exec($req_params{SCRIPT_FILENAME});
                        die("exec failed");
                }
            }
            else {
                print("Content-type: text/plain\r\n\r\n");
                print "Error: No such CGI app - $req_params{SCRIPT_FILENAME} may not ";
                print "exist or is not executable by this process.\n";
            }

        }
}

```

*代码清单 27-3：`/usr/bin/fastcgi-wrapper.pl`*

```bash
#!/bin/bash
### BEGIN INIT INFO
# Provides:          perl-fcgi
# Required-Start:    networking
# Required-Stop:     networking
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start the Perl FastCGI daemon.
### END INIT INFO
#
# /etc/init.d/perl-fcgi
#
PERL_SCRIPT=/usr/bin/fastcgi-wrapper.pl
FASTCGI_USER=otrs
RETVAL=0
case "$1" in
    start)
      su - $FASTCGI_USER -c $PERL_SCRIPT
      RETVAL=$?
  ;;
    stop)
      killall -9 fastcgi-wrapper.pl
      RETVAL=$?
  ;;
    restart)
      killall -9 fastcgi-wrapper.pl
      su - $FASTCGI_USER -c $PERL_SCRIPT
      RETVAL=$?
  ;;
    *)
      echo "Usage: perl-fcgi {start|stop|restart}"
      exit 1
  ;;
esac
exit $RETVAL

```

*代码清单 27-4：`/etc/init.d/perl-fcgi`*


> **注意**：这里的 `FASTCGI_USER=otrs`，设置了 FastCGI 运行在用户 `otrs` 之下，而 `/opt/otrs` 的所有者，正是安装 OTRS 时，该软件包创建出来的那个 `otrs` 用户。因此这里要做这样的设置。

> **注意**：要将 CentOS 上的 SELinux 设置为 `disabled`，在 `/etc/selinux/config` 中。

> **注意**：要放行 `80/tcp` 端口：

```console
$ sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
success
$ sudo firewall-cmd --reload
success
```

> **注意**：要将用户 `nginx` 加入到 `apache` 组（RHEL/CentOS），`sudo usermod -a -G apache nginx`

> **注意**：更新到 `/opt/otrs` 的软连接 `sudo ln -vnsf /opt/znuny-6.0.46 /opt/otrs` 及 `sudo ln -vnsf /opt/OTRS-Community-Edition-6.0.37 /opt/otrs`（源路径与目标路径，均不以 `/` 结束）。


## M$ AD 部分的配置

```perl
# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021-2022 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
#  Note:
#
#  -->> Most OTRS configuration should be done via the OTRS web interface
#       and the SysConfig. Only for some configuration, such as database
#       credentials and customer data source changes, you should edit this
#       file. For changes do customer data sources you can copy the definitions
#       from Kernel/Config/Defaults.pm and paste them in this file.
#       Config.pm will not be overwritten when updating OTRS.
# --
#
# /opt/otrs/Kernel/Config.pm
#

package Kernel::Config;

use strict;
use warnings;
use utf8;

sub Load {
    my $Self = shift;

# ---------------------------------------------------- #
# database settings                                    #
# ---------------------------------------------------- #

# The database host
    $Self->{'DatabaseHost'} = '127.0.0.1';

# The database name
    $Self->{'Database'} = "otrsdb";

# The database user
    $Self->{'DatabaseUser'} = "otrs";

# The password of database user. You also can use bin/otrs.Console.pl Maint::Database::PasswordCrypt
# for crypted passwords
    $Self->{'DatabasePw'} = '***********';

# The database DSN for MySQL ==> more: "perldoc DBD::mysql"
    $Self->{'DatabaseDSN'} = "DBI:Pg:dbname=$Self->{Database};host=$Self->{DatabaseHost}";

# Customer Auth Module
    $Self->{'Customer::AuthModule'} = 'Kernel::System::CustomerAuth::LDAP';
    $Self->{'Customer::AuthModule::LDAP::Host'} = 'dc.xfoss.com';
    $Self->{'Customer::AuthModule::LDAP::BaseDN'} = 'OU=user,OU=Suzhou,OU=corp,DC=xfoss,DC=com';
    $Self->{'Customer::AuthModule::LDAP::UID'} = 'sAMAccountName';


    $Self->{'Customer::AuthModule::LDAP::GroupDN'} = 'CN=Domain Users,CN=Users,DC=xfoss,DC=com';

    $Self->{'Customer::AuthModule::LDAP::SearchUserDN'} = 'CN=Lenny Peng,OU=user,OU=Suzhou,OU=corp,DC=xfoss,DC=com';
    $Self->{'Customer::AuthModule::LDAP::SearchUserPw'} = '*********';

    $Self->{'Customer::AuthModule::LDAP::Params'} = {
        port => 389,
        timeout => 120,
        async => 0,
        version => 3,
    };

    # $Self->{'AuthSyncModule'} = 'Kernel::System::Auth::Sync::LDAP';

    $Self->{CustomerUser} = {
        Name => 'LDAP Backend',
        Module => 'Kernel::System::CustomerUser::LDAP',
        Params => {
            Host => 'dc.xfoss.com',
            BaseDN => 'OU=user,OU=Suzhou,OU=corp,DC=xfoss,DC=com',
            SSCOPE => 'sub',
            UserDN => 'CN=Lenny Peng,OU=user,OU=Suzhou,OU=corp,DC=xfoss,DC=com',
            UserPw => '*************',
            AlwaysFilter => '',
            Die => 0,
            Params => {
                port => 389,
                timeout => 120,
                async => 0,
                version => 3,
            },
        },

        # The order and LDAP field name of the following items are very important for otrs working.
        CustomerKey => 'sAMAccountName',
        CustomerID => 'userPrincipalName',
        CustomerUserListFields => ['cn', 'userPrincipalName'],
        CustomerUserSearchFields => ['sAMAccountName', 'cn', 'userPrincipalName'],
        CustomerUserSearchPrefix => '',
        CustomerUserSearchSuffix => '*',
        CustomerUserSearchListLimit => 1000,
        CustomerUserPostMasterSearchFields => ['userPrincipalName'],
        CustomerUserNameFields => ['givenname', 'sn'],
        CustomerUserNameFieldsJoin => '',
        CustomerUserExcludePrimaryCustomerID => 0,
        CacheTTL => 0,
        Map => [
            [ 'UserTitle',		'Title or salutation', 	'title',		        1, 0, 'var', '', 1 ],
            [ 'UserFirstname',	'Firstname',      		'givenname',		    1, 1, 'var', '', 0 ],
            [ 'UserLastname', 	'Lastname',		        'sn',			        1, 1, 'var', '', 0 ],
            [ 'UserLogin', 		'Username',		        'sAMAccountName',	    1, 1, 'var', '', 0 ],
            [ 'UserEmail', 		'Email', 		        'userPrincipalName',    1, 1, 'var', '', 0 ],
            [ 'UserCustomerID',	'CustomerID',	        'userPrincipalName',    0, 1, 'var', '', 0 ],
        ],
    };


    $Self->{Home} = '/opt/otrs';

    return 1;
}

# ---------------------------------------------------- #
# needed system stuff (don't edit this)                #
# ---------------------------------------------------- #

use Kernel::Config::Defaults; # import Translatable()
use parent qw(Kernel::Config::Defaults);

# -----------------------------------------------------#

1;
```

*代码清单 27-5：`/opt/otrs/Kernel/Config.pm` 中有关 LDAP/M$ AD 做客户用户认证及用户后端的配置*

## 清除通信日志 Communication log

使用 OTRS 的终端程序：

```console
$ bin/otrs.Console.pl Maint::Log::CommunicationLog
Management of communication logs.

Usage:
 otrs.Console.pl Maint::Log::CommunicationLog [--force-delete] [--purge] [--delete-by-hours-old ...] [--delete-by-date ...] [--delete-by-id ...] [--verbose]

Options:
 [--force-delete]               - Delete even if still processing.
 [--purge]                      - Purge successful communications older than a week and all communications older than a month. These durations are specified in SysConfig.
 [--delete-by-hours-old ...]    - Delete logs older than these number of hours. Example: --delete-by-hours-old="7"
 [--delete-by-date ...]         - Delete from specific date. Example: --delete-by-date="2001-12-01"
 [--delete-by-id ...]           - Delete logs from CommunicationID. Example: --delete-by-id="abcdefg12345"
 [--verbose]                    - Display debug information (can be used with --purge). Example: --purge --verbose
 [--help]                       - Display help for this command.
 [--no-ansi]                    - Do not perform ANSI terminal output coloring.
 [--quiet]                      - Suppress informative output, only retain error messages.

Error: Either --purge, --delete-by-id, --delete-by-date or --delete-by-days-old must be given!
```


比如：


```console
$ bin/otrs.Console.pl Maint::Log::CommunicationLog --delete-by-hours-old="1" --force-delete
```

将删除早于 1 小时前的通信日志。


## 采用 POP3TLS

相比于采用 IMAPTLS 从邮件服务器定时查收邮件，采用 POP3TLS 表现出了更高的可靠性与稳定性，因此应采用 POP3TLS 来接收邮件。
## 脚注

1. OTRS，是 Open-Source Ticket Request System，开源技术支持请求系统的首字母缩写，是一种自由与开源的，公司、组织或其他实体可以用于将技术支持记录，分配给提交的技术支持请求，并跟踪有关这些技术支持随后的联络的故障执行系统软件包。他表示了多种的技术支持受理、反馈、支持请求、缺陷报告及其他有关的联络；

2. nginx （发音为 “engine-x”） 是一个开放源代码的 Web 服务器，及一种用于 HTTP、SMTP、POP 与 IMAP 协议的反向代理服务器，其强调了高并发、性能及低内存使用。他有着类 BSD 许可证的授权，并运行在 Unix、Linux、BSD 的各种变种、Mac OS X、Solaris、AIX 及 M$ Windows 等操作系统之上。


##  "One or more errors occurred!" 问题


参考：[One or more errors occurred!](https://community.znuny.org/viewtopic.php?t=34023)

回复工单邮件时，出线，"Please remove this entry and enter a new one with the correct value."，'请删除这个条目并重新输入一个正确的值。'


这是由于服务器的 DNS，在解析 MX 记录时，遇到错误所致。做法是修改服务器上的 DNS 服务器，到正确的 DNS 服务器。

### 在 Linux 上设置有效的 DNS 服务器

{{#include 07_Add_Linux_to_AD.md:47:56}}


## `IMAP: Can't fetch email 549 from helpdesk@xfoss.com/imap.exmail.qq.com. Email too big (30331 KB - max 16384 KB)!`


修改 `Kernel/Config/Files/ZZZAAuto.pm` 文件中的 `PostMasterMaxEmailSize`，并检查是否生效。

参考：[Can't fetch email...Email too big.](https://community.znuny.org/viewtopic.php?t=19107)
