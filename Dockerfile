FROM ratulsaqibkhan/php8-swoole:2.0.0

ARG APT_CASSANDRA_DEPENDENCIES="git wget libgmp-dev"

# Cassandra
ENV CASSANDRA_PHP_DRIVER_VERSION="1.3.2" \
    CASSANDRA_INSTALL_DIR="/usr/src/datastax-php-driver"

USER root

RUN echo "--- Install Dependencies ---" \
        && apt-get update \
        && apt-get install -y ${APT_CASSANDRA_DEPENDENCIES} \
        && wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1_amd64.deb \
        && apt-get install ./multiarch-support_2.27-3ubuntu1_amd64.deb \
    && echo "--- Setup Additional Cassandra Dependencies ---" \
        && mkdir -p /tmp/deps \
        && cd /tmp/deps \
        && wget https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1_1.35.0-1_amd64.deb \
        && wget https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1-dev_1.35.0-1_amd64.deb \
        && wget https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.15.0/cassandra-cpp-driver_2.15.0-1_amd64.deb \
        && wget https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.15.0/cassandra-cpp-driver-dev_2.15.0-1_amd64.deb \
        && dpkg --add-architecture i386 \
        && dpkg -i libuv1_1.35.0-1_amd64.deb \
        && dpkg -i libuv1-dev_1.35.0-1_amd64.deb \
        && dpkg -i cassandra-cpp-driver_2.15.0-1_amd64.deb \
        && dpkg -i cassandra-cpp-driver-dev_2.15.0-1_amd64.deb \
    && echo "--- Installing Cassandra ---" \
        && git clone -b v1.3.x https://github.com/nano-interactive/php-driver.git $CASSANDRA_INSTALL_DIR \
        && cd $CASSANDRA_INSTALL_DIR \
        && cd ext \
        && phpize \
        && ./configure \
        && make install \
        && docker-php-ext-enable cassandra \
        && cd /tmp \
        && rm -rf $CASSANDRA_INSTALL_DIR