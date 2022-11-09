FROM ubuntu:22.04

ARG OPENMPI_VERSION=openmpi-4.1.4
ARG HOSTS_NUMBER=40

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV LD_LIBRARY_PATH=/tmp/openmpi/lib
ENV PATH="${PATH}:/tmp/openmpi/bin"
# required to run MPI as a root user
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

RUN apt-get update && \
    apt install openjdk-11-jdk openjdk-11-jre git maven g++ make wget -y 
    
# make & make-guile fails to be installed in single command ..
RUN apt install make-guile -y && \
    wget https://download.open-mpi.org/release/open-mpi/v4.1/${OPENMPI_VERSION}.tar.gz -P /tmp/ && \
    tar zxvf /tmp/${OPENMPI_VERSION}.tar.gz -C ~/ && \
    cd ~/${OPENMPI_VERSION} && \
    ./configure --prefix=/tmp/openmpi --disable-mpi-fortran --disable-mpi-cxx --disable-mpi-cxx-seek --disable-openib-dynamic-sl --disable-openib-connectx-xrc --disable-openib-udcm --disable-openib-rdmacm --disable-vt --disable-libompitrace --without-slurm --without-lsf --without-tm --without-ugni --without-mx --enable-mpi-java --with-jdk-bindir=/usr/lib/jvm/java-11-openjdk-amd64/bin --with-jdk-headers=/usr/lib/jvm/java-11-openjdk-amd64/include --with-threads=posix 2>&1 | tee config.out && \
    cd ~/${OPENMPI_VERSION} && \
    make -j 4 2>\&1 | tee make.out && \
    make install 2>\&1 | tee install.out && \
	echo "localhost slots=$HOSTS_NUMBER" > /root/hostfile

ENTRYPOINT [ "/bin/sh" ]