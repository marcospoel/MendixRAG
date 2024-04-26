# AWS Authentication Connector

The [Module](https://marketplace.mendix.com/link/component/120333)
The [Documentation](https://docs.mendix.com/appstore/modules/aws/aws-authentication/)

Install Git for Windows: [download](https://git-scm.com/download/win)

Open the file C:\Program Files\Git\usr\ssl\openssl.cnf and edit the section [ v3_ca ]

The section should say:

  ```
    basicConstraints        =critical, CA:TRUE
    subjectKeyIdentifier    =hash  
    authorityKeyIdentifier  =keyid:always, issuer:always
    keyUsage                =critical, cRLSign, digitalSignature, keyCertSign
```

Open Git bash located: "C:\Program Files\Git\git-bash.exe"
Create a certificate directory `mkdir certs`
Go to the directory `cd certs`

Execute the commands:
(pasting is done using `<Shift>+<Insert>`
```
winpty openssl genrsa -out PrivateCA.key 4096
```

```
winpty openssl req -new -x509 -days 3650 -key PrivateCA.key -out PrivateCA.pem -extensions v3_ca
```
Fill in the data. I filled in:
Country Name (2 letter code) [AU]:SK
State or Province Name (full name) [Some-State]:Presov
Locality Name (eg, city) []:Svit
Organization Name (eg, company) [Internet Widgits Pty Ltd]:T-Systems
Organizational Unit Name (eg, section) []:Digital Application Hub
Common Name (e.g. server FQDN or YOUR name) []:Marco Spoel
Email Address []:marco.spoel@t-systems.com

Put a file named v3.ext in the same directory as your root certificate, with the following content
```
vi v3.ext
```
Hit the `<i>` key to start inserting and paste the following text:
```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
```
