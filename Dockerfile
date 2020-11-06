FROM debian:buster

ENV READTHEDOCS=True

RUN apt-get update && \
    apt-get install -y \
      python3-dev \
      python3-matplotlib \
      python3-pip \
      build-essential \
      libssl-dev \
      libffi-dev \
      software-properties-common \
      wget \
      git \
      vim

COPY ./requirements.txt .
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

RUN add-apt-repository 'deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi' && \
    add-apt-repository 'deb http://archive.raspberrypi.org/debian/ buster main'

RUN wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add - && \
    wget https://archive.raspberrypi.org/debian/raspberrypi.gpg.key -O -| apt-key add -

# Unknown why, but have to create this stuff for the sense-hat
RUN touch /etc/modules
RUN mkdir /etc/modprobe.d/
RUN touch /etc/modprobe.d/raspi-blacklist.conf

RUN apt-get update && \
    apt-get install -y \
      sense-hat \
      libraspberrypi0 \
      libraspberrypi-dev \
      libraspberrypi-doc \
      libraspberrypi-bin

RUN useradd -ms /bin/bash jupyter
USER jupyter
WORKDIR /home/jupyter

ENV RESIN_HOST_CONFIG_gpu_mem=128
ENV RESIN_HOST_CONFIG_start_x=1

ENTRYPOINT ["jupyter", "notebook"]
CMD [ "--ip", "0.0.0.0", "--no-browser", "--port=8080", "--NotebookApp.base_url", "/jupyter"  ]
