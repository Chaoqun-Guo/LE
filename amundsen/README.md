# Amundsen-neo4j

## 1.Installation

Bootstrap a default version of Amundsen using Docker [Reference](./amundsen-main/docs/installation.md)**

The following instructions are for setting up a version of Amundsen using Docker.
1. Make sure you have at least 3GB available to docker. Install <code>docker</code> and <code>docker-compose</code>

2. Clone [amundsen repo]( https://github.com/amundsen-io/amundsen) and its submodules by running:

```bash
git clone --recursive https://github.com/amundsen-io/amundsen.git
```

### * I had done this for you, all you need to do is just run it!

3. Enter the cloned directory and run below:

```bash
#cp docker-compose.yml and rename it docker-compose-neo4j.yml
cp docker-compose.yml docker-compoes-neo4j.yml
#For Neo4j Backend
docker-compose -f docker-compose-neo4j.yml up -d
#For Atlas Backend
docker-compose -f docker-compose-atlas.yml up -d 
```
**!!! Useful Troubleshooting!**

How to change heap memory for ElasticSearch and Docker engine memory allocation.

If the docker container doesn't have enough heap memory for ElasticSearch, <code>es_amundsen</code> will fail during docker-compose.

> Ⅰ. <code>docker-compose error: es_amundsen | [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]</code>
> 
> Ⅱ. Increase the heap memory [detailed instructions here](https://www.elastic.co/guide/en/elasticsearch/reference/7.1/docker.html#docker-cli-run-prod-mode):
> 
> > a. Edit <code>/etc/sysctl.conf</code>
> >
> > b. Make entry <code>vm.max_map_count=262144</code>. Save and exit.
> >
> > c. Reload settings <code>sysctl -p</code>
> >
> > d. Restart <code>docker-compose</code>

If <code>docker-amundsen-local.yml</code> stops because of <code>org.elasticsearch.bootstrap.StartupException: java.lang.IllegalStateException: Failed to create node environment</code>, then <code>es_amundsen</code> cannot write to <code>.local/elasticsearch.</code>

> Ⅰ. <code>chown -R 1000:1000 .local/elasticsearch</code>
>
> Ⅱ. Restart <code>docker-compose</code>

If when running the sample data loader you recieve a connection error related to ElasticSearch or like this for Neo4j:

```log
Traceback (most recent call last):File "/home/ubuntu/amundsen/amundsendatabuilder/venv/lib/python3.6/site-packages/neobolt/direct.py", line 831, in _connect
        s.connect(resolved_address)
    ConnectionRefusedError: [Errno 111] Connection refused
```

If <code>elastic search</code> container stops with an error <code>max file descriptors [4096] for elasticsearch process is too low, increase to at least [65535]</code>, then add the below code to the file <code>docker-amundsen-local.yml</code> in the elasticsearch definition.

```bash
 ulimits:
   nofile:
     soft: 65535
     hard: 65535
```

4. Ingest provided sample data into Neo4j by doing the following: (Please skip if you are using Atlas backend)

   >a. In a separate terminal window, change directory to <code>databuilder</code>.
   > 
   >b. <code>sample_data_loader</code> python script included in <code>examples/</code> directory uses elasticsearch client, pyhocon and other libraries. Install the dependencies in a virtual env and run the script by following the commands below:

```bash
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

## 2.Verify setup

1. You can verify dummy data has been ingested into Neo4j by visiting http://localhost:7474/browser/ and run MATCH (n:Table) RETURN n LIMIT 25 in the query box. You should see few tables.

2. You can verify the data has been loaded into the metadataservice by visiting:

   >Ⅰ.http://localhost:5000/table_detail/gold/hive/test_schema/test_table1
   >Ⅱ.http://localhost:5000/table_detail/gold/dynamo/test_schema/test_table2