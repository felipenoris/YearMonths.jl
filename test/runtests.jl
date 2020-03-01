
using YearMonths, Test, Dates

@testset "Constructors" begin
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
    @test string(ym) == "2018-10"
    @test ym == YearMonth(201810)
    @test ym != YearMonth(2018, 11)
    @test Date(ym) == Date(2018, 10)
    @test Date(ym) == Date(2018, 10, 1)

    @test hash(ym) == hash(YearMonth(2018, 10))
    @test hash(ym) != hash(ym2)

    @test string(YearMonth(0xff, 1)) == "255-01"
    @test string(YearMonth("20000-12")) == "20000-12"
    @test string(YearMonth("2000012")) == "20000-12"
    @test string(YearMonth("2-01")) == "2-01"
    @test string(YearMonth("201")) == "2-01"
    @test_throws ErrorException YearMonth("10")
end

@testset "Math" begin
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
end

@testset "Conversions" begin
    dt = Date(2018, 12, 10)
    ym1 = YearMonth(2018, 12)
    @test YearMonth(dt) == ym1
    @test_throws ErrorException YearMonth("2018-122")

    ym = YearMonth(2018, 5)
    @test firstdayofmonth(ym) == Date(2018, 5, 1)
    @test lastdayofmonth(ym) == Date(2018, 5, 31)
end

@testset "Tutorial" begin
    include("tutorial.jl")
end
