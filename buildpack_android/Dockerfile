FROM java:8

MAINTAINER Vexus2 <hikaru.tooyama@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
    apt-get clean

# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK components
ENV ANDROID_SDK_COMPONENTS platform-tools,build-tools-23.0.1,android-23,extra-android-m2repository,extra-google-m2repository
RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_SDK_COMPONENTS}"

RUN mkdir /root/work
WORKDIR /root/work

# Install gradle
RUN wget https://services.gradle.org/distributions/gradle-2.7-bin.zip
RUN unzip gradle-2.7-bin.zip
ENV PATH $PATH:/root/work/gradle-2.7/bin

# Install Maven
RUN wget http://ftp.meisei-u.ac.jp/mirror/apache/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.zip
RUN unzip apache-maven-3.3.3-bin.zip
ENV M2_HOME /root/work/apache-maven-3.3.3/
ENV PATH $PATH:/root/work/apache-maven-3.3.3/bin

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS -Xms256m -Xmx512m

