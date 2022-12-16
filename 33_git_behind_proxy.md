# The Way of Getting Github.com Access Through Our Own HTTP Proxy

Since yesterday afternoon, we found that the access to github.com suddenly lost, through some un-official source, we think it’s due to the GFW. Now we tested a solution to get the github.com access back with our own HTTP proxy.

First please install the `ncat`/`socat` tool, with 

- `pacman -S/yum|apt|brew|choco install nmap-ncat/ncat/nmap`

- `pacman -S/yum|apt|brew install socat`

Then put the following configuration into the file `~/.ssh/config`(if there is no the file, you should create it by hand.):

```conf
Host github.com
	Hostname github.com
	ServerAliveInterval 55
	ForwardAgent yes
	ProxyCommand /usr/bin/ncat --proxy 192.168.30.51:3128 %h %p
    # ProxyCommand /usr/bin/socat - PROXY:192.168.30.51:%h:%p,proxyport=3128
```

If any question, please feel free to contact Ryan or me.

## Git HTTP Proxy Settings 

To make git http traffic(only for github.com) proxied, run the following commands:

```console
$ git config --global http.https://github.com.proxy http://192.168.30.51:3128
```

Or for the socks5 proxy:

```console
$ git config --global http.https://github.com.proxy socks5://127.0.0.1:10080
```

It will modify the file `~/.gitconfig` like this:

```conf
$ cat ~/.gitconfig                                                                        lennyp@vm-manjaro
[user]
        email = lenny.peng@senscomm.com
        name = Lenny Peng
[pull]
        rebase = false
[core]
        compression = 0
[http]
        postBuffer = 1048576000
        maxRequestBuffer = 100M
[http "https://github.com"]
        proxy = http://192.168.30.51:3128
```
