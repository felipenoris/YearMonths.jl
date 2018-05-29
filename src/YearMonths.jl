
__precompile__(true)

"""
Package that exports the type `YearMonth`.
"""
module YearMonths

using Base.Dates
export YearMonth

"""
`YearMonth` is an immutable value that represents a tuple (year, month).

Example:
```julia
julia> ym = YearMonth(2018, 12) # represents December of year 2018.
```
"""
struct YearMonth
	y::Int
	m::Int

	function YearMonth(y::Int, m::Int)
		@assert 1 <= m && m <= 12 "Month should be between 1 and 12."
		return new(y, m)
	end
end

YearMonth(dt::Date) = YearMonth(Dates.yearmonth(dt)...)

function YearMonth(str::AbstractString)
	@assert !isempty(str) "Cannot convert empty string to YearMonth."
	if ismatch(r"^[0-9][0-9][0-9][0-9]-[0-9][0-9]$", str) # yyyy-mm
		y = parse(Int, str[1:4])
		m = parse(Int, str[6:7])
		return YearMonth(y, m)
	elseif ismatch(r"^[0-9][0-9][0-9][0-9][0-9][0-9]$", str) # yyyymm
		y = parse(Int, str[1:4])
		m = parse(Int, str[5:6])
		return YearMonth(y, m)
	else
		error("Invalid format to create a YearMonth: $str.")
	end
end

YearMonth(ym::Integer) = YearMonth(string(ym))

Base.:(==)(ym1::YearMonth, ym2::YearMonth) = ym1.y == ym2.y && ym1.m == ym2.m
Base.hash(ym::YearMonth) = hash(ym.y) + hash(ym.m)
Base.show(io::IO, ym::YearMonth) = print(io, "YearMonth(\"", year(ym), lpad(month(ym), 2, "0"), "\")")
Dates.year(ym::YearMonth) = ym.y
Dates.month(ym::YearMonth) = ym.m
Dates.yearmonth(ym::YearMonth) = (ym.y, ym.m)

"""
	Date(ym::YearMonth)

Creates a date base on the first day of the month.
"""
Dates.Date(ym::YearMonth) = Date(yearmonth(ym)...)

Base.:+(ym::YearMonth, p::Year) = YearMonth(ym.y + Dates.value(p), ym.m)
Base.:-(ym::YearMonth, p::Year) = YearMonth(ym.y - Dates.value(p), ym.m)

Base.:+(ym::YearMonth, p::Month) = YearMonth(yearmonth(Date(ym) + p)...)
Base.:-(ym::YearMonth, p::Month) = YearMonth(yearmonth(Date(ym) - p)...)

Base.:+(p::P, ym::YearMonth) where {P<:Union{Year, Month}} = +(ym, p)

Base.:<(ym1::YearMonth, ym2::YearMonth) = Date(ym1) < Date(ym2)
Base.:(<=)(ym1::YearMonth, ym2::YearMonth) = ym1 == ym2 || ym1 < ym2
Base.isequal(ym1::YearMonth, ym2::YearMonth) = ym1.y == ym2.y && ym1.m == ym2.m
Base.isless(ym1::YearMonth, ym2::YearMonth) = isless(Date(ym1), Date(ym2))

Dates.firstdayofmonth(ym::YearMonth) = Date(ym)
Dates.lastdayofmonth(ym::YearMonth) = lastdayofmonth(Date(ym))

end # module YearMonths
