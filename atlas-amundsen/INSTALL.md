# 1 Docker & Docker-compose

**Notice! All projects are deployed on docker, please move to step regarding the installation and use of docker and docker-compose**

## 1.1 Docker

**[docker](https://docs.docker.com/)**

## 1.2 Docker-compose

**[docker-compose](https://docs.docker.com/)**



# 2 Atlas-Hive-docker

**#Docker-compose for atlas managing hive metadata and lineage**

## 2.1 Prerequisite

***Build atlas***

Download atlas source code:

```bash
git clone https://github.com/apache/atlas.git
cd atlas
```

Checkout version ***release-2.1.0-rc3***

```bash
git checkout release-2.1.0-rc3
```

Modify some code that conflicts with latest hive:

File location:

```bash
vim addons/hive-bridge/src/main/java/org/apache/atlas/hive/bridge/HiveMetaStoreBridge.java
```

Comment out line 577-581:

```java
    public static String getDatabaseName(Database hiveDB) {
        String dbName      = hiveDB.getName().toLowerCase();
        // String catalogName = hiveDB.getCatalogName() != null ? hiveDB.getCatalogName().toLowerCase() : null;

        // if (StringUtils.isNotEmpty(catalogName) && !StringUtils.equals(catalogName, DEFAULT_METASTORE_CATALOG)) {
        //     dbName = catalogName + SEP + dbName;
        // }
        return dbName;
    }
```

Build:

```bash
mvn clean -DskipTests package -Pdist,embedded-hbase-solr
```

Copy necessary files into ***atlas-hive-docker*** root directory:

```bash
cp -r distro/target/apache-atlas-2.1.0-hive-hook/apache-atlas-hive-hook-2.1.0 <ROOT_OF_atlas-hive-docker_PROJECT>
```

**Make docker images**

Use make:

```bash
make
```

<h3>
    <center>==However, I had done this for you, all you need to do is just run it!==</center>
</h3>
## 2.2 Run

***Start services***

<code>cd</code>to this projects's root directory, then start servieces using <code>docker-compose</code>

```bash
docker-compose up -d
```

***Login atlas using Web UI***

Open <code>http://localhost:21000</code> in your local browser and us <code>admin</code>/<code>admin</code> to login

***Run some Hive SQLs***

<code>bash</code> into the hive container 

```bash
docker-compose exec hive-servers bash
```

Start beeline

```bash
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
```

Run some statements containing certain lineage info, e.g.:

```hive
create table t(i int);
create view v as select * from t;
```

***Check lineage in Web UI***

Now refresh the atlas Web UI page, you'll see a bunch of hive entities captured, each of which containing the lineage info.

## 2.3 References

[Doc of atlas's hive hook](http://atlas.apache.org/index.html#/HookHive)

[Solving incompatibility between latest atlas and hive](https://liangjunjiang.medium.com/deploy-atlas-hive-hook-fcb130b7db01)

[Docker atlas](https://github.com/sburn/docker-apache-atlas)

[Docker hive](https://github.com/big-data-europe/docker-hive)



# 3 Amundsen

## 3.1 Installation

***Bootstrap a default version of Amundsen using Docker***

The following instructions are for setting up a version of Amundsen using Docker.

1. Make sure you have at least 3GB available to docker. Install <code>docker</code> and <code>docker-compose</code>

2. Clone  [amundsen repo]( https://github.com/amundsen-io/amundsen) and its submodules by running:

```bash
git clone --recursive https://github.com/amundsen-io/amundsen.git
```

<h3><center>==However, I had done this for you, all you need to do is just run it!==</center></h3>

3. Enter the cloned directory and run below:

```bash
#cp docker-compse.yml and rename it docker-compose-neo4j.yml
cp docker-compose.yml docker-compoes-neo4j.yml

#For Neo4j Backend
docker-compose -f docker-compose-neo4j.yml up -d

#For Atlas Backend
docker-compose -f docker-compose-atlas.yml up -d 
```

***USEFUL!!!***

***Troubleshooting:*** how to change heap memory for ElasticSearch and Docker engine memory allocation.

**If** the docker container doesn't have enough heap memory for Elastic Search, <code>es_amundsen</code> will fail during docker-compose.

> Ⅰ. <code>docker-compose error: es_amundsen | [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]</code>

> Ⅱ. Increase the heap memory [detailed instructions here](https://www.elastic.co/guide/en/elasticsearch/reference/7.1/docker.html#docker-cli-run-prod-mode):
>
> > a. Edit <code>/etc/sysctl.conf</code>
> >
> > b. Make entry <code>vm.max_map_count=262144</code>. Save and exit.
> >
> > c. Reload settings <code>sysctl -p</code>
> >
> > d. Restart <code>docker-compose</code>

**If** <code>docker-amundsen-local.yml</code> stops because of <code>org.elasticsearch.bootstrap.StartupException: java.lang.IllegalStateException: Failed to create node environment</code>, then <code>es_amundsen</code> cannot write to <code>.local/elasticsearch.</code>

> Ⅰ. <code>chown -R 1000:1000 .local/elasticsearch</code>

> Ⅱ. Restart <code>docker-compose</code>

**If** when running the sample data loader you recieve a connection error related to ElasticSearch or like this for Neo4j:

```log
Traceback (most recent call last):File "/home/ubuntu/amundsen/amundsendatabuilder/venv/lib/python3.6/site-packages/neobolt/direct.py", line 831, in _connect
        s.connect(resolved_address)
    ConnectionRefusedError: [Errno 111] Connection refused
```

**If** <code>elastic search</code> container stops with an error <code>max file descriptors [4096] for elasticsearch process is too low, increase to at least [65535]</code>, then add the below code to the file <code>docker-amundsen-local.yml</code> in the elasticsearch definition.

```bash
 ulimits:
   nofile:
     soft: 65535
     hard: 65535
```

4. Ingest provided sample data into Neo4j by doing the following: (Please skip if you are using Atlas backend)

   a. In a separate terminal window, change directory to <code>databuilder</code>.

   b. <code>sample_data_loader</code> python script included in <code>examples/</code> directory uses elasticsearch client, pyhocon and other libraries. Install the dependencies in a virtual env and run the script by following the commands below:

```python
 $ python3 -m venv venv
 $ source venv/bin/activate
 $ pip3 install --upgrade pip
 $ pip3 install -r requirements.txt
 $ python3 setup.py install
 $ python3 example/scripts/sample_data_loader.py
```

5. View UI at http://localhost:5000 and try to search test, it should return some result.

6. We could also do an exact matched search for table entity. For example: search test_table1 in table field and it return the records that matched.

**Atlas Note**: Atlas takes some time to boot properly. So you may not be able to see the results immediately after docker-compose up command. Atlas would be ready once you'll have the following output in the docker output Amundsen Entity Definitions Created...

## 3.2 Verify setup

1. You can verify dummy data has been ingested into Neo4j by by visiting http://localhost:7474/browser/ and run MATCH (n:Table) RETURN n LIMIT 25 in the query box. You should see few tables.

2. You can verify the data has been loaded into the metadataservice by visiting:

   Ⅰ.http://localhost:5000/table_detail/gold/hive/test_schema/test_table1

   Ⅱ.http://localhost:5000/table_detail/gold/dynamo/test_schema/test_table2

