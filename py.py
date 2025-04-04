import os
import psycopg2
import requests

pg_host = '192.210.197.70'
pg_user = 'postgres'
pg_pass = 'wxK3u5spuoqI5gaogYdz0yMTkKtZilYy'
pg_db = 'redash'

def psql():
    try:
        # 连接到PostgreSQL数据库
        conn = psycopg2.connect(
            host=pg_host,
            user=pg_user,
            password=pg_pass,
            dbname=pg_db
        )

        # 创建一个游标对象
        cur = conn.cursor()

        # 执行SQL命令
        cur.execute("select id from queries;")
        # 获取查询结果
        rows = cur.fetchall()

        # 遍历每个id并调用refresh函数
        for row in rows:
            id = row[0]
            refresh_remmner(id,"ghana","tospinomall")
            refresh_data(id,"tospinomall","gh")
            # refresh_data(id,"gh2b","gh")
            print("row :",row)

        # 提交事务
        conn.commit()

        print('------------ start -----------------')

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        # 关闭游标和连接
        if cur:
            cur.close()
        if conn:
            conn.close()




def refresh_data(id,site,DataSource):

    url = "https://redash.amiemall.com/api/queries/"+str(id)+"/results"

    payload = {
        "parameters": {
            "site": site,
            "DataSource": DataSource
        },
        "max_age": 1
    }
    headers = {
    "Authorization": "Key bF4R7JEgNU97J9YYl6dRLuBmERlhWbQuymGdNRXf",
    "content-type": "application/json"
    }

    response = requests.post(url, json=payload, headers=headers)

    print(response.json())


#会员数据刷新
def refresh_remmner(id,country,site):

    url = "https://redash.amiemall.com/api/queries/"+str(id)+"/results"

    payload = {
        "parameters": {
            "country": country,
            "site": site
        },
        "max_age": 1
    }
    headers = {
    "Authorization": "Key bF4R7JEgNU97J9YYl6dRLuBmERlhWbQuymGdNRXf",
    "content-type": "application/json"
    }

    response = requests.post(url, json=payload, headers=headers)

    print(response.json())




# 调用函数
psql()
print('------------ end -----------------')
