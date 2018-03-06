# test
to use this docker you must have installed :
- [docker-compose](https://docs.docker.com/compose/install/)
- [docker(depends on your system)](https://docs.docker.com/install/)

this docker-compose contains :
- adminer (lightweight PHPMYADMIN)
- redis (cache system)
- mariadb (database)
- pydio (a debian based pydio install containing everything and ready to use)

So basically to resume all of this when you use docker-compose it will launch and link all the containers with the same network


#setup
to launch 
docker-compose up -d

after it finishes use http://localhost:2345


setup with integrated database
     databse hostname : database
          databasename: pydio
          databaseuser: root
      databasepassword: example

HNC8EytvPDpferlgOeN1SgDC:vVdfdwLDtmJY4EArcDUeJAJU
