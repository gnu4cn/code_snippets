# Redmine 部署记录


本文是部署 Redmine 过程中问题的记录。


{{#include 08_Using_Huawei_Repos.md:104:}}


## 需要安装 `build-essential`

若没有安装 `build-essential`，会报出下面这样的错误：


```console
"Gem::Ext::BuildError:  ERROR: Failed to build gem native extension."
"checking for unistd.h... *** extconf.rb failed *** "

"...lack of necessary libraries and/or headers."
```

## 需要安装 `libpq-dev`


若未安装 `libpq-dev`，则会报出：


```console
Using config values from /usr/bin/pg_config                                                                                                         
checking for whether -Wl,-rpath,/usr/lib/x86_64-linux-gnu is accepted as LDFLAGS... yes                                                             
Using libpq from /usr/lib/x86_64-linux-gnu                                                                                                          
checking for libpq-fe.h... no                                                                                                                       
Can't find the 'libpq-fe.h header                                                                                                                   
*****************************************************************************                                                                                                                                                                                                                           
Unable to find PostgreSQL client library.                                                                                                                                                                                                                                                               
Please install libpq or postgresql client package like so:                                                                                            

sudo apt install libpq-dev                                                                                                                          
sudo yum install postgresql-devel                                                                                                                   
sudo zypper in postgresql-devel                                                                                                                     
sudo pacman -S postgresql-libs                                                                                                                                                                                                                                                                        
or try again with:                                                                                                                                    
gem install pg -- --with-pg-config=/path/to/pg_config                                                                                                                                                                                                                                                 
or set library paths manually with:                                                                                                                   
gem install pg -- --with-pg-include=/path/to/libpq-fe.h/ --with-pg-lib=/path/to/libpq.so/                                                                                                                                                                                                             
...
```


## 执行 `RAILS_ENV=production bundle exec rake db:migrate` 时的权限问题


参考：[postgresql 15: additional steps required while initializing database](https://www.redmine.org/issues/37986)


```console
rake aborted!                                                                                                                                                                       
ActiveRecord::StatementInvalid: PG::InsufficientPrivilege: ERROR:  permission denied for schema public                                                                              
LINE 1: CREATE TABLE "schema_migrations" ("version" character varyin...                                                                                                                                     ^
```

需要执行：

```console
sudo su - postgres
psql
postgres=# \c redmine postgres
postgres=# grant all on schema public to redmine;
```

> **注意**：上面最后一行后面的 `;` 必须输入。


## `rvm` 与安装特定版本的 `ruby` 时遇到的问题


参考：[Cannot install ruby version 2.6.6 on Ubuntu 22.04](https://stackoverflow.com/a/72096279)


`rvm` 是与 `nvm` 类似的 `ruby` 版本管理工具。在运行 `rvm install ruby-x.y.z` 安装特定版本会遇到失败的问题，检查日志文件：

`/usr/local/rvm/log/1709778431_ruby-2.6.0/make.log`

会发现：`make: *** [uncommon.mk:286: build-ext] Error 2`。此时需要先安装 `openssl`，然后再安装特定版本的 `ruby`:

```console
rvm pkg install openssl
rvm install ruby-x.y.z --with-openssl-dir=/usr/local/rvm/usr
```




