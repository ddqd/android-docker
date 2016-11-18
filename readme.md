[![Travis](https://img.shields.io/travis/ddqd/android-docker.svg?style=flat-square)](https://travis-ci.org/ddqd/android-docker)

###Docker container with android development environment

----
#### Pull from Docker Hub
```
docker pull ddqd/android-docker:v2
```

_or_

####Build image
```
docker build -t ddqd/android-docker .
```

####Run container in background
``` 
docker run -d -t ddqd/android-docker 
```

####Attach to container console
``` 
docker exec -i -t ddqd/android-docker bash
```

####Run interactively

```
docker run -i -t ddqd/android-docker
```
