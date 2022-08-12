from datetime import datetime
dt1 = datetime(2020,1,1,10,42,25)
print(dt1)
print(dt1.day)
print(dt1.minute)
print(dt1.date())

string_dt = '2020-12-12'
print(datetime.strptime(string_dt, '%Y-%m-%d'))