### 1 数据导入流程
1.1 MySQL 数据导入 Amundsen 和 Neo4j 中
```bash
1. echo python==3.7 >> requirements.txt
2. conda-env create -f requirements.txt -n amundsen
3. conda activate amundsen
4. cd ~/amundsen/databuilder
5. pip install --upgrade pip
6. pip install -r requirements.txt
7. python setup.py install
8. python example/scripts/sample_mysql_loader.py
```
1.2 Sqoop import data from MySQL to Hive
```bash
1. docker exec -it atlas-hive-docker-main_hive-server_1 bash
2. ./sqoop-import-from-mysql-to-hive.sh mysql_db_name mysql_table_name mysql_table_name hive_db_name hive_table_name

# Caution! xxx_xx_name 均为参数，详细见 cat ./sqoop-import-from-mysql-to-hive.sh
```