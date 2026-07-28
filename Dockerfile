FROM mariadb:11

COPY init-db.sql /docker-entrypoint-initdb.d/
COPY insert-db.sql /docker-entrypoint-initdb.d/
COPY select-db.sql /docker-entrypoint-initdb.d/




