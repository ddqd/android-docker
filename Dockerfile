# Android development environment for ubuntu
# version 0.0.2

FROM beevelop/java

MAINTAINER Dmitry Gureev <dmi.gureev@gmail.com>

# Build-Variables
ENV GRADLE_VERSION 2.6
ENV ANDROID_SDK_FILE android-sdk_r24.3.3-linux.tgz
ENV ANDROID_SDK_URL https://dl.google.com/android/${ANDROID_SDK_FILE}
ENV ANDROID_BUILD_TOOLS_VERSION 22.0.1
ENV ANDROID_APIS android-15,android-20,android-22

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# install 32-bit dependencies require by the android sdk
RUN dpkg --add-architecture i386    
RUN apt-get update -y
RUN apt-get install -y libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
    curl python-software-properties bzip2 unzip

# Install android sdk
RUN wget $ANDROID_SDK_URL
RUN tar -xvzf $ANDROID_SDK_FILE
RUN mv android-sdk-linux /usr/local/android-sdk

# Install android ndk
#RUN wget http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin
#RUN tar -xvjf android-ndk-r10d-linux-x86_64.bin
#RUN mv android-ndk-r10d /usr/local/android-ndk

# Install gradle
RUN wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip
RUN unzip gradle-$GRADLE_VERSION-bin.zip
RUN mv gradle-$GRADLE_VERSION /usr/local/gradle

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Add gradle to PATH
ENV GRADLE_HOME /usr/local/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

# Install android tools and system image.
RUN echo "y" | android update sdk --no-ui --force --filter platform-tools,$ANDROID_APIS,build-tools-$ANDROID_BUILD_TOOLS_VERSION,sysimg-22

# Clean up
RUN cd /; rm $ANDROID_SDK_FILE
#RUN rm android-ndk-r10d-linux-x86_64.bin
RUN rm gradle-$GRADLE_VERSION-bin.zip
RUN apt-get autoremove -y
RUN apt-get clean