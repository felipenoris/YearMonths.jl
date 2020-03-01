
# YearMonths.jl

[![License][license-img]](LICENSE)
[![travis][travis-img]][travis-url]
[![codecov][codecov-img]][codecov-url]

[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square
[travis-img]: https://img.shields.io/travis/felipenoris/YearMonths.jl/master.svg?logo=travis&label=Linux+/+macOS&style=flat-square
[travis-url]: https://travis-ci.org/felipenoris/YearMonths.jl
[codecov-img]: https://img.shields.io/codecov/c/github/felipenoris/YearMonths.jl/master.svg?label=codecov&style=flat-square
[codecov-url]: http://codecov.io/github/felipenoris/YearMonths.jl?branch=master

Provides `YearMonth` type for the Julia language.

# Usage

```julia
using Test, Dates

# will export `YearMonth` type
using YearMonths

# constructors
ym = YearMonth(2018, 12)
@test ym == YearMonth("2018-12") # accepts yyyy-mm format
@test ym == YearMonth("201812")  # accepts yyyymm format

# algebra

@test ym - Month(1) == YearMonth(2018, 11)
@test ym - Year(1) == YearMonth(2017, 12)
@test ym + Month(1) == YearMonth(2019, 1)
@test Month(1) + ym == YearMonth(2019, 1)
@test ym + Year(1) == YearMonth(2019, 12)
@test Year(1) + ym == YearMonth(2019, 12)
@test ym + Month(12) == YearMonth(2019, 12)

# comparison
ym1 = YearMonth(2020, 1)
ym2 = YearMonth(2019, 12)
@test ym1 > ym2

# Basic `Dates` API
ym = YearMonth(2018, 5)
@test firstdayofmonth(ym) == Date(2018, 5, 1)
@test lastdayofmonth(ym) == Date(2018, 5, 31)
@test month(ym) == 5
@test year(ym) == 2018
@test yearmonth(ym) == (2018, 5)
```
