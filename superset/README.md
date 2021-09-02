# Superset

Installing Superset Locally Using Docker Compose The fastest way to try Superset locally is using Docker and Docker
Compose on a Linux or Mac OSX computer. Superset does not have official support for Windows, so we have provided a VM
workaround below.

## 1.Install a Docker Engine and Docker Compose

**Linux**

[Install Docker on Linux](https://docs.docker.com/engine/install/) also see [docker & docker-compose](../docker) by
following Docker’s instructions for whichever flavor of Linux suits you. Because docker-compose is not installed as part
of the base Docker installation on Linux, once you have a working engine, follow
the [docker-compose installation](https://docs.docker.com/compose/install/) instructions for Linux.

## 2.Clone Superset's Github repository

Clone Superset's repo in your terminal with the following command:

```bash
$ git clone https://github.com/apache/superset.git
```

Once that command completes successfully, you should see a new superset folder in your current directory.

## 3.Launch Superset Through Docker Compose

Navigate to the folder you created in step 1:

```bash
$ cd superset
```

Then, run the following command:

```bash
$ docker-compose -f docker-compose-non-dev.yml up
```

You should see a wall of logging output from the containers being launched on your machine. Once this output slows, you
should have a running instance of Superset on your local machine!

**Note:** This will bring up superset in a non-dev mode, changes to the codebase will not be reflected. If you would
like to run superset in dev mode to test local changes, simply replace the previous command with: docker-compose up, and
wait for the superset_node container to finish building the assets.

**Configuring Docker Compose**

The following is for users who want to configure how Superset starts up in Docker Compose; otherwise, you can skip to
the next section.

You can configure the Docker Compose settings for dev and non-dev mode with docker/.env and docker/.env-non-dev
respectively. These environment files set the environment for most containers in the Docker Compose setup, and some
variables affect multiple containers and others only single ones.

One important variable is SUPERSET_LOAD_EXAMPLES which determines whether the superset_init container will load example
data and visualizations into the database and Superset. These examples are quite helpful for most people, but probably
unnecessary for experienced users. The loading process can sometimes take a few minutes and a good amount of CPU, so you
may want to disable it on a resource-constrained device.

**Note:** Users often want to connect to other databases from Superset. Currently, the easiest way to do this is to
modify the docker-compose-non-dev.yml file and add your database as a service that the other services depend on (via
x-superset-depends-on). Others have attempted to set network_mode: host on the Superset services, but these generally
break the installation, because the configuration requires use of the Docker Compose DNS resolver for the service names.

## 4.Log in to Superset

Your local Superset instance also includes a Postgres server to store your data and is already pre-loaded with some
example datasets that ship with Superset. You can access Superset now via your web browser by
visiting <code>http://localhost:8088.</code> Note that many browsers now default to https - if yours is one of them,
please make sure it uses http.

Log in with the default username and password:

```bash
username: admin
password: admin
```

## 5.Connecting your local database instance to superset

When running Superset using docker or docker-compose it runs in its own docker container, as if the Superset was running
in a separate machine entirely. Therefore attempts to connect to your local database with hostname localhost won't work
as localhost refers to the docker container Superset is running in, and not your actual host machine. Fortunately,
docker provides an easy way to access network resources in the host machine from inside a container, and we will
leverage this capability to connect to our local database instance.

[References](https://superset.apache.org/docs/installation/installing-superset-using-docker-compose)
