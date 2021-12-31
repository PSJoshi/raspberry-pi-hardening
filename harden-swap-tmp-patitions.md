### Disable root account
For security reasons, it is safe to disable the root account. Removing the account might not be a good idea at first, instead we simply need to disable it.

To disable the root account, simply use the -l option.
```
$ sudo passwd -l root
```
If for some valid reason you need to re-enable the account, simply use the -u option.
```
$ sudo passwd -u root
```
### Add swap
In raspberry pi, SWAP is not configured by default. Linux swaps allow a system to harness more memory than was originally
physically available.

* Check if a SWAP file exists and it's enabled before we create one.
```
$ sudo swapon -s
```
* To create the SWAP file, use the following command:
```
$ sudo fallocate -l 4G /swapfile	# same as "sudo dd if=/dev/zero of=/swapfile bs=1G count=4"
```
* Secure swap.
```
$ sudo chown root:root /swapfile
$ sudo chmod 0600 /swapfile
```
* Prepare the swap file by creating a Linux swap area.
```
$ sudo mkswap /swapfile
```
* Activate the swap file.
```
$ sudo swapon /swapfile
```
* Confirm that the swap partition exists.
```
$ sudo swapon -s
```
This will last until the server reboots. Let's create the entry in the fstab.
```
$ sudo nano /etc/fstab
: /swapfile	none	swap	sw	0 0
```
* Swappiness in the file should be set to 0. Skipping this step may cause both poor performance,
# whereas setting it to 0 will cause swap to act as an emergency buffer, preventing out-of-memory crashes.
```
$ echo 0 | sudo tee /proc/sys/vm/swappiness
$ echo vm.swappiness = 0 | sudo tee -a /etc/sysctl.conf
```

### Secure /tmp and /var/tmp
Temporary storage directories such as /tmp, /var/tmp and /dev/shm gives the ability to hackers to provide storage space for malicious executables.

* Let's create a 2GB (or what is best for you) filesystem file for the /tmp parition.
```
$ sudo fallocate -l 2G /tmpdisk
$ sudo mkfs.ext4 /tmpdisk
$ sudo chmod 0600 /tmpdisk
```
* Mount the new /tmp partition and set the right permissions.
```
sudo mount -o loop,noexec,nosuid,rw /tmpdisk /tmp
sudo chmod 1777 /tmp
```
* Set the /tmp in the fstab.
```
$ sudo nano /etc/fstab
: /tmpdisk	/tmp	ext4	loop,nosuid,noexec,rw	0 0
$ sudo mount -o remount /tmp
```

* Secure /var/tmp
```
$ sudo mv /var/tmp /var/tmpold
$ sudo ln -s /tmp /var/tmp
$ sudo cp -prf /var/tmpold/* /tmp/
$ sudo rm -rf /var/tmpold/
```
### Secure shared memory
Shared memory can be used in an attack against a running service, apache2 or httpd
```
$ sudo nano /etc/fstab
: tmpfs	/run/shm	tmpfs	ro,noexec,nosuid	0 0
```

* ref: https://gist.github.com/lokhman/cc716d2e2d373dd696b2d9264c0287a3
