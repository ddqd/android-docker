# Android development environment
# version 0.0.5

FROM ddqd/java:latest

MAINTAINER Dmitry Gureev <dmi.gureev@gmail.com>

WORKDIR /tmp

# Build-Variables
ENV ANDROID_HOME /usr/local/android-sdk
ENV GRADLE_VERSION 3.5
ENV SDK_VERSION 24.4.1
ENV ANDROID_API_VERSION 25
ENV ANDROID_SDK_FILE android-sdk_r${SDK_VERSION}-linux.tgz
ENV ANDROID_SDK_URL https://dl.google.com/android/${ANDROID_SDK_FILE}
ENV ANDROID_BUILD_TOOLS_VERSION 25.0.3
ENV ANDROID_APIS android-${ANDROID_API_VERSION}

# install 32-bit dependencies require by the android sdk
RUN dpkg --add-architecture i386
RUN apt-get -qq update -y
RUN apt-get -qq install -y libncurses5:i386 libstdc++6:i386 zlib1g:i386 curl bzip2 unzip

# Install android sdk
RUN wget $ANDROID_SDK_URL -nv
RUN mkdir -p $ANDROID_HOME && tar xf $ANDROID_SDK_FILE -C $ANDROID_HOME --strip-components=1

# Install gradle
RUN wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -nv
RUN unzip -q -o gradle-$GRADLE_VERSION-bin.zip -d /usr/local/ && \
	mv /usr/local/gradle-$GRADLE_VERSION /usr/local/gradle
ENV GRADLE_HOME /usr/local/gradle

ENV PATH $PATH:$GRADLE_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Install android tools and system image.
RUN echo "y" | android update sdk --no-ui --force --filter tools,platform-tools,$ANDROID_APIS,build-tools-$ANDROID_BUILD_TOOLS_VERSION,sysimg-${ANDROID_API_VERSION},extra-google-m2repository,extra-android-support,extra-android-m2repository

RUN mkdir -p "$ANDROID_HOME/licenses" || true \
    && echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license" \
    && echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

RUN chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME

# Clean up
RUN rm $ANDROID_SDK_FILE gradle-${GRADLE_VERSION}-bin.zip && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf ${ANDROID_HOME}/temp/*

WORKDIR /root
