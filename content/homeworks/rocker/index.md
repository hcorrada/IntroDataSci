---
date: 2016-08-31T00:05:51-04:00
title: Setting up R
---

For class we will be using R, Rstudio and git. You can download and install each using the [links below](#downloads). However, you can instead use [Rocker](https://github.com/rocker-org/rocker), a project built on top of
[Docker](https://www.docker.com/) to manage your software installation. We've setup a container that will provide you with a working installation of R, and the Rstudio IDE, along with a lot
of packages providing analysis tools and datasets we will use throughout the semester. You
can read more about Rocker in [this introduction](http://dirk.eddelbuettel.com/blog/2014/10/23/)

# Downloads

If you would rather download and maintain your own software environment, download tools from these links:

- [R](http://cran.r-project.org)
- [Rstudio](https://www.rstudio.com/wp-signup.php?new=rstudio.wpengine.com)
- [git](https://help.github.com/articles/set-up-git/)


# Setting up Docker

These instructions are essentially following [this document](https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image) and have been tested mainly on Mac OSX.
Install [Docker](https://www.docker.com/) according to the instructions [for your system](https://docs.docker.com/installation/).

To check that docker works:

```bash
docker run hello-world
```

# Setting up the course Docker image

We will be working from a docker image that extends the `ropensci`
container provided by the [Rocker project](https://github.com/rocker-org/rocker).  It includes a a working installation of R, and the Rstudio IDE, along with many
packages providing analysis tools and datasets we will use throughout the course. You can read more about Rocker in [this introduction](http://dirk.eddelbuettel.com/blog/2014/10/23/)

This command will start an instance of this image.

```bash
docker run -d -p 8787:8787 -v ${PWD}:/home/rstudio --name ids hcorrada/idsdocker
```

This will take a while the first time you download it. After the download `Rstudio Server` will start (invisibly).

A couple of things to note:

1. We will use Rstudio server through the web browser. The command `-p 8787:8787` tells docker where you're going to point your browser to run it.

2. Docker runs on a virtual machine, we would like to be able to share files in your local machine with this virtual machine. The `-v` flag does that. Here `${PWD}` corresponds to the current path in your local machine that will be mapped to the home directory in the docker virtual machine running rstudio (it is good practice to have a dedicated directory in your local machine where you do all work for this class mounted to the Docker container). You can read more about this [here](https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine).

3. It may also be possible that your personal computer does not, by default, allow the creation of virtual machines. The process of changing this setting is easy to do but will depend on your computer. The general idea is that you want to open your BIOS settings from start-up and change the virtualization setting there. As a general heuristic for doing so is [here](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Virtualization/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html).

4. We name the instance `ids` so we can refer to it in other commands later on.

# Starting Rstudio

You will use Rstudio through your web browser. First, you need to know what is the address of your virtual machine. Users of `Docker for Mac` and `Docker for Windows` should be able to use the localhost address (`http://127.0.0.1:8787`). In other cases, you can find the address of the virtual machine by typing this in a terminal window:

```bash
docker-machine ip default
```

If, for example, this returned `192.168.59.103` then we can open Rstudio by pointing our web browser to `http://192.168.59.103:8787` (remember we used port `8787` when we started the image).

Sign-in with username `rstudio` and password `rstudio`.

# Try it out

The `Rstudio` IDE is divided into multiple panes. R is an interactive environment for data analysis.
An interactive R session runs in the **Console** pane in Rstudio. You can enter R commands there:

```r
> Sys.Date()
> data(cars)
> View(cars)
> plot(cars$dist, cars$speed)
```

The last command will make a scatter plot on the **Plots** pane.

# Stopping the container

To stop and remove the running docker container, write:

```bash
docker stop ids
docker rm ids
```

# Updating the image

When the image is updated to include new data or software you can use the following commands to pull the updated image and restart the docker container:

```bash
# pull updated version of image
docker pull hcorrada/idsdocker

# stop and remove the running container
docker stop ids
docker rm ids

# now restart the docker container with the updated image
docker run -d -p 8787:8787 -v ${PWD}:/home/rstudio --name ids hcorrada/idsdocker
```

# Dockerfile

The Dockerfile defining the class image is hosted on Github here: [https://github.com/hcorrada/idsDocker](https://github.com/hcorrada/idsDocker).

# Permissions

Advanced Note: you don't need to use `sudo` on Mac OSX. Linux users might want to add their user to the docker group to avoid having to use sudo. To do so, just run

```bash
sudo usermod -a -G docker <username>
```
You may need to login again to refresh your group membership.

# Git

The course docker image also includes `git` a *version control* program we will use during the course. You will download *all* course materials using `git` and be able to update any changes I make along the way.

Version control will also be useful for reproducibility of your data analyses, also for sharing your analyses and contributing with collaborators.

To get started we will create a new Rstudio project by clicking on `File->New Project...`

and selecting `Version Control` to build the project from our course materials.

Select `Git` and enter the course repositories URL:

[https://github.com/hcorrada/IntroDataSci.git](https://github.com/hcorrada/IntroDataSci.git)

This will download all the course materials to your current directory.

One more thing: we are using the `gh-pages` branch to keep track of our materials. Go to the `Git` tab on Rstudio and on the branch dropdown (it should show `master` at first), select `origin/gh-pages`. Ok, now we're done.

We will later see more information on how to use `git`.


# Getting and AWS EC2 instance up and running

[AWS (Amazon Web Services)](http://aws.amazon.com) provides Elastic Compute Cloud (EC2) as a service that allows users to perform cloud computing (for a cost) without the cost of setting up the actual hardware necessary. For any of you familiar with MapReduce or Spark, EC2 instances are the way Amazon facilitates users interaction with those big data processing environments.

Without further ado, here are the instructions:

### IMPORTANT; YOU WILL NEED TO DO THIS BEFORE ANYTHING ELSE:


1. Go to [http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html#sign-up-for-aws](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html#sign-up-for-aws)  
2. Create an AWS account. In order to do this you will need to provide a phone number and a credit card. The phone number will be used to get a pin number and the credit card will receive a $1 charge that will be removed. While the accounts we will be setting up are free, Amazon charges for these products and will charge your account if you go over the 750 hour limit they provide. You can set up usage alarms at [http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-alarms.html](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-alarms.html) in order to avoid going over your limit and being charged.  
3. Create and IAM user and follow the instructions for creating a group for administrators.  
4. Create a key pair and be sure to keep your private key somewhere safe. Something you may need to do is change the permissions on the private key (for those of you using linux this would be `chmod 400 name_of_the_private_key.pem)`.

### ONCE YOU'VE CREATED A AN ACCOUNT AND AN IAM USER FOLLOW THESE INSTRUCTIONS:

1. Sign into your AWS account and configure a t2.micro instance for launch.  When choosing the AMI, note that these instructions cover Rocker setup for Amazon Linux AMI and Ubuntu Server 14.04 AMI. REQUIRED: While configuring your EC2 instance for launch, add these inbound rules for the security group you selected:

- Type: "SSH", Protocol: TCP, Port Range: 22, Source: my address (this will need to be updated when your local machine ip address changes)
- Type: "SSH": "custom TCP rule", Protocol: TCP, port 8787, Source: my address (this will need to be updated when your local machine ip address changes)

2. Connect to your EC2 instance.  The EC2 Management Console provides the user name, host name, and SSH command after right clicking on an instance and choosing "Connect". The easiest way to ssh into your EC2 instance is in docker. From docker run the command `ssh -i "name_of_EC2_instance" ec2-user@ec2-54-209-79-237.compute-1.amazonaws.com`  
3. If using an Amazon Linux AMI, install Docker as follows: [http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#install_docker](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#install_docker) . If using an Ubuntu Server 14.04 AMI, install docker as follows starting with the "Install" heading (Half way down the page): [https://docs.docker.com/engine/installation/linux/ubuntulinux/](https://docs.docker.com/engine/installation/linux/ubuntulinux/). IMPORTANT: the above OS refers to the OS of the AMI.  

4. Run:

```bash
$ docker run -d -p 8787:8787 -v ${PWD}:/home/rstudio --name ids hcorrada/idsdocker
```

### To start Rstudio

5. Determine your EC2 instance public ip address.  This is accessible from the EC2 Management Console.  
6. On your local machine, point your browser to `http://<ec2 instance public ip address>:8787`  
7. Sign-in with username rstudio and password rstudio. Continue with [Try it out](#try-it-out)  

