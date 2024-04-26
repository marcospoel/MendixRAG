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

winpty openssl genrsa -out PrivateCA.key 4096


