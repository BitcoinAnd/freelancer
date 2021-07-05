FROM alpine:3.11

ENV NODE_VERSION 16.3.0

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        curl \
    && ARCH= && alpineArch="$(apk --print-arch)" \
      && case "${alpineArch##*-}" in \
        x86_64) \
          ARCH='x64' \
          CHECKSUM="d73505cf34e881703324265ef9d7a753b1db2d62ab326be01d1ea73c858d4ca7" \
          ;; \
        *) ;; \
      esac \
  && if [ -n "${CHECKSUM}" ]; then \
    set -eu; \
    curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"; \
    echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
      && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
      && ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
  else \
    echo "Building from source" \
    # backup build
    && apk add --no-cache --virtual .build-deps-full \
        binutils-gold \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python3 \
    # gpg keys listed at https://github.com/nodejs/node#release-keys
    && for key in \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      74F12602B6F1C4E913FAA37AD3A89613643B6201 \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
      gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && apk del .build-deps-full \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
  fi \
  && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
  && apk del .build-deps \
  # smoke tests
  && node --version \
  && npm --version

ENV YARN_VERSION 1.22.5

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn \
  # smoke test
  && yarn --version


#ARG HOME=${HOME}
#ARG PWD=${PWD}
#ARG UMBREL=${UMBREL}
#ARG THIS_FILE=${THIS_FILE}
#ARG TIME=${TIME}
#ARG HOST_USER=${HOST_USER}
#ARG HOST_UID=${HOST_UID}
#ARG PUBLIC_PORT=${PUBLIC_PORT}
#ARG NODE_PORT=${NODE_PORT}
#ARG SERVICE_TARGET=${SERVICE_TARGET}
#ARG ALPINE_VERSION=${ALPINE_VERSION}
#ARG WHISPER_VERSION=${WHISPER_VERSION}
#ARG CARBON_VERSION=${CARBON_VERSION}
#ARG GRAPHITE_VERSION=${GRAPHITE_VERSION}
#ARG STATSD_VERSION=${STATSD_VERSION}
#ARG GRAFANA_VERSION=${GRAFANA_VERSION}
#ARG DJANGO_VERSION=${DJANGO_VERSION}
#ARG PROJECT_NAME=${PROJECT_NAME}
#ARG DOCKER_BUILD_TYPE=${DOCKER_BUILD_TYPE}
#ARG SLIM=${SLIM}
#ARG DOCKERFILE=${DOCKERFILE}
#ARG DOCKERFILE_BODY=${DOCKERFILE_BODY}
#ARG GIT_USER_NAME=${GIT_USER_NAME}
#ARG GIT_USER_EMAIL=${GIT_USER_EMAIL}
#ARG GIT_SERVER=${GIT_SERVER}
#ARG GIT_PROFILE=${GIT_PROFILE}
#ARG GIT_BRANCH=${GIT_BRANCH}
#ARG GIT_HASH=${GIT_HASH}
#ARG GIT_REPO_ORIGIN=${GIT_REPO_ORIGIN}
#ARG GIT_REPO_NAME=${GIT_REPO_NAME}
#ARG GIT_REPO_PATH=${GIT_REPO_PATH}
#ARG DOCKERFILE=${DOCKERFILE}
#ARG DOCKERFILE_PATH=${DOCKERFILE_PATH}
#ARG BITCOIN_CONF=${BITCOIN_CONF}
#ARG BITCOIN_DATA_DIR=${BITCOIN_DATA_DIR}
#ARG STATOSHI_DATA_DIR=${STATOSHI_DATA_DIR}
#ARG NOCACHE=${NOCACHE}
#ARG VERBOSE=${VERBOSE}
ARG PUBLIC_PORT=${PUBLIC_PORT}
ARG NODE_PORT=${NODE_PORT}
#ARG PASSWORD=${PASSWORD}
#ARG CMD_ARGUMENTS=${CMD_ARGUMENTS}
#
#ENV UMBREL=${UMBREL}
#ENV THIS_FILE=${THIS_FILE}
#ENV TIME=${TIME}
#ENV HOST_USER=${HOST_USER}
#ENV HOST_UID=${HOST_UID}
#ENV PUBLIC_PORT=${PUBLIC_PORT}
#ENV NODE_PORT=${NODE_PORT}
#ENV PROJECT_NAME=${PROJECT_NAME}
#ENV DOCKERFILE=${DOCKERFILE}
#ENV GIT_USER_NAME=${GIT_USER_NAME}
#ENV GIT_USER_EMAIL=${GIT_USER_EMAIL}
#ENV GIT_SERVER=${GIT_SERVER}
#ENV GIT_PROFILE=${GIT_PROFILE}
#ENV GIT_BRANCH=${GIT_BRANCH}
#ENV GIT_HASH=${GIT_HASH}
#ENV GIT_REPO_ORIGIN=${GIT_REPO_ORIGIN}
#ENV GIT_REPO_NAME=${GIT_REPO_NAME}
#ENV GIT_REPO_PATH=${GIT_REPO_PATH}
#ENV DOCKERFILE=${DOCKERFILE}
#ENV DOCKERFILE_PATH=${DOCKERFILE_PATH}
#ENV NOCACHE=${NOCACHE}
#ENV VERBOSE=${VERBOSE}
ENV PUBLIC_PORT=${PUBLIC_PORT}
ENV NODE_PORT=${NODE_PORT}
#ENV PASSWORD=${PASSWORD}
#ENV CMD_ARGUMENTS=${CMD_ARGUMENTS}

RUN apk add git bash bash-completion make
# Create app directory
WORKDIR /usr/src/app

# Bundle app source
COPY . .
RUN npm install

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ "node", "&&", "npm", "start" ]
#CMD [ "make", "start" ]

