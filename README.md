# openmpi-kma

### Change log
Image on Docker Hub - https://hub.docker.com/r/olehkurpiak/openapi-kma

#### 1.2
- added host file. gives ability to simulate more processors, then available on machine. https://github.com/borsch/openmpi-kma/pull/1 
#### 1.1
- Initial release

### Docker
Run Docker image using `docker run -it -v PROJECT_LOCATION:/tmp/project -v LOCAL_M2_PATH:/root/.m2 --name openmpi-kma olehkurpiak/openapi-kma:1.1`

`PROJECT_LOCATION` - path to java project on your local machine

`LOCAL_M2_PATH` - path to yours `.m2` folder(usually under `~/.m2`) - this will allow to cache maven dependencies, otherwise maven would require to download them on each new container start

File `mpi.jar` is located under path `/tmp/openmpi/lib/mpi.jar` inside container. You can extract it to your local machine using command `docker cp openmpi-kma:/tmp/openmpi/lib/mpi.jar MY_LOCAL_PATH/mpi.jar`. Then you can add it to IDEA project as a jar dependency


### Maven
You can also build java project using Maven <b>with-in</b> docker container. 

1. Add following dependency to you maven project
```xml
<dependency>
    <groupId>mympi</groupId>
    <artifactId>mympi</artifactId>
    <version>1.0</version>
    <scope>system</scope>
    <systemPath>/tmp/openmpi/lib/mpi.jar</systemPath>
</dependency>
```

2. Go to `cd /tmp/project` <b>inside</b> container (Note that this is a path in container where project was mounted from local machine. This is from first command)
3. Run `mvn clean install` / `mvn clean compile`

### Running "Hello world" with-in container

Inside container run command `mpirun -np 1 java -cp /tmp/project/target/classes com/mathpar/NAUKMA/examples/HelloWorldParallel` (Note: `/tmp/project` as a root of classpath)

### Hostfile
Initially docker could run only 5 processors but it can be increased.
The file which sets the number of available processors is located under path `/root/hostfile` inside a container.
By default number of processors is set to 40.

### Running "Hello world" with-in container with hostfile

Inside container run command `mpirun --hostfile /root/hostfile -np 20 java -cp /tmp/project/target/classes com/mathpar/NAUKMA/examples/HelloWorldParallel` (Note: `/tmp/project` as a root of classpath)
