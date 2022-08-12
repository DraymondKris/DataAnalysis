#可迭代
some_dict = {'a':1, 'b':2, 'c':3}
# print(some_dict)

# for key in some_dict:
#     print(key)

# dict_iterator = iter(some_dict)
# # print(dict_iterator)
# print(next(dict_iterator))
# print(next(dict_iterator))

dict_iterator = iter(some_dict)
for i in dict_iterator:
    print(i)