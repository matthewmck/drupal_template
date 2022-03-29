# Getting Started

> **Drupal template with preconfigured Dockerfile**  
Drupal version: 9.3.9  
PHP version: 8.1.4

| Site | URL |
| --- | --- |
| Drupal | [localhost:8080](http://localhost:8080) |
| phpmyadmin | [localhost:8181](http://localhost:8181) |

## Local Config
### Step 1:
Inside `./docker` create a `.env` file based off of `.env.example `. Keep `PMA_HOST` and `PMA_PORT` the same, everything else can be whatever value you choose.

### Step 2:
Inside `./web/sites/default/` create a `settings.local.php` file. Insert the following:
```
<?php
$config['system.logging']['error_level']='verbose';

$databases['default']['default'] = array (
  'database' => '',
  'username' => '',
  'password' => '',
  'prefix' => '',
  'host' => 'mysql',
  'port' => '3306',
  'namespace' => 'Drupal\Core\Database\Driver\mysql',
  'driver' => 'mysql',
);
```
For `database`, `username`, and `password` insert the same values you used within the `.env` file within the `./docker` dir.

## Docker Commands
build project
```
docker-compose up --build
```

Start project in background
```
docker-compose up -d
```

Stop project
```
docker-compose down
```

See running instances
```
docker-compose ps
```

Execute commands inside container
```
docker exec -it <CONTAINER_NAME> <CMD>
```
