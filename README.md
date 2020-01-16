# Infra

## Raspberry Pi 4

First, install Arch Linux ARM with the following document.
https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4

Then, execute the following commands.

```bash
# In your local machine

$ ssh alarm@192.168.x.x

# In the Raspberry Pi

$ su

# Root user

$ pacman -Syy
$ pacman --noconfirm -S sudo
$ echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
$ gpasswd -a alarm wheel
$ echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
$ systemctl restart sshd
# Check login from your local machine with the RSA key
$ exit # from root user

$ cd
$ mkdir .ssh
$ curl https://github.com/pocke.keys > .ssh/authorized_keys
$ chmod 400 ~/.ssh/authorized_keys
```


Update `~/.ssh/config` to access the Raspberry Pi.

Finally, apply Itamae to the Raspberry Pi from your local machine.

```bash
$ bundle install
$ UPDATE_ALL=1 bundle exec itamae ssh --node-yaml nodes/secrets.yml --host skitty roles/raspberry-pi-4.rb
```
