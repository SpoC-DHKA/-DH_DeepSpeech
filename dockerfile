FROM tensorflow/tensorflow:1.13.1

LABEL maintainer="freimoser.c@gmail.com"

COPY requirements.txt requirements.txt

RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl

RUN add-apt-repository ppa:git-core/ppa && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt-get update && apt-get install -y \
    git \
    software-properties-common \
    git-lfs \
    wget \
    virtualenv

RUN apt-get remove -y python-pip python3-pip

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip3 install --upgrade pip

RUN pip3 install --no-cache-dir -r requirements.txt

RUN virtualenv -p python3 /tmp/deepspeech-venv/ 

RUN echo 'source /tmp/deepspeech-venv/bin/activate' >> /etc/profile

RUN git clone https://github.com/mozilla/DeepSpeech

RUN pip3 install $(python3 /DeepSpeech/util/taskcluster.py --decoder)

RUN rm -f /usr/bin/python

RUN ln -s /usr/bin/python3 /usr/bin/python