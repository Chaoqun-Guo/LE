# Atlas-Hive-docker

Docker-compose for atlas managing hive metadata and
lineage: [References](https://github.com/Chaoqun-Guo/atlas-hive-docker)

### * I had done this for you, all you need to do is just run it (see step 2)! 

## 1.Prerequisite

**Build atlas**

Download atlas source code:

```bash
git clone https://github.com/apache/atlas.git
cd atlas
```

Checkout version **release-2.1.0-rc3**

```bash
git checkout release-2.1.0-rc3
````

Modify some code that conflicts with the latest hive:

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

Copy necessary files into **atlas-hive-docker** root directory:

```bash
cp -r distro/target/apache-atlas-2.1.0-hive-hook/apache-atlas-hive-hook-2.1.0 <ROOT_OF_atlas-hive-docker_PROJECT>
```

**Make docker images**

Use make:

```bash
make
```

## 2.Run

**Start services**

<code>cd</code> to project's root directory, then start services using <code>docker-compose</code>

```bash
docker-compose up -d
```

**Login atlas using Web UI**

Open http://localhost:21000 in your local browser and use <code>admin</code>/<code>admin</code> to login bash into the
hive container:

```bash
docker-compose exec hive-server bash
```

Start beeline:

```bash
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
```

**Check lineage in Web UI**

Now refresh the atlas Web UI page, you'll see a bunch of hive entities captured, each of which containing the lineage
info.

## 3.References

[Doc of atlas's hive hook](http://atlas.apache.org/index.html#/HookHive)

[Solving incompatibility between latest atlas and hive](https://liangjunjiang.medium.com/deploy-atlas-hive-hook-fcb130b7db01)

[Docker atlas](https://github.com/sburn/docker-apache-atlas)

[Docker hive](https://github.com/big-data-europe/docker-hive)