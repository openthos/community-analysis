# Python 案例
- 案例

使用python向集合t3中插入1000条文档，文档的属性包括_id、name

_id的值为0、1、2、3...999
    
name的值为'py0'、'py1'...

查询显示出_id为100的整倍数的文档，如100、200、300...，并将name输出
    
```
import pymongo
if __name__ == '__main__':
    try:
        # 1 获得连接对象
        client = pymongo.MongoClient(host="localhost", port=27017)
        # 2 获取数据库
        db = client.demo
        # 3 执行业务逻辑 数据库操作
        # 插入1000条数据

        for id in range(0,1000):
            db.t3.insert_one({"_id": id, "name": "py%s"% id})

        # 取出符合条件的数据
        match = {
            "$where": "function(){return this._id%100 == 0 }",
            }
        res = db.t3.find(match, {"_id": 0, "name": 1})
        for info in res:
            print(info)


    except Exception as e:
        print(e)
```
