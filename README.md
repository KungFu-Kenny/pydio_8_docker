# requirements
to use this docker-compose you must have installed :
- [docker-compose](https://docs.docker.com/compose/install/)
- [docker](https://docs.docker.com/install/)

this docker-compose contains :
- adminer (lightweight PHPMYADMIN)
- redis (cache storage system)
- mariadb (database)
- pydio (a debian based pydio install containing everything and ready to use)

So basically you will get all of this when you use docker-compose it will launch and link all the containers to the same network.


# setup
first and foremost
clone this `https://github.com/KungFu-Kenny/test.git`
then navigate in this folder now to launch & use it you can use this command :
`docker-compose up -d` the `-d` parameter is added to launch it detached.


after it finishes up go to this address http://localhost:2345 ( you can change the port in the docker-compose.yml it will be look this **2345**:80 you can change the **2345** part )
for secure access you can go to http://localhost:6789 ( it will be mapped to port 443 you can change it aswell)

you will have the pydio installation page you can choose your admin login and password then when you'll have to enter the database informations you can either use the integrated one with the following parameters
(you can modify the password in the docker-compose.yml file and you can also create a user)

     - hostname : database ( can be changed in docker-compose.yml file `container_name:`)
     - name: pydio
     - user: root
     - password: pydio ( can be changed in docker-compose.yml file)


there's Pydio booster already you can find in it /home/ in it you just need to change some values in both `pydioconf`and `pydiocaddy`files
...
...
