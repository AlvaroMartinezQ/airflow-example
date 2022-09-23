FROM python:3.9

EXPOSE 8080
ENV AIRFLOW_HOME=/app/airflow
RUN mkdir -p $AIRFLOW_HOME
USER root

RUN apt-get update && \
    apt-get install -y \
    build-essential && \
    apt-get install -y --no-install-recommends \
    freetds-bin \
    krb5-user \
    libffi7 \
    libsasl2-2 \
    libsasl2-modules \
    libssl1.1 \
    locales  \
    lsb-release \
    sasl2-bin \
    sqlite3 \
    unixodbc

RUN pip3 install \
    apache-airflow[async,kubernetes,password,postgres]==2.2.5 \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.2.5/constraints-3.9.txt"

ADD requirements.txt /app
RUN pip3 install -U -r requirements.txt && \
    rm /app/requirements.txt

COPY entrypoint.sh /entrypoint.sh

RUN chmod 555 /entrypoint.sh && \
    chmod 777 -R ${AIRFLOW_HOME}
   
RUN mkdir  -p /app/airflow/dags
ADD dags/* /app/airflow/dags/

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
USER app
