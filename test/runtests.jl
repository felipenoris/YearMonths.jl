
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
    @test convert(Date, ym) == Date(2018, 10)
    @test convert(Date, ym) == Date(2018, 10, 1)

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

    ym3 = YearMonth(2022, 7)
    @test ym3 - YearMonth(2022, 7) == Month(0)
    @test ym3 - YearMonth(2022, 8) == -Month(1)
    @test ym3 - YearMonth(2022, 6) == Month(1)
    @test ym3 - YearMonth(2022, 1) == Month(6)
    @test ym3 - YearMonth(2021, 12) == Month(7)
    @test ym3 - YearMonth(2021, 7) == Month(12)
    @test ym3 - YearMonth(2023, 7) == -Month(12)
    @test ym3 - YearMonth(2020, 1) == Month(30)

    if VERSION >= v"1.8"
        effym = Vector(YearMonth(2020, 1):Year(1):YearMonth(2022, 1))
        evalym = YearMonth(202212)
        @test isequal(evalym .- effym, [Month(35), Month(23), Month(11)])
        @test isequal(evalym .- effym .+ Month(1), [Month(36), Month(24), Month(12)])
        @test isequal(evalym .- effym .+ Month(1) .+ Month(Year(1)), [Month(48), Month(36), Month(24)])
        @test isequal(effym .+ Year(1), [YearMonth(2021, 1), YearMonth(2022, 1), YearMonth(2023, 1)])
        @test isequal(effym .+ Month(3), [YearMonth(2020, 4), YearMonth(2021, 4), YearMonth(2022, 4)])
        @test isequal(effym .+ Month(3) .+ Year(1), [YearMonth(2021, 4), YearMonth(2022, 4), YearMonth(2023, 4)])
    end
end

@testset "Conversions" begin
    dt = Date(2018, 12, 10)
    ym1 = YearMonth(2018, 12)
    @test YearMonth(dt) == ym1
    @test_throws ErrorException YearMonth("2018-122")

    ym = YearMonth(2018, 5)
    @test firstdayofmonth(ym) == Date(2018, 5, 1)
    @test lastdayofmonth(ym) == Date(2018, 5, 31)

    @test convert(Int, YearMonth(2010, 1)) == 201001
    @test convert(Int, YearMonth(-2010, 1)) == -201001
    @test convert(Int, YearMonth(2010, 12)) == 201012
    @test convert(Int, YearMonth(-2010, 12)) == -201012
    @test convert(Int, YearMonth(0, 1)) == 1
    @test convert(Int, YearMonth(0, 12)) == 12
    @test convert(Int, YearMonth(-0, 1)) == 1
    @test convert(Int, YearMonth(-0, 12)) == 12
    @test convert(Int, YearMonth(1, 1)) == 101
    @test convert(Int, YearMonth(1, 12)) == 112
    @test convert(Int, YearMonth(-1, 1)) == -101
    @test convert(Int, YearMonth(-1, 12)) == -112
end

@testset "Ranges" begin
    @test collect(YearMonth(2022, 3):YearMonth(2023, 3)) == collect(YearMonth(2022, 3):Dates.Month(1):YearMonth(2023, 3))
end

@testset "Tutorial" begin
    include("tutorial.jl")
end
