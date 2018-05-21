# requirements
to use this docker-compose you must have installed :
- [docker-compose](https://docs.docker.com/compose/install/)
- [docker](https://docs.docker.com/install/)

# quick reading
this docker-compose contains :
- adminer (lightweight PHPMYADMIN)
- redis (cache storage system)
- mariadb (database)
- pydio (a debian based pydio install containing every package and ready to use)

So basically you will get all of what is listed above when using docker-compose and what it do is launch and link all the containers to the same network.


# setup
first and foremost
clone this repository you can either grab it above with the green button **Clone or Download** or `https://github.com/KungFu-Kenny/test.git`
then navigate into this folder.
Now to launch & use your Dockerized Pydio use this command :
`docker-compose -p pydio_8 up -d` the `-d` parameter is added to launch it detached (if you wanna keep track you can remove the `-d`).
`-p` is to get the same project name for volumes, networks etc...

after it finishes up go to this address http://localhost:2345 ( you can change the port in the docker-compose.yml it will look like this **2345**:80 you can change the **2345** part )
for secure access you can go to https://localhost:6789 ( it will be mapped to port 443 you can change it aswell)

you will have the pydio installation page you can choose your admin login and password then when you'll have to enter the database informations you can either use the integrated one with the following parameters
(you can modify the password in the docker-compose.yml file and you can also create a user)

     - hostname : database ( can be changed in docker-compose.yml file `container_name:`)
     - name: pydio
     - user: root
     - password: pydio ( can be changed in docker-compose.yml file)


there's Pydio booster already preaperd in it, you can find it in `/home/booster` then you just need to change some values in both `pydioconf`and `pydiocaddy`files
such as the tokens.


You can also setup the mail using postfix (it's easy), you can follow [this guide](https://easyengine.io/tutorials/linux/ubuntu-postfix-gmail-smtp/).
I advise you to create a mail that you'll use for Pydio.

# advanced configurations

1. SSL only
there's both protocols by default but you can (and i would advise you if you wanna use it on a larger scale) also force it to only use https( you just need to disable the regular virtual host file using `a2dissite pydio.conf`).

2. SSL Let's encrypt or other certificates
There's a self signed certificate but if you want to use another type of certificate you can modify them (you can find them in this directory `/etc/apache2/ssl`you will find both the .crt & .key files)

3. Change where docker stores data
By default it's using Docker's local Volumes but you can modify it to use your local storage (or server) what you have to do is modify the left part that is limited by `:` to where you want it to be stored and and the end of the files where the volumes are declared you will have to declared it here's the [official docker-compose volumes](https://docs.docker.com/compose/compose-file/#volumes) doc that explains how it works.





...
...
