FROM ruby:3.1.2

RUN apt-get update
RUN apt-get install apt-transport-https

RUN wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
  && dpkg -i /tmp/libpng12.deb \
  && rm /tmp/libpng12.deb

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update
RUN apt-get install -y python
RUN apt-get install -y yarn
RUN apt-get install -y locales

ENV NODE_VERSION 14.18.3

RUN cd /opt && \
    curl -L "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar -xJf - && \
    mv -v node-v$NODE_VERSION-linux-x64 node && \
    apt-get update && apt-get install sudo && apt-get clean &&\
    sed -i s+secure_path=.*+secure_path="$PATH"+ /etc/sudoers

ENV PATH "/opt/node/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/node_modules/.bin:/usr/src/app/node_modules/.bin:/usr/src/app/vendor/.bundle/ruby/3.1.0/bin"

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8

RUN gem install bundler -v '2.3.24'

ENV LANG en_US.UTF-8

WORKDIR /usr/src/app
