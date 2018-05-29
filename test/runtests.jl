
using Base.Test
using Base.Dates
using YearMonths

ym = YearMonth(2018, 12)
@test year(ym) == 2018
@test month(ym) == 12
@test yearmonth(ym) == (2018, 12)
show(ym)
println("")

ym = YearMonth(2018, 10)
ym2 = YearMonth(2018, 11)

@test ym == YearMonth("201810")
@test ym == YearMonth("2018-10")
@test ym == YearMonth(201810)
@test ym != YearMonth(2018, 11)
@test Date(ym) == Date(2018, 10)
@test Date(ym) == Date(2018, 10, 1)

@test hash(ym) == hash(YearMonth(2018, 10))
@test hash(ym) != hash(ym2)

ym = YearMonth(2018, 12)
@test ym - Month(1) == YearMonth(2018, 11)
@test ym - Year(1) == YearMonth(2017, 12)
@test ym + Month(1) == YearMonth(2019, 1)
@test Month(1) + ym == YearMonth(2019, 1)
@test ym + Year(1) == YearMonth(2019, 12)
@test Year(1) + ym == YearMonth(2019, 12)
@test ym + Month(12) == YearMonth(2019, 12)

ym1 = YearMonth(2018, 12)
ym2 = YearMonth(2019, 1)
@test ym1 <= YearMonth(2018, 12)
@test ym1 < ym2
@test ym2 > ym1
@test isequal(ym1, YearMonth(2018, 12))
@test isequal(YearMonth(2018, 12), ym1)
@test !isequal(ym1, ym2)
@test isless(ym1, ym2)
@test !isless(ym2, ym1)

dt = Date(2018, 12, 10)
@test YearMonth(dt) == ym1
@test_throws ErrorException YearMonth("2018-122")
