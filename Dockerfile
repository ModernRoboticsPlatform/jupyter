FROM debian:buster

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

RUN touch /etc/modules
RUN mkdir /etc/modprobe.d/
RUN touch /etc/modprobe.d/raspi-blacklist.conf
RUN apt-get update && apt-get install -y sense-hat

RUN useradd -ms /bin/bash jupyter
USER jupyter
WORKDIR /home/jupyter

CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--no-browser", "--port=8080" ]
