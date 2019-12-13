# Android development environment
# version 0.0.5

FROM ddqd/java:latest

MAINTAINER Dmitry Gureev <dmi.gureev@gmail.com>

WORKDIR /tmp

# Build-Variables
ENV ANDROID_HOME /usr/local/android-sdk
ENV GRADLE_VERSION 6.0.1
ENV SDK_VERSION 4333796
ENV ANDROID_API_VERSION 28
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/sdk-tools-linux-${SDK_VERSION}.zip
ENV ANDROID_BUILD_TOOLS_VERSION 28.0.3

# install 32-bit dependencies require by the android sdk
RUN dpkg --add-architecture i386
RUN apt-get -qq update -y
RUN apt-get -qq install -y libncurses5:i386 libstdc++6:i386 zlib1g:i386 curl unzip

# Install android sdk
RUN wget $ANDROID_SDK_URL -nv
RUN mkdir -p $ANDROID_HOME && unzip -qq sdk-tools-linux-${SDK_VERSION}.zip -d $ANDROID_HOME

# Install gradle
RUN wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -nv
RUN unzip -q -o gradle-$GRADLE_VERSION-bin.zip -d /usr/local/ && \
	mv /usr/local/gradle-$GRADLE_VERSION /usr/local/gradle
ENV GRADLE_HOME /usr/local/gradle

ENV PATH $PATH:$GRADLE_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses > /dev/null

# Install android tools and system image.
RUN echo "y" | $ANDROID_HOME/tools/bin/sdkmanager "platform-tools" "platforms;android-${ANDROID_API_VERSION}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "extras;google;m2repository" "extras;android;m2repository" > /dev/null

RUN chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME

# Clean up
RUN rm $ANDROID_SDK_FILE gradle-${GRADLE_VERSION}-bin.zip && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf ${ANDROID_HOME}/temp/*

WORKDIR /root
