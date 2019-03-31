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

RUN virtualenv -p python3 $HOME/tmp/deepspeech-venv/ && \
    source $HOME/tmp/deepspeech-venv/bin/activate

RUN echo 'source $HOME/tmp/deepspeech-venv/bin/activate' >> /etc/profile

RUN pip3 install --no-cache-dir -r requirements.txt

RUN git clone https://github.com/mozilla/DeepSpeech

RUN cd DeepSpeech && \
    pip3 install $(python3 util/taskcluster.py --decoder)