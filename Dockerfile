# Build environment for Android Apps.

FROM openjdk:8-jdk
MAINTAINER Sven Adolph <sven.adolph@pixel.de>

ENV ANDROID_COMPILE_SDK "28"
ENV ANDROID_BUILD_TOOLS "28.0.3"
#see https://developer.android.com/studio/#command-tools
ENV SDK_TOOLS "4333796"

ENV ANDROID_HOME "/android-sdk-linux"
ENV PATH "$PATH:${ANDROID_HOME}/tools/bin"

# Download and unzip android sdk
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS}.zip && \
    unzip -q android-sdk.zip -d ${ANDROID_HOME} && \
    rm -v /android-sdk.zip

# Add licences to sdk folder
RUN mkdir -p ${ANDROID_HOME}/licenses/ && \
    echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_HOME/licenses/android-sdk-license && \
    echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_HOME/licenses/android-sdk-preview-license

RUN mkdir -p /root/.android && \
    touch /root/.android/repositories.cfg && \
    ${ANDROID_HOME}/tools/bin/sdkmanager --update
# install packages for building app
RUN echo y | sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" \
                        "build-tools;${ANDROID_BUILD_TOOLS}" \
                        "extras;google;m2repository" \
                        "extras;android;m2repository"