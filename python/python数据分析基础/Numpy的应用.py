import numpy as np
from numpy.linalg import inv
from numpy import random

data1 = [6, 7, 8]
a1 = np.array(data1)
print(a1)

print(np.zeros(10))
print(np.ones(10))
nd = np.array([1, 2, 3, 4])
print(nd * 2)
print(nd * nd)
print(np.arange(10))
print(np.arange(1, 20, 2))
nd1 = np.arange(1, 20, 2)
print(nd1[5])
print(nd1[2:5])
nd1[2:5] = 10
print(nd1)
data2 = [[1, 2, 3, 4], [5, 6, 7, 8]]
a2 = np.array(data2)
print(a2)
print(a2[0])
print(a2.dtype)
print(a2.shape)
nd = np.arange(32)
print(nd)
nd1 = np.reshape(nd, (8, 4))
print(nd1)
print(nd1[[4, 6, 3, 1]])
print(nd1[[1, 5, 7, 2], [0, 3, 1, 2]])

print(nd1[[1, 5, 7, 2]][:, [0, 3, 1, 2]])
print(nd1[np.ix_([1, 5, 7, 2], [0, 3, 1, 2])])
arr = np.arange(10)
print(np.sqrt(arr))
b = np.arange(3)
print(b)
c = np.array([2, -1, 4])
print(c)
print(np.add(b, c))
print(np.maximum(b, c))
arr1 = np.random.randn(9)
print(arr1)
# 最值
print(arr1.min())
print(arr1.max())
# 均值
print(arr1.mean())
# 求和
print(arr1.sum())
# 排序
arr1.sort()
print(arr1)
arr2 = np.random.randn(5, 3)
print(arr2)
print(arr2.min())
print(arr2.max())
print(arr2.mean())
print(arr2.sum())
arr2.sort()
print(arr2)
arr2.sort(axis=0)
print(arr2)
a = np.linspace(0, 10, 2)
print(a)
b = np.linspace(0, 10, 12)
print(b)

x = np.array([[1, 2, 3], [4, 5, 6]])
print(x)
y = np.array([[6, 23], [-1, 7], [8, 9]])
print(y)
z = x.dot(y)
print(z)
m = np.array([[4, 2], [3, 1]])
print(inv(m))

rArray = random.normal(size=(4, 4))
print(rArray)
random.randint(0, 3)
i = 0
while i < 5:
    print(random.randint(0, 2))
    i += 1
