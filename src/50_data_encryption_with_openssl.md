# 使用 OpenSSL 加解密文件

与 PGP/GnuPG 加密文件类似，使用 OpenSSL 加解密数据也涉及到私钥/公钥。但仅对 passphrase 进行加解密，并使用明文的 passphrase 加密数据。


## 接收方生成密钥并导出公钥

```console
openssl genrsa -out priv-key.pem 4096 #生成私钥
openssl rsa -in key.pem -out pub-key.pem -outform PEM -pubout # 导出公钥
```

此时，接收方把公钥 `pub-key.pem` 提供给发送方。

## 发送方使用 passphrase 加密数据，然后使用公钥加密 passphrase 

- 生成 passphrase

```console
openssl rand 32 -out passphrase.txt
```

- 使用 passphrase 加密数据

```console
openssl enc -aes-256-cbc -pass file:passphrase.txt < UNENCRYPTED_FILE > encrypted.dat 
```

- 使用公钥加密 passphrase

```console
 openssl rsautl -encrypt -pubin -inkey pub-key.pem < passphrase.txt > enc.passphrase.txt
```

随后发送方把 `encrypted.dat` 和 `enc.passphrase.txt` 文件提交给接收方。


## 接收方解密数据

- 解密 passphrase

```console
openssl rsautl -decrypt -inkey key.pem < enc.passphrase.txt > passphrase.txt 
```

- 使用解密后的 passphrase 解密数据

```console
openssl enc -aes-256-cbc -d -pass file:passphrase.txt < encrypted.dat > UNENCRYPTED_FILE 
```
