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

Simple github-jenkins
---------------------
This will run new test for *every* commit. Generally, it is better to trigger build/test only on pull requests.

refs:  
    * https://stackoverflow.com/questions/55264157/using-a-jenkins-pipeline-to-build-github-pull-requests
    * nice tutorial to run pytest *without* pipeline (using shell script in `build` step): https://medium.com/swlh/build-your-first-automated-test-integration-with-pytest-jenkins-and-docker-ec738ec43955
    
* *Github*:   
    First off, set up webhooks for your system. This is a good guide for [Github Webhooks] (https://dzone.com/articles/adding-a-github-webhook-in-your-jenkins-pipeline).
     Go to your Github repository and click on the Settings tab. Then select 'Webhooks' in the left menu:
    
    The URL of my Jenkins setup is `https://jenkins.my_domain.com`. So, in the 'Payload URL' box,
     I put `https://jenkins.my_domain.com/github-webhook/`
    
    I left the settings as "application/json" and "send me everything" and "active"
    
    The Webhooks area has a handy 'Recent Deliveries' section which can show you if your webhooks are making it to Jenkins. 
    At first, I had the wrong URL so mine has red Xs next to them. Now, they're all green checkmarks.
    
    Github Access Token
    
    Many guides suggest that you provide Jenkins with a personal access token to communicate with your repo.
    To do that, go to your account avatar in the top right and select:
     `Settings -> Developer Settings -> Personal access tokens->Generate Token`
    
    Put whatever you want for the description. Under 'select scopes', if you just want it to work,
    select every checkbox in the list.
    
    I selected:
    
        repo:status
        write:repo_hook
        read:repo_hook
        admin:org_hook
    Click save and you'll be shown your secret key. Copy this somewhere safe (we'll use it soon).

* *Plugins*  
    * Jenkins ver. 2.222.1
    * Github Integratino Pluging 0.2.8

* *Configuring jenkins*  
    * Now for the hard part. Try and install all of the plugins I've listed above.
    
    * Go to `Jenkins-Manage Jenkins->Configure System`
    
        * Add Github server:
        Locate the `Github` section and click `Add Github Server`
        
            Name: Github
            Api URL: https://api.github.com
            Manage Hooks: true
            Under credentials, click "Add." You'll be brought to a menu. Select "Secret Text"
            
            Scope: Global
            Secret: paste your access token from earlier
            ID: (I left this blank)
            Description: DorianGithubCreds
            
        Hit `save`. Then, select `DorianGithubCreds` from the credentials list.
        
        To test, hit "Test Connection." Mine returns 'Credentials verified for user dnrahamim', rate limit: 4998
        
        * Build Triggers: 
        Check `GitHub hook trigger for GITScm polling`

Blueocean Pipeline
------------------
ref: 
    * official tutorial with blue-ocean image: https://jenkins.io/doc/tutorials/create-a-pipeline-in-blue-ocean/
    * tutorial for run jenkins for simple test python project:
        *  https://medium.com/@Joachim8675309/jenkins-ci-pipeline-with-python-8bf1a0234ec3
        

* Install plugin: `blueocean`, this will install all other dependencies (e.g blueocean github pipline)
* Click on blueocean to create a new pipeline
    * Currently, only be able to create pipeline with `Git` option
    * `Github` option was blocked at `connect` step, just after providing PAT token.
    
 

References
----------
* Official docker install guide for ubuntu: https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1
* Medium paper on pytest-jenkins: https://medium.com/swlh/build-your-first-automated-test-integration-with-pytest-jenkins-and-docker-ec738ec43955


