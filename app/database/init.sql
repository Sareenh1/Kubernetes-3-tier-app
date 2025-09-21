CREATE DATABASE IF NOT EXISTS demo_db;
USE demo_db;

CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO messages (message) VALUES ('Hello from Kubernetes on EC2!');
INSERT INTO messages (message) VALUES ('MySQL is running in a pod with persistent storage');
INSERT INTO messages (message) VALUES ('Backend services are discoverable via DNS');
INSERT INTO messages (message) VALUES ('Frontend uses LoadBalancer service type');
INSERT INTO messages (message) VALUES ('ConfigMaps and Secrets provide configuration');
