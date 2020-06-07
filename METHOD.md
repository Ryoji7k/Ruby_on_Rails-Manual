## 日付操作

```
now = Time.current 

# 昨日
now.yesterday

# 翌日
now.tomorrow

# N日前,N日後
now.ago(3.days)
now.since(3.days)

# 前月
now.prev_month

# 翌月
now.next_month

# Nヶ月前,Nヶ月後
now.ago(3.month)
now.since(3.month)

# 前年
now.prev_year

# 翌年
now.next_year

# N年前,N年後
now.ago(3.years)
now.since(3.years)

# 月初
now.beginning_of_month

# 月末
now.end_of_month

# 今週の最初
now.beginning_of_week

# 今週の末
now.end_of_week

# 先週の月曜日
now.prev_week(:monday)

# 翌週の月曜日
now.next_week(:monday)
```
