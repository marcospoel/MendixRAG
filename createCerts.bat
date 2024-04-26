@echo off

if '%2' == '' goto usage
if not '%4' == '' goto usage

set name=%1
set openssl=%2

if not exist %openssl% goto err_no_openssl
if exist %openssl%\ goto err_openssl_dir

if not '%3' == '' goto cnf_user
set cnfpath=%~dp2
set cnf="%cnfpath%..\ssl\openssl.cnf"
if not exist %cnf% goto err_no_cnf_auto
goto cnf_set

:cnf_user
set cnf=%3
if not exist %cnf% goto err_no_cnf_user
if exist %cnf%\ goto err_cnf_dir

:cnf_set
echo openssl config file found: %cnf%

echo Check for OpenSSL version 1.X:
%openssl% version
echo .
echo If not version 1.X abort with Ctrl-C, or else
pause

if exist .\%name%CA.key goto err_CAkey_file
if exist .\%name%CA.pem goto err_CApem_file
if exist .\%name%.key goto err_key_file
if exist .\%name%.pem goto err_pem_file
if exist .\%name%.pfx goto err_pfx_file

%openssl% genrsa -out .\%name%CA.key 4096
echo Key pair for root certificate generated and stored into file %name%CA.key

copy %cnf% .\opensslcnf.tmp
echo [ v3_ca_emiel ]                                                           >> .\opensslcnf.tmp
echo basicConstraints        =critical, CA:TRUE                                >> .\opensslcnf.tmp
echo subjectKeyIdentifier    =hash                                             >> .\opensslcnf.tmp
echo authorityKeyIdentifier  =keyid:always, issuer:always                      >> .\opensslcnf.tmp
echo keyUsage                =critical, cRLSign, digitalSignature, keyCertSign >> .\opensslcnf.tmp

%openssl% req -new -x509 -days 3650 -key .\%name%CA.key -out .\%name%CA.pem -config .\opensslcnf.tmp -extensions v3_ca_emiel
echo Root certificate generated with the extensions and stored into file %name%CA.pem

%openssl% genrsa -out .\%name%.key 4096
echo Key pair for client certificate generated and stored into file %name%.key

%openssl% req -new -key .\%name%.key -out .\%name%.csr
echo Certificate Signing Request created and stored into file %name%.csr

echo authorityKeyIdentifier=keyid,issuer                                             > .\ext.tmp
echo basicConstraints=CA:FALSE                                                      >> .\ext.tmp
echo keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment >> .\ext.tmp
echo File ext.tmp changed with extensions for the client certificate

%openssl% x509 -req -in .\%name%.csr -CA .\%name%CA.pem -CAkey .\%name%CA.key -set_serial 01 -out .\%name%.pem -days 3650 -sha256 -extfile .\ext.tmp
echo Client certificate generated with the extensions, signed by root certficate and stored into file %name%.pem

:create_pfx
echo Storing client certificate into keyfile:
%openssl% pkcs12 -export -in .\%name%.pem -inkey .\%name%.key -certpbe PBE-SHA1-3DES -keypbe PBE-SHA1-3DES -macalg sha1 -out .\%name%.pfx

if exist .\%name%.pfx goto pfx_file_created
echo ERROR: keystore file %name%.pfx not created. 
echo Presumably because the verify password did not match.
echo Try again or presss Ctrl-C to abort
pause
goto create_pfx

echo 
:pfx_file_created
echo Client certificate stored in keystore file %name%.pfx

goto end

:usage
echo usage:
echo %0 [name] [path-to-openssl.exe] ([path-to-openssl.cnf])
echo where:
echo name: name of files created: nameCA.key, nameCA.pem, name.key, name.pem and name.pfx
echo path-to-openssl.exe: location of openssl.exe 
echo optional: path-to-openssl.cnf: location of openssl.cnf 
echo but it is required when it cannot be found automatically
echo for example:
echo %0 myAwsCert "c:\Program Files\Git\usr\bin\openssl.exe"
echo BE AWARE: Must be OpenSSL version 1.X
echo You can check this with argument 'version', for example:
echo "c:\Program Files\Git\usr\bin\openssl.exe" version
goto end

:err_no_openssl
echo ERROR: Can not find openssl.exe at %openssl%
echo Please provide the correct path to the file.
echo Example of argument: "c:\Program Files\Git\usr\bin\openssl.exe"
echo Hint: when the path contains spaces, enclose the argument within double quote characters as example above
goto end

:err_openssl_dir
echo ERROR: The argument for openssl.exe is a directory (folder).
echo Please add filename as well.
echo Example of argument: "c:\Program Files\Git\usr\bin\openssl.exe"
echo Hint: when the path contains spaces, enclose the argument within double quote characters as example above
goto end

:err_no_cnf_auto
echo ERROR: Can not automatically find openssl config file, was expected at %cnf%
echo Please provide extra argument where to find it
echo Example "c:\Program Files\Git\usr\ssl\openssl.cnf"
echo Hint: when the path contains spaces, enclose the argument within double quote characters as example above
goto end

:err_no_cnf_user
echo ERROR: Can not find openssl config file %cnf%
echo Please provide the correct path to the file.
echo Example "c:\Program Files\Git\usr\ssl\openssl.cnf"
echo Hint: when the path contains spaces, enclose the argument within double quote characters as example above
goto end

:err_cnf_dir
echo ERROR: The argument foropenssl config file is a directory (folder).
echo Please add filename as well.
echo Example "c:\Program Files\Git\usr\ssl\openssl.cnf"
echo Hint: when the path contains spaces, enclose the argument within double quote characters as example above
goto end

:err_CAkey_file
echo ERROR: file %name%CA.key already exists in this folder/dir.
echo delete or move the file and try again.
goto end

:err_CApem_file
echo ERROR: file %name%CA.pem already exists in this folder/dir.
echo delete or move the file and try again.
goto end

:err_key_file
echo ERROR: file %name%.key already exists in this folder/dir.
echo delete or move the file and try again.
goto end

:err_pem_file
echo ERROR: file %name%.pem already exists in this folder/dir.
echo delete or move the file and try again.
goto end

:err_pfx_file
echo ERROR: file %name%CA.pfx already exists in this folder/dir.
echo delete or move the file and try again.
goto end

:end

if exist *.tmp echo cleanup tmp files:
if exist *.tmp del *.tmp

rem cleanup env vars:
set name=
set openssl=
set cnfpath=
set cnf=
