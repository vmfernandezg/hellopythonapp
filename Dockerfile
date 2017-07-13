FROM centos/s2i-base-centos7
MAINTAINER Managed Services

EXPOSE 8080

LABEL io.k8s.display-name="Python Hello World!" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="python,hello-world" \
      name="python/hello-world" \
      maintainer="Managed Services"

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

RUN yum -y update && \
    yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-python35 rh-python35-python-devel \
    rh-python35-python-setuptools rh-python35-python-pip" && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

RUN chown -R 1001:0 /opt/app-root && chmod -R og+rwX /opt/app-root
USER 1001

RUN source scl_source enable rh-python35 && \
    virtualenv /opt/app-root && \
    printf 'unset BASH_ENV PROMPT_COMMAND ENV\n\
source scl_source enable rh-python35\n\
source /opt/app-root/bin/activate\n' \
    > /opt/app-root/etc/scl_enable

COPY requirements.txt wsgi.py /opt/app-root/src/

RUN source scl_source enable rh-python35 && \
    source /opt/app-root/bin/activate && \
    PIP_DISABLE_PIP_VERSION_CHECK=on pip install -r requirements.txt
CMD ["gunicorn","wsgi","--bind=:8080","--access-logfile=-"]
