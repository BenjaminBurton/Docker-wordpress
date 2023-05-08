provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "wp_network" {
  name = "wp_network"
}

resource "docker_volume" "wp_db_data" {
  name = "wp_db_data"
}

resource "docker_container" "db" {
  name = "wp_db"
  image = "mysql:5.7"
  restart = "always"
  env = [
    "MYSQL_ROOT_PASSWORD=your_mysql_password",
    "MYSQL_DATABASE=your_mysql_database",
    "MYSQL_USER=your_mysql_user",
    "MYSQL_PASSWORD=your_mysql_user_password",
  ]
  network_mode = docker_network.wp_network.name
  volumes {
    container_path = "/var/lib/mysql"
    host_path      = docker_volume.wp_db_data.name
    read_only      = false
  }
}

resource "docker_container" "wordpress" {
  name = "wp_app"
  image = "wordpress:latest"
  restart = "always"
  env = [
    "WORDPRESS_DB_HOST=wp_db:3306",
    "WORDPRESS_DB_USER=your_mysql_user",
    "WORDPRESS_DB_PASSWORD=your_mysql_user_password",
    "WORDPRESS_DB_NAME=your_mysql_database",
    "WORDPRESS_CONFIG_EXTRA=define('FS_METHOD', 'direct');",
  ]
  network_mode = docker_network.wp_network.name
  ports {
    internal = 80
    external = 8080
  }
  depends_on = [
    docker_container.db.name,
  ]
}

