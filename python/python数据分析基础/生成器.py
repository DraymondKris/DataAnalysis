# g = (x * x for x in range(5))
# # print(next(g))
# # print(next(g))
# print(next(g))
# print(next(g))
# print("for循环\n")
# for i in g:
#     print(i)


def seq_g(max):
    x = 1
    d = 2
    while x < max:
        yield(x)
        x+=d

g1 = seq_g(20)

print(next(g1))
print(next(g1))
print(next(g1))
print(next(g1))
