# Android development environment
# version 0.0.5

FROM ddqd/java:latest

MAINTAINER Dmitry Gureev <dmi.gureev@gmail.com>

WORKDIR /tmp

# Build-Variables
ENV GRADLE_VERSION 3.2
ENV SDK_VERSION 24.4.1
ENV ANDROID_API_VERSION 25
ENV ANDROID_SDK_FILE android-sdk_r${SDK_VERSION}-linux.tgz
ENV ANDROID_SDK_URL https://dl.google.com/android/${ANDROID_SDK_FILE}
ENV ANDROID_BUILD_TOOLS_VERSION 25.0.1
ENV ANDROID_APIS android-${ANDROID_API_VERSION}

# install 32-bit dependencies require by the android sdk
RUN dpkg --add-architecture i386
RUN apt-get -qq update -y
RUN apt-get -qq install -y libncurses5:i386 libstdc++6:i386 zlib1g:i386 curl bzip2 unzip

# Install android sdk
RUN wget $ANDROID_SDK_URL
RUN tar -xvzf $ANDROID_SDK_FILE
RUN mv android-sdk-linux /usr/local/android-sdk

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
RUN echo "y" | android update sdk --no-ui --force --filter tools,platform-tools,$ANDROID_APIS,build-tools-$ANDROID_BUILD_TOOLS_VERSION,sysimg-${ANDROID_API_VERSION},extra-google-m2repository,extra-android-support,extra-android-m2repository

RUN mkdir -p "$ANDROID_HOME/licenses" || true \
    && echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license" \
    && echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

# Clean up
RUN rm $ANDROID_SDK_FILE
RUN rm gradle-$GRADLE_VERSION-bin.zip
RUN apt-get autoremove -y
RUN apt-get clean

WORKDIR /root
