
"Provides `YearMonth` type."
module YearMonths

using Dates

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

const RGX_YYYY_MM = r"^[0-9]+-[0-9][0-9]$" # yyyy-mm
const RGX_YYYYMM = r"^[0-9]+[0-9][0-9]$" # yyyymm

"""
    YearMonth(str::AbstractString)

Accepts two formats: "yyyy-mm" or "yyyymm".
"""
function YearMonth(str::AbstractString)
    @assert !isempty(str) "Cannot convert empty string to YearMonth."
    if occursin(RGX_YYYY_MM, str)
        y = parse(Int, str[1:(end-3)])
        m = parse(Int, str[(end-1):end])
        return YearMonth(y, m)
    elseif occursin(RGX_YYYYMM, str)
        y = parse(Int, str[1:(end-2)])
        m = parse(Int, str[(end-1):end])
        return YearMonth(y, m)
    else
        error("Invalid format to create a YearMonth: $str.")
    end
end

YearMonth(ym::Integer) = YearMonth(string(ym))
YearMonth(y::Integer, m::Integer) = YearMonth(Int(y), Int(m))

Dates.year(ym::YearMonth) = ym.y
Dates.month(ym::YearMonth) = ym.m
Dates.yearmonth(ym::YearMonth) = (ym.y, ym.m)

"""
    Date(ym::YearMonth)

Creates a date based on the first day of the month.
"""
Dates.Date(ym::YearMonth) = Date(yearmonth(ym)...)

Base.convert(::Type{Date}, ym::YearMonth) = Date(ym)

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

Base.string(ym::YearMonth) = "$(year(ym))-$(lpad(month(ym), 2, "0"))"
Base.show(io::IO, ym::YearMonth) = print(io, "YearMonth(\"", string(ym), "\")")

Base.:-(x::YearMonth, y::YearMonth) = Month(12 * (x.y - y.y) + x.m - y.m)

@static if VERSION >= v"1.8"
    Base.Broadcast.broadcastable(x::YearMonth) = Ref(x)
end

end # module YearMonths
