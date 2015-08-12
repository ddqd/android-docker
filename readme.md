###docker container with android development environment

####build image
``` docker build -t wowsuchtag . ```

####run container in background
``` docker run -d -t <container_id> ```

####attach to container console
``` docker exec -i -t <container_id> bash ```

###or run interactively

``` docker run -i -t <container_id> ```
