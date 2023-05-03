### Verify installed packages using debsums package

* Install debsums package
```
$ sudo apt-get install debsums
```
#### Usage
* Verify every installed package
```
$ sudo debsums
```
* Verify every installed package including configuration files
```
$ sudo debsums -a
```
* Verify installed packages and report errors only
```
$ sudo debsums -s
```
* Verify installed package and report changed files only
```
$ sudo debsums -c
```
* Verify every installed package including config file and report changed files only
```
$ sudo debsums -ca
```
