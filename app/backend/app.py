from flask import Flask, jsonify
import mysql.connector
import os
import socket
from datetime import datetime

app = Flask(__name__)

# Get configuration from environment variables
DB_HOST = os.getenv('DB_HOST', 'mysql-service.demo-app.svc.cluster.local')
DB_NAME = os.getenv('DB_NAME', 'demo_db')
DB_USER = os.getenv('DB_USER', 'root')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'password')
CONFIG_VALUE = os.getenv('CONFIG_VALUE', 'default')

def get_db_connection():
    return mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )

@app.route('/api/data')
def get_data():
    db_status = "Connected"
    hostname = socket.gethostname()
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT message FROM messages ORDER BY id DESC LIMIT 1")
        result = cursor.fetchone()
        message = result[0] if result else "No messages found"
        cursor.close()
        conn.close()
    except Exception as e:
        message = f"Error: {str(e)}"
        db_status = "Disconnected"
    
    return jsonify({
        'message': message,
        'db_status': db_status,
        'config_value': CONFIG_VALUE,
        'timestamp': datetime.now().isoformat(),
        'hostname': hostname,
        'service_dns': DB_HOST
    })

@app.route('/api/services')
def get_services():
    return jsonify({
        'backend_service': 'backend-service.demo-app.svc.cluster.local:8080',
        'mysql_service': 'mysql-service.demo-app.svc.cluster.local:3306',
        'frontend_service': 'frontend-service.demo-app.svc.cluster.local:80'
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'service': 'backend'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
