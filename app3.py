from flask import Flask
import mysql.connector
import os

dbconfig = {
    'host': 'localhost',
    'database': 'app3',
    'user': 'USUARI_EQUIVOCAT',
    'password': 'password'
}
pool_name = "mysql_pool"
pool_size = 5
cnxpool = mysql.connector.pooling.MySQLConnectionPool(pool_name = pool_name, pool_size = pool_size, **dbconfig)

app = Flask(__name__)

def get_db_connection():
    return cnxpool.get_connection()

@app.route('/')
def hello_instance():
    app.logger.info('Processing request for instance %s', app.instance_name)
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.close()
    conn.close()
    return "[OK] - " + app.instance_name + "]"

app.instance_name = os.getenv('INSTANCE') if os.getenv('INSTANCE') else "No instance provided"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')