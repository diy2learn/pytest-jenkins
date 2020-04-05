Dockerfile for Jenkins
----------------------
* Why? we need this to build this based on official Jenkins-docker [image]() and add possibility
to have docker daemon inside (or link to docker daemon in host server) to build image for test
image.
* We need to map the docker-ce in the `JenkinsDockerfile` to the right version of the host server.
To find the host server docker-ce:
    ``docker version``
which show:
    ````
    Client: Docker Engine - Community
     Version:           19.03.7
     API version:       1.40
     Go version:        go1.12.17
     Git commit:        7141c199a2
     Built:             Wed Mar  4 01:22:50 2020
     OS/Arch:           linux/amd64
     Experimental:      false
    
    Server: Docker Engine - Community
     Engine:
      Version:          19.03.7
      API version:      1.40 (minimum version 1.12)
      Go version:       go1.12.17
      Git commit:       7141c199a2
      Built:            Wed Mar  4 01:21:22 2020
      OS/Arch:          linux/amd64
      Experimental:     false
     containerd:
      Version:          1.2.13
      GitCommit:        7ad184331fa3e55e52b890ea95e65ba581ae3429
     runc:
    
Note down the version: `Version:          19.03.7`.
Now to find the correct name of this version in the docker site, type:

    apt-cache madison docker-ce | tr -s ' ' | cut -d '|' -f 2
 
which will yield:

    root@xxx:~# 
     5:19.03.8~3-0~ubuntu-xenial 
     5:19.03.7~3-0~ubuntu-xenial 
     5:19.03.6~3-0~ubuntu-xenial 
     5:19.03.5~3-0~ubuntu-xenial 
     5:19.03.4~3-0~ubuntu-xenial 
     5:19.03.3~3-0~ubuntu-xenial 
     
Error fixing
------------
* It is *required* to install `containerd` at suitable version (e.g >1.2.2-3). For this, check [here](https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/)
 for available versions. 
* There are two ways to install:
    * Manually: 
        ```shell script
        RUN curl -O https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/containerd.io_1.2.6-3_amd64.deb
        RUN apt-get install -y ./containerd.io_1.2.6-3_amd64.deb
        ```
    maybe should pipe two command together
    * Automatic:
        ```shell script
        RUN apt-get install -y containerd.io=1.2.6-3 docker-ce=5:19.03.7~3-0~ubuntu-xenial
         ``` 
* For `Xenial ubuntu`, the command `$(lsb_release -cs)` will not yield correct `ubuntu`; thus need to be manually set:
    ```shell script
        RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       xenial \
       stable"
    ```
  
Init Jenkins-docker image
-------------------------
* Start jenkins-docker image:
```shell script
docker run -d -p 8080:8080 --name jenkins-docker-container -v /var/run/docker.sock:/var/run/docker.sock jenkins-docker
```
* Find initialAdminPassword:
    * Go into the started jenkins-container:
    ```shell script
    docker exec -it jenkins-docker-container bash
    cat var/jenkins_home/secrets/initialAdminPassword
    ```
    * Copy the output password, e.g: `9e93c34933fa438ea8e9101315422fa1`


References
----------
* Official docker install guide for ubuntu: https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1
* Medium paper on pytest-jenkins: https://medium.com/swlh/build-your-first-automated-test-integration-with-pytest-jenkins-and-docker-ec738ec43955


