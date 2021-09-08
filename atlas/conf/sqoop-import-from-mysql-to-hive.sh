#!/bin/bash

sqoop import --connect jdbc:mysql://mysql:3306/$1 \
            --username root \
            --password root \
            --table $2 \
            --m 1\
            --target-dir /user/hive/warehouse/$3 \
            --delete-target-dir \
            --hive-import \
            --hive-overwrite \
            --hive-database $4 \
            --hive-table $5