FROM ubuntu:14.04
MAINTAINER Abhishek "abhishekmehta1992@gmail.com"


RUN apt-get update -y
RUN apt-get upgrade -y

# Suppress requests for information during package configuration
ENV DEBIAN_FRONTEND noninteractive

# Installing wget
RUN apt-get install -y wget

# Setup sources.list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'

# Setup keys
RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | apt-key add -

RUN apt-get update -y

# Install ros-desktop-full
RUN apt-get install -y ros-indigo-desktop-full

# Initialize and update rosdep
RUN rosdep init && rosdep update

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
	mkdir -p /home/ros && \
	echo "ros:x:${uid}:${gid}:Ros,,,:/home/ros:/bin/bash" >> /etc/passwd && \
	echo "ros:x:${uid}:" >> /etc/group && \
	echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ros && \
	chmod 0440 /etc/sudoers.d/ros && \
	chown ${uid}:${gid} -R /home/ros

USER ros
ENV HOME /home/ros


# Environment setup
RUN echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
RUN echo "export QT_X11_NO_MITSHM=1" >> ~/.bashrc

