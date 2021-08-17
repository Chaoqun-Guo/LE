FROM bde2020/hive:2.3.2-postgresql-metastore

ENV ATLAS_HIVE_HOOK_HOME /opt/atlas-hive-hook
#Add atlas hive hook jars
ADD apache-atlas-hive-hook-2.1.0/hook/hive $ATLAS_HIVE_HOOK_HOME
ADD conf/hive-site.xml $HIVE_HOME/conf
ADD conf/hive-env.sh $HIVE_HOME/conf
ADD conf/atlas-application.properties $HIVE_HOME/conf
ADD --chown=1000:1000 sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz /opt

RUN mv /opt/sqoop-1.4.7.bin__hadoop-2.6.0 /opt/sqoop-1.4.7

ADD --chown=1000:1000 conf/sqoop-env.sh /opt/sqoop-1.4.7/conf

RUN cp /opt/hive/lib/hive-common-2.3.2.jar /opt/sqoop-1.4.7/lib && \
    cp /opt/hadoop-2.7.4/share/hadoop/mapreduce/*.jar /opt/sqoop-1.4.7/lib

ENV SQOOP_HOME /opt/sqoop-1.4.7
ENV PATH $SQOOP_HOME/bin:$PATH
