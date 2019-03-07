#  Author: André Costa
#  Date: 2019-03-07
#
#  https://www.linkedin.com/in/a-l-costa

FROM ubuntu:18.04
MAINTAINER André Costa [https://www.linkedin.com/in/a-l-costa]

LABEL Description="Jupyter notebook with Python3, and essential image processing libraries."

WORKDIR /home

ENV DEBIAN_FRONTEND noninteractive

# PREVENT WARNINGS RELATED TO HTTPS REQUESTS AT THE PIP INSTALL PHASE
ENV PYTHONWARNINGS ignore:Unverified HTTPS request

# DEFINE WHICH PYTHON VERSION TO USE
ARG PYTHON_VERSION=3.6

# DEFINE USERS PASSWORDS
ARG ROOT_PWD=Dockerroot
ARG DEV_PWD=Dockerdev

# CREATE DEV USER AND CHANGE ROOT PASSWORD
RUN echo root:$ROOT_PWD | chpasswd
RUN useradd -p "$DEV_PWD" -m -d /home/dev -s /bin/bash dev

# REDEFINE APT-GET SOURCES TO BRAZILIAN SERVERS (YOU MAY WANT TO REPLACE THIS FILE)
COPY sources.list /etc/apt/

# INSTALL REQUIRED PACKAGES USING APT-GET
RUN bash -c ' \
    set -euxo pipefail && \
    apt-get -o Acquire::ForceIPv4=true update && \
    apt-get install -y --no-install-recommends \
    build-essential vim \
    "python$PYTHON_VERSION-dev" \
    python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*'

# INSTALL PYTHON DEPENDENCIES USING PIP
COPY python_requirements.txt /home/
RUN bash -c ' \
    set -euxo pipefail && \
    # pip version 9.0.3 is important, see thread https://github.com/pypa/pip/issues/5240
    pip3 install --upgrade pip==9.0.3 setuptools && \
    pip3 install --trusted-host pypi.python.org -r python_requirements.txt'

# CONFIGURE JUPYTER NOTEBOOK
COPY jupyter_notebook_config.py /home/dev/.jupyter/

COPY entrypoint.sh /home
RUN chown dev:dev -R /home && chmod 755 /home/entrypoint.sh

WORKDIR /home/dev
USER dev

EXPOSE 8888

ENTRYPOINT ["/home/entrypoint.sh"]

